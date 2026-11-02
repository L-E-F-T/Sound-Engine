class_name SynthRenderer
extends RefCounted
## Turns a [SynthPatch] into audio samples, one sample at a time, the way a hardware synth would.
##
## Everything happens offline: a patch is rendered once into a PackedFloat32Array, converted to an
## [AudioStreamWAV], and cached. That keeps the per-frame cost at zero and lets the normal Godot
## players handle 3D positioning and polyphony. The trade-off is that a patch cannot react to
## gameplay while it plays; for that you would feed [AudioStreamGenerator] instead (see README).
##
## Every optional feature is guarded by a `has_*` flag so a knob at its default adds no work and
## changes no bytes of the output.


## Render a patch to mono float samples in the range -1..1.
static func render(patch: SynthPatch) -> PackedFloat32Array:
	var sr := float(patch.sample_rate)
	var dt := 1.0 / sr
	var env_len := patch.envelope_length()
	var total := int(ceilf(patch.total_length() * sr))
	var out := PackedFloat32Array()
	out.resize(total)
	if total == 0 or env_len <= 0.0:
		return out

	# Hoist every patch property into a local so the hot loop never touches the Resource.
	var wave := patch.wave
	var duty := patch.duty
	var base_freq := patch.base_freq
	var noise_mix := patch.noise_mix
	var noise_tone := patch.noise_tone
	var sub_mix := patch.sub_mix
	var detune_ratio := pow(2.0, patch.detune_cents / 1200.0)
	var detune_mix := patch.detune_mix
	var pwm_depth := patch.pwm_depth
	var pwm_rate := patch.pwm_rate
	var ring_ratio := patch.ring_ratio
	var ring_mix := patch.ring_mix
	var sweep := patch.pitch_sweep_semitones
	var sweep_curve := patch.pitch_sweep_curve
	var vib_depth := patch.vibrato_depth
	var vib_rate := patch.vibrato_rate
	var vib_shape := patch.vibrato_shape
	var vib_fade := patch.vibrato_fade_in
	var arp := patch.arpeggio
	var arp_count := arp.size()
	var arp_rate := patch.arpeggio_rate
	var arp_mode := patch.arpeggio_mode
	var arp_glide := patch.arpeggio_glide
	var fm_ratio := patch.fm_ratio
	var fm_depth := patch.fm_depth
	var fm_decay := patch.fm_decay
	var attack := patch.attack
	var decay := patch.decay
	var sustain := patch.sustain_level
	var release := patch.release
	var a_end := attack
	var d_end := a_end + decay
	var s_end := d_end + patch.sustain_time
	var r_end := s_end + release
	var env_exp := patch.envelope_curve == SynthPatch.EnvCurve.EXPONENTIAL
	var trem_depth := patch.tremolo_depth
	var trem_rate := patch.tremolo_rate
	var trem_shape := patch.tremolo_shape
	var repeat_period := 1.0 / patch.repeat_rate if patch.repeat_rate > 0.0 else 0.0
	var filter_mode := patch.filter_mode
	var cutoff := patch.cutoff
	var cutoff_sweep := patch.cutoff_sweep_octaves
	var damp := lerpf(2.0, 0.1, patch.resonance)
	var flfo_depth := patch.filter_lfo_depth
	var flfo_rate := patch.filter_lfo_rate
	var flfo_shape := patch.filter_lfo_shape
	var drive_gain := 1.0 + patch.drive * 12.0
	var crush_levels := float(1 << (patch.bit_depth - 1))
	var hold := patch.sample_hold
	var delay_len := int(patch.delay_time * sr)
	var delay_fb := patch.delay_feedback
	var delay_mix := patch.delay_mix

	var has_vib := vib_depth > 0.0
	var vib_plain := vib_shape == SynthPatch.LfoShape.SINE and vib_fade <= 0.0
	var has_arp := arp_count > 0
	var arp_plain := arp_mode == SynthPatch.ArpMode.LOOP and arp_glide <= 0.0
	var has_fm := fm_ratio > 0.0 and fm_depth > 0.0
	var has_noise := noise_mix > 0.0 or wave == SynthPatch.Wave.NOISE
	var has_noise_tone := has_noise and noise_tone < 1.0
	var has_sub := sub_mix > 0.0
	var has_detune := detune_mix > 0.0 and wave != SynthPatch.Wave.NOISE
	var has_pwm := pwm_depth > 0.0 and wave == SynthPatch.Wave.SQUARE
	var has_ring := ring_ratio > 0.0 and ring_mix > 0.0
	var has_trem := trem_depth > 0.0
	var has_repeat := repeat_period > 0.0
	var has_filter := filter_mode != SynthPatch.FilterMode.NONE
	var has_flfo := has_filter and flfo_depth > 0.0
	var has_drive := patch.drive > 0.0
	var has_crush := patch.bit_depth < 16
	var has_hold := hold > 1
	var has_delay := delay_mix > 0.0 and delay_len > 0
	var max_cutoff := sr * 0.3

	var rng := RandomNumberGenerator.new()
	rng.seed = patch.noise_seed

	var phase := 0.0
	var phase2 := 0.0          # detuned copy
	var sub_phase := 0.0
	var fm_phase := 0.0
	var ring_phase := 0.0
	var pwm_phase := 0.0
	var vib_phase := 0.0       # radians for the plain path, cycles for the LFO path
	var vib_rand := 0.0
	var trem_phase := 0.0
	var trem_rand := 0.0
	var flfo_phase := 0.0
	var flfo_rand := 0.0
	var noise_lp := 0.0
	var arp_step := -1
	var arp_index := 0
	var arp_current := 0.0
	var glide_k := 1.0 - exp(-dt / arp_glide) if arp_glide > 0.0 else 1.0
	var svf_low := 0.0
	var svf_band := 0.0
	var hold_counter := 0
	var hold_value := 0.0
	var delay_buf := PackedFloat32Array()
	if has_delay:
		delay_buf.resize(delay_len)
	var delay_idx := 0

	for i in total:
		var t := i * dt
		# With repeat_rate, the envelope and sweep restart every period while the total length,
		# oscillator phase and effects keep running.
		var te := t
		if has_repeat:
			te = fmod(t, repeat_period)

		# --- Amp envelope: attack / decay / sustain / release. ---
		var env := 0.0
		if te < a_end:
			env = te / attack
		elif te < d_end:
			env = lerpf(1.0, sustain, (te - a_end) / decay)
		elif te < s_end:
			env = sustain
		elif te < r_end:
			env = sustain * (1.0 - (te - s_end) / release)
		if env_exp:
			env *= env

		var x := 0.0
		if env > 0.0:
			# --- Pitch: base + sweep + vibrato + arpeggio, all in semitones. ---
			var progress := minf(te / env_len, 1.0)
			var semis := sweep * pow(progress, sweep_curve)
			if has_vib:
				if vib_plain:
					semis += vib_depth * sin(vib_phase)
					vib_phase += TAU * vib_rate * dt
				else:
					var depth := vib_depth
					if vib_fade > 0.0:
						depth *= minf(t / vib_fade, 1.0)
					vib_phase += vib_rate * dt
					if vib_phase >= 1.0:
						vib_phase -= 1.0
						vib_rand = rng.randf_range(-1.0, 1.0)
					semis += depth * _lfo(vib_shape, vib_phase, vib_rand)
			if has_arp:
				if arp_plain:
					semis += arp[int(t * arp_rate) % arp_count]
				else:
					var step := int(t * arp_rate)
					if step != arp_step:
						arp_step = step
						match arp_mode:
							SynthPatch.ArpMode.LOOP:
								arp_index = step % arp_count
							SynthPatch.ArpMode.ONCE:
								arp_index = mini(step, arp_count - 1)
							SynthPatch.ArpMode.PING_PONG:
								var period := maxi(2 * (arp_count - 1), 1)
								var m := step % period
								arp_index = m if m < arp_count else period - m
							SynthPatch.ArpMode.RANDOM:
								arp_index = rng.randi() % arp_count
						if step == 0:
							arp_current = arp[arp_index]
					var target := float(arp[arp_index])
					arp_current += (target - arp_current) * glide_k
					semis += arp_current
			var freq := base_freq * pow(2.0, semis / 12.0)

			# --- FM: a second oscillator wobbles the phase of the first. ---
			var mod_phase := phase
			if has_fm:
				var index := fm_depth
				if fm_decay > 0.0:
					index *= exp(-te / fm_decay)
				mod_phase += index * sin(TAU * fm_phase) / TAU
				fm_phase = fmod(fm_phase + freq * fm_ratio * dt, 1.0)
			var p := mod_phase - floorf(mod_phase)

			# --- Oscillator ---
			var d := duty
			if has_pwm:
				d = clampf(duty + pwm_depth * sin(TAU * pwm_phase), 0.05, 0.95)
				pwm_phase = fmod(pwm_phase + pwm_rate * dt, 1.0)
			match wave:
				SynthPatch.Wave.SINE:
					x = sin(TAU * p)
				SynthPatch.Wave.SQUARE:
					x = 1.0 if p < d else -1.0
				SynthPatch.Wave.SAW:
					x = 2.0 * p - 1.0
				SynthPatch.Wave.TRIANGLE:
					x = 4.0 * absf(p - 0.5) - 1.0
				SynthPatch.Wave.NOISE:
					x = rng.randf_range(-1.0, 1.0)
					if has_noise_tone:
						noise_lp += noise_tone * (x - noise_lp)
						x = noise_lp
			if has_detune:
				var p2 := phase2 - floorf(phase2)
				var x2 := 0.0
				match wave:
					SynthPatch.Wave.SINE:
						x2 = sin(TAU * p2)
					SynthPatch.Wave.SQUARE:
						x2 = 1.0 if p2 < d else -1.0
					SynthPatch.Wave.SAW:
						x2 = 2.0 * p2 - 1.0
					SynthPatch.Wave.TRIANGLE:
						x2 = 4.0 * absf(p2 - 0.5) - 1.0
				x = x * (1.0 - detune_mix) + x2 * detune_mix
				phase2 += freq * detune_ratio * dt
				if phase2 >= 1.0:
					phase2 -= 1.0
			if has_sub:
				x = lerpf(x, sin(TAU * sub_phase), sub_mix)
				sub_phase += freq * 0.5 * dt
				if sub_phase >= 1.0:
					sub_phase -= 1.0
			if has_ring:
				x *= lerpf(1.0, sin(TAU * ring_phase), ring_mix)
				ring_phase = fmod(ring_phase + freq * ring_ratio * dt, 1.0)
			if has_noise and wave != SynthPatch.Wave.NOISE:
				var n := rng.randf_range(-1.0, 1.0)
				if has_noise_tone:
					noise_lp += noise_tone * (n - noise_lp)
					n = noise_lp
				x = lerpf(x, n, noise_mix)
			phase += freq * dt
			if phase >= 1.0:
				phase -= 1.0

			x *= env
			if has_trem:
				trem_phase += trem_rate * dt
				if trem_phase >= 1.0:
					trem_phase -= 1.0
					trem_rand = rng.randf_range(-1.0, 1.0)
				x *= 1.0 - trem_depth * (0.5 + 0.5 * _lfo(trem_shape, trem_phase, trem_rand))

			# --- Filter: Chamberlin state-variable, run twice per sample for stability. ---
			if has_filter:
				var fc := cutoff * pow(2.0, cutoff_sweep * progress)
				if has_flfo:
					flfo_phase += flfo_rate * dt
					if flfo_phase >= 1.0:
						flfo_phase -= 1.0
						flfo_rand = rng.randf_range(-1.0, 1.0)
					fc *= pow(2.0, flfo_depth * _lfo(flfo_shape, flfo_phase, flfo_rand))
				fc = clampf(fc, 20.0, max_cutoff)
				var f := 2.0 * sin(PI * fc / (sr * 2.0))
				var high := 0.0
				for _pass in 2:
					svf_low += f * svf_band
					high = x - svf_low - damp * svf_band
					svf_band += f * high
				match filter_mode:
					SynthPatch.FilterMode.LOWPASS:
						x = svf_low
					SynthPatch.FilterMode.HIGHPASS:
						x = high
					SynthPatch.FilterMode.BANDPASS:
						x = svf_band

			# --- Dirt ---
			if has_drive:
				x = tanh(x * drive_gain)
			if has_hold:
				if hold_counter == 0:
					hold_value = x
				hold_counter = (hold_counter + 1) % hold
				x = hold_value
			if has_crush:
				x = roundf(x * crush_levels) / crush_levels

		# --- Delay: keeps running after the envelope so the echo tail rings out. ---
		if has_delay:
			var echo := delay_buf[delay_idx]
			delay_buf[delay_idx] = x + echo * delay_fb
			delay_idx += 1
			if delay_idx >= delay_len:
				delay_idx = 0
			x += echo * delay_mix

		out[i] = x

	# --- Looping sounds: fold the echo tail back onto the start so the loop has no silent gap
	# and the echoes wrap around seamlessly. The loop region becomes exactly the envelope.
	if patch.loop:
		var loop_len := int(ceilf(env_len * sr))
		if loop_len > 0 and loop_len < total:
			# Sources are always at or past loop_len, targets always before it, so nothing is
			# counted twice, and a tail longer than one loop wraps as many times as needed.
			for i in range(loop_len, total):
				out[i % loop_len] += out[i]
			out.resize(loop_len)
			total = loop_len

	# --- Declick ---
	# A waveform that starts or stops away from zero (a square with attack 0, a sound cut by a
	# loop seam) makes an audible tick. One-shots get a 1.5 ms fade at each end; loops get a
	# 10 ms crossfade of their tail into their head so the seam is continuous.
	if patch.loop:
		var xf := mini(int(0.010 * sr), int(total / 4.0))
		if xf > 0:
			var keep := total - xf
			for i in xf:
				var w := float(i) / float(xf)
				out[i] = out[i] * w + out[keep + i] * (1.0 - w)
			out.resize(keep)
			total = keep
	else:
		var fade := mini(int(0.0015 * sr), int(total / 4.0))
		for i in fade:
			var w := float(i) / float(fade)
			out[i] *= w
			out[total - 1 - i] *= w

	# --- Output stage ---
	var gain := db_to_linear(patch.volume_db)
	if patch.normalize:
		var peak := 0.0
		for i in total:
			peak = maxf(peak, absf(out[i]))
		if peak > 0.0:
			gain *= 0.9 / peak
	for i in total:
		out[i] *= gain
	return out


## Low-frequency oscillator value in -1..1 for a phase in 0..1.
static func _lfo(shape: SynthPatch.LfoShape, phase: float, random_value: float) -> float:
	match shape:
		SynthPatch.LfoShape.SINE:
			return sin(TAU * phase)
		SynthPatch.LfoShape.TRIANGLE:
			return 1.0 - 4.0 * absf(phase - 0.5)
		SynthPatch.LfoShape.SQUARE:
			return 1.0 if phase < 0.5 else -1.0
		SynthPatch.LfoShape.SAW:
			return 1.0 - 2.0 * phase
		SynthPatch.LfoShape.RANDOM:
			return random_value
	return 0.0


## Pack float samples into a 16-bit mono [AudioStreamWAV].
static func to_wav(samples: PackedFloat32Array, sample_rate: int, loop := false) -> AudioStreamWAV:
	var count := samples.size()
	var bytes := PackedByteArray()
	bytes.resize(count * 2)
	for i in count:
		bytes.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	if loop:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		wav.loop_end = count
	return wav


## Convenience: patch straight to a playable stream.
static func render_to_stream(patch: SynthPatch) -> AudioStreamWAV:
	return to_wav(render(patch), patch.sample_rate, patch.loop)


## Add [param source] into [param target] starting at [param offset] samples, wrapping around the
## end so a note that spills past a loop boundary continues at the loop start. Used by PatternBaker.
static func mix_into(target: PackedFloat32Array, source: PackedFloat32Array, offset: int, gain := 1.0) -> void:
	var target_len := target.size()
	if target_len == 0:
		return
	var idx := offset % target_len
	for i in source.size():
		target[idx] += source[i] * gain
		idx += 1
		if idx >= target_len:
			idx = 0
