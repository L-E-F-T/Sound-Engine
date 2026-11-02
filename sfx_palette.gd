class_name SfxPalette
extends RefCounted
## The game's sound vocabulary, written as code so it is diffable and easy to copy-tweak.
##
## Naming rule: every preset that ships with the engine is keyed with the "p_" prefix
## (p[&"p_hit"]). Sounds you add yourself get no prefix (p[&"my_sound"]). The labs use that to
## sort sounds into "Presets" and "User created"; audio files in Samples/ form the third group.
##
## Each entry is a [SynthPatch]. Read a few of these alongside the README's "recipes" section and
## the patterns become obvious: pitch falling = heavy, pitch rising = positive, noise = impact,
## FM + arpeggio = magic, echo = big space.
##
## Every block lists every knob, grouped as in synth_patch.gd, at its value for that sound. A
## trailing `# *` marks a knob changed from its default; enum knobs list their choices. Edit here or
## in the Sound Lab's editor: Apply & commit rewrites the block in this layout and keeps your own
## comments. A block you write by hand only needs the lines you change; the rest default.


static func build() -> Dictionary[StringName, SynthPatch]:
	var p: Dictionary[StringName, SynthPatch] = {}

	# ------------------------------------------------------------------ Spells
	var cast_fire := SynthPatch.new()
	# ---- Oscillator
	cast_fire.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_fire.duty = 0.5
	cast_fire.base_freq = 220.0  # *
	cast_fire.noise_mix = 0.55  # *
	cast_fire.noise_tone = 1.0
	cast_fire.sub_mix = 0.0
	cast_fire.detune_cents = 0.0
	cast_fire.detune_mix = 0.0
	cast_fire.pwm_depth = 0.0
	cast_fire.pwm_rate = 2.0
	cast_fire.ring_ratio = 0.0
	cast_fire.ring_mix = 0.0
	# ---- Pitch motion
	cast_fire.pitch_sweep_semitones = -14.0  # *
	cast_fire.pitch_sweep_curve = 0.6  # *
	cast_fire.vibrato_depth = 0.0
	cast_fire.vibrato_rate = 6.0
	cast_fire.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_fire.vibrato_fade_in = 0.0
	cast_fire.arpeggio = []
	cast_fire.arpeggio_rate = 20.0
	cast_fire.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_fire.arpeggio_glide = 0.0
	# ---- FM
	cast_fire.fm_ratio = 0.0
	cast_fire.fm_depth = 0.0
	cast_fire.fm_decay = 0.0
	# ---- Amp envelope
	cast_fire.attack = 0.01  # *
	cast_fire.decay = 0.35  # *
	cast_fire.sustain_level = 0.0
	cast_fire.sustain_time = 0.0
	cast_fire.release = 0.1  # *
	cast_fire.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_fire.tremolo_depth = 0.0
	cast_fire.tremolo_rate = 6.0
	cast_fire.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_fire.repeat_rate = 0.0
	# ---- Filter
	cast_fire.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_fire.cutoff = 5000.0  # *
	cast_fire.cutoff_sweep_octaves = -3.0  # *
	cast_fire.resonance = 0.3  # *
	cast_fire.filter_lfo_depth = 0.0
	cast_fire.filter_lfo_rate = 3.0
	cast_fire.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_fire.drive = 0.5  # *
	cast_fire.bit_depth = 16
	cast_fire.sample_hold = 1
	# ---- Space
	cast_fire.delay_time = 0.0
	cast_fire.delay_feedback = 0.4
	cast_fire.delay_mix = 0.0
	# ---- Output
	cast_fire.volume_db = -2.0  # *
	cast_fire.normalize = true
	cast_fire.sample_rate = 44100
	cast_fire.loop = false
	cast_fire.noise_seed = 1
	cast_fire.condition = &""
	p[&"p_cast_fire"] = cast_fire

	var cast_arcane := SynthPatch.new()
	# ---- Oscillator
	cast_arcane.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_arcane.duty = 0.5
	cast_arcane.base_freq = 660.0  # *
	cast_arcane.noise_mix = 0.0
	cast_arcane.noise_tone = 1.0
	cast_arcane.sub_mix = 0.0
	cast_arcane.detune_cents = 0.0
	cast_arcane.detune_mix = 0.0
	cast_arcane.pwm_depth = 0.0
	cast_arcane.pwm_rate = 2.0
	cast_arcane.ring_ratio = 0.0
	cast_arcane.ring_mix = 0.0
	# ---- Pitch motion
	cast_arcane.pitch_sweep_semitones = 0.0
	cast_arcane.pitch_sweep_curve = 1.0
	cast_arcane.vibrato_depth = 0.0
	cast_arcane.vibrato_rate = 6.0
	cast_arcane.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_arcane.vibrato_fade_in = 0.0
	cast_arcane.arpeggio = [0, 7, 12, 19]  # *
	cast_arcane.arpeggio_rate = 28.0  # *
	cast_arcane.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_arcane.arpeggio_glide = 0.0
	# ---- FM
	cast_arcane.fm_ratio = 3.01  # *
	cast_arcane.fm_depth = 4.0  # *
	cast_arcane.fm_decay = 0.2  # *
	# ---- Amp envelope
	cast_arcane.attack = 0.005
	cast_arcane.decay = 0.3  # *
	cast_arcane.sustain_level = 0.0
	cast_arcane.sustain_time = 0.0
	cast_arcane.release = 0.15  # *
	cast_arcane.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_arcane.tremolo_depth = 0.0
	cast_arcane.tremolo_rate = 6.0
	cast_arcane.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_arcane.repeat_rate = 0.0
	# ---- Filter
	cast_arcane.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_arcane.cutoff = 2000.0
	cast_arcane.cutoff_sweep_octaves = 0.0
	cast_arcane.resonance = 0.0
	cast_arcane.filter_lfo_depth = 0.0
	cast_arcane.filter_lfo_rate = 3.0
	cast_arcane.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_arcane.drive = 0.0
	cast_arcane.bit_depth = 16
	cast_arcane.sample_hold = 1
	# ---- Space
	cast_arcane.delay_time = 0.12  # *
	cast_arcane.delay_feedback = 0.45  # *
	cast_arcane.delay_mix = 0.35  # *
	# ---- Output
	cast_arcane.volume_db = -4.0  # *
	cast_arcane.normalize = true
	cast_arcane.sample_rate = 44100
	cast_arcane.loop = false
	cast_arcane.noise_seed = 1
	cast_arcane.condition = &""
	p[&"p_cast_arcane"] = cast_arcane

	var cast_void := SynthPatch.new()
	# ---- Oscillator
	cast_void.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_void.duty = 0.5
	cast_void.base_freq = 180.0  # *
	cast_void.noise_mix = 0.0
	cast_void.noise_tone = 1.0
	cast_void.sub_mix = 0.0
	cast_void.detune_cents = 0.0
	cast_void.detune_mix = 0.0
	cast_void.pwm_depth = 0.0
	cast_void.pwm_rate = 2.0
	cast_void.ring_ratio = 0.0
	cast_void.ring_mix = 0.0
	# ---- Pitch motion
	cast_void.pitch_sweep_semitones = -24.0  # *
	cast_void.pitch_sweep_curve = 1.6  # *
	cast_void.vibrato_depth = 0.8  # *
	cast_void.vibrato_rate = 9.0  # *
	cast_void.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_void.vibrato_fade_in = 0.0
	cast_void.arpeggio = []
	cast_void.arpeggio_rate = 20.0
	cast_void.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_void.arpeggio_glide = 0.0
	# ---- FM
	cast_void.fm_ratio = 0.5  # *
	cast_void.fm_depth = 6.0  # *
	cast_void.fm_decay = 0.0
	# ---- Amp envelope
	cast_void.attack = 0.02  # *
	cast_void.decay = 0.5  # *
	cast_void.sustain_level = 0.0
	cast_void.sustain_time = 0.0
	cast_void.release = 0.2  # *
	cast_void.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_void.tremolo_depth = 0.0
	cast_void.tremolo_rate = 6.0
	cast_void.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_void.repeat_rate = 0.0
	# ---- Filter
	cast_void.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_void.cutoff = 1800.0  # *
	cast_void.cutoff_sweep_octaves = -2.0  # *
	cast_void.resonance = 0.0
	cast_void.filter_lfo_depth = 0.0
	cast_void.filter_lfo_rate = 3.0
	cast_void.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_void.drive = 0.0
	cast_void.bit_depth = 16
	cast_void.sample_hold = 1
	# ---- Space
	cast_void.delay_time = 0.2  # *
	cast_void.delay_feedback = 0.5  # *
	cast_void.delay_mix = 0.3  # *
	# ---- Output
	cast_void.volume_db = 0.0
	cast_void.normalize = true
	cast_void.sample_rate = 44100
	cast_void.loop = false
	cast_void.noise_seed = 1
	cast_void.condition = &""
	p[&"p_cast_void"] = cast_void

	var cast_lightning := SynthPatch.new()
	# ---- Oscillator
	cast_lightning.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_lightning.duty = 0.15  # *
	cast_lightning.base_freq = 1400.0  # *
	cast_lightning.noise_mix = 0.4  # *
	cast_lightning.noise_tone = 1.0
	cast_lightning.sub_mix = 0.0
	cast_lightning.detune_cents = 0.0
	cast_lightning.detune_mix = 0.0
	cast_lightning.pwm_depth = 0.0
	cast_lightning.pwm_rate = 2.0
	cast_lightning.ring_ratio = 0.0
	cast_lightning.ring_mix = 0.0
	# ---- Pitch motion
	cast_lightning.pitch_sweep_semitones = -30.0  # *
	cast_lightning.pitch_sweep_curve = 0.4  # *
	cast_lightning.vibrato_depth = 3.0  # *
	cast_lightning.vibrato_rate = 35.0  # *
	cast_lightning.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_lightning.vibrato_fade_in = 0.0
	cast_lightning.arpeggio = []
	cast_lightning.arpeggio_rate = 20.0
	cast_lightning.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_lightning.arpeggio_glide = 0.0
	# ---- FM
	cast_lightning.fm_ratio = 0.0
	cast_lightning.fm_depth = 0.0
	cast_lightning.fm_decay = 0.0
	# ---- Amp envelope
	cast_lightning.attack = 0.0  # *
	cast_lightning.decay = 0.18  # *
	cast_lightning.sustain_level = 0.0
	cast_lightning.sustain_time = 0.0
	cast_lightning.release = 0.05
	cast_lightning.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_lightning.tremolo_depth = 0.0
	cast_lightning.tremolo_rate = 6.0
	cast_lightning.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_lightning.repeat_rate = 0.0
	# ---- Filter
	cast_lightning.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_lightning.cutoff = 2000.0
	cast_lightning.cutoff_sweep_octaves = 0.0
	cast_lightning.resonance = 0.0
	cast_lightning.filter_lfo_depth = 0.0
	cast_lightning.filter_lfo_rate = 3.0
	cast_lightning.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_lightning.drive = 0.0
	cast_lightning.bit_depth = 6  # *
	cast_lightning.sample_hold = 1
	# ---- Space
	cast_lightning.delay_time = 0.0
	cast_lightning.delay_feedback = 0.4
	cast_lightning.delay_mix = 0.0
	# ---- Output
	cast_lightning.volume_db = -5.0  # *
	cast_lightning.normalize = true
	cast_lightning.sample_rate = 44100
	cast_lightning.loop = false
	cast_lightning.noise_seed = 1
	cast_lightning.condition = &""
	p[&"p_cast_lightning"] = cast_lightning

	var shield_up := SynthPatch.new()
	# ---- Oscillator
	shield_up.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	shield_up.duty = 0.5
	shield_up.base_freq = 330.0  # *
	shield_up.noise_mix = 0.0
	shield_up.noise_tone = 1.0
	shield_up.sub_mix = 0.0
	shield_up.detune_cents = 0.0
	shield_up.detune_mix = 0.0
	shield_up.pwm_depth = 0.0
	shield_up.pwm_rate = 2.0
	shield_up.ring_ratio = 0.0
	shield_up.ring_mix = 0.0
	# ---- Pitch motion
	shield_up.pitch_sweep_semitones = 0.0
	shield_up.pitch_sweep_curve = 1.0
	shield_up.vibrato_depth = 0.3  # *
	shield_up.vibrato_rate = 5.0  # *
	shield_up.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_up.vibrato_fade_in = 0.0
	shield_up.arpeggio = [0, 4, 7, 12, 16]  # *
	shield_up.arpeggio_rate = 24.0  # *
	shield_up.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	shield_up.arpeggio_glide = 0.0
	# ---- FM
	shield_up.fm_ratio = 0.0
	shield_up.fm_depth = 0.0
	shield_up.fm_decay = 0.0
	# ---- Amp envelope
	shield_up.attack = 0.02  # *
	shield_up.decay = 0.1  # *
	shield_up.sustain_level = 0.6  # *
	shield_up.sustain_time = 0.15  # *
	shield_up.release = 0.3  # *
	shield_up.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	shield_up.tremolo_depth = 0.0
	shield_up.tremolo_rate = 6.0
	shield_up.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_up.repeat_rate = 0.0
	# ---- Filter
	shield_up.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	shield_up.cutoff = 1200.0  # *
	shield_up.cutoff_sweep_octaves = 2.5  # *
	shield_up.resonance = 0.5  # *
	shield_up.filter_lfo_depth = 0.0
	shield_up.filter_lfo_rate = 3.0
	shield_up.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	shield_up.drive = 0.0
	shield_up.bit_depth = 16
	shield_up.sample_hold = 1
	# ---- Space
	shield_up.delay_time = 0.15  # *
	shield_up.delay_feedback = 0.4
	shield_up.delay_mix = 0.3  # *
	# ---- Output
	shield_up.volume_db = -4.0  # *
	shield_up.normalize = true
	shield_up.sample_rate = 44100
	shield_up.loop = false
	shield_up.noise_seed = 1
	shield_up.condition = &""
	p[&"p_shield_up"] = shield_up

	var warp := SynthPatch.new()
	# ---- Oscillator
	warp.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	warp.duty = 0.5
	warp.base_freq = 110.0  # *
	warp.noise_mix = 0.0
	warp.noise_tone = 1.0
	warp.sub_mix = 0.0
	warp.detune_cents = 0.0
	warp.detune_mix = 0.0
	warp.pwm_depth = 0.0
	warp.pwm_rate = 2.0
	warp.ring_ratio = 0.0
	warp.ring_mix = 0.0
	# ---- Pitch motion
	warp.pitch_sweep_semitones = 36.0  # *
	warp.pitch_sweep_curve = 2.2  # *
	warp.vibrato_depth = 1.5  # *
	warp.vibrato_rate = 12.0  # *
	warp.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	warp.vibrato_fade_in = 0.0
	warp.arpeggio = []
	warp.arpeggio_rate = 20.0
	warp.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	warp.arpeggio_glide = 0.0
	# ---- FM
	warp.fm_ratio = 2.0  # *
	warp.fm_depth = 2.5  # *
	warp.fm_decay = 0.0
	# ---- Amp envelope
	warp.attack = 0.1  # *
	warp.decay = 0.2  # *
	warp.sustain_level = 0.8  # *
	warp.sustain_time = 0.4  # *
	warp.release = 0.4  # *
	warp.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	warp.tremolo_depth = 0.0
	warp.tremolo_rate = 6.0
	warp.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	warp.repeat_rate = 0.0
	# ---- Filter
	warp.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	warp.cutoff = 2000.0
	warp.cutoff_sweep_octaves = 0.0
	warp.resonance = 0.0
	warp.filter_lfo_depth = 0.0
	warp.filter_lfo_rate = 3.0
	warp.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	warp.drive = 0.0
	warp.bit_depth = 16
	warp.sample_hold = 1
	# ---- Space
	warp.delay_time = 0.25  # *
	warp.delay_feedback = 0.55  # *
	warp.delay_mix = 0.4  # *
	# ---- Output
	warp.volume_db = -4.0  # *
	warp.normalize = true
	warp.sample_rate = 44100
	warp.loop = false
	warp.noise_seed = 1
	warp.condition = &""
	p[&"p_warp"] = warp

	# ----------------------------------------------------------------- Impacts
	var hit := SynthPatch.new()
	# ---- Oscillator
	hit.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	hit.duty = 0.5
	hit.base_freq = 440.0
	hit.noise_mix = 0.0
	hit.noise_tone = 1.0
	hit.sub_mix = 0.0
	hit.detune_cents = 0.0
	hit.detune_mix = 0.0
	hit.pwm_depth = 0.0
	hit.pwm_rate = 2.0
	hit.ring_ratio = 0.0
	hit.ring_mix = 0.0
	# ---- Pitch motion
	hit.pitch_sweep_semitones = 0.0
	hit.pitch_sweep_curve = 1.0
	hit.vibrato_depth = 0.0
	hit.vibrato_rate = 6.0
	hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hit.vibrato_fade_in = 0.0
	hit.arpeggio = []
	hit.arpeggio_rate = 20.0
	hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	hit.arpeggio_glide = 0.0
	# ---- FM
	hit.fm_ratio = 0.0
	hit.fm_depth = 0.0
	hit.fm_decay = 0.0
	# ---- Amp envelope
	hit.attack = 0.0  # *
	hit.decay = 0.12  # *
	hit.sustain_level = 0.0
	hit.sustain_time = 0.0
	hit.release = 0.03  # *
	hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	hit.tremolo_depth = 0.0
	hit.tremolo_rate = 6.0
	hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hit.repeat_rate = 0.0
	# ---- Filter
	hit.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	hit.cutoff = 3000.0  # *
	hit.cutoff_sweep_octaves = -3.0  # *
	hit.resonance = 0.2  # *
	hit.filter_lfo_depth = 0.0
	hit.filter_lfo_rate = 3.0
	hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	hit.drive = 0.4  # *
	hit.bit_depth = 16
	hit.sample_hold = 1
	# ---- Space
	hit.delay_time = 0.0
	hit.delay_feedback = 0.4
	hit.delay_mix = 0.0
	# ---- Output
	hit.volume_db = -3.0  # *
	hit.normalize = true
	hit.sample_rate = 44100
	hit.loop = false
	hit.noise_seed = 1
	hit.condition = &""
	p[&"p_hit"] = hit

	var thump := SynthPatch.new()
	# ---- Oscillator
	thump.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	thump.duty = 0.5
	thump.base_freq = 160.0  # *
	thump.noise_mix = 0.25  # *
	thump.noise_tone = 1.0
	thump.sub_mix = 0.0
	thump.detune_cents = 0.0
	thump.detune_mix = 0.0
	thump.pwm_depth = 0.0
	thump.pwm_rate = 2.0
	thump.ring_ratio = 0.0
	thump.ring_mix = 0.0
	# ---- Pitch motion
	thump.pitch_sweep_semitones = -24.0  # *
	thump.pitch_sweep_curve = 0.35  # *
	thump.vibrato_depth = 0.0
	thump.vibrato_rate = 6.0
	thump.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	thump.vibrato_fade_in = 0.0
	thump.arpeggio = []
	thump.arpeggio_rate = 20.0
	thump.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	thump.arpeggio_glide = 0.0
	# ---- FM
	thump.fm_ratio = 0.0
	thump.fm_depth = 0.0
	thump.fm_decay = 0.0
	# ---- Amp envelope
	thump.attack = 0.0  # *
	thump.decay = 0.2  # *
	thump.sustain_level = 0.0
	thump.sustain_time = 0.0
	thump.release = 0.05
	thump.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	thump.tremolo_depth = 0.0
	thump.tremolo_rate = 6.0
	thump.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	thump.repeat_rate = 0.0
	# ---- Filter
	thump.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	thump.cutoff = 2000.0
	thump.cutoff_sweep_octaves = 0.0
	thump.resonance = 0.0
	thump.filter_lfo_depth = 0.0
	thump.filter_lfo_rate = 3.0
	thump.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	thump.drive = 0.6  # *
	thump.bit_depth = 16
	thump.sample_hold = 1
	# ---- Space
	thump.delay_time = 0.0
	thump.delay_feedback = 0.4
	thump.delay_mix = 0.0
	# ---- Output
	thump.volume_db = -1.0  # *
	thump.normalize = true
	thump.sample_rate = 44100
	thump.loop = false
	thump.noise_seed = 1
	thump.condition = &""
	p[&"p_thump"] = thump

	var explosion := SynthPatch.new()
	# ---- Oscillator
	explosion.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	explosion.duty = 0.5
	explosion.base_freq = 440.0
	explosion.noise_mix = 0.0
	explosion.noise_tone = 1.0
	explosion.sub_mix = 0.0
	explosion.detune_cents = 0.0
	explosion.detune_mix = 0.0
	explosion.pwm_depth = 0.0
	explosion.pwm_rate = 2.0
	explosion.ring_ratio = 0.0
	explosion.ring_mix = 0.0
	# ---- Pitch motion
	explosion.pitch_sweep_semitones = 0.0
	explosion.pitch_sweep_curve = 1.0
	explosion.vibrato_depth = 0.0
	explosion.vibrato_rate = 6.0
	explosion.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	explosion.vibrato_fade_in = 0.0
	explosion.arpeggio = []
	explosion.arpeggio_rate = 20.0
	explosion.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	explosion.arpeggio_glide = 0.0
	# ---- FM
	explosion.fm_ratio = 0.0
	explosion.fm_depth = 0.0
	explosion.fm_decay = 0.0
	# ---- Amp envelope
	explosion.attack = 0.005
	explosion.decay = 0.7  # *
	explosion.sustain_level = 0.0
	explosion.sustain_time = 0.0
	explosion.release = 0.3  # *
	explosion.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	explosion.tremolo_depth = 0.0
	explosion.tremolo_rate = 6.0
	explosion.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	explosion.repeat_rate = 0.0
	# ---- Filter
	explosion.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	explosion.cutoff = 4000.0  # *
	explosion.cutoff_sweep_octaves = -4.5  # *
	explosion.resonance = 0.35  # *
	explosion.filter_lfo_depth = 0.0
	explosion.filter_lfo_rate = 3.0
	explosion.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	explosion.drive = 0.7  # *
	explosion.bit_depth = 16
	explosion.sample_hold = 2  # *
	# ---- Space
	explosion.delay_time = 0.09  # *
	explosion.delay_feedback = 0.3  # *
	explosion.delay_mix = 0.25  # *
	# ---- Output
	explosion.volume_db = 0.0
	explosion.normalize = true
	explosion.sample_rate = 44100
	explosion.loop = false
	explosion.noise_seed = 1
	explosion.condition = &""
	p[&"p_explosion"] = explosion

	var hurt := SynthPatch.new()
	# ---- Oscillator
	hurt.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	hurt.duty = 0.5
	hurt.base_freq = 300.0  # *
	hurt.noise_mix = 0.3  # *
	hurt.noise_tone = 1.0
	hurt.sub_mix = 0.0
	hurt.detune_cents = 0.0
	hurt.detune_mix = 0.0
	hurt.pwm_depth = 0.0
	hurt.pwm_rate = 2.0
	hurt.ring_ratio = 0.0
	hurt.ring_mix = 0.0
	# ---- Pitch motion
	hurt.pitch_sweep_semitones = -10.0  # *
	hurt.pitch_sweep_curve = 1.0
	hurt.vibrato_depth = 0.0
	hurt.vibrato_rate = 6.0
	hurt.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hurt.vibrato_fade_in = 0.0
	hurt.arpeggio = []
	hurt.arpeggio_rate = 20.0
	hurt.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	hurt.arpeggio_glide = 0.0
	# ---- FM
	hurt.fm_ratio = 0.0
	hurt.fm_depth = 0.0
	hurt.fm_decay = 0.0
	# ---- Amp envelope
	hurt.attack = 0.0  # *
	hurt.decay = 0.15
	hurt.sustain_level = 0.0
	hurt.sustain_time = 0.0
	hurt.release = 0.05
	hurt.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	hurt.tremolo_depth = 0.0
	hurt.tremolo_rate = 6.0
	hurt.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hurt.repeat_rate = 0.0
	# ---- Filter
	hurt.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	hurt.cutoff = 2000.0
	hurt.cutoff_sweep_octaves = 0.0
	hurt.resonance = 0.0
	hurt.filter_lfo_depth = 0.0
	hurt.filter_lfo_rate = 3.0
	hurt.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	hurt.drive = 0.0
	hurt.bit_depth = 7  # *
	hurt.sample_hold = 1
	# ---- Space
	hurt.delay_time = 0.0
	hurt.delay_feedback = 0.4
	hurt.delay_mix = 0.0
	# ---- Output
	hurt.volume_db = -3.0  # *
	hurt.normalize = true
	hurt.sample_rate = 44100
	hurt.loop = false
	hurt.noise_seed = 1
	hurt.condition = &""
	p[&"p_hurt"] = hurt

	var death := SynthPatch.new()
	# ---- Oscillator
	death.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	death.duty = 0.3  # *
	death.base_freq = 240.0  # *
	death.noise_mix = 0.0
	death.noise_tone = 1.0
	death.sub_mix = 0.0
	death.detune_cents = 0.0
	death.detune_mix = 0.0
	death.pwm_depth = 0.0
	death.pwm_rate = 2.0
	death.ring_ratio = 0.0
	death.ring_mix = 0.0
	# ---- Pitch motion
	death.pitch_sweep_semitones = -26.0  # *
	death.pitch_sweep_curve = 1.2  # *
	death.vibrato_depth = 1.0  # *
	death.vibrato_rate = 7.0  # *
	death.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	death.vibrato_fade_in = 0.0
	death.arpeggio = []
	death.arpeggio_rate = 20.0
	death.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	death.arpeggio_glide = 0.0
	# ---- FM
	death.fm_ratio = 0.0
	death.fm_depth = 0.0
	death.fm_decay = 0.0
	# ---- Amp envelope
	death.attack = 0.01  # *
	death.decay = 0.3  # *
	death.sustain_level = 0.5  # *
	death.sustain_time = 0.3  # *
	death.release = 0.5  # *
	death.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	death.tremolo_depth = 0.0
	death.tremolo_rate = 6.0
	death.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	death.repeat_rate = 0.0
	# ---- Filter
	death.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	death.cutoff = 2000.0
	death.cutoff_sweep_octaves = 0.0
	death.resonance = 0.0
	death.filter_lfo_depth = 0.0
	death.filter_lfo_rate = 3.0
	death.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	death.drive = 0.0
	death.bit_depth = 5  # *
	death.sample_hold = 4  # *
	# ---- Space
	death.delay_time = 0.18  # *
	death.delay_feedback = 0.4
	death.delay_mix = 0.3  # *
	# ---- Output
	death.volume_db = -3.0  # *
	death.normalize = true
	death.sample_rate = 44100
	death.loop = false
	death.noise_seed = 1
	death.condition = &""
	p[&"p_death"] = death

	# ---------------------------------------------------------------- Movement
	var jump := SynthPatch.new()
	# ---- Oscillator
	jump.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	jump.duty = 0.4  # *
	jump.base_freq = 260.0  # *
	jump.noise_mix = 0.0
	jump.noise_tone = 1.0
	jump.sub_mix = 0.0
	jump.detune_cents = 0.0
	jump.detune_mix = 0.0
	jump.pwm_depth = 0.0
	jump.pwm_rate = 2.0
	jump.ring_ratio = 0.0
	jump.ring_mix = 0.0
	# ---- Pitch motion
	jump.pitch_sweep_semitones = 10.0  # *
	jump.pitch_sweep_curve = 0.7  # *
	jump.vibrato_depth = 0.0
	jump.vibrato_rate = 6.0
	jump.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	jump.vibrato_fade_in = 0.0
	jump.arpeggio = []
	jump.arpeggio_rate = 20.0
	jump.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	jump.arpeggio_glide = 0.0
	# ---- FM
	jump.fm_ratio = 0.0
	jump.fm_depth = 0.0
	jump.fm_decay = 0.0
	# ---- Amp envelope
	jump.attack = 0.0  # *
	jump.decay = 0.14  # *
	jump.sustain_level = 0.0
	jump.sustain_time = 0.0
	jump.release = 0.04  # *
	jump.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	jump.tremolo_depth = 0.0
	jump.tremolo_rate = 6.0
	jump.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	jump.repeat_rate = 0.0
	# ---- Filter
	jump.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	jump.cutoff = 2000.0
	jump.cutoff_sweep_octaves = 0.0
	jump.resonance = 0.0
	jump.filter_lfo_depth = 0.0
	jump.filter_lfo_rate = 3.0
	jump.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	jump.drive = 0.0
	jump.bit_depth = 16
	jump.sample_hold = 1
	# ---- Space
	jump.delay_time = 0.0
	jump.delay_feedback = 0.4
	jump.delay_mix = 0.0
	# ---- Output
	jump.volume_db = -8.0  # *
	jump.normalize = true
	jump.sample_rate = 44100
	jump.loop = false
	jump.noise_seed = 1
	jump.condition = &""
	p[&"p_jump"] = jump

	var land := SynthPatch.new()
	# ---- Oscillator
	land.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	land.duty = 0.5
	land.base_freq = 440.0
	land.noise_mix = 0.0
	land.noise_tone = 1.0
	land.sub_mix = 0.0
	land.detune_cents = 0.0
	land.detune_mix = 0.0
	land.pwm_depth = 0.0
	land.pwm_rate = 2.0
	land.ring_ratio = 0.0
	land.ring_mix = 0.0
	# ---- Pitch motion
	land.pitch_sweep_semitones = 0.0
	land.pitch_sweep_curve = 1.0
	land.vibrato_depth = 0.0
	land.vibrato_rate = 6.0
	land.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	land.vibrato_fade_in = 0.0
	land.arpeggio = []
	land.arpeggio_rate = 20.0
	land.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	land.arpeggio_glide = 0.0
	# ---- FM
	land.fm_ratio = 0.0
	land.fm_depth = 0.0
	land.fm_decay = 0.0
	# ---- Amp envelope
	land.attack = 0.0  # *
	land.decay = 0.07  # *
	land.sustain_level = 0.0
	land.sustain_time = 0.0
	land.release = 0.02  # *
	land.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	land.tremolo_depth = 0.0
	land.tremolo_rate = 6.0
	land.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	land.repeat_rate = 0.0
	# ---- Filter
	land.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	land.cutoff = 900.0  # *
	land.cutoff_sweep_octaves = -2.0  # *
	land.resonance = 0.0
	land.filter_lfo_depth = 0.0
	land.filter_lfo_rate = 3.0
	land.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	land.drive = 0.0
	land.bit_depth = 16
	land.sample_hold = 1
	# ---- Space
	land.delay_time = 0.0
	land.delay_feedback = 0.4
	land.delay_mix = 0.0
	# ---- Output
	land.volume_db = -6.0  # *
	land.normalize = true
	land.sample_rate = 44100
	land.loop = false
	land.noise_seed = 1
	land.condition = &""
	p[&"p_land"] = land

	# ------------------------------------------------------------------ Pickups
	var pickup_mana := SynthPatch.new()
	# ---- Oscillator
	pickup_mana.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	pickup_mana.duty = 0.5
	pickup_mana.base_freq = 880.0  # *
	pickup_mana.noise_mix = 0.0
	pickup_mana.noise_tone = 1.0
	pickup_mana.sub_mix = 0.0
	pickup_mana.detune_cents = 0.0
	pickup_mana.detune_mix = 0.0
	pickup_mana.pwm_depth = 0.0
	pickup_mana.pwm_rate = 2.0
	pickup_mana.ring_ratio = 0.0
	pickup_mana.ring_mix = 0.0
	# ---- Pitch motion
	pickup_mana.pitch_sweep_semitones = 0.0
	pickup_mana.pitch_sweep_curve = 1.0
	pickup_mana.vibrato_depth = 0.0
	pickup_mana.vibrato_rate = 6.0
	pickup_mana.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pickup_mana.vibrato_fade_in = 0.0
	pickup_mana.arpeggio = [0, 7, 12]  # *
	pickup_mana.arpeggio_rate = 30.0  # *
	pickup_mana.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pickup_mana.arpeggio_glide = 0.0
	# ---- FM
	pickup_mana.fm_ratio = 2.0  # *
	pickup_mana.fm_depth = 1.2  # *
	pickup_mana.fm_decay = 0.0
	# ---- Amp envelope
	pickup_mana.attack = 0.0  # *
	pickup_mana.decay = 0.12  # *
	pickup_mana.sustain_level = 0.0
	pickup_mana.sustain_time = 0.0
	pickup_mana.release = 0.1  # *
	pickup_mana.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pickup_mana.tremolo_depth = 0.0
	pickup_mana.tremolo_rate = 6.0
	pickup_mana.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pickup_mana.repeat_rate = 0.0
	# ---- Filter
	pickup_mana.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	pickup_mana.cutoff = 2000.0
	pickup_mana.cutoff_sweep_octaves = 0.0
	pickup_mana.resonance = 0.0
	pickup_mana.filter_lfo_depth = 0.0
	pickup_mana.filter_lfo_rate = 3.0
	pickup_mana.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pickup_mana.drive = 0.0
	pickup_mana.bit_depth = 16
	pickup_mana.sample_hold = 1
	# ---- Space
	pickup_mana.delay_time = 0.0
	pickup_mana.delay_feedback = 0.4
	pickup_mana.delay_mix = 0.0
	# ---- Output
	pickup_mana.volume_db = -8.0  # *
	pickup_mana.normalize = true
	pickup_mana.sample_rate = 44100
	pickup_mana.loop = false
	pickup_mana.noise_seed = 1
	pickup_mana.condition = &""
	p[&"p_pickup_mana"] = pickup_mana

	var pickup_rare := SynthPatch.new()
	# ---- Oscillator
	pickup_rare.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	pickup_rare.duty = 0.5
	pickup_rare.base_freq = 523.0  # *
	pickup_rare.noise_mix = 0.0
	pickup_rare.noise_tone = 1.0
	pickup_rare.sub_mix = 0.0
	pickup_rare.detune_cents = 0.0
	pickup_rare.detune_mix = 0.0
	pickup_rare.pwm_depth = 0.0
	pickup_rare.pwm_rate = 2.0
	pickup_rare.ring_ratio = 0.0
	pickup_rare.ring_mix = 0.0
	# ---- Pitch motion
	pickup_rare.pitch_sweep_semitones = 0.0
	pickup_rare.pitch_sweep_curve = 1.0
	pickup_rare.vibrato_depth = 0.0
	pickup_rare.vibrato_rate = 6.0
	pickup_rare.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pickup_rare.vibrato_fade_in = 0.0
	pickup_rare.arpeggio = [0, 4, 7, 12, 16, 19, 24]  # *
	pickup_rare.arpeggio_rate = 26.0  # *
	pickup_rare.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pickup_rare.arpeggio_glide = 0.0
	# ---- FM
	pickup_rare.fm_ratio = 0.0
	pickup_rare.fm_depth = 0.0
	pickup_rare.fm_decay = 0.0
	# ---- Amp envelope
	pickup_rare.attack = 0.0  # *
	pickup_rare.decay = 0.2  # *
	pickup_rare.sustain_level = 0.4  # *
	pickup_rare.sustain_time = 0.1  # *
	pickup_rare.release = 0.25  # *
	pickup_rare.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pickup_rare.tremolo_depth = 0.0
	pickup_rare.tremolo_rate = 6.0
	pickup_rare.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pickup_rare.repeat_rate = 0.0
	# ---- Filter
	pickup_rare.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	pickup_rare.cutoff = 2000.0
	pickup_rare.cutoff_sweep_octaves = 0.0
	pickup_rare.resonance = 0.0
	pickup_rare.filter_lfo_depth = 0.0
	pickup_rare.filter_lfo_rate = 3.0
	pickup_rare.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pickup_rare.drive = 0.0
	pickup_rare.bit_depth = 16
	pickup_rare.sample_hold = 1
	# ---- Space
	pickup_rare.delay_time = 0.13  # *
	pickup_rare.delay_feedback = 0.4
	pickup_rare.delay_mix = 0.3  # *
	# ---- Output
	pickup_rare.volume_db = -6.0  # *
	pickup_rare.normalize = true
	pickup_rare.sample_rate = 44100
	pickup_rare.loop = false
	pickup_rare.noise_seed = 1
	pickup_rare.condition = &""
	p[&"p_pickup_rare"] = pickup_rare

	# ---------------------------------------------------------------------- UI
	var ui_click := SynthPatch.new()
	# ---- Oscillator
	ui_click.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_click.duty = 0.5
	ui_click.base_freq = 1200.0  # *
	ui_click.noise_mix = 0.0
	ui_click.noise_tone = 1.0
	ui_click.sub_mix = 0.0
	ui_click.detune_cents = 0.0
	ui_click.detune_mix = 0.0
	ui_click.pwm_depth = 0.0
	ui_click.pwm_rate = 2.0
	ui_click.ring_ratio = 0.0
	ui_click.ring_mix = 0.0
	# ---- Pitch motion
	ui_click.pitch_sweep_semitones = 0.0
	ui_click.pitch_sweep_curve = 1.0
	ui_click.vibrato_depth = 0.0
	ui_click.vibrato_rate = 6.0
	ui_click.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_click.vibrato_fade_in = 0.0
	ui_click.arpeggio = []
	ui_click.arpeggio_rate = 20.0
	ui_click.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_click.arpeggio_glide = 0.0
	# ---- FM
	ui_click.fm_ratio = 0.0
	ui_click.fm_depth = 0.0
	ui_click.fm_decay = 0.0
	# ---- Amp envelope
	ui_click.attack = 0.0  # *
	ui_click.decay = 0.03  # *
	ui_click.sustain_level = 0.0
	ui_click.sustain_time = 0.0
	ui_click.release = 0.01  # *
	ui_click.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_click.tremolo_depth = 0.0
	ui_click.tremolo_rate = 6.0
	ui_click.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_click.repeat_rate = 0.0
	# ---- Filter
	ui_click.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_click.cutoff = 2000.0
	ui_click.cutoff_sweep_octaves = 0.0
	ui_click.resonance = 0.0
	ui_click.filter_lfo_depth = 0.0
	ui_click.filter_lfo_rate = 3.0
	ui_click.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_click.drive = 0.0
	ui_click.bit_depth = 16
	ui_click.sample_hold = 1
	# ---- Space
	ui_click.delay_time = 0.0
	ui_click.delay_feedback = 0.4
	ui_click.delay_mix = 0.0
	# ---- Output
	ui_click.volume_db = -10.0  # *
	ui_click.normalize = true
	ui_click.sample_rate = 44100
	ui_click.loop = false
	ui_click.noise_seed = 1
	ui_click.condition = &""
	p[&"p_ui_click"] = ui_click

	var ui_confirm := SynthPatch.new()
	# ---- Oscillator
	ui_confirm.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_confirm.duty = 0.5
	ui_confirm.base_freq = 700.0  # *
	ui_confirm.noise_mix = 0.0
	ui_confirm.noise_tone = 1.0
	ui_confirm.sub_mix = 0.0
	ui_confirm.detune_cents = 0.0
	ui_confirm.detune_mix = 0.0
	ui_confirm.pwm_depth = 0.0
	ui_confirm.pwm_rate = 2.0
	ui_confirm.ring_ratio = 0.0
	ui_confirm.ring_mix = 0.0
	# ---- Pitch motion
	ui_confirm.pitch_sweep_semitones = 0.0
	ui_confirm.pitch_sweep_curve = 1.0
	ui_confirm.vibrato_depth = 0.0
	ui_confirm.vibrato_rate = 6.0
	ui_confirm.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_confirm.vibrato_fade_in = 0.0
	ui_confirm.arpeggio = [0, 5]  # *
	ui_confirm.arpeggio_rate = 16.0  # *
	ui_confirm.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_confirm.arpeggio_glide = 0.0
	# ---- FM
	ui_confirm.fm_ratio = 0.0
	ui_confirm.fm_depth = 0.0
	ui_confirm.fm_decay = 0.0
	# ---- Amp envelope
	ui_confirm.attack = 0.0  # *
	ui_confirm.decay = 0.12  # *
	ui_confirm.sustain_level = 0.0
	ui_confirm.sustain_time = 0.0
	ui_confirm.release = 0.05
	ui_confirm.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_confirm.tremolo_depth = 0.0
	ui_confirm.tremolo_rate = 6.0
	ui_confirm.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_confirm.repeat_rate = 0.0
	# ---- Filter
	ui_confirm.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_confirm.cutoff = 2000.0
	ui_confirm.cutoff_sweep_octaves = 0.0
	ui_confirm.resonance = 0.0
	ui_confirm.filter_lfo_depth = 0.0
	ui_confirm.filter_lfo_rate = 3.0
	ui_confirm.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_confirm.drive = 0.0
	ui_confirm.bit_depth = 16
	ui_confirm.sample_hold = 1
	# ---- Space
	ui_confirm.delay_time = 0.0
	ui_confirm.delay_feedback = 0.4
	ui_confirm.delay_mix = 0.0
	# ---- Output
	ui_confirm.volume_db = -8.0  # *
	ui_confirm.normalize = true
	ui_confirm.sample_rate = 44100
	ui_confirm.loop = false
	ui_confirm.noise_seed = 1
	ui_confirm.condition = &""
	p[&"p_ui_confirm"] = ui_confirm

	var ui_back := SynthPatch.new()
	# ---- Oscillator
	ui_back.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_back.duty = 0.5
	ui_back.base_freq = 700.0  # *
	ui_back.noise_mix = 0.0
	ui_back.noise_tone = 1.0
	ui_back.sub_mix = 0.0
	ui_back.detune_cents = 0.0
	ui_back.detune_mix = 0.0
	ui_back.pwm_depth = 0.0
	ui_back.pwm_rate = 2.0
	ui_back.ring_ratio = 0.0
	ui_back.ring_mix = 0.0
	# ---- Pitch motion
	ui_back.pitch_sweep_semitones = 0.0
	ui_back.pitch_sweep_curve = 1.0
	ui_back.vibrato_depth = 0.0
	ui_back.vibrato_rate = 6.0
	ui_back.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_back.vibrato_fade_in = 0.0
	ui_back.arpeggio = [0, -5]  # *
	ui_back.arpeggio_rate = 16.0  # *
	ui_back.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_back.arpeggio_glide = 0.0
	# ---- FM
	ui_back.fm_ratio = 0.0
	ui_back.fm_depth = 0.0
	ui_back.fm_decay = 0.0
	# ---- Amp envelope
	ui_back.attack = 0.0  # *
	ui_back.decay = 0.12  # *
	ui_back.sustain_level = 0.0
	ui_back.sustain_time = 0.0
	ui_back.release = 0.05
	ui_back.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_back.tremolo_depth = 0.0
	ui_back.tremolo_rate = 6.0
	ui_back.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_back.repeat_rate = 0.0
	# ---- Filter
	ui_back.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_back.cutoff = 2000.0
	ui_back.cutoff_sweep_octaves = 0.0
	ui_back.resonance = 0.0
	ui_back.filter_lfo_depth = 0.0
	ui_back.filter_lfo_rate = 3.0
	ui_back.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_back.drive = 0.0
	ui_back.bit_depth = 16
	ui_back.sample_hold = 1
	# ---- Space
	ui_back.delay_time = 0.0
	ui_back.delay_feedback = 0.4
	ui_back.delay_mix = 0.0
	# ---- Output
	ui_back.volume_db = -8.0  # *
	ui_back.normalize = true
	ui_back.sample_rate = 44100
	ui_back.loop = false
	ui_back.noise_seed = 1
	ui_back.condition = &""
	p[&"p_ui_back"] = ui_back

	# ================================================================= Artillery
	# The ship's gun is the hero sound of the game. Loading is wood and iron, charging is magic
	# building up, firing is the biggest thing in the mix, and the flyby/impact sell the distance.

	var artillery_load := SynthPatch.new()
	# ---- Oscillator
	artillery_load.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_load.duty = 0.5
	artillery_load.base_freq = 440.0
	artillery_load.noise_mix = 0.0
	artillery_load.noise_tone = 1.0
	artillery_load.sub_mix = 0.0
	artillery_load.detune_cents = 0.0
	artillery_load.detune_mix = 0.0
	artillery_load.pwm_depth = 0.0
	artillery_load.pwm_rate = 2.0
	artillery_load.ring_ratio = 0.0
	artillery_load.ring_mix = 0.0
	# ---- Pitch motion
	artillery_load.pitch_sweep_semitones = 0.0
	artillery_load.pitch_sweep_curve = 1.0
	artillery_load.vibrato_depth = 0.0
	artillery_load.vibrato_rate = 6.0
	artillery_load.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_load.vibrato_fade_in = 0.0
	artillery_load.arpeggio = []
	artillery_load.arpeggio_rate = 20.0
	artillery_load.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_load.arpeggio_glide = 0.0
	# ---- FM
	artillery_load.fm_ratio = 0.0
	artillery_load.fm_depth = 0.0
	artillery_load.fm_decay = 0.0
	# ---- Amp envelope
	artillery_load.attack = 0.0  # *
	artillery_load.decay = 0.12  # *
	artillery_load.sustain_level = 0.0
	artillery_load.sustain_time = 0.0
	artillery_load.release = 0.05
	artillery_load.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_load.tremolo_depth = 0.0
	artillery_load.tremolo_rate = 6.0
	artillery_load.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_load.repeat_rate = 0.0
	# ---- Filter
	artillery_load.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_load.cutoff = 700.0  # *
	artillery_load.cutoff_sweep_octaves = -1.0  # *
	artillery_load.resonance = 0.55  # *
	artillery_load.filter_lfo_depth = 0.0
	artillery_load.filter_lfo_rate = 3.0
	artillery_load.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_load.drive = 0.3  # *
	artillery_load.bit_depth = 16
	artillery_load.sample_hold = 1
	# ---- Space
	artillery_load.delay_time = 0.06  # *
	artillery_load.delay_feedback = 0.3  # *
	artillery_load.delay_mix = 0.3  # *
	# ---- Output
	artillery_load.volume_db = -4.0  # *
	artillery_load.normalize = true
	artillery_load.sample_rate = 44100
	artillery_load.loop = false
	artillery_load.noise_seed = 1
	artillery_load.condition = &""
	p[&"p_artillery_load"] = artillery_load

	var artillery_lock := SynthPatch.new()
	# ---- Oscillator
	artillery_lock.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_lock.duty = 0.5
	artillery_lock.base_freq = 520.0  # *
	artillery_lock.noise_mix = 0.25  # *
	artillery_lock.noise_tone = 1.0
	artillery_lock.sub_mix = 0.0
	artillery_lock.detune_cents = 0.0
	artillery_lock.detune_mix = 0.0
	artillery_lock.pwm_depth = 0.0
	artillery_lock.pwm_rate = 2.0
	artillery_lock.ring_ratio = 0.0
	artillery_lock.ring_mix = 0.0
	# ---- Pitch motion
	artillery_lock.pitch_sweep_semitones = 0.0
	artillery_lock.pitch_sweep_curve = 1.0
	artillery_lock.vibrato_depth = 0.0
	artillery_lock.vibrato_rate = 6.0
	artillery_lock.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_lock.vibrato_fade_in = 0.0
	artillery_lock.arpeggio = []
	artillery_lock.arpeggio_rate = 20.0
	artillery_lock.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_lock.arpeggio_glide = 0.0
	# ---- FM
	artillery_lock.fm_ratio = 3.7  # *
	artillery_lock.fm_depth = 7.0  # *
	artillery_lock.fm_decay = 0.05  # *
	# ---- Amp envelope
	artillery_lock.attack = 0.0  # *
	artillery_lock.decay = 0.18  # *
	artillery_lock.sustain_level = 0.0
	artillery_lock.sustain_time = 0.0
	artillery_lock.release = 0.05
	artillery_lock.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_lock.tremolo_depth = 0.0
	artillery_lock.tremolo_rate = 6.0
	artillery_lock.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_lock.repeat_rate = 0.0
	# ---- Filter
	artillery_lock.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_lock.cutoff = 2000.0
	artillery_lock.cutoff_sweep_octaves = 0.0
	artillery_lock.resonance = 0.0
	artillery_lock.filter_lfo_depth = 0.0
	artillery_lock.filter_lfo_rate = 3.0
	artillery_lock.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_lock.drive = 0.4  # *
	artillery_lock.bit_depth = 16
	artillery_lock.sample_hold = 1
	# ---- Space
	artillery_lock.delay_time = 0.0
	artillery_lock.delay_feedback = 0.4
	artillery_lock.delay_mix = 0.0
	# ---- Output
	artillery_lock.volume_db = -5.0  # *
	artillery_lock.normalize = true
	artillery_lock.sample_rate = 44100
	artillery_lock.loop = false
	artillery_lock.noise_seed = 1
	artillery_lock.condition = &""
	p[&"p_artillery_lock"] = artillery_lock

	var artillery_charge := SynthPatch.new()
	# ---- Oscillator
	artillery_charge.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_charge.duty = 0.5
	artillery_charge.base_freq = 80.0  # *
	artillery_charge.noise_mix = 0.0
	artillery_charge.noise_tone = 1.0
	artillery_charge.sub_mix = 0.0
	artillery_charge.detune_cents = 0.0
	artillery_charge.detune_mix = 0.0
	artillery_charge.pwm_depth = 0.0
	artillery_charge.pwm_rate = 2.0
	artillery_charge.ring_ratio = 0.0
	artillery_charge.ring_mix = 0.0
	# ---- Pitch motion
	artillery_charge.pitch_sweep_semitones = 31.0  # *
	artillery_charge.pitch_sweep_curve = 1.8  # *
	artillery_charge.vibrato_depth = 0.6  # *
	artillery_charge.vibrato_rate = 14.0  # *
	artillery_charge.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_charge.vibrato_fade_in = 0.0
	artillery_charge.arpeggio = []
	artillery_charge.arpeggio_rate = 20.0
	artillery_charge.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_charge.arpeggio_glide = 0.0
	# ---- FM
	artillery_charge.fm_ratio = 0.0
	artillery_charge.fm_depth = 0.0
	artillery_charge.fm_decay = 0.0
	# ---- Amp envelope
	artillery_charge.attack = 0.05  # *
	artillery_charge.decay = 0.1  # *
	artillery_charge.sustain_level = 0.9  # *
	artillery_charge.sustain_time = 0.9  # *
	artillery_charge.release = 0.05
	artillery_charge.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_charge.tremolo_depth = 0.0
	artillery_charge.tremolo_rate = 6.0
	artillery_charge.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_charge.repeat_rate = 0.0
	# ---- Filter
	artillery_charge.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_charge.cutoff = 300.0  # *
	artillery_charge.cutoff_sweep_octaves = 4.5  # *
	artillery_charge.resonance = 0.6  # *
	artillery_charge.filter_lfo_depth = 0.0
	artillery_charge.filter_lfo_rate = 3.0
	artillery_charge.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_charge.drive = 0.3  # *
	artillery_charge.bit_depth = 16
	artillery_charge.sample_hold = 1
	# ---- Space
	artillery_charge.delay_time = 0.0
	artillery_charge.delay_feedback = 0.4
	artillery_charge.delay_mix = 0.0
	# ---- Output
	artillery_charge.volume_db = -6.0  # *
	artillery_charge.normalize = true
	artillery_charge.sample_rate = 44100
	artillery_charge.loop = false
	artillery_charge.noise_seed = 1
	artillery_charge.condition = &""
	p[&"p_artillery_charge"] = artillery_charge

	var artillery_fire := SynthPatch.new()
	# ---- Oscillator
	artillery_fire.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_fire.duty = 0.5
	artillery_fire.base_freq = 95.0  # *
	artillery_fire.noise_mix = 0.7  # *
	artillery_fire.noise_tone = 1.0
	artillery_fire.sub_mix = 0.0
	artillery_fire.detune_cents = 0.0
	artillery_fire.detune_mix = 0.0
	artillery_fire.pwm_depth = 0.0
	artillery_fire.pwm_rate = 2.0
	artillery_fire.ring_ratio = 0.0
	artillery_fire.ring_mix = 0.0
	# ---- Pitch motion
	artillery_fire.pitch_sweep_semitones = -22.0  # *
	artillery_fire.pitch_sweep_curve = 0.3  # *
	artillery_fire.vibrato_depth = 0.0
	artillery_fire.vibrato_rate = 6.0
	artillery_fire.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_fire.vibrato_fade_in = 0.0
	artillery_fire.arpeggio = []
	artillery_fire.arpeggio_rate = 20.0
	artillery_fire.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_fire.arpeggio_glide = 0.0
	# ---- FM
	artillery_fire.fm_ratio = 0.0
	artillery_fire.fm_depth = 0.0
	artillery_fire.fm_decay = 0.0
	# ---- Amp envelope
	artillery_fire.attack = 0.0  # *
	artillery_fire.decay = 0.9  # *
	artillery_fire.sustain_level = 0.0
	artillery_fire.sustain_time = 0.0
	artillery_fire.release = 0.3  # *
	artillery_fire.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_fire.tremolo_depth = 0.0
	artillery_fire.tremolo_rate = 6.0
	artillery_fire.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_fire.repeat_rate = 0.0
	# ---- Filter
	artillery_fire.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_fire.cutoff = 6000.0  # *
	artillery_fire.cutoff_sweep_octaves = -5.0  # *
	artillery_fire.resonance = 0.2  # *
	artillery_fire.filter_lfo_depth = 0.0
	artillery_fire.filter_lfo_rate = 3.0
	artillery_fire.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_fire.drive = 0.9  # *
	artillery_fire.bit_depth = 16
	artillery_fire.sample_hold = 1
	# ---- Space
	artillery_fire.delay_time = 0.11  # *
	artillery_fire.delay_feedback = 0.35  # *
	artillery_fire.delay_mix = 0.3  # *
	# ---- Output
	artillery_fire.volume_db = 0.0
	artillery_fire.normalize = true
	artillery_fire.sample_rate = 44100
	artillery_fire.loop = false
	artillery_fire.noise_seed = 1
	artillery_fire.condition = &""
	p[&"p_artillery_fire"] = artillery_fire

	var artillery_flyby := SynthPatch.new()
	# ---- Oscillator
	artillery_flyby.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_flyby.duty = 0.5
	artillery_flyby.base_freq = 900.0  # *
	artillery_flyby.noise_mix = 0.35  # *
	artillery_flyby.noise_tone = 1.0
	artillery_flyby.sub_mix = 0.0
	artillery_flyby.detune_cents = 0.0
	artillery_flyby.detune_mix = 0.0
	artillery_flyby.pwm_depth = 0.0
	artillery_flyby.pwm_rate = 2.0
	artillery_flyby.ring_ratio = 0.0
	artillery_flyby.ring_mix = 0.0
	# ---- Pitch motion
	artillery_flyby.pitch_sweep_semitones = -19.0  # *
	artillery_flyby.pitch_sweep_curve = 1.3  # *
	artillery_flyby.vibrato_depth = 0.4  # *
	artillery_flyby.vibrato_rate = 22.0  # *
	artillery_flyby.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_flyby.vibrato_fade_in = 0.0
	artillery_flyby.arpeggio = []
	artillery_flyby.arpeggio_rate = 20.0
	artillery_flyby.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_flyby.arpeggio_glide = 0.0
	# ---- FM
	artillery_flyby.fm_ratio = 0.0
	artillery_flyby.fm_depth = 0.0
	artillery_flyby.fm_decay = 0.0
	# ---- Amp envelope
	artillery_flyby.attack = 0.15  # *
	artillery_flyby.decay = 0.3  # *
	artillery_flyby.sustain_level = 0.6  # *
	artillery_flyby.sustain_time = 0.3  # *
	artillery_flyby.release = 0.4  # *
	artillery_flyby.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_flyby.tremolo_depth = 0.0
	artillery_flyby.tremolo_rate = 6.0
	artillery_flyby.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_flyby.repeat_rate = 0.0
	# ---- Filter
	artillery_flyby.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_flyby.cutoff = 1800.0  # *
	artillery_flyby.cutoff_sweep_octaves = -2.0  # *
	artillery_flyby.resonance = 0.4  # *
	artillery_flyby.filter_lfo_depth = 0.0
	artillery_flyby.filter_lfo_rate = 3.0
	artillery_flyby.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_flyby.drive = 0.0
	artillery_flyby.bit_depth = 16
	artillery_flyby.sample_hold = 1
	# ---- Space
	artillery_flyby.delay_time = 0.0
	artillery_flyby.delay_feedback = 0.4
	artillery_flyby.delay_mix = 0.0
	# ---- Output
	artillery_flyby.volume_db = -8.0  # *
	artillery_flyby.normalize = true
	artillery_flyby.sample_rate = 44100
	artillery_flyby.loop = false
	artillery_flyby.noise_seed = 1
	artillery_flyby.condition = &""
	p[&"p_artillery_flyby"] = artillery_flyby

	var artillery_impact := SynthPatch.new()
	# ---- Oscillator
	artillery_impact.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_impact.duty = 0.5
	artillery_impact.base_freq = 440.0
	artillery_impact.noise_mix = 0.0
	artillery_impact.noise_tone = 1.0
	artillery_impact.sub_mix = 0.0
	artillery_impact.detune_cents = 0.0
	artillery_impact.detune_mix = 0.0
	artillery_impact.pwm_depth = 0.0
	artillery_impact.pwm_rate = 2.0
	artillery_impact.ring_ratio = 0.0
	artillery_impact.ring_mix = 0.0
	# ---- Pitch motion
	artillery_impact.pitch_sweep_semitones = 0.0
	artillery_impact.pitch_sweep_curve = 1.0
	artillery_impact.vibrato_depth = 0.0
	artillery_impact.vibrato_rate = 6.0
	artillery_impact.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_impact.vibrato_fade_in = 0.0
	artillery_impact.arpeggio = []
	artillery_impact.arpeggio_rate = 20.0
	artillery_impact.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_impact.arpeggio_glide = 0.0
	# ---- FM
	artillery_impact.fm_ratio = 0.0
	artillery_impact.fm_depth = 0.0
	artillery_impact.fm_decay = 0.0
	# ---- Amp envelope
	artillery_impact.attack = 0.0  # *
	artillery_impact.decay = 0.6  # *
	artillery_impact.sustain_level = 0.0
	artillery_impact.sustain_time = 0.0
	artillery_impact.release = 0.4  # *
	artillery_impact.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_impact.tremolo_depth = 0.0
	artillery_impact.tremolo_rate = 6.0
	artillery_impact.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_impact.repeat_rate = 0.0
	# ---- Filter
	artillery_impact.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_impact.cutoff = 2500.0  # *
	artillery_impact.cutoff_sweep_octaves = -4.0  # *
	artillery_impact.resonance = 0.3  # *
	artillery_impact.filter_lfo_depth = 0.0
	artillery_impact.filter_lfo_rate = 3.0
	artillery_impact.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_impact.drive = 0.8  # *
	artillery_impact.bit_depth = 16
	artillery_impact.sample_hold = 2  # *
	# ---- Space
	artillery_impact.delay_time = 0.15  # *
	artillery_impact.delay_feedback = 0.4
	artillery_impact.delay_mix = 0.35  # *
	# ---- Output
	artillery_impact.volume_db = 0.0
	artillery_impact.normalize = true
	artillery_impact.sample_rate = 44100
	artillery_impact.loop = false
	artillery_impact.noise_seed = 1
	artillery_impact.condition = &""
	p[&"p_artillery_impact"] = artillery_impact

	var artillery_ready := SynthPatch.new()
	# ---- Oscillator
	artillery_ready.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	artillery_ready.duty = 0.5
	artillery_ready.base_freq = 1320.0  # *
	artillery_ready.noise_mix = 0.0
	artillery_ready.noise_tone = 1.0
	artillery_ready.sub_mix = 0.0
	artillery_ready.detune_cents = 0.0
	artillery_ready.detune_mix = 0.0
	artillery_ready.pwm_depth = 0.0
	artillery_ready.pwm_rate = 2.0
	artillery_ready.ring_ratio = 0.0
	artillery_ready.ring_mix = 0.0
	# ---- Pitch motion
	artillery_ready.pitch_sweep_semitones = 0.0
	artillery_ready.pitch_sweep_curve = 1.0
	artillery_ready.vibrato_depth = 0.0
	artillery_ready.vibrato_rate = 6.0
	artillery_ready.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_ready.vibrato_fade_in = 0.0
	artillery_ready.arpeggio = [0, 5]  # *
	artillery_ready.arpeggio_rate = 9.0  # *
	artillery_ready.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	artillery_ready.arpeggio_glide = 0.0
	# ---- FM
	artillery_ready.fm_ratio = 3.5  # *
	artillery_ready.fm_depth = 2.5  # *
	artillery_ready.fm_decay = 0.15  # *
	# ---- Amp envelope
	artillery_ready.attack = 0.0  # *
	artillery_ready.decay = 0.35  # *
	artillery_ready.sustain_level = 0.0
	artillery_ready.sustain_time = 0.0
	artillery_ready.release = 0.2  # *
	artillery_ready.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	artillery_ready.tremolo_depth = 0.0
	artillery_ready.tremolo_rate = 6.0
	artillery_ready.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	artillery_ready.repeat_rate = 0.0
	# ---- Filter
	artillery_ready.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	artillery_ready.cutoff = 2000.0
	artillery_ready.cutoff_sweep_octaves = 0.0
	artillery_ready.resonance = 0.0
	artillery_ready.filter_lfo_depth = 0.0
	artillery_ready.filter_lfo_rate = 3.0
	artillery_ready.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	artillery_ready.drive = 0.0
	artillery_ready.bit_depth = 16
	artillery_ready.sample_hold = 1
	# ---- Space
	artillery_ready.delay_time = 0.14  # *
	artillery_ready.delay_feedback = 0.3  # *
	artillery_ready.delay_mix = 0.25  # *
	# ---- Output
	artillery_ready.volume_db = -10.0  # *
	artillery_ready.normalize = true
	artillery_ready.sample_rate = 44100
	artillery_ready.loop = false
	artillery_ready.noise_seed = 1
	artillery_ready.condition = &""
	p[&"p_artillery_ready"] = artillery_ready

	# ===================================================================== Spells
	# One family per element. Fire is noisy and falls, ice is crystalline and high, wind is
	# filtered noise, void is low FM, lightning is harsh and fast. Utility spells are "pitch
	# bends": slow bends down, haste bends up, pull is a rising tractor beam.

	var cast_ice := SynthPatch.new()
	# ---- Oscillator
	cast_ice.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_ice.duty = 0.5
	cast_ice.base_freq = 1760.0  # *
	cast_ice.noise_mix = 0.0
	cast_ice.noise_tone = 1.0
	cast_ice.sub_mix = 0.0
	cast_ice.detune_cents = 0.0
	cast_ice.detune_mix = 0.0
	cast_ice.pwm_depth = 0.0
	cast_ice.pwm_rate = 2.0
	cast_ice.ring_ratio = 0.0
	cast_ice.ring_mix = 0.0
	# ---- Pitch motion
	cast_ice.pitch_sweep_semitones = 0.0
	cast_ice.pitch_sweep_curve = 1.0
	cast_ice.vibrato_depth = 0.0
	cast_ice.vibrato_rate = 6.0
	cast_ice.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_ice.vibrato_fade_in = 0.0
	cast_ice.arpeggio = [12, 7, 0, 7, 12, 19]  # *
	cast_ice.arpeggio_rate = 32.0  # *
	cast_ice.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_ice.arpeggio_glide = 0.0
	# ---- FM
	cast_ice.fm_ratio = 7.0  # *
	cast_ice.fm_depth = 2.0  # *
	cast_ice.fm_decay = 0.08  # *
	# ---- Amp envelope
	cast_ice.attack = 0.0  # *
	cast_ice.decay = 0.3  # *
	cast_ice.sustain_level = 0.0
	cast_ice.sustain_time = 0.0
	cast_ice.release = 0.2  # *
	cast_ice.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_ice.tremolo_depth = 0.0
	cast_ice.tremolo_rate = 6.0
	cast_ice.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_ice.repeat_rate = 0.0
	# ---- Filter
	cast_ice.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_ice.cutoff = 900.0  # *
	cast_ice.cutoff_sweep_octaves = 0.0
	cast_ice.resonance = 0.0
	cast_ice.filter_lfo_depth = 0.0
	cast_ice.filter_lfo_rate = 3.0
	cast_ice.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_ice.drive = 0.0
	cast_ice.bit_depth = 16
	cast_ice.sample_hold = 1
	# ---- Space
	cast_ice.delay_time = 0.09  # *
	cast_ice.delay_feedback = 0.5  # *
	cast_ice.delay_mix = 0.4  # *
	# ---- Output
	cast_ice.volume_db = -8.0  # *
	cast_ice.normalize = true
	cast_ice.sample_rate = 44100
	cast_ice.loop = false
	cast_ice.noise_seed = 1
	cast_ice.condition = &""
	p[&"p_cast_ice"] = cast_ice

	var cast_wind := SynthPatch.new()
	# ---- Oscillator
	cast_wind.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_wind.duty = 0.5
	cast_wind.base_freq = 440.0
	cast_wind.noise_mix = 0.0
	cast_wind.noise_tone = 1.0
	cast_wind.sub_mix = 0.0
	cast_wind.detune_cents = 0.0
	cast_wind.detune_mix = 0.0
	cast_wind.pwm_depth = 0.0
	cast_wind.pwm_rate = 2.0
	cast_wind.ring_ratio = 0.0
	cast_wind.ring_mix = 0.0
	# ---- Pitch motion
	cast_wind.pitch_sweep_semitones = 0.0
	cast_wind.pitch_sweep_curve = 1.0
	cast_wind.vibrato_depth = 0.0
	cast_wind.vibrato_rate = 6.0
	cast_wind.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_wind.vibrato_fade_in = 0.0
	cast_wind.arpeggio = []
	cast_wind.arpeggio_rate = 20.0
	cast_wind.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_wind.arpeggio_glide = 0.0
	# ---- FM
	cast_wind.fm_ratio = 0.0
	cast_wind.fm_depth = 0.0
	cast_wind.fm_decay = 0.0
	# ---- Amp envelope
	cast_wind.attack = 0.08  # *
	cast_wind.decay = 0.3  # *
	cast_wind.sustain_level = 0.5  # *
	cast_wind.sustain_time = 0.1  # *
	cast_wind.release = 0.35  # *
	cast_wind.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_wind.tremolo_depth = 0.0
	cast_wind.tremolo_rate = 6.0
	cast_wind.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_wind.repeat_rate = 0.0
	# ---- Filter
	cast_wind.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_wind.cutoff = 500.0  # *
	cast_wind.cutoff_sweep_octaves = 2.5  # *
	cast_wind.resonance = 0.75  # *
	cast_wind.filter_lfo_depth = 0.0
	cast_wind.filter_lfo_rate = 3.0
	cast_wind.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_wind.drive = 0.0
	cast_wind.bit_depth = 16
	cast_wind.sample_hold = 1
	# ---- Space
	cast_wind.delay_time = 0.0
	cast_wind.delay_feedback = 0.4
	cast_wind.delay_mix = 0.0
	# ---- Output
	cast_wind.volume_db = -5.0  # *
	cast_wind.normalize = true
	cast_wind.sample_rate = 44100
	cast_wind.loop = false
	cast_wind.noise_seed = 1
	cast_wind.condition = &""
	p[&"p_cast_wind"] = cast_wind

	var cast_slow := SynthPatch.new()
	# ---- Oscillator
	cast_slow.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_slow.duty = 0.5
	cast_slow.base_freq = 660.0  # *
	cast_slow.noise_mix = 0.0
	cast_slow.noise_tone = 1.0
	cast_slow.sub_mix = 0.0
	cast_slow.detune_cents = 0.0
	cast_slow.detune_mix = 0.0
	cast_slow.pwm_depth = 0.0
	cast_slow.pwm_rate = 2.0
	cast_slow.ring_ratio = 0.0
	cast_slow.ring_mix = 0.0
	# ---- Pitch motion
	cast_slow.pitch_sweep_semitones = -24.0  # *
	cast_slow.pitch_sweep_curve = 1.6  # *
	cast_slow.vibrato_depth = 0.5  # *
	cast_slow.vibrato_rate = 3.0  # *
	cast_slow.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_slow.vibrato_fade_in = 0.0
	cast_slow.arpeggio = []
	cast_slow.arpeggio_rate = 20.0
	cast_slow.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_slow.arpeggio_glide = 0.0
	# ---- FM
	cast_slow.fm_ratio = 1.0  # *
	cast_slow.fm_depth = 1.5  # *
	cast_slow.fm_decay = 0.0
	# ---- Amp envelope
	cast_slow.attack = 0.02  # *
	cast_slow.decay = 0.2  # *
	cast_slow.sustain_level = 0.8  # *
	cast_slow.sustain_time = 0.5  # *
	cast_slow.release = 0.3  # *
	cast_slow.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_slow.tremolo_depth = 0.0
	cast_slow.tremolo_rate = 6.0
	cast_slow.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_slow.repeat_rate = 0.0
	# ---- Filter
	cast_slow.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_slow.cutoff = 4000.0  # *
	cast_slow.cutoff_sweep_octaves = -3.0  # *
	cast_slow.resonance = 0.0
	cast_slow.filter_lfo_depth = 0.0
	cast_slow.filter_lfo_rate = 3.0
	cast_slow.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_slow.drive = 0.0
	cast_slow.bit_depth = 16
	cast_slow.sample_hold = 1
	# ---- Space
	cast_slow.delay_time = 0.25  # *
	cast_slow.delay_feedback = 0.45  # *
	cast_slow.delay_mix = 0.35  # *
	# ---- Output
	cast_slow.volume_db = -7.0  # *
	cast_slow.normalize = true
	cast_slow.sample_rate = 44100
	cast_slow.loop = false
	cast_slow.noise_seed = 1
	cast_slow.condition = &""
	p[&"p_cast_slow"] = cast_slow

	var cast_haste := SynthPatch.new()
	# ---- Oscillator
	cast_haste.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_haste.duty = 0.35  # *
	cast_haste.base_freq = 440.0
	cast_haste.noise_mix = 0.0
	cast_haste.noise_tone = 1.0
	cast_haste.sub_mix = 0.0
	cast_haste.detune_cents = 0.0
	cast_haste.detune_mix = 0.0
	cast_haste.pwm_depth = 0.0
	cast_haste.pwm_rate = 2.0
	cast_haste.ring_ratio = 0.0
	cast_haste.ring_mix = 0.0
	# ---- Pitch motion
	cast_haste.pitch_sweep_semitones = 12.0  # *
	cast_haste.pitch_sweep_curve = 1.0
	cast_haste.vibrato_depth = 0.0
	cast_haste.vibrato_rate = 6.0
	cast_haste.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_haste.vibrato_fade_in = 0.0
	cast_haste.arpeggio = [0, 2, 4, 5, 7, 9, 11, 12]  # *
	cast_haste.arpeggio_rate = 40.0  # *
	cast_haste.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_haste.arpeggio_glide = 0.0
	# ---- FM
	cast_haste.fm_ratio = 0.0
	cast_haste.fm_depth = 0.0
	cast_haste.fm_decay = 0.0
	# ---- Amp envelope
	cast_haste.attack = 0.0  # *
	cast_haste.decay = 0.3  # *
	cast_haste.sustain_level = 0.0
	cast_haste.sustain_time = 0.0
	cast_haste.release = 0.1  # *
	cast_haste.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_haste.tremolo_depth = 0.0
	cast_haste.tremolo_rate = 6.0
	cast_haste.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_haste.repeat_rate = 0.0
	# ---- Filter
	cast_haste.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_haste.cutoff = 2000.0
	cast_haste.cutoff_sweep_octaves = 2.0  # *
	cast_haste.resonance = 0.0
	cast_haste.filter_lfo_depth = 0.0
	cast_haste.filter_lfo_rate = 3.0
	cast_haste.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_haste.drive = 0.0
	cast_haste.bit_depth = 16
	cast_haste.sample_hold = 1
	# ---- Space
	cast_haste.delay_time = 0.1  # *
	cast_haste.delay_feedback = 0.3  # *
	cast_haste.delay_mix = 0.3  # *
	# ---- Output
	cast_haste.volume_db = -9.0  # *
	cast_haste.normalize = true
	cast_haste.sample_rate = 44100
	cast_haste.loop = false
	cast_haste.noise_seed = 1
	cast_haste.condition = &""
	p[&"p_cast_haste"] = cast_haste

	var cast_pull := SynthPatch.new()
	# ---- Oscillator
	cast_pull.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_pull.duty = 0.5
	cast_pull.base_freq = 110.0  # *
	cast_pull.noise_mix = 0.0
	cast_pull.noise_tone = 1.0
	cast_pull.sub_mix = 0.0
	cast_pull.detune_cents = 0.0
	cast_pull.detune_mix = 0.0
	cast_pull.pwm_depth = 0.0
	cast_pull.pwm_rate = 2.0
	cast_pull.ring_ratio = 0.0
	cast_pull.ring_mix = 0.0
	# ---- Pitch motion
	cast_pull.pitch_sweep_semitones = 17.0  # *
	cast_pull.pitch_sweep_curve = 0.8  # *
	cast_pull.vibrato_depth = 0.3  # *
	cast_pull.vibrato_rate = 7.0  # *
	cast_pull.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_pull.vibrato_fade_in = 0.0
	cast_pull.arpeggio = []
	cast_pull.arpeggio_rate = 20.0
	cast_pull.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_pull.arpeggio_glide = 0.0
	# ---- FM
	cast_pull.fm_ratio = 0.0
	cast_pull.fm_depth = 0.0
	cast_pull.fm_decay = 0.0
	# ---- Amp envelope
	cast_pull.attack = 0.1  # *
	cast_pull.decay = 0.2  # *
	cast_pull.sustain_level = 0.8  # *
	cast_pull.sustain_time = 0.5  # *
	cast_pull.release = 0.25  # *
	cast_pull.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_pull.tremolo_depth = 0.0
	cast_pull.tremolo_rate = 6.0
	cast_pull.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_pull.repeat_rate = 0.0
	# ---- Filter
	cast_pull.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_pull.cutoff = 500.0  # *
	cast_pull.cutoff_sweep_octaves = 2.5  # *
	cast_pull.resonance = 0.5  # *
	cast_pull.filter_lfo_depth = 0.0
	cast_pull.filter_lfo_rate = 3.0
	cast_pull.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_pull.drive = 0.0
	cast_pull.bit_depth = 16
	cast_pull.sample_hold = 1
	# ---- Space
	cast_pull.delay_time = 0.2  # *
	cast_pull.delay_feedback = 0.4
	cast_pull.delay_mix = 0.3  # *
	# ---- Output
	cast_pull.volume_db = -8.0  # *
	cast_pull.normalize = true
	cast_pull.sample_rate = 44100
	cast_pull.loop = false
	cast_pull.noise_seed = 1
	cast_pull.condition = &""
	p[&"p_cast_pull"] = cast_pull

	var cast_big_blast := SynthPatch.new()
	# ---- Oscillator
	cast_big_blast.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	cast_big_blast.duty = 0.5
	cast_big_blast.base_freq = 140.0  # *
	cast_big_blast.noise_mix = 0.45  # *
	cast_big_blast.noise_tone = 1.0
	cast_big_blast.sub_mix = 0.0
	cast_big_blast.detune_cents = 0.0
	cast_big_blast.detune_mix = 0.0
	cast_big_blast.pwm_depth = 0.0
	cast_big_blast.pwm_rate = 2.0
	cast_big_blast.ring_ratio = 0.0
	cast_big_blast.ring_mix = 0.0
	# ---- Pitch motion
	cast_big_blast.pitch_sweep_semitones = -30.0  # *
	cast_big_blast.pitch_sweep_curve = 0.5  # *
	cast_big_blast.vibrato_depth = 0.0
	cast_big_blast.vibrato_rate = 6.0
	cast_big_blast.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_big_blast.vibrato_fade_in = 0.0
	cast_big_blast.arpeggio = []
	cast_big_blast.arpeggio_rate = 20.0
	cast_big_blast.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	cast_big_blast.arpeggio_glide = 0.0
	# ---- FM
	cast_big_blast.fm_ratio = 0.5  # *
	cast_big_blast.fm_depth = 9.0  # *
	cast_big_blast.fm_decay = 0.4  # *
	# ---- Amp envelope
	cast_big_blast.attack = 0.0  # *
	cast_big_blast.decay = 1.2  # *
	cast_big_blast.sustain_level = 0.0
	cast_big_blast.sustain_time = 0.0
	cast_big_blast.release = 0.5  # *
	cast_big_blast.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	cast_big_blast.tremolo_depth = 0.0
	cast_big_blast.tremolo_rate = 6.0
	cast_big_blast.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	cast_big_blast.repeat_rate = 0.0
	# ---- Filter
	cast_big_blast.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	cast_big_blast.cutoff = 5000.0  # *
	cast_big_blast.cutoff_sweep_octaves = -4.0  # *
	cast_big_blast.resonance = 0.0
	cast_big_blast.filter_lfo_depth = 0.0
	cast_big_blast.filter_lfo_rate = 3.0
	cast_big_blast.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	cast_big_blast.drive = 0.9  # *
	cast_big_blast.bit_depth = 16
	cast_big_blast.sample_hold = 1
	# ---- Space
	cast_big_blast.delay_time = 0.18  # *
	cast_big_blast.delay_feedback = 0.45  # *
	cast_big_blast.delay_mix = 0.35  # *
	# ---- Output
	cast_big_blast.volume_db = 0.0
	cast_big_blast.normalize = true
	cast_big_blast.sample_rate = 44100
	cast_big_blast.loop = false
	cast_big_blast.noise_seed = 1
	cast_big_blast.condition = &""
	p[&"p_cast_big_blast"] = cast_big_blast

	var ritual_tick := SynthPatch.new()
	# ---- Oscillator
	ritual_tick.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ritual_tick.duty = 0.5
	ritual_tick.base_freq = 1100.0  # *
	ritual_tick.noise_mix = 0.0
	ritual_tick.noise_tone = 1.0
	ritual_tick.sub_mix = 0.0
	ritual_tick.detune_cents = 0.0
	ritual_tick.detune_mix = 0.0
	ritual_tick.pwm_depth = 0.0
	ritual_tick.pwm_rate = 2.0
	ritual_tick.ring_ratio = 0.0
	ritual_tick.ring_mix = 0.0
	# ---- Pitch motion
	ritual_tick.pitch_sweep_semitones = 0.0
	ritual_tick.pitch_sweep_curve = 1.0
	ritual_tick.vibrato_depth = 0.0
	ritual_tick.vibrato_rate = 6.0
	ritual_tick.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ritual_tick.vibrato_fade_in = 0.0
	ritual_tick.arpeggio = []
	ritual_tick.arpeggio_rate = 20.0
	ritual_tick.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ritual_tick.arpeggio_glide = 0.0
	# ---- FM
	ritual_tick.fm_ratio = 2.0  # *
	ritual_tick.fm_depth = 1.0  # *
	ritual_tick.fm_decay = 0.05  # *
	# ---- Amp envelope
	ritual_tick.attack = 0.0  # *
	ritual_tick.decay = 0.08  # *
	ritual_tick.sustain_level = 0.0
	ritual_tick.sustain_time = 0.0
	ritual_tick.release = 0.04  # *
	ritual_tick.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ritual_tick.tremolo_depth = 0.0
	ritual_tick.tremolo_rate = 6.0
	ritual_tick.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ritual_tick.repeat_rate = 0.0
	# ---- Filter
	ritual_tick.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ritual_tick.cutoff = 2000.0
	ritual_tick.cutoff_sweep_octaves = 0.0
	ritual_tick.resonance = 0.0
	ritual_tick.filter_lfo_depth = 0.0
	ritual_tick.filter_lfo_rate = 3.0
	ritual_tick.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ritual_tick.drive = 0.0
	ritual_tick.bit_depth = 16
	ritual_tick.sample_hold = 1
	# ---- Space
	ritual_tick.delay_time = 0.12  # *
	ritual_tick.delay_feedback = 0.3  # *
	ritual_tick.delay_mix = 0.3  # *
	# ---- Output
	ritual_tick.volume_db = -14.0  # *
	ritual_tick.normalize = true
	ritual_tick.sample_rate = 44100
	ritual_tick.loop = false
	ritual_tick.noise_seed = 1
	ritual_tick.condition = &""
	p[&"p_ritual_tick"] = ritual_tick

	var ritual_complete := SynthPatch.new()
	# ---- Oscillator
	ritual_complete.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ritual_complete.duty = 0.5
	ritual_complete.base_freq = 330.0  # *
	ritual_complete.noise_mix = 0.0
	ritual_complete.noise_tone = 1.0
	ritual_complete.sub_mix = 0.0
	ritual_complete.detune_cents = 0.0
	ritual_complete.detune_mix = 0.0
	ritual_complete.pwm_depth = 0.0
	ritual_complete.pwm_rate = 2.0
	ritual_complete.ring_ratio = 0.0
	ritual_complete.ring_mix = 0.0
	# ---- Pitch motion
	ritual_complete.pitch_sweep_semitones = 0.0
	ritual_complete.pitch_sweep_curve = 1.0
	ritual_complete.vibrato_depth = 0.0
	ritual_complete.vibrato_rate = 6.0
	ritual_complete.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ritual_complete.vibrato_fade_in = 0.0
	ritual_complete.arpeggio = [0, 4, 7, 12, 16, 19, 24]  # *
	ritual_complete.arpeggio_rate = 14.0  # *
	ritual_complete.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ritual_complete.arpeggio_glide = 0.0
	# ---- FM
	ritual_complete.fm_ratio = 2.0  # *
	ritual_complete.fm_depth = 1.5  # *
	ritual_complete.fm_decay = 0.0
	# ---- Amp envelope
	ritual_complete.attack = 0.01  # *
	ritual_complete.decay = 0.3  # *
	ritual_complete.sustain_level = 0.7  # *
	ritual_complete.sustain_time = 0.4  # *
	ritual_complete.release = 0.6  # *
	ritual_complete.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ritual_complete.tremolo_depth = 0.0
	ritual_complete.tremolo_rate = 6.0
	ritual_complete.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ritual_complete.repeat_rate = 0.0
	# ---- Filter
	ritual_complete.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ritual_complete.cutoff = 1500.0  # *
	ritual_complete.cutoff_sweep_octaves = 2.5  # *
	ritual_complete.resonance = 0.0
	ritual_complete.filter_lfo_depth = 0.0
	ritual_complete.filter_lfo_rate = 3.0
	ritual_complete.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ritual_complete.drive = 0.0
	ritual_complete.bit_depth = 16
	ritual_complete.sample_hold = 1
	# ---- Space
	ritual_complete.delay_time = 0.27  # *
	ritual_complete.delay_feedback = 0.5  # *
	ritual_complete.delay_mix = 0.4  # *
	# ---- Output
	ritual_complete.volume_db = -5.0  # *
	ritual_complete.normalize = true
	ritual_complete.sample_rate = 44100
	ritual_complete.loop = false
	ritual_complete.noise_seed = 1
	ritual_complete.condition = &""
	p[&"p_ritual_complete"] = ritual_complete

	var rune_activate := SynthPatch.new()
	# ---- Oscillator
	rune_activate.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	rune_activate.duty = 0.5
	rune_activate.base_freq = 880.0  # *
	rune_activate.noise_mix = 0.0
	rune_activate.noise_tone = 1.0
	rune_activate.sub_mix = 0.0
	rune_activate.detune_cents = 0.0
	rune_activate.detune_mix = 0.0
	rune_activate.pwm_depth = 0.0
	rune_activate.pwm_rate = 2.0
	rune_activate.ring_ratio = 0.0
	rune_activate.ring_mix = 0.0
	# ---- Pitch motion
	rune_activate.pitch_sweep_semitones = 5.0  # *
	rune_activate.pitch_sweep_curve = 0.5  # *
	rune_activate.vibrato_depth = 0.0
	rune_activate.vibrato_rate = 6.0
	rune_activate.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rune_activate.vibrato_fade_in = 0.0
	rune_activate.arpeggio = []
	rune_activate.arpeggio_rate = 20.0
	rune_activate.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	rune_activate.arpeggio_glide = 0.0
	# ---- FM
	rune_activate.fm_ratio = 2.76  # *
	rune_activate.fm_depth = 5.0  # *
	rune_activate.fm_decay = 0.3  # *
	# ---- Amp envelope
	rune_activate.attack = 0.01  # *
	rune_activate.decay = 0.6  # *
	rune_activate.sustain_level = 0.0
	rune_activate.sustain_time = 0.0
	rune_activate.release = 0.3  # *
	rune_activate.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	rune_activate.tremolo_depth = 0.0
	rune_activate.tremolo_rate = 6.0
	rune_activate.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rune_activate.repeat_rate = 0.0
	# ---- Filter
	rune_activate.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	rune_activate.cutoff = 2000.0
	rune_activate.cutoff_sweep_octaves = 0.0
	rune_activate.resonance = 0.0
	rune_activate.filter_lfo_depth = 0.0
	rune_activate.filter_lfo_rate = 3.0
	rune_activate.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	rune_activate.drive = 0.0
	rune_activate.bit_depth = 16
	rune_activate.sample_hold = 1
	# ---- Space
	rune_activate.delay_time = 0.2  # *
	rune_activate.delay_feedback = 0.5  # *
	rune_activate.delay_mix = 0.4  # *
	# ---- Output
	rune_activate.volume_db = -7.0  # *
	rune_activate.normalize = true
	rune_activate.sample_rate = 44100
	rune_activate.loop = false
	rune_activate.noise_seed = 1
	rune_activate.condition = &""
	p[&"p_rune_activate"] = rune_activate

	var rune_break := SynthPatch.new()
	# ---- Oscillator
	rune_break.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	rune_break.duty = 0.5
	rune_break.base_freq = 880.0  # *
	rune_break.noise_mix = 0.4  # *
	rune_break.noise_tone = 1.0
	rune_break.sub_mix = 0.0
	rune_break.detune_cents = 0.0
	rune_break.detune_mix = 0.0
	rune_break.pwm_depth = 0.0
	rune_break.pwm_rate = 2.0
	rune_break.ring_ratio = 0.0
	rune_break.ring_mix = 0.0
	# ---- Pitch motion
	rune_break.pitch_sweep_semitones = -17.0  # *
	rune_break.pitch_sweep_curve = 0.6  # *
	rune_break.vibrato_depth = 0.0
	rune_break.vibrato_rate = 6.0
	rune_break.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rune_break.vibrato_fade_in = 0.0
	rune_break.arpeggio = []
	rune_break.arpeggio_rate = 20.0
	rune_break.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	rune_break.arpeggio_glide = 0.0
	# ---- FM
	rune_break.fm_ratio = 2.76  # *
	rune_break.fm_depth = 9.0  # *
	rune_break.fm_decay = 0.2  # *
	# ---- Amp envelope
	rune_break.attack = 0.0  # *
	rune_break.decay = 0.5  # *
	rune_break.sustain_level = 0.0
	rune_break.sustain_time = 0.0
	rune_break.release = 0.2  # *
	rune_break.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	rune_break.tremolo_depth = 0.0
	rune_break.tremolo_rate = 6.0
	rune_break.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rune_break.repeat_rate = 0.0
	# ---- Filter
	rune_break.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	rune_break.cutoff = 2000.0
	rune_break.cutoff_sweep_octaves = 0.0
	rune_break.resonance = 0.0
	rune_break.filter_lfo_depth = 0.0
	rune_break.filter_lfo_rate = 3.0
	rune_break.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	rune_break.drive = 0.0
	rune_break.bit_depth = 7  # *
	rune_break.sample_hold = 1
	# ---- Space
	rune_break.delay_time = 0.13  # *
	rune_break.delay_feedback = 0.4
	rune_break.delay_mix = 0.3  # *
	# ---- Output
	rune_break.volume_db = -5.0  # *
	rune_break.normalize = true
	rune_break.sample_rate = 44100
	rune_break.loop = false
	rune_break.noise_seed = 1
	rune_break.condition = &""
	p[&"p_rune_break"] = rune_break

	var shield_hit := SynthPatch.new()
	# ---- Oscillator
	shield_hit.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	shield_hit.duty = 0.3  # *
	shield_hit.base_freq = 700.0  # *
	shield_hit.noise_mix = 0.0
	shield_hit.noise_tone = 1.0
	shield_hit.sub_mix = 0.0
	shield_hit.detune_cents = 0.0
	shield_hit.detune_mix = 0.0
	shield_hit.pwm_depth = 0.0
	shield_hit.pwm_rate = 2.0
	shield_hit.ring_ratio = 0.0
	shield_hit.ring_mix = 0.0
	# ---- Pitch motion
	shield_hit.pitch_sweep_semitones = -7.0  # *
	shield_hit.pitch_sweep_curve = 0.5  # *
	shield_hit.vibrato_depth = 0.0
	shield_hit.vibrato_rate = 6.0
	shield_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_hit.vibrato_fade_in = 0.0
	shield_hit.arpeggio = []
	shield_hit.arpeggio_rate = 20.0
	shield_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	shield_hit.arpeggio_glide = 0.0
	# ---- FM
	shield_hit.fm_ratio = 1.41  # *
	shield_hit.fm_depth = 4.0  # *
	shield_hit.fm_decay = 0.06  # *
	# ---- Amp envelope
	shield_hit.attack = 0.0  # *
	shield_hit.decay = 0.15
	shield_hit.sustain_level = 0.0
	shield_hit.sustain_time = 0.0
	shield_hit.release = 0.08  # *
	shield_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	shield_hit.tremolo_depth = 0.0
	shield_hit.tremolo_rate = 6.0
	shield_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_hit.repeat_rate = 0.0
	# ---- Filter
	shield_hit.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	shield_hit.cutoff = 1500.0  # *
	shield_hit.cutoff_sweep_octaves = 0.0
	shield_hit.resonance = 0.4  # *
	shield_hit.filter_lfo_depth = 0.0
	shield_hit.filter_lfo_rate = 3.0
	shield_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	shield_hit.drive = 0.0
	shield_hit.bit_depth = 16
	shield_hit.sample_hold = 1
	# ---- Space
	shield_hit.delay_time = 0.05  # *
	shield_hit.delay_feedback = 0.4
	shield_hit.delay_mix = 0.35  # *
	# ---- Output
	shield_hit.volume_db = -6.0  # *
	shield_hit.normalize = true
	shield_hit.sample_rate = 44100
	shield_hit.loop = false
	shield_hit.noise_seed = 1
	shield_hit.condition = &""
	p[&"p_shield_hit"] = shield_hit

	var shield_down := SynthPatch.new()
	# ---- Oscillator
	shield_down.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	shield_down.duty = 0.5
	shield_down.base_freq = 440.0
	shield_down.noise_mix = 0.0
	shield_down.noise_tone = 1.0
	shield_down.sub_mix = 0.0
	shield_down.detune_cents = 0.0
	shield_down.detune_mix = 0.0
	shield_down.pwm_depth = 0.0
	shield_down.pwm_rate = 2.0
	shield_down.ring_ratio = 0.0
	shield_down.ring_mix = 0.0
	# ---- Pitch motion
	shield_down.pitch_sweep_semitones = -24.0  # *
	shield_down.pitch_sweep_curve = 1.2  # *
	shield_down.vibrato_depth = 2.0  # *
	shield_down.vibrato_rate = 18.0  # *
	shield_down.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_down.vibrato_fade_in = 0.0
	shield_down.arpeggio = []
	shield_down.arpeggio_rate = 20.0
	shield_down.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	shield_down.arpeggio_glide = 0.0
	# ---- FM
	shield_down.fm_ratio = 0.0
	shield_down.fm_depth = 0.0
	shield_down.fm_decay = 0.0
	# ---- Amp envelope
	shield_down.attack = 0.0  # *
	shield_down.decay = 0.5  # *
	shield_down.sustain_level = 0.0
	shield_down.sustain_time = 0.0
	shield_down.release = 0.2  # *
	shield_down.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	shield_down.tremolo_depth = 0.0
	shield_down.tremolo_rate = 6.0
	shield_down.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	shield_down.repeat_rate = 0.0
	# ---- Filter
	shield_down.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	shield_down.cutoff = 3000.0  # *
	shield_down.cutoff_sweep_octaves = -3.0  # *
	shield_down.resonance = 0.3  # *
	shield_down.filter_lfo_depth = 0.0
	shield_down.filter_lfo_rate = 3.0
	shield_down.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	shield_down.drive = 0.0
	shield_down.bit_depth = 8  # *
	shield_down.sample_hold = 1
	# ---- Space
	shield_down.delay_time = 0.12  # *
	shield_down.delay_feedback = 0.4
	shield_down.delay_mix = 0.3  # *
	# ---- Output
	shield_down.volume_db = -5.0  # *
	shield_down.normalize = true
	shield_down.sample_rate = 44100
	shield_down.loop = false
	shield_down.noise_seed = 1
	shield_down.condition = &""
	p[&"p_shield_down"] = shield_down

	var mana_empty := SynthPatch.new()
	# ---- Oscillator
	mana_empty.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	mana_empty.duty = 0.2  # *
	mana_empty.base_freq = 110.0  # *
	mana_empty.noise_mix = 0.0
	mana_empty.noise_tone = 1.0
	mana_empty.sub_mix = 0.0
	mana_empty.detune_cents = 0.0
	mana_empty.detune_mix = 0.0
	mana_empty.pwm_depth = 0.0
	mana_empty.pwm_rate = 2.0
	mana_empty.ring_ratio = 0.0
	mana_empty.ring_mix = 0.0
	# ---- Pitch motion
	mana_empty.pitch_sweep_semitones = 0.0
	mana_empty.pitch_sweep_curve = 1.0
	mana_empty.vibrato_depth = 0.0
	mana_empty.vibrato_rate = 6.0
	mana_empty.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	mana_empty.vibrato_fade_in = 0.0
	mana_empty.arpeggio = []
	mana_empty.arpeggio_rate = 20.0
	mana_empty.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	mana_empty.arpeggio_glide = 0.0
	# ---- FM
	mana_empty.fm_ratio = 0.0
	mana_empty.fm_depth = 0.0
	mana_empty.fm_decay = 0.0
	# ---- Amp envelope
	mana_empty.attack = 0.0  # *
	mana_empty.decay = 0.12  # *
	mana_empty.sustain_level = 0.0
	mana_empty.sustain_time = 0.0
	mana_empty.release = 0.03  # *
	mana_empty.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	mana_empty.tremolo_depth = 0.0
	mana_empty.tremolo_rate = 6.0
	mana_empty.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	mana_empty.repeat_rate = 0.0
	# ---- Filter
	mana_empty.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	mana_empty.cutoff = 2000.0
	mana_empty.cutoff_sweep_octaves = 0.0
	mana_empty.resonance = 0.0
	mana_empty.filter_lfo_depth = 0.0
	mana_empty.filter_lfo_rate = 3.0
	mana_empty.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	mana_empty.drive = 0.0
	mana_empty.bit_depth = 6  # *
	mana_empty.sample_hold = 1
	# ---- Space
	mana_empty.delay_time = 0.0
	mana_empty.delay_feedback = 0.4
	mana_empty.delay_mix = 0.0
	# ---- Output
	mana_empty.volume_db = -10.0  # *
	mana_empty.normalize = true
	mana_empty.sample_rate = 44100
	mana_empty.loop = false
	mana_empty.noise_seed = 1
	mana_empty.condition = &""
	p[&"p_mana_empty"] = mana_empty

	# ================================================================= Materials
	# Hits are short noise with a filter that says what the material is: stone is low and dull,
	# wood is a hollow band-pass knock, metal is inharmonic FM ringing, glass is high FM plus
	# fizz. Breaks are the same recipe stretched longer, with crackle from sample_hold and a
	# low rumble for mass. Edit cutoff and base_freq first when making variants.

	var stone_hit := SynthPatch.new()
	# ---- Oscillator
	stone_hit.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	stone_hit.duty = 0.5
	stone_hit.base_freq = 440.0
	stone_hit.noise_mix = 0.0
	stone_hit.noise_tone = 1.0
	stone_hit.sub_mix = 0.0
	stone_hit.detune_cents = 0.0
	stone_hit.detune_mix = 0.0
	stone_hit.pwm_depth = 0.0
	stone_hit.pwm_rate = 2.0
	stone_hit.ring_ratio = 0.0
	stone_hit.ring_mix = 0.0
	# ---- Pitch motion
	stone_hit.pitch_sweep_semitones = 0.0
	stone_hit.pitch_sweep_curve = 1.0
	stone_hit.vibrato_depth = 0.0
	stone_hit.vibrato_rate = 6.0
	stone_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_hit.vibrato_fade_in = 0.0
	stone_hit.arpeggio = []
	stone_hit.arpeggio_rate = 20.0
	stone_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	stone_hit.arpeggio_glide = 0.0
	# ---- FM
	stone_hit.fm_ratio = 0.0
	stone_hit.fm_depth = 0.0
	stone_hit.fm_decay = 0.0
	# ---- Amp envelope
	stone_hit.attack = 0.0  # *
	stone_hit.decay = 0.09  # *
	stone_hit.sustain_level = 0.0
	stone_hit.sustain_time = 0.0
	stone_hit.release = 0.03  # *
	stone_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	stone_hit.tremolo_depth = 0.0
	stone_hit.tremolo_rate = 6.0
	stone_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_hit.repeat_rate = 0.0
	# ---- Filter
	stone_hit.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	stone_hit.cutoff = 1400.0  # *
	stone_hit.cutoff_sweep_octaves = -2.5  # *
	stone_hit.resonance = 0.2  # *
	stone_hit.filter_lfo_depth = 0.0
	stone_hit.filter_lfo_rate = 3.0
	stone_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	stone_hit.drive = 0.4  # *
	stone_hit.bit_depth = 16
	stone_hit.sample_hold = 1
	# ---- Space
	stone_hit.delay_time = 0.0
	stone_hit.delay_feedback = 0.4
	stone_hit.delay_mix = 0.0
	# ---- Output
	stone_hit.volume_db = -4.0  # *
	stone_hit.normalize = true
	stone_hit.sample_rate = 44100
	stone_hit.loop = false
	stone_hit.noise_seed = 1
	stone_hit.condition = &""
	p[&"p_stone_hit"] = stone_hit

	var stone_break := SynthPatch.new()
	# ---- Oscillator
	stone_break.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	stone_break.duty = 0.5
	stone_break.base_freq = 440.0
	stone_break.noise_mix = 0.0
	stone_break.noise_tone = 1.0
	stone_break.sub_mix = 0.0
	stone_break.detune_cents = 0.0
	stone_break.detune_mix = 0.0
	stone_break.pwm_depth = 0.0
	stone_break.pwm_rate = 2.0
	stone_break.ring_ratio = 0.0
	stone_break.ring_mix = 0.0
	# ---- Pitch motion
	stone_break.pitch_sweep_semitones = 0.0
	stone_break.pitch_sweep_curve = 1.0
	stone_break.vibrato_depth = 0.0
	stone_break.vibrato_rate = 6.0
	stone_break.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_break.vibrato_fade_in = 0.0
	stone_break.arpeggio = []
	stone_break.arpeggio_rate = 20.0
	stone_break.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	stone_break.arpeggio_glide = 0.0
	# ---- FM
	stone_break.fm_ratio = 0.0
	stone_break.fm_depth = 0.0
	stone_break.fm_decay = 0.0
	# ---- Amp envelope
	stone_break.attack = 0.0  # *
	stone_break.decay = 0.5  # *
	stone_break.sustain_level = 0.0
	stone_break.sustain_time = 0.0
	stone_break.release = 0.25  # *
	stone_break.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	stone_break.tremolo_depth = 0.0
	stone_break.tremolo_rate = 6.0
	stone_break.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_break.repeat_rate = 0.0
	# ---- Filter
	stone_break.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	stone_break.cutoff = 2200.0  # *
	stone_break.cutoff_sweep_octaves = -3.5  # *
	stone_break.resonance = 0.25  # *
	stone_break.filter_lfo_depth = 0.0
	stone_break.filter_lfo_rate = 3.0
	stone_break.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	stone_break.drive = 0.6  # *
	stone_break.bit_depth = 16
	stone_break.sample_hold = 2  # *
	# ---- Space
	stone_break.delay_time = 0.07  # *
	stone_break.delay_feedback = 0.35  # *
	stone_break.delay_mix = 0.3  # *
	# ---- Output
	stone_break.volume_db = -1.0  # *
	stone_break.normalize = true
	stone_break.sample_rate = 44100
	stone_break.loop = false
	stone_break.noise_seed = 1
	stone_break.condition = &""
	p[&"p_stone_break"] = stone_break

	var stone_rumble := SynthPatch.new()
	# ---- Oscillator
	stone_rumble.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	stone_rumble.duty = 0.5
	stone_rumble.base_freq = 440.0
	stone_rumble.noise_mix = 0.0
	stone_rumble.noise_tone = 1.0
	stone_rumble.sub_mix = 0.0
	stone_rumble.detune_cents = 0.0
	stone_rumble.detune_mix = 0.0
	stone_rumble.pwm_depth = 0.0
	stone_rumble.pwm_rate = 2.0
	stone_rumble.ring_ratio = 0.0
	stone_rumble.ring_mix = 0.0
	# ---- Pitch motion
	stone_rumble.pitch_sweep_semitones = 0.0
	stone_rumble.pitch_sweep_curve = 1.0
	stone_rumble.vibrato_depth = 0.0
	stone_rumble.vibrato_rate = 6.0
	stone_rumble.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_rumble.vibrato_fade_in = 0.0
	stone_rumble.arpeggio = []
	stone_rumble.arpeggio_rate = 20.0
	stone_rumble.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	stone_rumble.arpeggio_glide = 0.0
	# ---- FM
	stone_rumble.fm_ratio = 0.0
	stone_rumble.fm_depth = 0.0
	stone_rumble.fm_decay = 0.0
	# ---- Amp envelope
	stone_rumble.attack = 0.05  # *
	stone_rumble.decay = 0.6  # *
	stone_rumble.sustain_level = 0.5  # *
	stone_rumble.sustain_time = 0.4  # *
	stone_rumble.release = 0.6  # *
	stone_rumble.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	stone_rumble.tremolo_depth = 0.0
	stone_rumble.tremolo_rate = 6.0
	stone_rumble.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stone_rumble.repeat_rate = 0.0
	# ---- Filter
	stone_rumble.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	stone_rumble.cutoff = 220.0  # *
	stone_rumble.cutoff_sweep_octaves = -1.0  # *
	stone_rumble.resonance = 0.3  # *
	stone_rumble.filter_lfo_depth = 0.0
	stone_rumble.filter_lfo_rate = 3.0
	stone_rumble.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	stone_rumble.drive = 0.7  # *
	stone_rumble.bit_depth = 16
	stone_rumble.sample_hold = 3  # *
	# ---- Space
	stone_rumble.delay_time = 0.0
	stone_rumble.delay_feedback = 0.4
	stone_rumble.delay_mix = 0.0
	# ---- Output
	stone_rumble.volume_db = 0.0
	stone_rumble.normalize = true
	stone_rumble.sample_rate = 44100
	stone_rumble.loop = false
	stone_rumble.noise_seed = 1
	stone_rumble.condition = &""
	p[&"p_stone_rumble"] = stone_rumble

	var wood_hit := SynthPatch.new()
	# ---- Oscillator
	wood_hit.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wood_hit.duty = 0.5
	wood_hit.base_freq = 440.0
	wood_hit.noise_mix = 0.0
	wood_hit.noise_tone = 1.0
	wood_hit.sub_mix = 0.0
	wood_hit.detune_cents = 0.0
	wood_hit.detune_mix = 0.0
	wood_hit.pwm_depth = 0.0
	wood_hit.pwm_rate = 2.0
	wood_hit.ring_ratio = 0.0
	wood_hit.ring_mix = 0.0
	# ---- Pitch motion
	wood_hit.pitch_sweep_semitones = 0.0
	wood_hit.pitch_sweep_curve = 1.0
	wood_hit.vibrato_depth = 0.0
	wood_hit.vibrato_rate = 6.0
	wood_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_hit.vibrato_fade_in = 0.0
	wood_hit.arpeggio = []
	wood_hit.arpeggio_rate = 20.0
	wood_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wood_hit.arpeggio_glide = 0.0
	# ---- FM
	wood_hit.fm_ratio = 0.0
	wood_hit.fm_depth = 0.0
	wood_hit.fm_decay = 0.0
	# ---- Amp envelope
	wood_hit.attack = 0.0  # *
	wood_hit.decay = 0.07  # *
	wood_hit.sustain_level = 0.0
	wood_hit.sustain_time = 0.0
	wood_hit.release = 0.03  # *
	wood_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wood_hit.tremolo_depth = 0.0
	wood_hit.tremolo_rate = 6.0
	wood_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_hit.repeat_rate = 0.0
	# ---- Filter
	wood_hit.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wood_hit.cutoff = 850.0  # *
	wood_hit.cutoff_sweep_octaves = -0.5  # *
	wood_hit.resonance = 0.65  # *
	wood_hit.filter_lfo_depth = 0.0
	wood_hit.filter_lfo_rate = 3.0
	wood_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wood_hit.drive = 0.3  # *
	wood_hit.bit_depth = 16
	wood_hit.sample_hold = 1
	# ---- Space
	wood_hit.delay_time = 0.0
	wood_hit.delay_feedback = 0.4
	wood_hit.delay_mix = 0.0
	# ---- Output
	wood_hit.volume_db = -3.0  # *
	wood_hit.normalize = true
	wood_hit.sample_rate = 44100
	wood_hit.loop = false
	wood_hit.noise_seed = 1
	wood_hit.condition = &""
	p[&"p_wood_hit"] = wood_hit

	var wood_break := SynthPatch.new()
	# ---- Oscillator
	wood_break.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wood_break.duty = 0.5
	wood_break.base_freq = 440.0
	wood_break.noise_mix = 0.0
	wood_break.noise_tone = 1.0
	wood_break.sub_mix = 0.0
	wood_break.detune_cents = 0.0
	wood_break.detune_mix = 0.0
	wood_break.pwm_depth = 0.0
	wood_break.pwm_rate = 2.0
	wood_break.ring_ratio = 0.0
	wood_break.ring_mix = 0.0
	# ---- Pitch motion
	wood_break.pitch_sweep_semitones = 0.0
	wood_break.pitch_sweep_curve = 1.0
	wood_break.vibrato_depth = 0.0
	wood_break.vibrato_rate = 6.0
	wood_break.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_break.vibrato_fade_in = 0.0
	wood_break.arpeggio = []
	wood_break.arpeggio_rate = 20.0
	wood_break.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wood_break.arpeggio_glide = 0.0
	# ---- FM
	wood_break.fm_ratio = 0.0
	wood_break.fm_depth = 0.0
	wood_break.fm_decay = 0.0
	# ---- Amp envelope
	wood_break.attack = 0.0  # *
	wood_break.decay = 0.3  # *
	wood_break.sustain_level = 0.0
	wood_break.sustain_time = 0.0
	wood_break.release = 0.15  # *
	wood_break.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wood_break.tremolo_depth = 0.0
	wood_break.tremolo_rate = 6.0
	wood_break.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_break.repeat_rate = 0.0
	# ---- Filter
	wood_break.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wood_break.cutoff = 650.0  # *
	wood_break.cutoff_sweep_octaves = -1.2  # *
	wood_break.resonance = 0.5  # *
	wood_break.filter_lfo_depth = 0.0
	wood_break.filter_lfo_rate = 3.0
	wood_break.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wood_break.drive = 0.6  # *
	wood_break.bit_depth = 16
	wood_break.sample_hold = 3  # *
	# ---- Space
	wood_break.delay_time = 0.045  # *
	wood_break.delay_feedback = 0.4
	wood_break.delay_mix = 0.35  # *
	# ---- Output
	wood_break.volume_db = -1.0  # *
	wood_break.normalize = true
	wood_break.sample_rate = 44100
	wood_break.loop = false
	wood_break.noise_seed = 1
	wood_break.condition = &""
	p[&"p_wood_break"] = wood_break

	var wood_creak := SynthPatch.new()
	# ---- Oscillator
	wood_creak.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wood_creak.duty = 0.5
	wood_creak.base_freq = 95.0  # *
	wood_creak.noise_mix = 0.2  # *
	wood_creak.noise_tone = 1.0
	wood_creak.sub_mix = 0.0
	wood_creak.detune_cents = 0.0
	wood_creak.detune_mix = 0.0
	wood_creak.pwm_depth = 0.0
	wood_creak.pwm_rate = 2.0
	wood_creak.ring_ratio = 0.0
	wood_creak.ring_mix = 0.0
	# ---- Pitch motion
	wood_creak.pitch_sweep_semitones = 4.0  # *
	wood_creak.pitch_sweep_curve = 1.0
	wood_creak.vibrato_depth = 2.5  # *
	wood_creak.vibrato_rate = 9.0  # *
	wood_creak.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_creak.vibrato_fade_in = 0.0
	wood_creak.arpeggio = []
	wood_creak.arpeggio_rate = 20.0
	wood_creak.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wood_creak.arpeggio_glide = 0.0
	# ---- FM
	wood_creak.fm_ratio = 0.0
	wood_creak.fm_depth = 0.0
	wood_creak.fm_decay = 0.0
	# ---- Amp envelope
	wood_creak.attack = 0.08  # *
	wood_creak.decay = 0.2  # *
	wood_creak.sustain_level = 0.6  # *
	wood_creak.sustain_time = 0.2  # *
	wood_creak.release = 0.2  # *
	wood_creak.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wood_creak.tremolo_depth = 0.0
	wood_creak.tremolo_rate = 6.0
	wood_creak.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wood_creak.repeat_rate = 0.0
	# ---- Filter
	wood_creak.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wood_creak.cutoff = 700.0  # *
	wood_creak.cutoff_sweep_octaves = 0.0
	wood_creak.resonance = 0.4  # *
	wood_creak.filter_lfo_depth = 0.0
	wood_creak.filter_lfo_rate = 3.0
	wood_creak.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wood_creak.drive = 0.0
	wood_creak.bit_depth = 16
	wood_creak.sample_hold = 4  # *
	# ---- Space
	wood_creak.delay_time = 0.0
	wood_creak.delay_feedback = 0.4
	wood_creak.delay_mix = 0.0
	# ---- Output
	wood_creak.volume_db = -9.0  # *
	wood_creak.normalize = true
	wood_creak.sample_rate = 44100
	wood_creak.loop = false
	wood_creak.noise_seed = 1
	wood_creak.condition = &""
	p[&"p_wood_creak"] = wood_creak

	var metal_hit := SynthPatch.new()
	# ---- Oscillator
	metal_hit.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	metal_hit.duty = 0.5
	metal_hit.base_freq = 620.0  # *
	metal_hit.noise_mix = 0.2  # *
	metal_hit.noise_tone = 1.0
	metal_hit.sub_mix = 0.0
	metal_hit.detune_cents = 0.0
	metal_hit.detune_mix = 0.0
	metal_hit.pwm_depth = 0.0
	metal_hit.pwm_rate = 2.0
	metal_hit.ring_ratio = 0.0
	metal_hit.ring_mix = 0.0
	# ---- Pitch motion
	metal_hit.pitch_sweep_semitones = 0.0
	metal_hit.pitch_sweep_curve = 1.0
	metal_hit.vibrato_depth = 0.0
	metal_hit.vibrato_rate = 6.0
	metal_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_hit.vibrato_fade_in = 0.0
	metal_hit.arpeggio = []
	metal_hit.arpeggio_rate = 20.0
	metal_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	metal_hit.arpeggio_glide = 0.0
	# ---- FM
	metal_hit.fm_ratio = 3.14  # *
	metal_hit.fm_depth = 6.0  # *
	metal_hit.fm_decay = 0.1  # *
	# ---- Amp envelope
	metal_hit.attack = 0.0  # *
	metal_hit.decay = 0.3  # *
	metal_hit.sustain_level = 0.0
	metal_hit.sustain_time = 0.0
	metal_hit.release = 0.1  # *
	metal_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	metal_hit.tremolo_depth = 0.0
	metal_hit.tremolo_rate = 6.0
	metal_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_hit.repeat_rate = 0.0
	# ---- Filter
	metal_hit.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	metal_hit.cutoff = 2000.0
	metal_hit.cutoff_sweep_octaves = 0.0
	metal_hit.resonance = 0.0
	metal_hit.filter_lfo_depth = 0.0
	metal_hit.filter_lfo_rate = 3.0
	metal_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	metal_hit.drive = 0.2  # *
	metal_hit.bit_depth = 16
	metal_hit.sample_hold = 1
	# ---- Space
	metal_hit.delay_time = 0.0
	metal_hit.delay_feedback = 0.4
	metal_hit.delay_mix = 0.0
	# ---- Output
	metal_hit.volume_db = -6.0  # *
	metal_hit.normalize = true
	metal_hit.sample_rate = 44100
	metal_hit.loop = false
	metal_hit.noise_seed = 1
	metal_hit.condition = &""
	p[&"p_metal_hit"] = metal_hit

	var metal_clang := SynthPatch.new()
	# ---- Oscillator
	metal_clang.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	metal_clang.duty = 0.5
	metal_clang.base_freq = 240.0  # *
	metal_clang.noise_mix = 0.15  # *
	metal_clang.noise_tone = 1.0
	metal_clang.sub_mix = 0.0
	metal_clang.detune_cents = 0.0
	metal_clang.detune_mix = 0.0
	metal_clang.pwm_depth = 0.0
	metal_clang.pwm_rate = 2.0
	metal_clang.ring_ratio = 0.0
	metal_clang.ring_mix = 0.0
	# ---- Pitch motion
	metal_clang.pitch_sweep_semitones = 0.0
	metal_clang.pitch_sweep_curve = 1.0
	metal_clang.vibrato_depth = 0.0
	metal_clang.vibrato_rate = 6.0
	metal_clang.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_clang.vibrato_fade_in = 0.0
	metal_clang.arpeggio = []
	metal_clang.arpeggio_rate = 20.0
	metal_clang.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	metal_clang.arpeggio_glide = 0.0
	# ---- FM
	metal_clang.fm_ratio = 2.41  # *
	metal_clang.fm_depth = 8.0  # *
	metal_clang.fm_decay = 0.35  # *
	# ---- Amp envelope
	metal_clang.attack = 0.0  # *
	metal_clang.decay = 0.9  # *
	metal_clang.sustain_level = 0.0
	metal_clang.sustain_time = 0.0
	metal_clang.release = 0.3  # *
	metal_clang.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	metal_clang.tremolo_depth = 0.0
	metal_clang.tremolo_rate = 6.0
	metal_clang.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_clang.repeat_rate = 0.0
	# ---- Filter
	metal_clang.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	metal_clang.cutoff = 2000.0
	metal_clang.cutoff_sweep_octaves = 0.0
	metal_clang.resonance = 0.0
	metal_clang.filter_lfo_depth = 0.0
	metal_clang.filter_lfo_rate = 3.0
	metal_clang.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	metal_clang.drive = 0.3  # *
	metal_clang.bit_depth = 16
	metal_clang.sample_hold = 1
	# ---- Space
	metal_clang.delay_time = 0.08  # *
	metal_clang.delay_feedback = 0.35  # *
	metal_clang.delay_mix = 0.3  # *
	# ---- Output
	metal_clang.volume_db = -4.0  # *
	metal_clang.normalize = true
	metal_clang.sample_rate = 44100
	metal_clang.loop = false
	metal_clang.noise_seed = 1
	metal_clang.condition = &""
	p[&"p_metal_clang"] = metal_clang

	var metal_break := SynthPatch.new()
	# ---- Oscillator
	metal_break.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	metal_break.duty = 0.5
	metal_break.base_freq = 300.0  # *
	metal_break.noise_mix = 0.55  # *
	metal_break.noise_tone = 1.0
	metal_break.sub_mix = 0.0
	metal_break.detune_cents = 0.0
	metal_break.detune_mix = 0.0
	metal_break.pwm_depth = 0.0
	metal_break.pwm_rate = 2.0
	metal_break.ring_ratio = 0.0
	metal_break.ring_mix = 0.0
	# ---- Pitch motion
	metal_break.pitch_sweep_semitones = -9.0  # *
	metal_break.pitch_sweep_curve = 0.7  # *
	metal_break.vibrato_depth = 0.0
	metal_break.vibrato_rate = 6.0
	metal_break.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_break.vibrato_fade_in = 0.0
	metal_break.arpeggio = []
	metal_break.arpeggio_rate = 20.0
	metal_break.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	metal_break.arpeggio_glide = 0.0
	# ---- FM
	metal_break.fm_ratio = 2.41  # *
	metal_break.fm_depth = 10.0  # *
	metal_break.fm_decay = 0.25  # *
	# ---- Amp envelope
	metal_break.attack = 0.0  # *
	metal_break.decay = 0.6  # *
	metal_break.sustain_level = 0.0
	metal_break.sustain_time = 0.0
	metal_break.release = 0.3  # *
	metal_break.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	metal_break.tremolo_depth = 0.0
	metal_break.tremolo_rate = 6.0
	metal_break.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	metal_break.repeat_rate = 0.0
	# ---- Filter
	metal_break.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	metal_break.cutoff = 2000.0
	metal_break.cutoff_sweep_octaves = 0.0
	metal_break.resonance = 0.0
	metal_break.filter_lfo_depth = 0.0
	metal_break.filter_lfo_rate = 3.0
	metal_break.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	metal_break.drive = 0.6  # *
	metal_break.bit_depth = 16
	metal_break.sample_hold = 2  # *
	# ---- Space
	metal_break.delay_time = 0.1  # *
	metal_break.delay_feedback = 0.35  # *
	metal_break.delay_mix = 0.3  # *
	# ---- Output
	metal_break.volume_db = -3.0  # *
	metal_break.normalize = true
	metal_break.sample_rate = 44100
	metal_break.loop = false
	metal_break.noise_seed = 1
	metal_break.condition = &""
	p[&"p_metal_break"] = metal_break

	var glass_hit := SynthPatch.new()
	# ---- Oscillator
	glass_hit.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	glass_hit.duty = 0.5
	glass_hit.base_freq = 2400.0  # *
	glass_hit.noise_mix = 0.0
	glass_hit.noise_tone = 1.0
	glass_hit.sub_mix = 0.0
	glass_hit.detune_cents = 0.0
	glass_hit.detune_mix = 0.0
	glass_hit.pwm_depth = 0.0
	glass_hit.pwm_rate = 2.0
	glass_hit.ring_ratio = 0.0
	glass_hit.ring_mix = 0.0
	# ---- Pitch motion
	glass_hit.pitch_sweep_semitones = 0.0
	glass_hit.pitch_sweep_curve = 1.0
	glass_hit.vibrato_depth = 0.0
	glass_hit.vibrato_rate = 6.0
	glass_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glass_hit.vibrato_fade_in = 0.0
	glass_hit.arpeggio = []
	glass_hit.arpeggio_rate = 20.0
	glass_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	glass_hit.arpeggio_glide = 0.0
	# ---- FM
	glass_hit.fm_ratio = 5.1  # *
	glass_hit.fm_depth = 3.0  # *
	glass_hit.fm_decay = 0.04  # *
	# ---- Amp envelope
	glass_hit.attack = 0.0  # *
	glass_hit.decay = 0.12  # *
	glass_hit.sustain_level = 0.0
	glass_hit.sustain_time = 0.0
	glass_hit.release = 0.05
	glass_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	glass_hit.tremolo_depth = 0.0
	glass_hit.tremolo_rate = 6.0
	glass_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glass_hit.repeat_rate = 0.0
	# ---- Filter
	glass_hit.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	glass_hit.cutoff = 2000.0
	glass_hit.cutoff_sweep_octaves = 0.0
	glass_hit.resonance = 0.0
	glass_hit.filter_lfo_depth = 0.0
	glass_hit.filter_lfo_rate = 3.0
	glass_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	glass_hit.drive = 0.0
	glass_hit.bit_depth = 16
	glass_hit.sample_hold = 1
	# ---- Space
	glass_hit.delay_time = 0.0
	glass_hit.delay_feedback = 0.4
	glass_hit.delay_mix = 0.0
	# ---- Output
	glass_hit.volume_db = -10.0  # *
	glass_hit.normalize = true
	glass_hit.sample_rate = 44100
	glass_hit.loop = false
	glass_hit.noise_seed = 1
	glass_hit.condition = &""
	p[&"p_glass_hit"] = glass_hit

	var glass_break := SynthPatch.new()
	# ---- Oscillator
	glass_break.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	glass_break.duty = 0.5
	glass_break.base_freq = 440.0
	glass_break.noise_mix = 0.0
	glass_break.noise_tone = 1.0
	glass_break.sub_mix = 0.0
	glass_break.detune_cents = 0.0
	glass_break.detune_mix = 0.0
	glass_break.pwm_depth = 0.0
	glass_break.pwm_rate = 2.0
	glass_break.ring_ratio = 0.0
	glass_break.ring_mix = 0.0
	# ---- Pitch motion
	glass_break.pitch_sweep_semitones = 0.0
	glass_break.pitch_sweep_curve = 1.0
	glass_break.vibrato_depth = 0.0
	glass_break.vibrato_rate = 6.0
	glass_break.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glass_break.vibrato_fade_in = 0.0
	glass_break.arpeggio = []
	glass_break.arpeggio_rate = 20.0
	glass_break.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	glass_break.arpeggio_glide = 0.0
	# ---- FM
	glass_break.fm_ratio = 0.0
	glass_break.fm_depth = 0.0
	glass_break.fm_decay = 0.0
	# ---- Amp envelope
	glass_break.attack = 0.0  # *
	glass_break.decay = 0.4  # *
	glass_break.sustain_level = 0.0
	glass_break.sustain_time = 0.0
	glass_break.release = 0.2  # *
	glass_break.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	glass_break.tremolo_depth = 0.0
	glass_break.tremolo_rate = 6.0
	glass_break.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glass_break.repeat_rate = 0.0
	# ---- Filter
	glass_break.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	glass_break.cutoff = 3800.0  # *
	glass_break.cutoff_sweep_octaves = 0.0
	glass_break.resonance = 0.0
	glass_break.filter_lfo_depth = 0.0
	glass_break.filter_lfo_rate = 3.0
	glass_break.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	glass_break.drive = 0.0
	glass_break.bit_depth = 16
	glass_break.sample_hold = 2  # *
	# ---- Space
	glass_break.delay_time = 0.03  # *
	glass_break.delay_feedback = 0.55  # *
	glass_break.delay_mix = 0.45  # *
	# ---- Output
	glass_break.volume_db = -5.0  # *
	glass_break.normalize = true
	glass_break.sample_rate = 44100
	glass_break.loop = false
	glass_break.noise_seed = 1
	glass_break.condition = &""
	p[&"p_glass_break"] = glass_break

	var debris_fall := SynthPatch.new()
	# ---- Oscillator
	debris_fall.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	debris_fall.duty = 0.5
	debris_fall.base_freq = 440.0
	debris_fall.noise_mix = 0.0
	debris_fall.noise_tone = 1.0
	debris_fall.sub_mix = 0.0
	debris_fall.detune_cents = 0.0
	debris_fall.detune_mix = 0.0
	debris_fall.pwm_depth = 0.0
	debris_fall.pwm_rate = 2.0
	debris_fall.ring_ratio = 0.0
	debris_fall.ring_mix = 0.0
	# ---- Pitch motion
	debris_fall.pitch_sweep_semitones = 0.0
	debris_fall.pitch_sweep_curve = 1.0
	debris_fall.vibrato_depth = 0.0
	debris_fall.vibrato_rate = 6.0
	debris_fall.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	debris_fall.vibrato_fade_in = 0.0
	debris_fall.arpeggio = []
	debris_fall.arpeggio_rate = 20.0
	debris_fall.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	debris_fall.arpeggio_glide = 0.0
	# ---- FM
	debris_fall.fm_ratio = 0.0
	debris_fall.fm_depth = 0.0
	debris_fall.fm_decay = 0.0
	# ---- Amp envelope
	debris_fall.attack = 0.02  # *
	debris_fall.decay = 0.5  # *
	debris_fall.sustain_level = 0.0
	debris_fall.sustain_time = 0.0
	debris_fall.release = 0.3  # *
	debris_fall.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	debris_fall.tremolo_depth = 0.0
	debris_fall.tremolo_rate = 6.0
	debris_fall.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	debris_fall.repeat_rate = 0.0
	# ---- Filter
	debris_fall.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	debris_fall.cutoff = 500.0  # *
	debris_fall.cutoff_sweep_octaves = -1.0  # *
	debris_fall.resonance = 0.0
	debris_fall.filter_lfo_depth = 0.0
	debris_fall.filter_lfo_rate = 3.0
	debris_fall.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	debris_fall.drive = 0.3  # *
	debris_fall.bit_depth = 16
	debris_fall.sample_hold = 5  # *
	# ---- Space
	debris_fall.delay_time = 0.0
	debris_fall.delay_feedback = 0.4
	debris_fall.delay_mix = 0.0
	# ---- Output
	debris_fall.volume_db = -6.0  # *
	debris_fall.normalize = true
	debris_fall.sample_rate = 44100
	debris_fall.loop = false
	debris_fall.noise_seed = 1
	debris_fall.condition = &""
	p[&"p_debris_fall"] = debris_fall

	var fortress_collapse := SynthPatch.new()
	# ---- Oscillator
	fortress_collapse.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	fortress_collapse.duty = 0.5
	fortress_collapse.base_freq = 440.0
	fortress_collapse.noise_mix = 0.0
	fortress_collapse.noise_tone = 1.0
	fortress_collapse.sub_mix = 0.0
	fortress_collapse.detune_cents = 0.0
	fortress_collapse.detune_mix = 0.0
	fortress_collapse.pwm_depth = 0.0
	fortress_collapse.pwm_rate = 2.0
	fortress_collapse.ring_ratio = 0.0
	fortress_collapse.ring_mix = 0.0
	# ---- Pitch motion
	fortress_collapse.pitch_sweep_semitones = 0.0
	fortress_collapse.pitch_sweep_curve = 1.0
	fortress_collapse.vibrato_depth = 0.0
	fortress_collapse.vibrato_rate = 6.0
	fortress_collapse.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	fortress_collapse.vibrato_fade_in = 0.0
	fortress_collapse.arpeggio = []
	fortress_collapse.arpeggio_rate = 20.0
	fortress_collapse.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	fortress_collapse.arpeggio_glide = 0.0
	# ---- FM
	fortress_collapse.fm_ratio = 0.0
	fortress_collapse.fm_depth = 0.0
	fortress_collapse.fm_decay = 0.0
	# ---- Amp envelope
	fortress_collapse.attack = 0.1  # *
	fortress_collapse.decay = 1.0  # *
	fortress_collapse.sustain_level = 0.6  # *
	fortress_collapse.sustain_time = 0.6  # *
	fortress_collapse.release = 1.0  # *
	fortress_collapse.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	fortress_collapse.tremolo_depth = 0.0
	fortress_collapse.tremolo_rate = 6.0
	fortress_collapse.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	fortress_collapse.repeat_rate = 0.0
	# ---- Filter
	fortress_collapse.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	fortress_collapse.cutoff = 900.0  # *
	fortress_collapse.cutoff_sweep_octaves = -2.0  # *
	fortress_collapse.resonance = 0.6  # *
	fortress_collapse.filter_lfo_depth = 0.0
	fortress_collapse.filter_lfo_rate = 3.0
	fortress_collapse.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	fortress_collapse.drive = 0.8  # *
	fortress_collapse.bit_depth = 16
	fortress_collapse.sample_hold = 3  # *
	# ---- Space
	fortress_collapse.delay_time = 0.2  # *
	fortress_collapse.delay_feedback = 0.4
	fortress_collapse.delay_mix = 0.3  # *
	# ---- Output
	fortress_collapse.volume_db = 0.0
	fortress_collapse.normalize = true
	fortress_collapse.sample_rate = 44100
	fortress_collapse.loop = false
	fortress_collapse.noise_seed = 1
	fortress_collapse.condition = &""
	p[&"p_fortress_collapse"] = fortress_collapse

	# ======================================================================= Ship

	var ship_engine := SynthPatch.new()
	# ---- Oscillator
	ship_engine.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ship_engine.duty = 0.5
	ship_engine.base_freq = 55.0  # *
	ship_engine.noise_mix = 0.15  # *
	ship_engine.noise_tone = 1.0
	ship_engine.sub_mix = 0.0
	ship_engine.detune_cents = 0.0
	ship_engine.detune_mix = 0.0
	ship_engine.pwm_depth = 0.0
	ship_engine.pwm_rate = 2.0
	ship_engine.ring_ratio = 0.0
	ship_engine.ring_mix = 0.0
	# ---- Pitch motion
	ship_engine.pitch_sweep_semitones = 0.0
	ship_engine.pitch_sweep_curve = 1.0
	ship_engine.vibrato_depth = 0.15  # *
	ship_engine.vibrato_rate = 1.5  # *
	ship_engine.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_engine.vibrato_fade_in = 0.0
	ship_engine.arpeggio = []
	ship_engine.arpeggio_rate = 20.0
	ship_engine.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ship_engine.arpeggio_glide = 0.0
	# ---- FM
	ship_engine.fm_ratio = 0.0
	ship_engine.fm_depth = 0.0
	ship_engine.fm_decay = 0.0
	# ---- Amp envelope
	ship_engine.attack = 0.0  # *
	ship_engine.decay = 0.0  # *
	ship_engine.sustain_level = 1.0  # *
	ship_engine.sustain_time = 2.0  # *
	ship_engine.release = 0.0  # *
	ship_engine.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ship_engine.tremolo_depth = 0.0
	ship_engine.tremolo_rate = 6.0
	ship_engine.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_engine.repeat_rate = 0.0
	# ---- Filter
	ship_engine.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ship_engine.cutoff = 320.0  # *
	ship_engine.cutoff_sweep_octaves = 0.0
	ship_engine.resonance = 0.35  # *
	ship_engine.filter_lfo_depth = 0.0
	ship_engine.filter_lfo_rate = 3.0
	ship_engine.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ship_engine.drive = 0.3  # *
	ship_engine.bit_depth = 16
	ship_engine.sample_hold = 1
	# ---- Space
	ship_engine.delay_time = 0.0
	ship_engine.delay_feedback = 0.4
	ship_engine.delay_mix = 0.0
	# ---- Output
	ship_engine.volume_db = -14.0  # *
	ship_engine.normalize = true
	ship_engine.sample_rate = 44100
	ship_engine.loop = true  # *
	ship_engine.noise_seed = 1
	ship_engine.condition = &""
	p[&"p_ship_engine"] = ship_engine

	var ship_hit := SynthPatch.new()
	# ---- Oscillator
	ship_hit.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ship_hit.duty = 0.5
	ship_hit.base_freq = 110.0  # *
	ship_hit.noise_mix = 0.6  # *
	ship_hit.noise_tone = 1.0
	ship_hit.sub_mix = 0.0
	ship_hit.detune_cents = 0.0
	ship_hit.detune_mix = 0.0
	ship_hit.pwm_depth = 0.0
	ship_hit.pwm_rate = 2.0
	ship_hit.ring_ratio = 0.0
	ship_hit.ring_mix = 0.0
	# ---- Pitch motion
	ship_hit.pitch_sweep_semitones = -18.0  # *
	ship_hit.pitch_sweep_curve = 0.4  # *
	ship_hit.vibrato_depth = 0.0
	ship_hit.vibrato_rate = 6.0
	ship_hit.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_hit.vibrato_fade_in = 0.0
	ship_hit.arpeggio = []
	ship_hit.arpeggio_rate = 20.0
	ship_hit.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ship_hit.arpeggio_glide = 0.0
	# ---- FM
	ship_hit.fm_ratio = 0.0
	ship_hit.fm_depth = 0.0
	ship_hit.fm_decay = 0.0
	# ---- Amp envelope
	ship_hit.attack = 0.0  # *
	ship_hit.decay = 0.45  # *
	ship_hit.sustain_level = 0.0
	ship_hit.sustain_time = 0.0
	ship_hit.release = 0.2  # *
	ship_hit.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ship_hit.tremolo_depth = 0.0
	ship_hit.tremolo_rate = 6.0
	ship_hit.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_hit.repeat_rate = 0.0
	# ---- Filter
	ship_hit.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ship_hit.cutoff = 500.0  # *
	ship_hit.cutoff_sweep_octaves = -1.0  # *
	ship_hit.resonance = 0.4  # *
	ship_hit.filter_lfo_depth = 0.0
	ship_hit.filter_lfo_rate = 3.0
	ship_hit.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ship_hit.drive = 0.7  # *
	ship_hit.bit_depth = 16
	ship_hit.sample_hold = 2  # *
	# ---- Space
	ship_hit.delay_time = 0.0
	ship_hit.delay_feedback = 0.4
	ship_hit.delay_mix = 0.0
	# ---- Output
	ship_hit.volume_db = -1.0  # *
	ship_hit.normalize = true
	ship_hit.sample_rate = 44100
	ship_hit.loop = false
	ship_hit.noise_seed = 1
	ship_hit.condition = &""
	p[&"p_ship_hit"] = ship_hit

	var ship_bell := SynthPatch.new()
	# ---- Oscillator
	ship_bell.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ship_bell.duty = 0.5
	ship_bell.base_freq = 880.0  # *
	ship_bell.noise_mix = 0.0
	ship_bell.noise_tone = 1.0
	ship_bell.sub_mix = 0.0
	ship_bell.detune_cents = 0.0
	ship_bell.detune_mix = 0.0
	ship_bell.pwm_depth = 0.0
	ship_bell.pwm_rate = 2.0
	ship_bell.ring_ratio = 0.0
	ship_bell.ring_mix = 0.0
	# ---- Pitch motion
	ship_bell.pitch_sweep_semitones = 0.0
	ship_bell.pitch_sweep_curve = 1.0
	ship_bell.vibrato_depth = 0.0
	ship_bell.vibrato_rate = 6.0
	ship_bell.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_bell.vibrato_fade_in = 0.0
	ship_bell.arpeggio = []
	ship_bell.arpeggio_rate = 20.0
	ship_bell.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ship_bell.arpeggio_glide = 0.0
	# ---- FM
	ship_bell.fm_ratio = 2.0  # *
	ship_bell.fm_depth = 3.0  # *
	ship_bell.fm_decay = 0.5  # *
	# ---- Amp envelope
	ship_bell.attack = 0.0  # *
	ship_bell.decay = 1.2  # *
	ship_bell.sustain_level = 0.0
	ship_bell.sustain_time = 0.0
	ship_bell.release = 0.3  # *
	ship_bell.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ship_bell.tremolo_depth = 0.0
	ship_bell.tremolo_rate = 6.0
	ship_bell.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_bell.repeat_rate = 0.0
	# ---- Filter
	ship_bell.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ship_bell.cutoff = 2000.0
	ship_bell.cutoff_sweep_octaves = 0.0
	ship_bell.resonance = 0.0
	ship_bell.filter_lfo_depth = 0.0
	ship_bell.filter_lfo_rate = 3.0
	ship_bell.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ship_bell.drive = 0.0
	ship_bell.bit_depth = 16
	ship_bell.sample_hold = 1
	# ---- Space
	ship_bell.delay_time = 0.3  # *
	ship_bell.delay_feedback = 0.4
	ship_bell.delay_mix = 0.3  # *
	# ---- Output
	ship_bell.volume_db = -8.0  # *
	ship_bell.normalize = true
	ship_bell.sample_rate = 44100
	ship_bell.loop = false
	ship_bell.noise_seed = 1
	ship_bell.condition = &""
	p[&"p_ship_bell"] = ship_bell

	var ship_alarm := SynthPatch.new()
	# ---- Oscillator
	ship_alarm.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	ship_alarm.duty = 0.5
	ship_alarm.base_freq = 660.0  # *
	ship_alarm.noise_mix = 0.0
	ship_alarm.noise_tone = 1.0
	ship_alarm.sub_mix = 0.0
	ship_alarm.detune_cents = 0.0
	ship_alarm.detune_mix = 0.0
	ship_alarm.pwm_depth = 0.0
	ship_alarm.pwm_rate = 2.0
	ship_alarm.ring_ratio = 0.0
	ship_alarm.ring_mix = 0.0
	# ---- Pitch motion
	ship_alarm.pitch_sweep_semitones = 0.0
	ship_alarm.pitch_sweep_curve = 1.0
	ship_alarm.vibrato_depth = 0.0
	ship_alarm.vibrato_rate = 6.0
	ship_alarm.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_alarm.vibrato_fade_in = 0.0
	ship_alarm.arpeggio = [0, 5]  # *
	ship_alarm.arpeggio_rate = 6.0  # *
	ship_alarm.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ship_alarm.arpeggio_glide = 0.0
	# ---- FM
	ship_alarm.fm_ratio = 0.0
	ship_alarm.fm_depth = 0.0
	ship_alarm.fm_decay = 0.0
	# ---- Amp envelope
	ship_alarm.attack = 0.01  # *
	ship_alarm.decay = 0.05  # *
	ship_alarm.sustain_level = 0.8  # *
	ship_alarm.sustain_time = 0.55  # *
	ship_alarm.release = 0.05
	ship_alarm.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ship_alarm.tremolo_depth = 0.0
	ship_alarm.tremolo_rate = 6.0
	ship_alarm.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ship_alarm.repeat_rate = 0.0
	# ---- Filter
	ship_alarm.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ship_alarm.cutoff = 2500.0  # *
	ship_alarm.cutoff_sweep_octaves = 0.0
	ship_alarm.resonance = 0.0
	ship_alarm.filter_lfo_depth = 0.0
	ship_alarm.filter_lfo_rate = 3.0
	ship_alarm.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ship_alarm.drive = 0.0
	ship_alarm.bit_depth = 8  # *
	ship_alarm.sample_hold = 1
	# ---- Space
	ship_alarm.delay_time = 0.0
	ship_alarm.delay_feedback = 0.4
	ship_alarm.delay_mix = 0.0
	# ---- Output
	ship_alarm.volume_db = -11.0  # *
	ship_alarm.normalize = true
	ship_alarm.sample_rate = 44100
	ship_alarm.loop = false
	ship_alarm.noise_seed = 1
	ship_alarm.condition = &""
	p[&"p_ship_alarm"] = ship_alarm

	var enemy_fire := SynthPatch.new()
	# ---- Oscillator
	enemy_fire.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	enemy_fire.duty = 0.5
	enemy_fire.base_freq = 130.0  # *
	enemy_fire.noise_mix = 0.6  # *
	enemy_fire.noise_tone = 1.0
	enemy_fire.sub_mix = 0.0
	enemy_fire.detune_cents = 0.0
	enemy_fire.detune_mix = 0.0
	enemy_fire.pwm_depth = 0.0
	enemy_fire.pwm_rate = 2.0
	enemy_fire.ring_ratio = 0.0
	enemy_fire.ring_mix = 0.0
	# ---- Pitch motion
	enemy_fire.pitch_sweep_semitones = -16.0  # *
	enemy_fire.pitch_sweep_curve = 0.35  # *
	enemy_fire.vibrato_depth = 0.0
	enemy_fire.vibrato_rate = 6.0
	enemy_fire.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	enemy_fire.vibrato_fade_in = 0.0
	enemy_fire.arpeggio = []
	enemy_fire.arpeggio_rate = 20.0
	enemy_fire.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	enemy_fire.arpeggio_glide = 0.0
	# ---- FM
	enemy_fire.fm_ratio = 0.0
	enemy_fire.fm_depth = 0.0
	enemy_fire.fm_decay = 0.0
	# ---- Amp envelope
	enemy_fire.attack = 0.0  # *
	enemy_fire.decay = 0.3  # *
	enemy_fire.sustain_level = 0.0
	enemy_fire.sustain_time = 0.0
	enemy_fire.release = 0.12  # *
	enemy_fire.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	enemy_fire.tremolo_depth = 0.0
	enemy_fire.tremolo_rate = 6.0
	enemy_fire.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	enemy_fire.repeat_rate = 0.0
	# ---- Filter
	enemy_fire.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	enemy_fire.cutoff = 3000.0  # *
	enemy_fire.cutoff_sweep_octaves = -3.0  # *
	enemy_fire.resonance = 0.0
	enemy_fire.filter_lfo_depth = 0.0
	enemy_fire.filter_lfo_rate = 3.0
	enemy_fire.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	enemy_fire.drive = 0.6  # *
	enemy_fire.bit_depth = 16
	enemy_fire.sample_hold = 1
	# ---- Space
	enemy_fire.delay_time = 0.0
	enemy_fire.delay_feedback = 0.4
	enemy_fire.delay_mix = 0.0
	# ---- Output
	enemy_fire.volume_db = -5.0  # *
	enemy_fire.normalize = true
	enemy_fire.sample_rate = 44100
	enemy_fire.loop = false
	enemy_fire.noise_seed = 1
	enemy_fire.condition = &""
	p[&"p_enemy_fire"] = enemy_fire

	# =================================================================== Treasure

	var coin := SynthPatch.new()
	# ---- Oscillator
	coin.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	coin.duty = 0.5
	coin.base_freq = 1320.0  # *
	coin.noise_mix = 0.0
	coin.noise_tone = 1.0
	coin.sub_mix = 0.0
	coin.detune_cents = 0.0
	coin.detune_mix = 0.0
	coin.pwm_depth = 0.0
	coin.pwm_rate = 2.0
	coin.ring_ratio = 0.0
	coin.ring_mix = 0.0
	# ---- Pitch motion
	coin.pitch_sweep_semitones = 0.0
	coin.pitch_sweep_curve = 1.0
	coin.vibrato_depth = 0.0
	coin.vibrato_rate = 6.0
	coin.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	coin.vibrato_fade_in = 0.0
	coin.arpeggio = [0, 12]  # *
	coin.arpeggio_rate = 24.0  # *
	coin.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	coin.arpeggio_glide = 0.0
	# ---- FM
	coin.fm_ratio = 3.0  # *
	coin.fm_depth = 1.5  # *
	coin.fm_decay = 0.05  # *
	# ---- Amp envelope
	coin.attack = 0.0  # *
	coin.decay = 0.14  # *
	coin.sustain_level = 0.0
	coin.sustain_time = 0.0
	coin.release = 0.06  # *
	coin.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	coin.tremolo_depth = 0.0
	coin.tremolo_rate = 6.0
	coin.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	coin.repeat_rate = 0.0
	# ---- Filter
	coin.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	coin.cutoff = 2000.0
	coin.cutoff_sweep_octaves = 0.0
	coin.resonance = 0.0
	coin.filter_lfo_depth = 0.0
	coin.filter_lfo_rate = 3.0
	coin.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	coin.drive = 0.0
	coin.bit_depth = 16
	coin.sample_hold = 1
	# ---- Space
	coin.delay_time = 0.0
	coin.delay_feedback = 0.4
	coin.delay_mix = 0.0
	# ---- Output
	coin.volume_db = -12.0  # *
	coin.normalize = true
	coin.sample_rate = 44100
	coin.loop = false
	coin.noise_seed = 1
	coin.condition = &""
	p[&"p_coin"] = coin

	var treasure_collect := SynthPatch.new()
	# ---- Oscillator
	treasure_collect.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	treasure_collect.duty = 0.5
	treasure_collect.base_freq = 660.0  # *
	treasure_collect.noise_mix = 0.0
	treasure_collect.noise_tone = 1.0
	treasure_collect.sub_mix = 0.0
	treasure_collect.detune_cents = 0.0
	treasure_collect.detune_mix = 0.0
	treasure_collect.pwm_depth = 0.0
	treasure_collect.pwm_rate = 2.0
	treasure_collect.ring_ratio = 0.0
	treasure_collect.ring_mix = 0.0
	# ---- Pitch motion
	treasure_collect.pitch_sweep_semitones = 0.0
	treasure_collect.pitch_sweep_curve = 1.0
	treasure_collect.vibrato_depth = 0.0
	treasure_collect.vibrato_rate = 6.0
	treasure_collect.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	treasure_collect.vibrato_fade_in = 0.0
	treasure_collect.arpeggio = [0, 4, 7, 12, 16, 19]  # *
	treasure_collect.arpeggio_rate = 22.0  # *
	treasure_collect.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	treasure_collect.arpeggio_glide = 0.0
	# ---- FM
	treasure_collect.fm_ratio = 2.0  # *
	treasure_collect.fm_depth = 1.5  # *
	treasure_collect.fm_decay = 0.2  # *
	# ---- Amp envelope
	treasure_collect.attack = 0.0  # *
	treasure_collect.decay = 0.35  # *
	treasure_collect.sustain_level = 0.4  # *
	treasure_collect.sustain_time = 0.1  # *
	treasure_collect.release = 0.3  # *
	treasure_collect.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	treasure_collect.tremolo_depth = 0.0
	treasure_collect.tremolo_rate = 6.0
	treasure_collect.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	treasure_collect.repeat_rate = 0.0
	# ---- Filter
	treasure_collect.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	treasure_collect.cutoff = 2000.0
	treasure_collect.cutoff_sweep_octaves = 0.0
	treasure_collect.resonance = 0.0
	treasure_collect.filter_lfo_depth = 0.0
	treasure_collect.filter_lfo_rate = 3.0
	treasure_collect.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	treasure_collect.drive = 0.0
	treasure_collect.bit_depth = 16
	treasure_collect.sample_hold = 1
	# ---- Space
	treasure_collect.delay_time = 0.14  # *
	treasure_collect.delay_feedback = 0.4
	treasure_collect.delay_mix = 0.35  # *
	# ---- Output
	treasure_collect.volume_db = -7.0  # *
	treasure_collect.normalize = true
	treasure_collect.sample_rate = 44100
	treasure_collect.loop = false
	treasure_collect.noise_seed = 1
	treasure_collect.condition = &""
	p[&"p_treasure_collect"] = treasure_collect

	var chest_open := SynthPatch.new()
	# ---- Oscillator
	chest_open.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	chest_open.duty = 0.5
	chest_open.base_freq = 262.0  # *
	chest_open.noise_mix = 0.0
	chest_open.noise_tone = 1.0
	chest_open.sub_mix = 0.0
	chest_open.detune_cents = 0.0
	chest_open.detune_mix = 0.0
	chest_open.pwm_depth = 0.0
	chest_open.pwm_rate = 2.0
	chest_open.ring_ratio = 0.0
	chest_open.ring_mix = 0.0
	# ---- Pitch motion
	chest_open.pitch_sweep_semitones = 0.0
	chest_open.pitch_sweep_curve = 1.0
	chest_open.vibrato_depth = 0.0
	chest_open.vibrato_rate = 6.0
	chest_open.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	chest_open.vibrato_fade_in = 0.0
	chest_open.arpeggio = [0, 4, 7, 12]  # *
	chest_open.arpeggio_rate = 10.0  # *
	chest_open.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	chest_open.arpeggio_glide = 0.0
	# ---- FM
	chest_open.fm_ratio = 0.0
	chest_open.fm_depth = 0.0
	chest_open.fm_decay = 0.0
	# ---- Amp envelope
	chest_open.attack = 0.02  # *
	chest_open.decay = 0.2  # *
	chest_open.sustain_level = 0.6  # *
	chest_open.sustain_time = 0.25  # *
	chest_open.release = 0.3  # *
	chest_open.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	chest_open.tremolo_depth = 0.0
	chest_open.tremolo_rate = 6.0
	chest_open.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	chest_open.repeat_rate = 0.0
	# ---- Filter
	chest_open.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	chest_open.cutoff = 900.0  # *
	chest_open.cutoff_sweep_octaves = 3.0  # *
	chest_open.resonance = 0.0
	chest_open.filter_lfo_depth = 0.0
	chest_open.filter_lfo_rate = 3.0
	chest_open.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	chest_open.drive = 0.0
	chest_open.bit_depth = 16
	chest_open.sample_hold = 1
	# ---- Space
	chest_open.delay_time = 0.2  # *
	chest_open.delay_feedback = 0.35  # *
	chest_open.delay_mix = 0.3  # *
	# ---- Output
	chest_open.volume_db = -8.0  # *
	chest_open.normalize = true
	chest_open.sample_rate = 44100
	chest_open.loop = false
	chest_open.noise_seed = 1
	chest_open.condition = &""
	p[&"p_chest_open"] = chest_open

	# ===================================================================== Player

	var footstep := SynthPatch.new()
	# ---- Oscillator
	footstep.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	footstep.duty = 0.5
	footstep.base_freq = 440.0
	footstep.noise_mix = 0.0
	footstep.noise_tone = 1.0
	footstep.sub_mix = 0.0
	footstep.detune_cents = 0.0
	footstep.detune_mix = 0.0
	footstep.pwm_depth = 0.0
	footstep.pwm_rate = 2.0
	footstep.ring_ratio = 0.0
	footstep.ring_mix = 0.0
	# ---- Pitch motion
	footstep.pitch_sweep_semitones = 0.0
	footstep.pitch_sweep_curve = 1.0
	footstep.vibrato_depth = 0.0
	footstep.vibrato_rate = 6.0
	footstep.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	footstep.vibrato_fade_in = 0.0
	footstep.arpeggio = []
	footstep.arpeggio_rate = 20.0
	footstep.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	footstep.arpeggio_glide = 0.0
	# ---- FM
	footstep.fm_ratio = 0.0
	footstep.fm_depth = 0.0
	footstep.fm_decay = 0.0
	# ---- Amp envelope
	footstep.attack = 0.0  # *
	footstep.decay = 0.05  # *
	footstep.sustain_level = 0.0
	footstep.sustain_time = 0.0
	footstep.release = 0.02  # *
	footstep.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	footstep.tremolo_depth = 0.0
	footstep.tremolo_rate = 6.0
	footstep.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	footstep.repeat_rate = 0.0
	# ---- Filter
	footstep.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	footstep.cutoff = 600.0  # *
	footstep.cutoff_sweep_octaves = -1.5  # *
	footstep.resonance = 0.0
	footstep.filter_lfo_depth = 0.0
	footstep.filter_lfo_rate = 3.0
	footstep.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	footstep.drive = 0.0
	footstep.bit_depth = 16
	footstep.sample_hold = 1
	# ---- Space
	footstep.delay_time = 0.0
	footstep.delay_feedback = 0.4
	footstep.delay_mix = 0.0
	# ---- Output
	footstep.volume_db = -14.0  # *
	footstep.normalize = true
	footstep.sample_rate = 44100
	footstep.loop = false
	footstep.noise_seed = 1
	footstep.condition = &""
	p[&"p_footstep"] = footstep

	var dash := SynthPatch.new()
	# ---- Oscillator
	dash.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	dash.duty = 0.5
	dash.base_freq = 440.0
	dash.noise_mix = 0.0
	dash.noise_tone = 1.0
	dash.sub_mix = 0.0
	dash.detune_cents = 0.0
	dash.detune_mix = 0.0
	dash.pwm_depth = 0.0
	dash.pwm_rate = 2.0
	dash.ring_ratio = 0.0
	dash.ring_mix = 0.0
	# ---- Pitch motion
	dash.pitch_sweep_semitones = 0.0
	dash.pitch_sweep_curve = 1.0
	dash.vibrato_depth = 0.0
	dash.vibrato_rate = 6.0
	dash.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	dash.vibrato_fade_in = 0.0
	dash.arpeggio = []
	dash.arpeggio_rate = 20.0
	dash.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	dash.arpeggio_glide = 0.0
	# ---- FM
	dash.fm_ratio = 0.0
	dash.fm_depth = 0.0
	dash.fm_decay = 0.0
	# ---- Amp envelope
	dash.attack = 0.01  # *
	dash.decay = 0.18  # *
	dash.sustain_level = 0.0
	dash.sustain_time = 0.0
	dash.release = 0.08  # *
	dash.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	dash.tremolo_depth = 0.0
	dash.tremolo_rate = 6.0
	dash.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	dash.repeat_rate = 0.0
	# ---- Filter
	dash.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	dash.cutoff = 900.0  # *
	dash.cutoff_sweep_octaves = 2.0  # *
	dash.resonance = 0.6  # *
	dash.filter_lfo_depth = 0.0
	dash.filter_lfo_rate = 3.0
	dash.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	dash.drive = 0.0
	dash.bit_depth = 16
	dash.sample_hold = 1
	# ---- Space
	dash.delay_time = 0.0
	dash.delay_feedback = 0.4
	dash.delay_mix = 0.0
	# ---- Output
	dash.volume_db = -8.0  # *
	dash.normalize = true
	dash.sample_rate = 44100
	dash.loop = false
	dash.noise_seed = 1
	dash.condition = &""
	p[&"p_dash"] = dash

	var heal := SynthPatch.new()
	# ---- Oscillator
	heal.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	heal.duty = 0.5
	heal.base_freq = 523.0  # *
	heal.noise_mix = 0.0
	heal.noise_tone = 1.0
	heal.sub_mix = 0.0
	heal.detune_cents = 0.0
	heal.detune_mix = 0.0
	heal.pwm_depth = 0.0
	heal.pwm_rate = 2.0
	heal.ring_ratio = 0.0
	heal.ring_mix = 0.0
	# ---- Pitch motion
	heal.pitch_sweep_semitones = 0.0
	heal.pitch_sweep_curve = 1.0
	heal.vibrato_depth = 0.2  # *
	heal.vibrato_rate = 5.0  # *
	heal.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	heal.vibrato_fade_in = 0.0
	heal.arpeggio = [0, 4, 7, 11, 12]  # *
	heal.arpeggio_rate = 16.0  # *
	heal.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	heal.arpeggio_glide = 0.0
	# ---- FM
	heal.fm_ratio = 2.0  # *
	heal.fm_depth = 1.0  # *
	heal.fm_decay = 0.0
	# ---- Amp envelope
	heal.attack = 0.05  # *
	heal.decay = 0.3  # *
	heal.sustain_level = 0.5  # *
	heal.sustain_time = 0.2  # *
	heal.release = 0.4  # *
	heal.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	heal.tremolo_depth = 0.0
	heal.tremolo_rate = 6.0
	heal.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	heal.repeat_rate = 0.0
	# ---- Filter
	heal.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	heal.cutoff = 2000.0
	heal.cutoff_sweep_octaves = 0.0
	heal.resonance = 0.0
	heal.filter_lfo_depth = 0.0
	heal.filter_lfo_rate = 3.0
	heal.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	heal.drive = 0.0
	heal.bit_depth = 16
	heal.sample_hold = 1
	# ---- Space
	heal.delay_time = 0.18  # *
	heal.delay_feedback = 0.45  # *
	heal.delay_mix = 0.35  # *
	# ---- Output
	heal.volume_db = -9.0  # *
	heal.normalize = true
	heal.sample_rate = 44100
	heal.loop = false
	heal.noise_seed = 1
	heal.condition = &""
	p[&"p_heal"] = heal

	# ===================================================== Planning phase and UI

	var ui_place := SynthPatch.new()
	# ---- Oscillator
	ui_place.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_place.duty = 0.5
	ui_place.base_freq = 880.0  # *
	ui_place.noise_mix = 0.0
	ui_place.noise_tone = 1.0
	ui_place.sub_mix = 0.0
	ui_place.detune_cents = 0.0
	ui_place.detune_mix = 0.0
	ui_place.pwm_depth = 0.0
	ui_place.pwm_rate = 2.0
	ui_place.ring_ratio = 0.0
	ui_place.ring_mix = 0.0
	# ---- Pitch motion
	ui_place.pitch_sweep_semitones = 5.0  # *
	ui_place.pitch_sweep_curve = 0.5  # *
	ui_place.vibrato_depth = 0.0
	ui_place.vibrato_rate = 6.0
	ui_place.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_place.vibrato_fade_in = 0.0
	ui_place.arpeggio = []
	ui_place.arpeggio_rate = 20.0
	ui_place.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_place.arpeggio_glide = 0.0
	# ---- FM
	ui_place.fm_ratio = 0.0
	ui_place.fm_depth = 0.0
	ui_place.fm_decay = 0.0
	# ---- Amp envelope
	ui_place.attack = 0.0  # *
	ui_place.decay = 0.06  # *
	ui_place.sustain_level = 0.0
	ui_place.sustain_time = 0.0
	ui_place.release = 0.03  # *
	ui_place.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_place.tremolo_depth = 0.0
	ui_place.tremolo_rate = 6.0
	ui_place.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_place.repeat_rate = 0.0
	# ---- Filter
	ui_place.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_place.cutoff = 2000.0
	ui_place.cutoff_sweep_octaves = 0.0
	ui_place.resonance = 0.0
	ui_place.filter_lfo_depth = 0.0
	ui_place.filter_lfo_rate = 3.0
	ui_place.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_place.drive = 0.0
	ui_place.bit_depth = 16
	ui_place.sample_hold = 1
	# ---- Space
	ui_place.delay_time = 0.0
	ui_place.delay_feedback = 0.4
	ui_place.delay_mix = 0.0
	# ---- Output
	ui_place.volume_db = -10.0  # *
	ui_place.normalize = true
	ui_place.sample_rate = 44100
	ui_place.loop = false
	ui_place.noise_seed = 1
	ui_place.condition = &""
	p[&"p_ui_place"] = ui_place

	var ui_remove := SynthPatch.new()
	# ---- Oscillator
	ui_remove.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_remove.duty = 0.5
	ui_remove.base_freq = 880.0  # *
	ui_remove.noise_mix = 0.0
	ui_remove.noise_tone = 1.0
	ui_remove.sub_mix = 0.0
	ui_remove.detune_cents = 0.0
	ui_remove.detune_mix = 0.0
	ui_remove.pwm_depth = 0.0
	ui_remove.pwm_rate = 2.0
	ui_remove.ring_ratio = 0.0
	ui_remove.ring_mix = 0.0
	# ---- Pitch motion
	ui_remove.pitch_sweep_semitones = -5.0  # *
	ui_remove.pitch_sweep_curve = 0.5  # *
	ui_remove.vibrato_depth = 0.0
	ui_remove.vibrato_rate = 6.0
	ui_remove.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_remove.vibrato_fade_in = 0.0
	ui_remove.arpeggio = []
	ui_remove.arpeggio_rate = 20.0
	ui_remove.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_remove.arpeggio_glide = 0.0
	# ---- FM
	ui_remove.fm_ratio = 0.0
	ui_remove.fm_depth = 0.0
	ui_remove.fm_decay = 0.0
	# ---- Amp envelope
	ui_remove.attack = 0.0  # *
	ui_remove.decay = 0.06  # *
	ui_remove.sustain_level = 0.0
	ui_remove.sustain_time = 0.0
	ui_remove.release = 0.03  # *
	ui_remove.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_remove.tremolo_depth = 0.0
	ui_remove.tremolo_rate = 6.0
	ui_remove.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_remove.repeat_rate = 0.0
	# ---- Filter
	ui_remove.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_remove.cutoff = 2000.0
	ui_remove.cutoff_sweep_octaves = 0.0
	ui_remove.resonance = 0.0
	ui_remove.filter_lfo_depth = 0.0
	ui_remove.filter_lfo_rate = 3.0
	ui_remove.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_remove.drive = 0.0
	ui_remove.bit_depth = 16
	ui_remove.sample_hold = 1
	# ---- Space
	ui_remove.delay_time = 0.0
	ui_remove.delay_feedback = 0.4
	ui_remove.delay_mix = 0.0
	# ---- Output
	ui_remove.volume_db = -10.0  # *
	ui_remove.normalize = true
	ui_remove.sample_rate = 44100
	ui_remove.loop = false
	ui_remove.noise_seed = 1
	ui_remove.condition = &""
	p[&"p_ui_remove"] = ui_remove

	var ui_tick := SynthPatch.new()
	# ---- Oscillator
	ui_tick.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_tick.duty = 0.5
	ui_tick.base_freq = 1800.0  # *
	ui_tick.noise_mix = 0.0
	ui_tick.noise_tone = 1.0
	ui_tick.sub_mix = 0.0
	ui_tick.detune_cents = 0.0
	ui_tick.detune_mix = 0.0
	ui_tick.pwm_depth = 0.0
	ui_tick.pwm_rate = 2.0
	ui_tick.ring_ratio = 0.0
	ui_tick.ring_mix = 0.0
	# ---- Pitch motion
	ui_tick.pitch_sweep_semitones = 0.0
	ui_tick.pitch_sweep_curve = 1.0
	ui_tick.vibrato_depth = 0.0
	ui_tick.vibrato_rate = 6.0
	ui_tick.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_tick.vibrato_fade_in = 0.0
	ui_tick.arpeggio = []
	ui_tick.arpeggio_rate = 20.0
	ui_tick.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_tick.arpeggio_glide = 0.0
	# ---- FM
	ui_tick.fm_ratio = 0.0
	ui_tick.fm_depth = 0.0
	ui_tick.fm_decay = 0.0
	# ---- Amp envelope
	ui_tick.attack = 0.0  # *
	ui_tick.decay = 0.012  # *
	ui_tick.sustain_level = 0.0
	ui_tick.sustain_time = 0.0
	ui_tick.release = 0.005  # *
	ui_tick.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_tick.tremolo_depth = 0.0
	ui_tick.tremolo_rate = 6.0
	ui_tick.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_tick.repeat_rate = 0.0
	# ---- Filter
	ui_tick.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_tick.cutoff = 2000.0
	ui_tick.cutoff_sweep_octaves = 0.0
	ui_tick.resonance = 0.0
	ui_tick.filter_lfo_depth = 0.0
	ui_tick.filter_lfo_rate = 3.0
	ui_tick.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_tick.drive = 0.0
	ui_tick.bit_depth = 16
	ui_tick.sample_hold = 1
	# ---- Space
	ui_tick.delay_time = 0.0
	ui_tick.delay_feedback = 0.4
	ui_tick.delay_mix = 0.0
	# ---- Output
	ui_tick.volume_db = -16.0  # *
	ui_tick.normalize = true
	ui_tick.sample_rate = 44100
	ui_tick.loop = false
	ui_tick.noise_seed = 1
	ui_tick.condition = &""
	p[&"p_ui_tick"] = ui_tick

	var ui_error := SynthPatch.new()
	# ---- Oscillator
	ui_error.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_error.duty = 0.25  # *
	ui_error.base_freq = 150.0  # *
	ui_error.noise_mix = 0.0
	ui_error.noise_tone = 1.0
	ui_error.sub_mix = 0.0
	ui_error.detune_cents = 0.0
	ui_error.detune_mix = 0.0
	ui_error.pwm_depth = 0.0
	ui_error.pwm_rate = 2.0
	ui_error.ring_ratio = 0.0
	ui_error.ring_mix = 0.0
	# ---- Pitch motion
	ui_error.pitch_sweep_semitones = 0.0
	ui_error.pitch_sweep_curve = 1.0
	ui_error.vibrato_depth = 0.0
	ui_error.vibrato_rate = 6.0
	ui_error.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_error.vibrato_fade_in = 0.0
	ui_error.arpeggio = [0, -3]  # *
	ui_error.arpeggio_rate = 12.0  # *
	ui_error.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_error.arpeggio_glide = 0.0
	# ---- FM
	ui_error.fm_ratio = 0.0
	ui_error.fm_depth = 0.0
	ui_error.fm_decay = 0.0
	# ---- Amp envelope
	ui_error.attack = 0.0  # *
	ui_error.decay = 0.16  # *
	ui_error.sustain_level = 0.0
	ui_error.sustain_time = 0.0
	ui_error.release = 0.03  # *
	ui_error.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_error.tremolo_depth = 0.0
	ui_error.tremolo_rate = 6.0
	ui_error.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_error.repeat_rate = 0.0
	# ---- Filter
	ui_error.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_error.cutoff = 2000.0
	ui_error.cutoff_sweep_octaves = 0.0
	ui_error.resonance = 0.0
	ui_error.filter_lfo_depth = 0.0
	ui_error.filter_lfo_rate = 3.0
	ui_error.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_error.drive = 0.0
	ui_error.bit_depth = 6  # *
	ui_error.sample_hold = 1
	# ---- Space
	ui_error.delay_time = 0.0
	ui_error.delay_feedback = 0.4
	ui_error.delay_mix = 0.0
	# ---- Output
	ui_error.volume_db = -10.0  # *
	ui_error.normalize = true
	ui_error.sample_rate = 44100
	ui_error.loop = false
	ui_error.noise_seed = 1
	ui_error.condition = &""
	p[&"p_ui_error"] = ui_error

	var ui_begin_assault := SynthPatch.new()
	# ---- Oscillator
	ui_begin_assault.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_begin_assault.duty = 0.5
	ui_begin_assault.base_freq = 196.0  # *
	ui_begin_assault.noise_mix = 0.0
	ui_begin_assault.noise_tone = 1.0
	ui_begin_assault.sub_mix = 0.0
	ui_begin_assault.detune_cents = 0.0
	ui_begin_assault.detune_mix = 0.0
	ui_begin_assault.pwm_depth = 0.0
	ui_begin_assault.pwm_rate = 2.0
	ui_begin_assault.ring_ratio = 0.0
	ui_begin_assault.ring_mix = 0.0
	# ---- Pitch motion
	ui_begin_assault.pitch_sweep_semitones = 0.0
	ui_begin_assault.pitch_sweep_curve = 1.0
	ui_begin_assault.vibrato_depth = 0.2  # *
	ui_begin_assault.vibrato_rate = 5.0  # *
	ui_begin_assault.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_begin_assault.vibrato_fade_in = 0.0
	ui_begin_assault.arpeggio = [0, 7, 12]  # *
	ui_begin_assault.arpeggio_rate = 7.0  # *
	ui_begin_assault.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_begin_assault.arpeggio_glide = 0.0
	# ---- FM
	ui_begin_assault.fm_ratio = 0.0
	ui_begin_assault.fm_depth = 0.0
	ui_begin_assault.fm_decay = 0.0
	# ---- Amp envelope
	ui_begin_assault.attack = 0.03  # *
	ui_begin_assault.decay = 0.2  # *
	ui_begin_assault.sustain_level = 0.8  # *
	ui_begin_assault.sustain_time = 0.6  # *
	ui_begin_assault.release = 0.4  # *
	ui_begin_assault.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_begin_assault.tremolo_depth = 0.0
	ui_begin_assault.tremolo_rate = 6.0
	ui_begin_assault.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_begin_assault.repeat_rate = 0.0
	# ---- Filter
	ui_begin_assault.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_begin_assault.cutoff = 700.0  # *
	ui_begin_assault.cutoff_sweep_octaves = 2.5  # *
	ui_begin_assault.resonance = 0.3  # *
	ui_begin_assault.filter_lfo_depth = 0.0
	ui_begin_assault.filter_lfo_rate = 3.0
	ui_begin_assault.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_begin_assault.drive = 0.5  # *
	ui_begin_assault.bit_depth = 16
	ui_begin_assault.sample_hold = 1
	# ---- Space
	ui_begin_assault.delay_time = 0.27  # *
	ui_begin_assault.delay_feedback = 0.4
	ui_begin_assault.delay_mix = 0.3  # *
	# ---- Output
	ui_begin_assault.volume_db = -4.0  # *
	ui_begin_assault.normalize = true
	ui_begin_assault.sample_rate = 44100
	ui_begin_assault.loop = false
	ui_begin_assault.noise_seed = 1
	ui_begin_assault.condition = &""
	p[&"p_ui_begin_assault"] = ui_begin_assault

	var ui_phase_riser := SynthPatch.new()
	# ---- Oscillator
	ui_phase_riser.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ui_phase_riser.duty = 0.5
	ui_phase_riser.base_freq = 440.0
	ui_phase_riser.noise_mix = 0.0
	ui_phase_riser.noise_tone = 1.0
	ui_phase_riser.sub_mix = 0.0
	ui_phase_riser.detune_cents = 0.0
	ui_phase_riser.detune_mix = 0.0
	ui_phase_riser.pwm_depth = 0.0
	ui_phase_riser.pwm_rate = 2.0
	ui_phase_riser.ring_ratio = 0.0
	ui_phase_riser.ring_mix = 0.0
	# ---- Pitch motion
	ui_phase_riser.pitch_sweep_semitones = 0.0
	ui_phase_riser.pitch_sweep_curve = 1.0
	ui_phase_riser.vibrato_depth = 0.0
	ui_phase_riser.vibrato_rate = 6.0
	ui_phase_riser.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_phase_riser.vibrato_fade_in = 0.0
	ui_phase_riser.arpeggio = []
	ui_phase_riser.arpeggio_rate = 20.0
	ui_phase_riser.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ui_phase_riser.arpeggio_glide = 0.0
	# ---- FM
	ui_phase_riser.fm_ratio = 0.0
	ui_phase_riser.fm_depth = 0.0
	ui_phase_riser.fm_decay = 0.0
	# ---- Amp envelope
	ui_phase_riser.attack = 0.4  # *
	ui_phase_riser.decay = 0.2  # *
	ui_phase_riser.sustain_level = 0.9  # *
	ui_phase_riser.sustain_time = 0.2  # *
	ui_phase_riser.release = 0.3  # *
	ui_phase_riser.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	ui_phase_riser.tremolo_depth = 0.0
	ui_phase_riser.tremolo_rate = 6.0
	ui_phase_riser.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ui_phase_riser.repeat_rate = 0.0
	# ---- Filter
	ui_phase_riser.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	ui_phase_riser.cutoff = 250.0  # *
	ui_phase_riser.cutoff_sweep_octaves = 4.5  # *
	ui_phase_riser.resonance = 0.7  # *
	ui_phase_riser.filter_lfo_depth = 0.0
	ui_phase_riser.filter_lfo_rate = 3.0
	ui_phase_riser.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ui_phase_riser.drive = 0.0
	ui_phase_riser.bit_depth = 16
	ui_phase_riser.sample_hold = 1
	# ---- Space
	ui_phase_riser.delay_time = 0.15  # *
	ui_phase_riser.delay_feedback = 0.4
	ui_phase_riser.delay_mix = 0.3  # *
	# ---- Output
	ui_phase_riser.volume_db = -7.0  # *
	ui_phase_riser.normalize = true
	ui_phase_riser.sample_rate = 44100
	ui_phase_riser.loop = false
	ui_phase_riser.noise_seed = 1
	ui_phase_riser.condition = &""
	p[&"p_ui_phase_riser"] = ui_phase_riser

	# =================================================================== Outcomes

	var win_fanfare := SynthPatch.new()
	# ---- Oscillator
	win_fanfare.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	win_fanfare.duty = 0.5
	win_fanfare.base_freq = 262.0  # *
	win_fanfare.noise_mix = 0.0
	win_fanfare.noise_tone = 1.0
	win_fanfare.sub_mix = 0.0
	win_fanfare.detune_cents = 0.0
	win_fanfare.detune_mix = 0.0
	win_fanfare.pwm_depth = 0.0
	win_fanfare.pwm_rate = 2.0
	win_fanfare.ring_ratio = 0.0
	win_fanfare.ring_mix = 0.0
	# ---- Pitch motion
	win_fanfare.pitch_sweep_semitones = 0.0
	win_fanfare.pitch_sweep_curve = 1.0
	win_fanfare.vibrato_depth = 0.2  # *
	win_fanfare.vibrato_rate = 6.0
	win_fanfare.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	win_fanfare.vibrato_fade_in = 0.0
	win_fanfare.arpeggio = [0, 4, 7, 12, 16, 19, 24, 24]  # *
	win_fanfare.arpeggio_rate = 9.0  # *
	win_fanfare.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	win_fanfare.arpeggio_glide = 0.0
	# ---- FM
	win_fanfare.fm_ratio = 0.0
	win_fanfare.fm_depth = 0.0
	win_fanfare.fm_decay = 0.0
	# ---- Amp envelope
	win_fanfare.attack = 0.02  # *
	win_fanfare.decay = 0.3  # *
	win_fanfare.sustain_level = 0.8  # *
	win_fanfare.sustain_time = 0.7  # *
	win_fanfare.release = 0.6  # *
	win_fanfare.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	win_fanfare.tremolo_depth = 0.0
	win_fanfare.tremolo_rate = 6.0
	win_fanfare.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	win_fanfare.repeat_rate = 0.0
	# ---- Filter
	win_fanfare.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	win_fanfare.cutoff = 1200.0  # *
	win_fanfare.cutoff_sweep_octaves = 2.0  # *
	win_fanfare.resonance = 0.0
	win_fanfare.filter_lfo_depth = 0.0
	win_fanfare.filter_lfo_rate = 3.0
	win_fanfare.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	win_fanfare.drive = 0.3  # *
	win_fanfare.bit_depth = 16
	win_fanfare.sample_hold = 1
	# ---- Space
	win_fanfare.delay_time = 0.27  # *
	win_fanfare.delay_feedback = 0.45  # *
	win_fanfare.delay_mix = 0.35  # *
	# ---- Output
	win_fanfare.volume_db = -5.0  # *
	win_fanfare.normalize = true
	win_fanfare.sample_rate = 44100
	win_fanfare.loop = false
	win_fanfare.noise_seed = 1
	win_fanfare.condition = &""
	p[&"p_win_fanfare"] = win_fanfare

	var lose_sting := SynthPatch.new()
	# ---- Oscillator
	lose_sting.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	lose_sting.duty = 0.5
	lose_sting.base_freq = 220.0  # *
	lose_sting.noise_mix = 0.0
	lose_sting.noise_tone = 1.0
	lose_sting.sub_mix = 0.0
	lose_sting.detune_cents = 0.0
	lose_sting.detune_mix = 0.0
	lose_sting.pwm_depth = 0.0
	lose_sting.pwm_rate = 2.0
	lose_sting.ring_ratio = 0.0
	lose_sting.ring_mix = 0.0
	# ---- Pitch motion
	lose_sting.pitch_sweep_semitones = -12.0  # *
	lose_sting.pitch_sweep_curve = 1.5  # *
	lose_sting.vibrato_depth = 1.0  # *
	lose_sting.vibrato_rate = 4.0  # *
	lose_sting.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	lose_sting.vibrato_fade_in = 0.0
	lose_sting.arpeggio = []
	lose_sting.arpeggio_rate = 20.0
	lose_sting.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	lose_sting.arpeggio_glide = 0.0
	# ---- FM
	lose_sting.fm_ratio = 0.0
	lose_sting.fm_depth = 0.0
	lose_sting.fm_decay = 0.0
	# ---- Amp envelope
	lose_sting.attack = 0.05  # *
	lose_sting.decay = 0.4  # *
	lose_sting.sustain_level = 0.7  # *
	lose_sting.sustain_time = 0.5  # *
	lose_sting.release = 0.7  # *
	lose_sting.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	lose_sting.tremolo_depth = 0.0
	lose_sting.tremolo_rate = 6.0
	lose_sting.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	lose_sting.repeat_rate = 0.0
	# ---- Filter
	lose_sting.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	lose_sting.cutoff = 2000.0
	lose_sting.cutoff_sweep_octaves = -3.0  # *
	lose_sting.resonance = 0.0
	lose_sting.filter_lfo_depth = 0.0
	lose_sting.filter_lfo_rate = 3.0
	lose_sting.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	lose_sting.drive = 0.0
	lose_sting.bit_depth = 7  # *
	lose_sting.sample_hold = 1
	# ---- Space
	lose_sting.delay_time = 0.3  # *
	lose_sting.delay_feedback = 0.4
	lose_sting.delay_mix = 0.3  # *
	# ---- Output
	lose_sting.volume_db = -5.0  # *
	lose_sting.normalize = true
	lose_sting.sample_rate = 44100
	lose_sting.loop = false
	lose_sting.noise_seed = 1
	lose_sting.condition = &""
	p[&"p_lose_sting"] = lose_sting

	# ============================================================ Miscellaneous
	# Odds and ends that stretch the palette in directions the game systems above do not:
	# creatures, weather, water, sci-fi, and a few timing/feedback blips. Good starting points
	# when you need "something like X" fast.

	var whoosh := SynthPatch.new()
	# ---- Oscillator
	whoosh.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	whoosh.duty = 0.5
	whoosh.base_freq = 440.0
	whoosh.noise_mix = 0.0
	whoosh.noise_tone = 1.0
	whoosh.sub_mix = 0.0
	whoosh.detune_cents = 0.0
	whoosh.detune_mix = 0.0
	whoosh.pwm_depth = 0.0
	whoosh.pwm_rate = 2.0
	whoosh.ring_ratio = 0.0
	whoosh.ring_mix = 0.0
	# ---- Pitch motion
	whoosh.pitch_sweep_semitones = 0.0
	whoosh.pitch_sweep_curve = 1.0
	whoosh.vibrato_depth = 0.0
	whoosh.vibrato_rate = 6.0
	whoosh.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	whoosh.vibrato_fade_in = 0.0
	whoosh.arpeggio = []
	whoosh.arpeggio_rate = 20.0
	whoosh.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	whoosh.arpeggio_glide = 0.0
	# ---- FM
	whoosh.fm_ratio = 0.0
	whoosh.fm_depth = 0.0
	whoosh.fm_decay = 0.0
	# ---- Amp envelope
	whoosh.attack = 0.04  # *
	whoosh.decay = 0.12  # *
	whoosh.sustain_level = 0.0
	whoosh.sustain_time = 0.0
	whoosh.release = 0.12  # *
	whoosh.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	whoosh.tremolo_depth = 0.0
	whoosh.tremolo_rate = 6.0
	whoosh.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	whoosh.repeat_rate = 0.0
	# ---- Filter
	whoosh.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	whoosh.cutoff = 400.0  # *
	whoosh.cutoff_sweep_octaves = 3.0  # *
	whoosh.resonance = 0.7  # *
	whoosh.filter_lfo_depth = 0.0
	whoosh.filter_lfo_rate = 3.0
	whoosh.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	whoosh.drive = 0.0
	whoosh.bit_depth = 16
	whoosh.sample_hold = 1
	# ---- Space
	whoosh.delay_time = 0.0
	whoosh.delay_feedback = 0.4
	whoosh.delay_mix = 0.0
	# ---- Output
	whoosh.volume_db = -7.0  # *
	whoosh.normalize = true
	whoosh.sample_rate = 44100
	whoosh.loop = false
	whoosh.noise_seed = 1
	whoosh.condition = &""
	p[&"p_whoosh"] = whoosh

	var laser := SynthPatch.new()
	# ---- Oscillator
	laser.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	laser.duty = 0.5
	laser.base_freq = 1800.0  # *
	laser.noise_mix = 0.0
	laser.noise_tone = 1.0
	laser.sub_mix = 0.0
	laser.detune_cents = 0.0
	laser.detune_mix = 0.0
	laser.pwm_depth = 0.0
	laser.pwm_rate = 2.0
	laser.ring_ratio = 0.0
	laser.ring_mix = 0.0
	# ---- Pitch motion
	laser.pitch_sweep_semitones = -28.0  # *
	laser.pitch_sweep_curve = 0.6  # *
	laser.vibrato_depth = 0.0
	laser.vibrato_rate = 6.0
	laser.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	laser.vibrato_fade_in = 0.0
	laser.arpeggio = []
	laser.arpeggio_rate = 20.0
	laser.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	laser.arpeggio_glide = 0.0
	# ---- FM
	laser.fm_ratio = 0.0
	laser.fm_depth = 0.0
	laser.fm_decay = 0.0
	# ---- Amp envelope
	laser.attack = 0.0  # *
	laser.decay = 0.2  # *
	laser.sustain_level = 0.0
	laser.sustain_time = 0.0
	laser.release = 0.05
	laser.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	laser.tremolo_depth = 0.0
	laser.tremolo_rate = 6.0
	laser.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	laser.repeat_rate = 0.0
	# ---- Filter
	laser.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	laser.cutoff = 6000.0  # *
	laser.cutoff_sweep_octaves = -2.0  # *
	laser.resonance = 0.6  # *
	laser.filter_lfo_depth = 0.0
	laser.filter_lfo_rate = 3.0
	laser.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	laser.drive = 0.0
	laser.bit_depth = 16
	laser.sample_hold = 1
	# ---- Space
	laser.delay_time = 0.0
	laser.delay_feedback = 0.4
	laser.delay_mix = 0.0
	# ---- Output
	laser.volume_db = -9.0  # *
	laser.normalize = true
	laser.sample_rate = 44100
	laser.loop = false
	laser.noise_seed = 1
	laser.condition = &""
	p[&"p_laser"] = laser

	var teleport_out := SynthPatch.new()
	# ---- Oscillator
	teleport_out.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	teleport_out.duty = 0.5
	teleport_out.base_freq = 1400.0  # *
	teleport_out.noise_mix = 0.0
	teleport_out.noise_tone = 1.0
	teleport_out.sub_mix = 0.0
	teleport_out.detune_cents = 0.0
	teleport_out.detune_mix = 0.0
	teleport_out.pwm_depth = 0.0
	teleport_out.pwm_rate = 2.0
	teleport_out.ring_ratio = 0.0
	teleport_out.ring_mix = 0.0
	# ---- Pitch motion
	teleport_out.pitch_sweep_semitones = -36.0  # *
	teleport_out.pitch_sweep_curve = 0.45  # *
	teleport_out.vibrato_depth = 1.5  # *
	teleport_out.vibrato_rate = 12.0  # *
	teleport_out.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	teleport_out.vibrato_fade_in = 0.0
	teleport_out.arpeggio = []
	teleport_out.arpeggio_rate = 20.0
	teleport_out.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	teleport_out.arpeggio_glide = 0.0
	# ---- FM
	teleport_out.fm_ratio = 2.0  # *
	teleport_out.fm_depth = 2.5  # *
	teleport_out.fm_decay = 0.0
	# ---- Amp envelope
	teleport_out.attack = 0.0  # *
	teleport_out.decay = 0.5  # *
	teleport_out.sustain_level = 0.0
	teleport_out.sustain_time = 0.0
	teleport_out.release = 0.3  # *
	teleport_out.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	teleport_out.tremolo_depth = 0.0
	teleport_out.tremolo_rate = 6.0
	teleport_out.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	teleport_out.repeat_rate = 0.0
	# ---- Filter
	teleport_out.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	teleport_out.cutoff = 2000.0
	teleport_out.cutoff_sweep_octaves = 0.0
	teleport_out.resonance = 0.0
	teleport_out.filter_lfo_depth = 0.0
	teleport_out.filter_lfo_rate = 3.0
	teleport_out.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	teleport_out.drive = 0.0
	teleport_out.bit_depth = 16
	teleport_out.sample_hold = 1
	# ---- Space
	teleport_out.delay_time = 0.2  # *
	teleport_out.delay_feedback = 0.5  # *
	teleport_out.delay_mix = 0.4  # *
	# ---- Output
	teleport_out.volume_db = -6.0  # *
	teleport_out.normalize = true
	teleport_out.sample_rate = 44100
	teleport_out.loop = false
	teleport_out.noise_seed = 1
	teleport_out.condition = &""
	p[&"p_teleport_out"] = teleport_out

	var powerup := SynthPatch.new()
	# ---- Oscillator
	powerup.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	powerup.duty = 0.5
	powerup.base_freq = 330.0  # *
	powerup.noise_mix = 0.0
	powerup.noise_tone = 1.0
	powerup.sub_mix = 0.0
	powerup.detune_cents = 0.0
	powerup.detune_mix = 0.0
	powerup.pwm_depth = 0.0
	powerup.pwm_rate = 2.0
	powerup.ring_ratio = 0.0
	powerup.ring_mix = 0.0
	# ---- Pitch motion
	powerup.pitch_sweep_semitones = 24.0  # *
	powerup.pitch_sweep_curve = 0.9  # *
	powerup.vibrato_depth = 0.0
	powerup.vibrato_rate = 6.0
	powerup.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	powerup.vibrato_fade_in = 0.0
	powerup.arpeggio = [0, 4, 7]  # *
	powerup.arpeggio_rate = 36.0  # *
	powerup.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	powerup.arpeggio_glide = 0.0
	# ---- FM
	powerup.fm_ratio = 0.0
	powerup.fm_depth = 0.0
	powerup.fm_decay = 0.0
	# ---- Amp envelope
	powerup.attack = 0.0  # *
	powerup.decay = 0.4  # *
	powerup.sustain_level = 0.0
	powerup.sustain_time = 0.0
	powerup.release = 0.1  # *
	powerup.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	powerup.tremolo_depth = 0.0
	powerup.tremolo_rate = 6.0
	powerup.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	powerup.repeat_rate = 0.0
	# ---- Filter
	powerup.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	powerup.cutoff = 3000.0  # *
	powerup.cutoff_sweep_octaves = 1.5  # *
	powerup.resonance = 0.0
	powerup.filter_lfo_depth = 0.0
	powerup.filter_lfo_rate = 3.0
	powerup.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	powerup.drive = 0.0
	powerup.bit_depth = 16
	powerup.sample_hold = 1
	# ---- Space
	powerup.delay_time = 0.0
	powerup.delay_feedback = 0.4
	powerup.delay_mix = 0.0
	# ---- Output
	powerup.volume_db = -9.0  # *
	powerup.normalize = true
	powerup.sample_rate = 44100
	powerup.loop = false
	powerup.noise_seed = 1
	powerup.condition = &""
	p[&"p_powerup"] = powerup

	var countdown_beep := SynthPatch.new()
	# ---- Oscillator
	countdown_beep.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	countdown_beep.duty = 0.5
	countdown_beep.base_freq = 880.0  # *
	countdown_beep.noise_mix = 0.0
	countdown_beep.noise_tone = 1.0
	countdown_beep.sub_mix = 0.0
	countdown_beep.detune_cents = 0.0
	countdown_beep.detune_mix = 0.0
	countdown_beep.pwm_depth = 0.0
	countdown_beep.pwm_rate = 2.0
	countdown_beep.ring_ratio = 0.0
	countdown_beep.ring_mix = 0.0
	# ---- Pitch motion
	countdown_beep.pitch_sweep_semitones = 0.0
	countdown_beep.pitch_sweep_curve = 1.0
	countdown_beep.vibrato_depth = 0.0
	countdown_beep.vibrato_rate = 6.0
	countdown_beep.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	countdown_beep.vibrato_fade_in = 0.0
	countdown_beep.arpeggio = []
	countdown_beep.arpeggio_rate = 20.0
	countdown_beep.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	countdown_beep.arpeggio_glide = 0.0
	# ---- FM
	countdown_beep.fm_ratio = 0.0
	countdown_beep.fm_depth = 0.0
	countdown_beep.fm_decay = 0.0
	# ---- Amp envelope
	countdown_beep.attack = 0.0  # *
	countdown_beep.decay = 0.05  # *
	countdown_beep.sustain_level = 0.8  # *
	countdown_beep.sustain_time = 0.08  # *
	countdown_beep.release = 0.03  # *
	countdown_beep.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	countdown_beep.tremolo_depth = 0.0
	countdown_beep.tremolo_rate = 6.0
	countdown_beep.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	countdown_beep.repeat_rate = 0.0
	# ---- Filter
	countdown_beep.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	countdown_beep.cutoff = 3500.0  # *
	countdown_beep.cutoff_sweep_octaves = 0.0
	countdown_beep.resonance = 0.0
	countdown_beep.filter_lfo_depth = 0.0
	countdown_beep.filter_lfo_rate = 3.0
	countdown_beep.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	countdown_beep.drive = 0.0
	countdown_beep.bit_depth = 16
	countdown_beep.sample_hold = 1
	# ---- Space
	countdown_beep.delay_time = 0.0
	countdown_beep.delay_feedback = 0.4
	countdown_beep.delay_mix = 0.0
	# ---- Output
	countdown_beep.volume_db = -12.0  # *
	countdown_beep.normalize = true
	countdown_beep.sample_rate = 44100
	countdown_beep.loop = false
	countdown_beep.noise_seed = 1
	countdown_beep.condition = &""
	p[&"p_countdown_beep"] = countdown_beep

	var clock_tick := SynthPatch.new()
	# ---- Oscillator
	clock_tick.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	clock_tick.duty = 0.5
	clock_tick.base_freq = 440.0
	clock_tick.noise_mix = 0.0
	clock_tick.noise_tone = 1.0
	clock_tick.sub_mix = 0.0
	clock_tick.detune_cents = 0.0
	clock_tick.detune_mix = 0.0
	clock_tick.pwm_depth = 0.0
	clock_tick.pwm_rate = 2.0
	clock_tick.ring_ratio = 0.0
	clock_tick.ring_mix = 0.0
	# ---- Pitch motion
	clock_tick.pitch_sweep_semitones = 0.0
	clock_tick.pitch_sweep_curve = 1.0
	clock_tick.vibrato_depth = 0.0
	clock_tick.vibrato_rate = 6.0
	clock_tick.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	clock_tick.vibrato_fade_in = 0.0
	clock_tick.arpeggio = []
	clock_tick.arpeggio_rate = 20.0
	clock_tick.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	clock_tick.arpeggio_glide = 0.0
	# ---- FM
	clock_tick.fm_ratio = 0.0
	clock_tick.fm_depth = 0.0
	clock_tick.fm_decay = 0.0
	# ---- Amp envelope
	clock_tick.attack = 0.0  # *
	clock_tick.decay = 0.02  # *
	clock_tick.sustain_level = 0.0
	clock_tick.sustain_time = 0.0
	clock_tick.release = 0.01  # *
	clock_tick.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	clock_tick.tremolo_depth = 0.0
	clock_tick.tremolo_rate = 6.0
	clock_tick.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	clock_tick.repeat_rate = 0.0
	# ---- Filter
	clock_tick.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	clock_tick.cutoff = 2500.0  # *
	clock_tick.cutoff_sweep_octaves = 0.0
	clock_tick.resonance = 0.8  # *
	clock_tick.filter_lfo_depth = 0.0
	clock_tick.filter_lfo_rate = 3.0
	clock_tick.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	clock_tick.drive = 0.0
	clock_tick.bit_depth = 16
	clock_tick.sample_hold = 1
	# ---- Space
	clock_tick.delay_time = 0.0
	clock_tick.delay_feedback = 0.4
	clock_tick.delay_mix = 0.0
	# ---- Output
	clock_tick.volume_db = -12.0  # *
	clock_tick.normalize = true
	clock_tick.sample_rate = 44100
	clock_tick.loop = false
	clock_tick.noise_seed = 1
	clock_tick.condition = &""
	p[&"p_clock_tick"] = clock_tick

	var heartbeat := SynthPatch.new()
	# ---- Oscillator
	heartbeat.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	heartbeat.duty = 0.5
	heartbeat.base_freq = 70.0  # *
	heartbeat.noise_mix = 0.0
	heartbeat.noise_tone = 1.0
	heartbeat.sub_mix = 0.0
	heartbeat.detune_cents = 0.0
	heartbeat.detune_mix = 0.0
	heartbeat.pwm_depth = 0.0
	heartbeat.pwm_rate = 2.0
	heartbeat.ring_ratio = 0.0
	heartbeat.ring_mix = 0.0
	# ---- Pitch motion
	heartbeat.pitch_sweep_semitones = -10.0  # *
	heartbeat.pitch_sweep_curve = 0.4  # *
	heartbeat.vibrato_depth = 0.0
	heartbeat.vibrato_rate = 6.0
	heartbeat.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	heartbeat.vibrato_fade_in = 0.0
	heartbeat.arpeggio = []
	heartbeat.arpeggio_rate = 20.0
	heartbeat.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	heartbeat.arpeggio_glide = 0.0
	# ---- FM
	heartbeat.fm_ratio = 0.0
	heartbeat.fm_depth = 0.0
	heartbeat.fm_decay = 0.0
	# ---- Amp envelope
	heartbeat.attack = 0.005
	heartbeat.decay = 0.12  # *
	heartbeat.sustain_level = 0.0
	heartbeat.sustain_time = 0.0
	heartbeat.release = 0.05
	heartbeat.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	heartbeat.tremolo_depth = 0.0
	heartbeat.tremolo_rate = 6.0
	heartbeat.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	heartbeat.repeat_rate = 0.0
	# ---- Filter
	heartbeat.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	heartbeat.cutoff = 2000.0
	heartbeat.cutoff_sweep_octaves = 0.0
	heartbeat.resonance = 0.0
	heartbeat.filter_lfo_depth = 0.0
	heartbeat.filter_lfo_rate = 3.0
	heartbeat.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	heartbeat.drive = 0.4  # *
	heartbeat.bit_depth = 16
	heartbeat.sample_hold = 1
	# ---- Space
	# A single echo with no feedback makes the second "dub" of the beat.
	heartbeat.delay_time = 0.16  # *
	heartbeat.delay_feedback = 0.0  # *
	heartbeat.delay_mix = 0.7  # *
	# ---- Output
	heartbeat.volume_db = -3.0  # *
	heartbeat.normalize = true
	heartbeat.sample_rate = 44100
	heartbeat.loop = false
	heartbeat.noise_seed = 1
	heartbeat.condition = &""
	p[&"p_heartbeat"] = heartbeat

	var thunder := SynthPatch.new()
	# ---- Oscillator
	thunder.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	thunder.duty = 0.5
	thunder.base_freq = 440.0
	thunder.noise_mix = 0.0
	thunder.noise_tone = 1.0
	thunder.sub_mix = 0.0
	thunder.detune_cents = 0.0
	thunder.detune_mix = 0.0
	thunder.pwm_depth = 0.0
	thunder.pwm_rate = 2.0
	thunder.ring_ratio = 0.0
	thunder.ring_mix = 0.0
	# ---- Pitch motion
	thunder.pitch_sweep_semitones = 0.0
	thunder.pitch_sweep_curve = 1.0
	thunder.vibrato_depth = 0.0
	thunder.vibrato_rate = 6.0
	thunder.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	thunder.vibrato_fade_in = 0.0
	thunder.arpeggio = []
	thunder.arpeggio_rate = 20.0
	thunder.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	thunder.arpeggio_glide = 0.0
	# ---- FM
	thunder.fm_ratio = 0.0
	thunder.fm_depth = 0.0
	thunder.fm_decay = 0.0
	# ---- Amp envelope
	thunder.attack = 0.02  # *
	thunder.decay = 1.4  # *
	thunder.sustain_level = 0.0
	thunder.sustain_time = 0.0
	thunder.release = 0.8  # *
	thunder.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	thunder.tremolo_depth = 0.0
	thunder.tremolo_rate = 6.0
	thunder.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	thunder.repeat_rate = 0.0
	# ---- Filter
	thunder.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	thunder.cutoff = 600.0  # *
	thunder.cutoff_sweep_octaves = -1.5  # *
	thunder.resonance = 0.3  # *
	thunder.filter_lfo_depth = 0.0
	thunder.filter_lfo_rate = 3.0
	thunder.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	thunder.drive = 0.8  # *
	thunder.bit_depth = 16
	thunder.sample_hold = 2  # *
	# ---- Space
	thunder.delay_time = 0.25  # *
	thunder.delay_feedback = 0.45  # *
	thunder.delay_mix = 0.35  # *
	# ---- Output
	thunder.volume_db = -1.0  # *
	thunder.normalize = true
	thunder.sample_rate = 44100
	thunder.loop = false
	thunder.noise_seed = 1
	thunder.condition = &""
	p[&"p_thunder"] = thunder

	var rain_loop := SynthPatch.new()
	# ---- Oscillator
	rain_loop.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	rain_loop.duty = 0.5
	rain_loop.base_freq = 440.0
	rain_loop.noise_mix = 0.0
	rain_loop.noise_tone = 1.0
	rain_loop.sub_mix = 0.0
	rain_loop.detune_cents = 0.0
	rain_loop.detune_mix = 0.0
	rain_loop.pwm_depth = 0.0
	rain_loop.pwm_rate = 2.0
	rain_loop.ring_ratio = 0.0
	rain_loop.ring_mix = 0.0
	# ---- Pitch motion
	rain_loop.pitch_sweep_semitones = 0.0
	rain_loop.pitch_sweep_curve = 1.0
	rain_loop.vibrato_depth = 0.0
	rain_loop.vibrato_rate = 6.0
	rain_loop.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rain_loop.vibrato_fade_in = 0.0
	rain_loop.arpeggio = []
	rain_loop.arpeggio_rate = 20.0
	rain_loop.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	rain_loop.arpeggio_glide = 0.0
	# ---- FM
	rain_loop.fm_ratio = 0.0
	rain_loop.fm_depth = 0.0
	rain_loop.fm_decay = 0.0
	# ---- Amp envelope
	rain_loop.attack = 0.0  # *
	rain_loop.decay = 0.0  # *
	rain_loop.sustain_level = 1.0  # *
	rain_loop.sustain_time = 2.0  # *
	rain_loop.release = 0.0  # *
	rain_loop.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	rain_loop.tremolo_depth = 0.0
	rain_loop.tremolo_rate = 6.0
	rain_loop.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	rain_loop.repeat_rate = 0.0
	# ---- Filter
	rain_loop.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	rain_loop.cutoff = 2500.0  # *
	rain_loop.cutoff_sweep_octaves = 0.0
	rain_loop.resonance = 0.0
	rain_loop.filter_lfo_depth = 0.0
	rain_loop.filter_lfo_rate = 3.0
	rain_loop.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	rain_loop.drive = 0.0
	rain_loop.bit_depth = 16
	rain_loop.sample_hold = 2  # *
	# ---- Space
	rain_loop.delay_time = 0.0
	rain_loop.delay_feedback = 0.4
	rain_loop.delay_mix = 0.0
	# ---- Output
	rain_loop.volume_db = -16.0  # *
	rain_loop.normalize = true
	rain_loop.sample_rate = 44100
	rain_loop.loop = true  # *
	rain_loop.noise_seed = 1
	rain_loop.condition = &""
	p[&"p_rain_loop"] = rain_loop

	var wind_loop := SynthPatch.new()
	# ---- Oscillator
	wind_loop.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wind_loop.duty = 0.5
	wind_loop.base_freq = 440.0
	wind_loop.noise_mix = 0.0
	wind_loop.noise_tone = 1.0
	wind_loop.sub_mix = 0.0
	wind_loop.detune_cents = 0.0
	wind_loop.detune_mix = 0.0
	wind_loop.pwm_depth = 0.0
	wind_loop.pwm_rate = 2.0
	wind_loop.ring_ratio = 0.0
	wind_loop.ring_mix = 0.0
	# ---- Pitch motion
	wind_loop.pitch_sweep_semitones = 0.0
	wind_loop.pitch_sweep_curve = 1.0
	wind_loop.vibrato_depth = 0.0
	wind_loop.vibrato_rate = 6.0
	wind_loop.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wind_loop.vibrato_fade_in = 0.0
	wind_loop.arpeggio = []
	wind_loop.arpeggio_rate = 20.0
	wind_loop.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wind_loop.arpeggio_glide = 0.0
	# ---- FM
	wind_loop.fm_ratio = 0.0
	wind_loop.fm_depth = 0.0
	wind_loop.fm_decay = 0.0
	# ---- Amp envelope
	wind_loop.attack = 0.0  # *
	wind_loop.decay = 0.0  # *
	wind_loop.sustain_level = 1.0  # *
	wind_loop.sustain_time = 3.0  # *
	wind_loop.release = 0.0  # *
	wind_loop.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wind_loop.tremolo_depth = 0.0
	wind_loop.tremolo_rate = 6.0
	wind_loop.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wind_loop.repeat_rate = 0.0
	# ---- Filter
	wind_loop.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wind_loop.cutoff = 500.0  # *
	wind_loop.cutoff_sweep_octaves = 0.0
	wind_loop.resonance = 0.6  # *
	wind_loop.filter_lfo_depth = 0.0
	wind_loop.filter_lfo_rate = 3.0
	wind_loop.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wind_loop.drive = 0.0
	wind_loop.bit_depth = 16
	wind_loop.sample_hold = 1
	# ---- Space
	wind_loop.delay_time = 0.0
	wind_loop.delay_feedback = 0.4
	wind_loop.delay_mix = 0.0
	# ---- Output
	wind_loop.volume_db = -14.0  # *
	wind_loop.normalize = true
	wind_loop.sample_rate = 44100
	wind_loop.loop = true  # *
	wind_loop.noise_seed = 1
	wind_loop.condition = &""
	p[&"p_wind_loop"] = wind_loop

	var bubble := SynthPatch.new()
	# ---- Oscillator
	bubble.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	bubble.duty = 0.5
	bubble.base_freq = 400.0  # *
	bubble.noise_mix = 0.0
	bubble.noise_tone = 1.0
	bubble.sub_mix = 0.0
	bubble.detune_cents = 0.0
	bubble.detune_mix = 0.0
	bubble.pwm_depth = 0.0
	bubble.pwm_rate = 2.0
	bubble.ring_ratio = 0.0
	bubble.ring_mix = 0.0
	# ---- Pitch motion
	bubble.pitch_sweep_semitones = 19.0  # *
	bubble.pitch_sweep_curve = 1.6  # *
	bubble.vibrato_depth = 0.0
	bubble.vibrato_rate = 6.0
	bubble.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	bubble.vibrato_fade_in = 0.0
	bubble.arpeggio = []
	bubble.arpeggio_rate = 20.0
	bubble.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	bubble.arpeggio_glide = 0.0
	# ---- FM
	bubble.fm_ratio = 0.0
	bubble.fm_depth = 0.0
	bubble.fm_decay = 0.0
	# ---- Amp envelope
	bubble.attack = 0.0  # *
	bubble.decay = 0.1  # *
	bubble.sustain_level = 0.0
	bubble.sustain_time = 0.0
	bubble.release = 0.03  # *
	bubble.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	bubble.tremolo_depth = 0.0
	bubble.tremolo_rate = 6.0
	bubble.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	bubble.repeat_rate = 0.0
	# ---- Filter
	bubble.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	bubble.cutoff = 2000.0
	bubble.cutoff_sweep_octaves = 0.0
	bubble.resonance = 0.0
	bubble.filter_lfo_depth = 0.0
	bubble.filter_lfo_rate = 3.0
	bubble.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	bubble.drive = 0.0
	bubble.bit_depth = 16
	bubble.sample_hold = 1
	# ---- Space
	bubble.delay_time = 0.0
	bubble.delay_feedback = 0.4
	bubble.delay_mix = 0.0
	# ---- Output
	bubble.volume_db = -10.0  # *
	bubble.normalize = true
	bubble.sample_rate = 44100
	bubble.loop = false
	bubble.noise_seed = 1
	bubble.condition = &""
	p[&"p_bubble"] = bubble

	var drip := SynthPatch.new()
	# ---- Oscillator
	drip.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	drip.duty = 0.5
	drip.base_freq = 2200.0  # *
	drip.noise_mix = 0.0
	drip.noise_tone = 1.0
	drip.sub_mix = 0.0
	drip.detune_cents = 0.0
	drip.detune_mix = 0.0
	drip.pwm_depth = 0.0
	drip.pwm_rate = 2.0
	drip.ring_ratio = 0.0
	drip.ring_mix = 0.0
	# ---- Pitch motion
	drip.pitch_sweep_semitones = -14.0  # *
	drip.pitch_sweep_curve = 0.3  # *
	drip.vibrato_depth = 0.0
	drip.vibrato_rate = 6.0
	drip.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	drip.vibrato_fade_in = 0.0
	drip.arpeggio = []
	drip.arpeggio_rate = 20.0
	drip.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	drip.arpeggio_glide = 0.0
	# ---- FM
	drip.fm_ratio = 0.0
	drip.fm_depth = 0.0
	drip.fm_decay = 0.0
	# ---- Amp envelope
	drip.attack = 0.0  # *
	drip.decay = 0.09  # *
	drip.sustain_level = 0.0
	drip.sustain_time = 0.0
	drip.release = 0.04  # *
	drip.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	drip.tremolo_depth = 0.0
	drip.tremolo_rate = 6.0
	drip.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	drip.repeat_rate = 0.0
	# ---- Filter
	drip.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	drip.cutoff = 2000.0
	drip.cutoff_sweep_octaves = 0.0
	drip.resonance = 0.0
	drip.filter_lfo_depth = 0.0
	drip.filter_lfo_rate = 3.0
	drip.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	drip.drive = 0.0
	drip.bit_depth = 16
	drip.sample_hold = 1
	# ---- Space
	drip.delay_time = 0.18  # *
	drip.delay_feedback = 0.45  # *
	drip.delay_mix = 0.4  # *
	# ---- Output
	drip.volume_db = -12.0  # *
	drip.normalize = true
	drip.sample_rate = 44100
	drip.loop = false
	drip.noise_seed = 1
	drip.condition = &""
	p[&"p_drip"] = drip

	var splash := SynthPatch.new()
	# ---- Oscillator
	splash.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	splash.duty = 0.5
	splash.base_freq = 440.0
	splash.noise_mix = 0.0
	splash.noise_tone = 1.0
	splash.sub_mix = 0.0
	splash.detune_cents = 0.0
	splash.detune_mix = 0.0
	splash.pwm_depth = 0.0
	splash.pwm_rate = 2.0
	splash.ring_ratio = 0.0
	splash.ring_mix = 0.0
	# ---- Pitch motion
	splash.pitch_sweep_semitones = 0.0
	splash.pitch_sweep_curve = 1.0
	splash.vibrato_depth = 0.0
	splash.vibrato_rate = 6.0
	splash.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	splash.vibrato_fade_in = 0.0
	splash.arpeggio = []
	splash.arpeggio_rate = 20.0
	splash.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	splash.arpeggio_glide = 0.0
	# ---- FM
	splash.fm_ratio = 0.0
	splash.fm_depth = 0.0
	splash.fm_decay = 0.0
	# ---- Amp envelope
	splash.attack = 0.01  # *
	splash.decay = 0.35  # *
	splash.sustain_level = 0.0
	splash.sustain_time = 0.0
	splash.release = 0.2  # *
	splash.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	splash.tremolo_depth = 0.0
	splash.tremolo_rate = 6.0
	splash.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	splash.repeat_rate = 0.0
	# ---- Filter
	splash.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	splash.cutoff = 1800.0  # *
	splash.cutoff_sweep_octaves = -1.5  # *
	splash.resonance = 0.3  # *
	splash.filter_lfo_depth = 0.0
	splash.filter_lfo_rate = 3.0
	splash.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	splash.drive = 0.0
	splash.bit_depth = 16
	splash.sample_hold = 2  # *
	# ---- Space
	splash.delay_time = 0.0
	splash.delay_feedback = 0.4
	splash.delay_mix = 0.0
	# ---- Output
	splash.volume_db = -6.0  # *
	splash.normalize = true
	splash.sample_rate = 44100
	splash.loop = false
	splash.noise_seed = 1
	splash.condition = &""
	p[&"p_splash"] = splash

	var growl := SynthPatch.new()
	# ---- Oscillator
	growl.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	growl.duty = 0.5
	growl.base_freq = 60.0  # *
	growl.noise_mix = 0.3  # *
	growl.noise_tone = 1.0
	growl.sub_mix = 0.0
	growl.detune_cents = 0.0
	growl.detune_mix = 0.0
	growl.pwm_depth = 0.0
	growl.pwm_rate = 2.0
	growl.ring_ratio = 0.0
	growl.ring_mix = 0.0
	# ---- Pitch motion
	growl.pitch_sweep_semitones = -5.0  # *
	growl.pitch_sweep_curve = 1.0
	growl.vibrato_depth = 3.0  # *
	growl.vibrato_rate = 11.0  # *
	growl.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	growl.vibrato_fade_in = 0.0
	growl.arpeggio = []
	growl.arpeggio_rate = 20.0
	growl.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	growl.arpeggio_glide = 0.0
	# ---- FM
	growl.fm_ratio = 0.0
	growl.fm_depth = 0.0
	growl.fm_decay = 0.0
	# ---- Amp envelope
	growl.attack = 0.05  # *
	growl.decay = 0.2  # *
	growl.sustain_level = 0.7  # *
	growl.sustain_time = 0.4  # *
	growl.release = 0.3  # *
	growl.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	growl.tremolo_depth = 0.0
	growl.tremolo_rate = 6.0
	growl.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	growl.repeat_rate = 0.0
	# ---- Filter
	growl.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	growl.cutoff = 900.0  # *
	growl.cutoff_sweep_octaves = -1.0  # *
	growl.resonance = 0.5  # *
	growl.filter_lfo_depth = 0.0
	growl.filter_lfo_rate = 3.0
	growl.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	growl.drive = 0.7  # *
	growl.bit_depth = 16
	growl.sample_hold = 3  # *
	# ---- Space
	growl.delay_time = 0.0
	growl.delay_feedback = 0.4
	growl.delay_mix = 0.0
	# ---- Output
	growl.volume_db = -4.0  # *
	growl.normalize = true
	growl.sample_rate = 44100
	growl.loop = false
	growl.noise_seed = 1
	growl.condition = &""
	p[&"p_growl"] = growl

	var roar := SynthPatch.new()
	# ---- Oscillator
	roar.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	roar.duty = 0.5
	roar.base_freq = 110.0  # *
	roar.noise_mix = 0.45  # *
	roar.noise_tone = 1.0
	roar.sub_mix = 0.0
	roar.detune_cents = 0.0
	roar.detune_mix = 0.0
	roar.pwm_depth = 0.0
	roar.pwm_rate = 2.0
	roar.ring_ratio = 0.0
	roar.ring_mix = 0.0
	# ---- Pitch motion
	roar.pitch_sweep_semitones = 7.0  # *
	roar.pitch_sweep_curve = 0.5  # *
	roar.vibrato_depth = 2.0  # *
	roar.vibrato_rate = 7.0  # *
	roar.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	roar.vibrato_fade_in = 0.0
	roar.arpeggio = []
	roar.arpeggio_rate = 20.0
	roar.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	roar.arpeggio_glide = 0.0
	# ---- FM
	roar.fm_ratio = 0.0
	roar.fm_depth = 0.0
	roar.fm_decay = 0.0
	# ---- Amp envelope
	roar.attack = 0.08  # *
	roar.decay = 0.3  # *
	roar.sustain_level = 0.8  # *
	roar.sustain_time = 0.5  # *
	roar.release = 0.5  # *
	roar.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	roar.tremolo_depth = 0.0
	roar.tremolo_rate = 6.0
	roar.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	roar.repeat_rate = 0.0
	# ---- Filter
	roar.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	roar.cutoff = 700.0  # *
	roar.cutoff_sweep_octaves = 1.0  # *
	roar.resonance = 0.4  # *
	roar.filter_lfo_depth = 0.0
	roar.filter_lfo_rate = 3.0
	roar.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	roar.drive = 0.9  # *
	roar.bit_depth = 16
	roar.sample_hold = 1
	# ---- Space
	roar.delay_time = 0.15  # *
	roar.delay_feedback = 0.4
	roar.delay_mix = 0.3  # *
	# ---- Output
	roar.volume_db = -2.0  # *
	roar.normalize = true
	roar.sample_rate = 44100
	roar.loop = false
	roar.noise_seed = 1
	roar.condition = &""
	p[&"p_roar"] = roar

	var space_gull := SynthPatch.new()
	# ---- Oscillator
	space_gull.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	space_gull.duty = 0.5
	space_gull.base_freq = 1500.0  # *
	space_gull.noise_mix = 0.0
	space_gull.noise_tone = 1.0
	space_gull.sub_mix = 0.0
	space_gull.detune_cents = 0.0
	space_gull.detune_mix = 0.0
	space_gull.pwm_depth = 0.0
	space_gull.pwm_rate = 2.0
	space_gull.ring_ratio = 0.0
	space_gull.ring_mix = 0.0
	# ---- Pitch motion
	space_gull.pitch_sweep_semitones = 9.0  # *
	space_gull.pitch_sweep_curve = 0.5  # *
	space_gull.vibrato_depth = 2.5  # *
	space_gull.vibrato_rate = 20.0  # *
	space_gull.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	space_gull.vibrato_fade_in = 0.0
	space_gull.arpeggio = []
	space_gull.arpeggio_rate = 20.0
	space_gull.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	space_gull.arpeggio_glide = 0.0
	# ---- FM
	space_gull.fm_ratio = 1.0  # *
	space_gull.fm_depth = 1.2  # *
	space_gull.fm_decay = 0.0
	# ---- Amp envelope
	space_gull.attack = 0.03  # *
	space_gull.decay = 0.15
	space_gull.sustain_level = 0.6  # *
	space_gull.sustain_time = 0.15  # *
	space_gull.release = 0.15  # *
	space_gull.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	space_gull.tremolo_depth = 0.0
	space_gull.tremolo_rate = 6.0
	space_gull.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	space_gull.repeat_rate = 0.0
	# ---- Filter
	space_gull.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	space_gull.cutoff = 2000.0
	space_gull.cutoff_sweep_octaves = 0.0
	space_gull.resonance = 0.0
	space_gull.filter_lfo_depth = 0.0
	space_gull.filter_lfo_rate = 3.0
	space_gull.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	space_gull.drive = 0.0
	space_gull.bit_depth = 16
	space_gull.sample_hold = 1
	# ---- Space
	space_gull.delay_time = 0.3  # *
	space_gull.delay_feedback = 0.3  # *
	space_gull.delay_mix = 0.25  # *
	# ---- Output
	space_gull.volume_db = -12.0  # *
	space_gull.normalize = true
	space_gull.sample_rate = 44100
	space_gull.loop = false
	space_gull.noise_seed = 1
	space_gull.condition = &""
	p[&"p_space_gull"] = space_gull

	var anchor_drop := SynthPatch.new()
	# ---- Oscillator
	anchor_drop.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	anchor_drop.duty = 0.5
	anchor_drop.base_freq = 160.0  # *
	anchor_drop.noise_mix = 0.35  # *
	anchor_drop.noise_tone = 1.0
	anchor_drop.sub_mix = 0.0
	anchor_drop.detune_cents = 0.0
	anchor_drop.detune_mix = 0.0
	anchor_drop.pwm_depth = 0.0
	anchor_drop.pwm_rate = 2.0
	anchor_drop.ring_ratio = 0.0
	anchor_drop.ring_mix = 0.0
	# ---- Pitch motion
	anchor_drop.pitch_sweep_semitones = -12.0  # *
	anchor_drop.pitch_sweep_curve = 0.3  # *
	anchor_drop.vibrato_depth = 0.0
	anchor_drop.vibrato_rate = 6.0
	anchor_drop.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	anchor_drop.vibrato_fade_in = 0.0
	anchor_drop.arpeggio = []
	anchor_drop.arpeggio_rate = 20.0
	anchor_drop.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	anchor_drop.arpeggio_glide = 0.0
	# ---- FM
	anchor_drop.fm_ratio = 2.41  # *
	anchor_drop.fm_depth = 6.0  # *
	anchor_drop.fm_decay = 0.3  # *
	# ---- Amp envelope
	anchor_drop.attack = 0.0  # *
	anchor_drop.decay = 0.8  # *
	anchor_drop.sustain_level = 0.0
	anchor_drop.sustain_time = 0.0
	anchor_drop.release = 0.4  # *
	anchor_drop.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	anchor_drop.tremolo_depth = 0.0
	anchor_drop.tremolo_rate = 6.0
	anchor_drop.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	anchor_drop.repeat_rate = 0.0
	# ---- Filter
	anchor_drop.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	anchor_drop.cutoff = 2500.0  # *
	anchor_drop.cutoff_sweep_octaves = -2.0  # *
	anchor_drop.resonance = 0.0
	anchor_drop.filter_lfo_depth = 0.0
	anchor_drop.filter_lfo_rate = 3.0
	anchor_drop.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	anchor_drop.drive = 0.6  # *
	anchor_drop.bit_depth = 16
	anchor_drop.sample_hold = 1
	# ---- Space
	anchor_drop.delay_time = 0.12  # *
	anchor_drop.delay_feedback = 0.4
	anchor_drop.delay_mix = 0.3  # *
	# ---- Output
	anchor_drop.volume_db = -2.0  # *
	anchor_drop.normalize = true
	anchor_drop.sample_rate = 44100
	anchor_drop.loop = false
	anchor_drop.noise_seed = 1
	anchor_drop.condition = &""
	p[&"p_anchor_drop"] = anchor_drop

	var sail_flap := SynthPatch.new()
	# ---- Oscillator
	sail_flap.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	sail_flap.duty = 0.5
	sail_flap.base_freq = 440.0
	sail_flap.noise_mix = 0.0
	sail_flap.noise_tone = 1.0
	sail_flap.sub_mix = 0.0
	sail_flap.detune_cents = 0.0
	sail_flap.detune_mix = 0.0
	sail_flap.pwm_depth = 0.0
	sail_flap.pwm_rate = 2.0
	sail_flap.ring_ratio = 0.0
	sail_flap.ring_mix = 0.0
	# ---- Pitch motion
	sail_flap.pitch_sweep_semitones = 0.0
	sail_flap.pitch_sweep_curve = 1.0
	sail_flap.vibrato_depth = 0.0
	sail_flap.vibrato_rate = 6.0
	sail_flap.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	sail_flap.vibrato_fade_in = 0.0
	sail_flap.arpeggio = []
	sail_flap.arpeggio_rate = 20.0
	sail_flap.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	sail_flap.arpeggio_glide = 0.0
	# ---- FM
	sail_flap.fm_ratio = 0.0
	sail_flap.fm_depth = 0.0
	sail_flap.fm_decay = 0.0
	# ---- Amp envelope
	sail_flap.attack = 0.02  # *
	sail_flap.decay = 0.1  # *
	sail_flap.sustain_level = 0.0
	sail_flap.sustain_time = 0.0
	sail_flap.release = 0.06  # *
	sail_flap.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	sail_flap.tremolo_depth = 0.0
	sail_flap.tremolo_rate = 6.0
	sail_flap.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	sail_flap.repeat_rate = 0.0
	# ---- Filter
	sail_flap.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	sail_flap.cutoff = 300.0  # *
	sail_flap.cutoff_sweep_octaves = 1.5  # *
	sail_flap.resonance = 0.5  # *
	sail_flap.filter_lfo_depth = 0.0
	sail_flap.filter_lfo_rate = 3.0
	sail_flap.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	sail_flap.drive = 0.0
	sail_flap.bit_depth = 16
	sail_flap.sample_hold = 2  # *
	# ---- Space
	sail_flap.delay_time = 0.09  # *
	sail_flap.delay_feedback = 0.3  # *
	sail_flap.delay_mix = 0.4  # *
	# ---- Output
	sail_flap.volume_db = -8.0  # *
	sail_flap.normalize = true
	sail_flap.sample_rate = 44100
	sail_flap.loop = false
	sail_flap.noise_seed = 1
	sail_flap.condition = &""
	p[&"p_sail_flap"] = sail_flap

	var static_crackle := SynthPatch.new()
	# ---- Oscillator
	static_crackle.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	static_crackle.duty = 0.5
	static_crackle.base_freq = 440.0
	static_crackle.noise_mix = 0.0
	static_crackle.noise_tone = 1.0
	static_crackle.sub_mix = 0.0
	static_crackle.detune_cents = 0.0
	static_crackle.detune_mix = 0.0
	static_crackle.pwm_depth = 0.0
	static_crackle.pwm_rate = 2.0
	static_crackle.ring_ratio = 0.0
	static_crackle.ring_mix = 0.0
	# ---- Pitch motion
	static_crackle.pitch_sweep_semitones = 0.0
	static_crackle.pitch_sweep_curve = 1.0
	static_crackle.vibrato_depth = 0.0
	static_crackle.vibrato_rate = 6.0
	static_crackle.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	static_crackle.vibrato_fade_in = 0.0
	static_crackle.arpeggio = []
	static_crackle.arpeggio_rate = 20.0
	static_crackle.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	static_crackle.arpeggio_glide = 0.0
	# ---- FM
	static_crackle.fm_ratio = 0.0
	static_crackle.fm_depth = 0.0
	static_crackle.fm_decay = 0.0
	# ---- Amp envelope
	static_crackle.attack = 0.0  # *
	static_crackle.decay = 0.3  # *
	static_crackle.sustain_level = 0.0
	static_crackle.sustain_time = 0.0
	static_crackle.release = 0.1  # *
	static_crackle.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	static_crackle.tremolo_depth = 0.0
	static_crackle.tremolo_rate = 6.0
	static_crackle.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	static_crackle.repeat_rate = 0.0
	# ---- Filter
	static_crackle.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	static_crackle.cutoff = 1500.0  # *
	static_crackle.cutoff_sweep_octaves = 0.0
	static_crackle.resonance = 0.0
	static_crackle.filter_lfo_depth = 0.0
	static_crackle.filter_lfo_rate = 3.0
	static_crackle.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	static_crackle.drive = 0.0
	static_crackle.bit_depth = 4  # *
	static_crackle.sample_hold = 6  # *
	# ---- Space
	static_crackle.delay_time = 0.0
	static_crackle.delay_feedback = 0.4
	static_crackle.delay_mix = 0.0
	# ---- Output
	static_crackle.volume_db = -12.0  # *
	static_crackle.normalize = true
	static_crackle.sample_rate = 44100
	static_crackle.loop = false
	static_crackle.noise_seed = 1
	static_crackle.condition = &""
	p[&"p_static_crackle"] = static_crackle

	var hover_hum := SynthPatch.new()
	# ---- Oscillator
	hover_hum.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	hover_hum.duty = 0.5
	hover_hum.base_freq = 82.0  # *
	hover_hum.noise_mix = 0.0
	hover_hum.noise_tone = 1.0
	hover_hum.sub_mix = 0.0
	hover_hum.detune_cents = 0.0
	hover_hum.detune_mix = 0.0
	hover_hum.pwm_depth = 0.0
	hover_hum.pwm_rate = 2.0
	hover_hum.ring_ratio = 0.0
	hover_hum.ring_mix = 0.0
	# ---- Pitch motion
	hover_hum.pitch_sweep_semitones = 0.0
	hover_hum.pitch_sweep_curve = 1.0
	hover_hum.vibrato_depth = 0.1  # *
	hover_hum.vibrato_rate = 0.7  # *
	hover_hum.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hover_hum.vibrato_fade_in = 0.0
	hover_hum.arpeggio = []
	hover_hum.arpeggio_rate = 20.0
	hover_hum.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	hover_hum.arpeggio_glide = 0.0
	# ---- FM
	hover_hum.fm_ratio = 2.0  # *
	hover_hum.fm_depth = 0.6  # *
	hover_hum.fm_decay = 0.0
	# ---- Amp envelope
	hover_hum.attack = 0.0  # *
	hover_hum.decay = 0.0  # *
	hover_hum.sustain_level = 1.0  # *
	hover_hum.sustain_time = 2.0  # *
	hover_hum.release = 0.0  # *
	hover_hum.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	hover_hum.tremolo_depth = 0.0
	hover_hum.tremolo_rate = 6.0
	hover_hum.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hover_hum.repeat_rate = 0.0
	# ---- Filter
	hover_hum.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	hover_hum.cutoff = 500.0  # *
	hover_hum.cutoff_sweep_octaves = 0.0
	hover_hum.resonance = 0.3  # *
	hover_hum.filter_lfo_depth = 0.0
	hover_hum.filter_lfo_rate = 3.0
	hover_hum.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	hover_hum.drive = 0.0
	hover_hum.bit_depth = 16
	hover_hum.sample_hold = 1
	# ---- Space
	hover_hum.delay_time = 0.0
	hover_hum.delay_feedback = 0.4
	hover_hum.delay_mix = 0.0
	# ---- Output
	hover_hum.volume_db = -16.0  # *
	hover_hum.normalize = true
	hover_hum.sample_rate = 44100
	hover_hum.loop = true  # *
	hover_hum.noise_seed = 1
	hover_hum.condition = &""
	p[&"p_hover_hum"] = hover_hum

	var sparkle := SynthPatch.new()
	# ---- Oscillator
	sparkle.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	sparkle.duty = 0.5
	sparkle.base_freq = 2093.0  # *
	sparkle.noise_mix = 0.0
	sparkle.noise_tone = 1.0
	sparkle.sub_mix = 0.0
	sparkle.detune_cents = 0.0
	sparkle.detune_mix = 0.0
	sparkle.pwm_depth = 0.0
	sparkle.pwm_rate = 2.0
	sparkle.ring_ratio = 0.0
	sparkle.ring_mix = 0.0
	# ---- Pitch motion
	sparkle.pitch_sweep_semitones = 0.0
	sparkle.pitch_sweep_curve = 1.0
	sparkle.vibrato_depth = 0.0
	sparkle.vibrato_rate = 6.0
	sparkle.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	sparkle.vibrato_fade_in = 0.0
	sparkle.arpeggio = [0, 7, 4, 12, 2, 9, 5, 14]  # *
	sparkle.arpeggio_rate = 45.0  # *
	sparkle.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	sparkle.arpeggio_glide = 0.0
	# ---- FM
	sparkle.fm_ratio = 3.0  # *
	sparkle.fm_depth = 1.0  # *
	sparkle.fm_decay = 0.05  # *
	# ---- Amp envelope
	sparkle.attack = 0.0  # *
	sparkle.decay = 0.25  # *
	sparkle.sustain_level = 0.0
	sparkle.sustain_time = 0.0
	sparkle.release = 0.15  # *
	sparkle.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	sparkle.tremolo_depth = 0.0
	sparkle.tremolo_rate = 6.0
	sparkle.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	sparkle.repeat_rate = 0.0
	# ---- Filter
	sparkle.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	sparkle.cutoff = 2000.0
	sparkle.cutoff_sweep_octaves = 0.0
	sparkle.resonance = 0.0
	sparkle.filter_lfo_depth = 0.0
	sparkle.filter_lfo_rate = 3.0
	sparkle.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	sparkle.drive = 0.0
	sparkle.bit_depth = 16
	sparkle.sample_hold = 1
	# ---- Space
	sparkle.delay_time = 0.08  # *
	sparkle.delay_feedback = 0.5  # *
	sparkle.delay_mix = 0.4  # *
	# ---- Output
	sparkle.volume_db = -12.0  # *
	sparkle.normalize = true
	sparkle.sample_rate = 44100
	sparkle.loop = false
	sparkle.noise_seed = 1
	sparkle.condition = &""
	p[&"p_sparkle"] = sparkle

	var low_drone := SynthPatch.new()
	# ---- Oscillator
	low_drone.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	low_drone.duty = 0.5
	low_drone.base_freq = 41.2  # *
	low_drone.noise_mix = 0.1  # *
	low_drone.noise_tone = 1.0
	low_drone.sub_mix = 0.0
	low_drone.detune_cents = 0.0
	low_drone.detune_mix = 0.0
	low_drone.pwm_depth = 0.0
	low_drone.pwm_rate = 2.0
	low_drone.ring_ratio = 0.0
	low_drone.ring_mix = 0.0
	# ---- Pitch motion
	low_drone.pitch_sweep_semitones = 0.0
	low_drone.pitch_sweep_curve = 1.0
	low_drone.vibrato_depth = 0.1  # *
	low_drone.vibrato_rate = 0.4  # *
	low_drone.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	low_drone.vibrato_fade_in = 0.0
	low_drone.arpeggio = []
	low_drone.arpeggio_rate = 20.0
	low_drone.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	low_drone.arpeggio_glide = 0.0
	# ---- FM
	low_drone.fm_ratio = 0.0
	low_drone.fm_depth = 0.0
	low_drone.fm_decay = 0.0
	# ---- Amp envelope
	low_drone.attack = 0.0  # *
	low_drone.decay = 0.0  # *
	low_drone.sustain_level = 1.0  # *
	low_drone.sustain_time = 3.0  # *
	low_drone.release = 0.0  # *
	low_drone.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	low_drone.tremolo_depth = 0.0
	low_drone.tremolo_rate = 6.0
	low_drone.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	low_drone.repeat_rate = 0.0
	# ---- Filter
	low_drone.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	low_drone.cutoff = 180.0  # *
	low_drone.cutoff_sweep_octaves = 0.0
	low_drone.resonance = 0.5  # *
	low_drone.filter_lfo_depth = 0.0
	low_drone.filter_lfo_rate = 3.0
	low_drone.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	low_drone.drive = 0.0
	low_drone.bit_depth = 16
	low_drone.sample_hold = 1
	# ---- Space
	low_drone.delay_time = 0.0
	low_drone.delay_feedback = 0.4
	low_drone.delay_mix = 0.0
	# ---- Output
	low_drone.volume_db = -14.0  # *
	low_drone.normalize = true
	low_drone.sample_rate = 44100
	low_drone.loop = true  # *
	low_drone.noise_seed = 1
	low_drone.condition = &""
	p[&"p_low_drone"] = low_drone

	# ================================================= Music instruments (for .pattern files)
	# Baked by PatternBaker into song layers at the song's tempo; see README section 7.
	var kick := SynthPatch.new()
	# ---- Oscillator
	kick.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	kick.duty = 0.5
	kick.base_freq = 150.0  # *
	kick.noise_mix = 0.0
	kick.noise_tone = 1.0
	kick.sub_mix = 0.0
	kick.detune_cents = 0.0
	kick.detune_mix = 0.0
	kick.pwm_depth = 0.0
	kick.pwm_rate = 2.0
	kick.ring_ratio = 0.0
	kick.ring_mix = 0.0
	# ---- Pitch motion
	kick.pitch_sweep_semitones = -26.0  # *
	kick.pitch_sweep_curve = 0.3  # *
	kick.vibrato_depth = 0.0
	kick.vibrato_rate = 6.0
	kick.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	kick.vibrato_fade_in = 0.0
	kick.arpeggio = []
	kick.arpeggio_rate = 20.0
	kick.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	kick.arpeggio_glide = 0.0
	# ---- FM
	kick.fm_ratio = 0.0
	kick.fm_depth = 0.0
	kick.fm_decay = 0.0
	# ---- Amp envelope
	kick.attack = 0.0  # *
	kick.decay = 0.28  # *
	kick.sustain_level = 0.0
	kick.sustain_time = 0.0
	kick.release = 0.05
	kick.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	kick.tremolo_depth = 0.0
	kick.tremolo_rate = 6.0
	kick.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	kick.repeat_rate = 0.0
	# ---- Filter
	kick.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	kick.cutoff = 2000.0
	kick.cutoff_sweep_octaves = 0.0
	kick.resonance = 0.0
	kick.filter_lfo_depth = 0.0
	kick.filter_lfo_rate = 3.0
	kick.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	kick.drive = 0.35  # *
	kick.bit_depth = 16
	kick.sample_hold = 1
	# ---- Space
	kick.delay_time = 0.0
	kick.delay_feedback = 0.4
	kick.delay_mix = 0.0
	# ---- Output
	kick.volume_db = 0.0
	kick.normalize = true
	kick.sample_rate = 44100
	kick.loop = false
	kick.noise_seed = 1
	kick.condition = &""
	p[&"p_inst_kick"] = kick

	var hat := SynthPatch.new()
	# ---- Oscillator
	hat.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	hat.duty = 0.5
	hat.base_freq = 440.0
	hat.noise_mix = 0.0
	hat.noise_tone = 1.0
	hat.sub_mix = 0.0
	hat.detune_cents = 0.0
	hat.detune_mix = 0.0
	hat.pwm_depth = 0.0
	hat.pwm_rate = 2.0
	hat.ring_ratio = 0.0
	hat.ring_mix = 0.0
	# ---- Pitch motion
	hat.pitch_sweep_semitones = 0.0
	hat.pitch_sweep_curve = 1.0
	hat.vibrato_depth = 0.0
	hat.vibrato_rate = 6.0
	hat.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hat.vibrato_fade_in = 0.0
	hat.arpeggio = []
	hat.arpeggio_rate = 20.0
	hat.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	hat.arpeggio_glide = 0.0
	# ---- FM
	hat.fm_ratio = 0.0
	hat.fm_depth = 0.0
	hat.fm_decay = 0.0
	# ---- Amp envelope
	hat.attack = 0.0  # *
	hat.decay = 0.05  # *
	hat.sustain_level = 0.0
	hat.sustain_time = 0.0
	hat.release = 0.02  # *
	hat.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	hat.tremolo_depth = 0.0
	hat.tremolo_rate = 6.0
	hat.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	hat.repeat_rate = 0.0
	# ---- Filter
	hat.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	hat.cutoff = 7000.0  # *
	hat.cutoff_sweep_octaves = 0.0
	hat.resonance = 0.0
	hat.filter_lfo_depth = 0.0
	hat.filter_lfo_rate = 3.0
	hat.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	hat.drive = 0.0
	hat.bit_depth = 16
	hat.sample_hold = 1
	# ---- Space
	hat.delay_time = 0.0
	hat.delay_feedback = 0.4
	hat.delay_mix = 0.0
	# ---- Output
	hat.volume_db = -14.0  # *
	hat.normalize = true
	hat.sample_rate = 44100
	hat.loop = false
	hat.noise_seed = 1
	hat.condition = &""
	p[&"p_inst_hat"] = hat

	var bass := SynthPatch.new()
	# ---- Oscillator
	bass.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	bass.duty = 0.5
	bass.base_freq = 73.42  # *
	bass.noise_mix = 0.0
	bass.noise_tone = 1.0
	bass.sub_mix = 0.0
	bass.detune_cents = 0.0
	bass.detune_mix = 0.0
	bass.pwm_depth = 0.0
	bass.pwm_rate = 2.0
	bass.ring_ratio = 0.0
	bass.ring_mix = 0.0
	# ---- Pitch motion
	bass.pitch_sweep_semitones = 0.0
	bass.pitch_sweep_curve = 1.0
	bass.vibrato_depth = 0.0
	bass.vibrato_rate = 6.0
	bass.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	bass.vibrato_fade_in = 0.0
	bass.arpeggio = []
	bass.arpeggio_rate = 20.0
	bass.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	bass.arpeggio_glide = 0.0
	# ---- FM
	bass.fm_ratio = 0.0
	bass.fm_depth = 0.0
	bass.fm_decay = 0.0
	# ---- Amp envelope
	bass.attack = 0.005
	bass.decay = 0.2  # *
	bass.sustain_level = 0.5  # *
	bass.sustain_time = 0.1  # *
	bass.release = 0.08  # *
	bass.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	bass.tremolo_depth = 0.0
	bass.tremolo_rate = 6.0
	bass.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	bass.repeat_rate = 0.0
	# ---- Filter
	bass.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	bass.cutoff = 900.0  # *
	bass.cutoff_sweep_octaves = -1.5  # *
	bass.resonance = 0.4  # *
	bass.filter_lfo_depth = 0.0
	bass.filter_lfo_rate = 3.0
	bass.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	bass.drive = 0.2  # *
	bass.bit_depth = 16
	bass.sample_hold = 1
	# ---- Space
	bass.delay_time = 0.0
	bass.delay_feedback = 0.4
	bass.delay_mix = 0.0
	# ---- Output
	bass.volume_db = -6.0  # *
	bass.normalize = true
	bass.sample_rate = 44100
	bass.loop = false
	bass.noise_seed = 1
	bass.condition = &""
	p[&"p_inst_bass"] = bass

	var pluck := SynthPatch.new()
	# ---- Oscillator
	pluck.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	pluck.duty = 0.5
	pluck.base_freq = 293.66  # *
	pluck.noise_mix = 0.0
	pluck.noise_tone = 1.0
	pluck.sub_mix = 0.0
	pluck.detune_cents = 0.0
	pluck.detune_mix = 0.0
	pluck.pwm_depth = 0.0
	pluck.pwm_rate = 2.0
	pluck.ring_ratio = 0.0
	pluck.ring_mix = 0.0
	# ---- Pitch motion
	pluck.pitch_sweep_semitones = 0.0
	pluck.pitch_sweep_curve = 1.0
	pluck.vibrato_depth = 0.0
	pluck.vibrato_rate = 6.0
	pluck.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pluck.vibrato_fade_in = 0.0
	pluck.arpeggio = []
	pluck.arpeggio_rate = 20.0
	pluck.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pluck.arpeggio_glide = 0.0
	# ---- FM
	pluck.fm_ratio = 2.0  # *
	pluck.fm_depth = 2.2  # *
	pluck.fm_decay = 0.12  # *
	# ---- Amp envelope
	pluck.attack = 0.002  # *
	pluck.decay = 0.25  # *
	pluck.sustain_level = 0.0
	pluck.sustain_time = 0.0
	pluck.release = 0.05
	pluck.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pluck.tremolo_depth = 0.0
	pluck.tremolo_rate = 6.0
	pluck.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pluck.repeat_rate = 0.0
	# ---- Filter
	pluck.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	pluck.cutoff = 2000.0
	pluck.cutoff_sweep_octaves = 0.0
	pluck.resonance = 0.0
	pluck.filter_lfo_depth = 0.0
	pluck.filter_lfo_rate = 3.0
	pluck.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pluck.drive = 0.0
	pluck.bit_depth = 16
	pluck.sample_hold = 1
	# ---- Space
	pluck.delay_time = 0.2727  # *
	pluck.delay_feedback = 0.35  # *
	pluck.delay_mix = 0.3  # *
	# ---- Output
	pluck.volume_db = -12.0  # *
	pluck.normalize = true
	pluck.sample_rate = 44100
	pluck.loop = false
	pluck.noise_seed = 1
	pluck.condition = &""
	p[&"p_inst_pluck"] = pluck

	var pad := SynthPatch.new()
	# ---- Oscillator
	pad.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	pad.duty = 0.5
	pad.base_freq = 146.83  # *
	pad.noise_mix = 0.0
	pad.noise_tone = 1.0
	pad.sub_mix = 0.0
	pad.detune_cents = 0.0
	pad.detune_mix = 0.0
	pad.pwm_depth = 0.0
	pad.pwm_rate = 2.0
	pad.ring_ratio = 0.0
	pad.ring_mix = 0.0
	# ---- Pitch motion
	pad.pitch_sweep_semitones = 0.0
	pad.pitch_sweep_curve = 1.0
	pad.vibrato_depth = 0.15  # *
	pad.vibrato_rate = 4.0  # *
	pad.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pad.vibrato_fade_in = 0.0
	pad.arpeggio = []
	pad.arpeggio_rate = 20.0
	pad.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pad.arpeggio_glide = 0.0
	# ---- FM
	pad.fm_ratio = 0.0
	pad.fm_depth = 0.0
	pad.fm_decay = 0.0
	# ---- Amp envelope
	pad.attack = 0.4  # *
	pad.decay = 0.3  # *
	pad.sustain_level = 0.7  # *
	pad.sustain_time = 1.4  # *
	pad.release = 0.5  # *
	pad.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pad.tremolo_depth = 0.0
	pad.tremolo_rate = 6.0
	pad.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pad.repeat_rate = 0.0
	# ---- Filter
	pad.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	pad.cutoff = 600.0  # *
	pad.cutoff_sweep_octaves = 1.0  # *
	pad.resonance = 0.2  # *
	pad.filter_lfo_depth = 0.0
	pad.filter_lfo_rate = 3.0
	pad.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pad.drive = 0.0
	pad.bit_depth = 16
	pad.sample_hold = 1
	# ---- Space
	pad.delay_time = 0.0
	pad.delay_feedback = 0.4
	pad.delay_mix = 0.0
	# ---- Output
	pad.volume_db = -18.0  # *
	pad.normalize = true
	pad.sample_rate = 44100
	pad.loop = false
	pad.noise_seed = 1
	pad.condition = &""
	p[&"p_inst_pad"] = pad


	# ======================================================== Modulation showcase
	# Each of these exists to demonstrate one knob nothing else uses, named in its first comment.
	# Copy the one whose knob you want and bend it to your purpose.

	var trill := SynthPatch.new()  # showcases: vibrato_shape SQUARE (a trill between two notes)
	# ---- Oscillator
	trill.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	trill.duty = 0.4  # *
	trill.base_freq = 880.0  # *
	trill.noise_mix = 0.0
	trill.noise_tone = 1.0
	trill.sub_mix = 0.0
	trill.detune_cents = 0.0
	trill.detune_mix = 0.0
	trill.pwm_depth = 0.0
	trill.pwm_rate = 2.0
	trill.ring_ratio = 0.0
	trill.ring_mix = 0.0
	# ---- Pitch motion
	trill.pitch_sweep_semitones = 0.0
	trill.pitch_sweep_curve = 1.0
	trill.vibrato_depth = 2.0  # *
	trill.vibrato_rate = 12.0  # *
	trill.vibrato_shape = SynthPatch.LfoShape.SQUARE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	trill.vibrato_fade_in = 0.0
	trill.arpeggio = []
	trill.arpeggio_rate = 20.0
	trill.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	trill.arpeggio_glide = 0.0
	# ---- FM
	trill.fm_ratio = 0.0
	trill.fm_depth = 0.0
	trill.fm_decay = 0.0
	# ---- Amp envelope
	trill.attack = 0.005
	trill.decay = 0.1  # *
	trill.sustain_level = 0.7  # *
	trill.sustain_time = 0.4  # *
	trill.release = 0.1  # *
	trill.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	trill.tremolo_depth = 0.0
	trill.tremolo_rate = 6.0
	trill.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	trill.repeat_rate = 0.0
	# ---- Filter
	trill.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	trill.cutoff = 4000.0  # *
	trill.cutoff_sweep_octaves = 0.0
	trill.resonance = 0.0
	trill.filter_lfo_depth = 0.0
	trill.filter_lfo_rate = 3.0
	trill.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	trill.drive = 0.0
	trill.bit_depth = 16
	trill.sample_hold = 1
	# ---- Space
	trill.delay_time = 0.0
	trill.delay_feedback = 0.4
	trill.delay_mix = 0.0
	# ---- Output
	trill.volume_db = -10.0  # *
	trill.normalize = true
	trill.sample_rate = 44100
	trill.loop = false
	trill.noise_seed = 1
	trill.condition = &""
	p[&"p_trill"] = trill

	var siren := SynthPatch.new()  # showcases: vibrato_shape SAW (a rising-then-reset sweep)
	# ---- Oscillator
	siren.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	siren.duty = 0.5
	siren.base_freq = 440.0
	siren.noise_mix = 0.0
	siren.noise_tone = 1.0
	siren.sub_mix = 0.0
	siren.detune_cents = 0.0
	siren.detune_mix = 0.0
	siren.pwm_depth = 0.0
	siren.pwm_rate = 2.0
	siren.ring_ratio = 0.0
	siren.ring_mix = 0.0
	# ---- Pitch motion
	siren.pitch_sweep_semitones = 0.0
	siren.pitch_sweep_curve = 1.0
	siren.vibrato_depth = 12.0  # *
	siren.vibrato_rate = 1.5  # *
	siren.vibrato_shape = SynthPatch.LfoShape.SAW  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	siren.vibrato_fade_in = 0.0
	siren.arpeggio = []
	siren.arpeggio_rate = 20.0
	siren.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	siren.arpeggio_glide = 0.0
	# ---- FM
	siren.fm_ratio = 0.0
	siren.fm_depth = 0.0
	siren.fm_decay = 0.0
	# ---- Amp envelope
	siren.attack = 0.05  # *
	siren.decay = 0.1  # *
	siren.sustain_level = 0.9  # *
	siren.sustain_time = 1.4  # *
	siren.release = 0.2  # *
	siren.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	siren.tremolo_depth = 0.0
	siren.tremolo_rate = 6.0
	siren.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	siren.repeat_rate = 0.0
	# ---- Filter
	siren.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	siren.cutoff = 2000.0
	siren.cutoff_sweep_octaves = 0.0
	siren.resonance = 0.0
	siren.filter_lfo_depth = 0.0
	siren.filter_lfo_rate = 3.0
	siren.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	siren.drive = 0.3  # *
	siren.bit_depth = 16
	siren.sample_hold = 1
	# ---- Space
	siren.delay_time = 0.0
	siren.delay_feedback = 0.4
	siren.delay_mix = 0.0
	# ---- Output
	siren.volume_db = -8.0  # *
	siren.normalize = true
	siren.sample_rate = 44100
	siren.loop = false
	siren.noise_seed = 1
	siren.condition = &""
	p[&"p_siren"] = siren

	var burble := SynthPatch.new()  # showcases: vibrato_shape RANDOM (sample-and-hold pitch)
	# ---- Oscillator
	burble.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	burble.duty = 0.5
	burble.base_freq = 520.0  # *
	burble.noise_mix = 0.0
	burble.noise_tone = 1.0
	burble.sub_mix = 0.0
	burble.detune_cents = 0.0
	burble.detune_mix = 0.0
	burble.pwm_depth = 0.0
	burble.pwm_rate = 2.0
	burble.ring_ratio = 0.0
	burble.ring_mix = 0.0
	# ---- Pitch motion
	burble.pitch_sweep_semitones = 0.0
	burble.pitch_sweep_curve = 1.0
	burble.vibrato_depth = 5.0  # *
	burble.vibrato_rate = 18.0  # *
	burble.vibrato_shape = SynthPatch.LfoShape.RANDOM  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	burble.vibrato_fade_in = 0.0
	burble.arpeggio = []
	burble.arpeggio_rate = 20.0
	burble.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	burble.arpeggio_glide = 0.0
	# ---- FM
	burble.fm_ratio = 0.0
	burble.fm_depth = 0.0
	burble.fm_decay = 0.0
	# ---- Amp envelope
	burble.attack = 0.01  # *
	burble.decay = 0.1  # *
	burble.sustain_level = 0.8  # *
	burble.sustain_time = 0.5  # *
	burble.release = 0.15  # *
	burble.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	burble.tremolo_depth = 0.0
	burble.tremolo_rate = 6.0
	burble.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	burble.repeat_rate = 0.0
	# ---- Filter
	burble.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	burble.cutoff = 2000.0
	burble.cutoff_sweep_octaves = 0.0
	burble.resonance = 0.0
	burble.filter_lfo_depth = 0.0
	burble.filter_lfo_rate = 3.0
	burble.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	burble.drive = 0.0
	burble.bit_depth = 16
	burble.sample_hold = 1
	# ---- Space
	burble.delay_time = 0.11  # *
	burble.delay_feedback = 0.3  # *
	burble.delay_mix = 0.25  # *
	# ---- Output
	burble.volume_db = -9.0  # *
	burble.normalize = true
	burble.sample_rate = 44100
	burble.loop = false
	burble.noise_seed = 1
	burble.condition = &""
	p[&"p_burble"] = burble

	var swell := SynthPatch.new()  # showcases: vibrato_fade_in (vibrato grows into the note)
	# ---- Oscillator
	swell.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	swell.duty = 0.5
	swell.base_freq = 330.0  # *
	swell.noise_mix = 0.0
	swell.noise_tone = 1.0
	swell.sub_mix = 0.0
	swell.detune_cents = 0.0
	swell.detune_mix = 0.0
	swell.pwm_depth = 0.0
	swell.pwm_rate = 2.0
	swell.ring_ratio = 0.0
	swell.ring_mix = 0.0
	# ---- Pitch motion
	swell.pitch_sweep_semitones = 0.0
	swell.pitch_sweep_curve = 1.0
	swell.vibrato_depth = 0.6  # *
	swell.vibrato_rate = 5.5  # *
	swell.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	swell.vibrato_fade_in = 0.8  # *
	swell.arpeggio = []
	swell.arpeggio_rate = 20.0
	swell.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	swell.arpeggio_glide = 0.0
	# ---- FM
	swell.fm_ratio = 0.0
	swell.fm_depth = 0.0
	swell.fm_decay = 0.0
	# ---- Amp envelope
	swell.attack = 0.5  # *
	swell.decay = 0.2  # *
	swell.sustain_level = 0.9  # *
	swell.sustain_time = 0.8  # *
	swell.release = 0.6  # *
	swell.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	swell.tremolo_depth = 0.0
	swell.tremolo_rate = 6.0
	swell.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	swell.repeat_rate = 0.0
	# ---- Filter
	swell.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	swell.cutoff = 900.0  # *
	swell.cutoff_sweep_octaves = 2.0  # *
	swell.resonance = 0.0
	swell.filter_lfo_depth = 0.0
	swell.filter_lfo_rate = 3.0
	swell.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	swell.drive = 0.0
	swell.bit_depth = 16
	swell.sample_hold = 1
	# ---- Space
	swell.delay_time = 0.25  # *
	swell.delay_feedback = 0.4
	swell.delay_mix = 0.3  # *
	# ---- Output
	swell.volume_db = -8.0  # *
	swell.normalize = true
	swell.sample_rate = 44100
	swell.loop = false
	swell.noise_seed = 1
	swell.condition = &""
	p[&"p_swell"] = swell

	var arp_climb := SynthPatch.new()  # showcases: arpeggio_mode ONCE (climbs, then holds the top)
	# ---- Oscillator
	arp_climb.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	arp_climb.duty = 0.5
	arp_climb.base_freq = 262.0  # *
	arp_climb.noise_mix = 0.0
	arp_climb.noise_tone = 1.0
	arp_climb.sub_mix = 0.0
	arp_climb.detune_cents = 0.0
	arp_climb.detune_mix = 0.0
	arp_climb.pwm_depth = 0.0
	arp_climb.pwm_rate = 2.0
	arp_climb.ring_ratio = 0.0
	arp_climb.ring_mix = 0.0
	# ---- Pitch motion
	arp_climb.pitch_sweep_semitones = 0.0
	arp_climb.pitch_sweep_curve = 1.0
	arp_climb.vibrato_depth = 0.0
	arp_climb.vibrato_rate = 6.0
	arp_climb.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	arp_climb.vibrato_fade_in = 0.0
	arp_climb.arpeggio = [0, 4, 7, 12, 16, 19, 24]  # *
	arp_climb.arpeggio_rate = 12.0  # *
	arp_climb.arpeggio_mode = SynthPatch.ArpMode.ONCE  # * choices: LOOP ONCE PING_PONG RANDOM
	arp_climb.arpeggio_glide = 0.0
	# ---- FM
	arp_climb.fm_ratio = 0.0
	arp_climb.fm_depth = 0.0
	arp_climb.fm_decay = 0.0
	# ---- Amp envelope
	arp_climb.attack = 0.0  # *
	arp_climb.decay = 0.1  # *
	arp_climb.sustain_level = 0.7  # *
	arp_climb.sustain_time = 0.7  # *
	arp_climb.release = 0.3  # *
	arp_climb.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	arp_climb.tremolo_depth = 0.0
	arp_climb.tremolo_rate = 6.0
	arp_climb.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	arp_climb.repeat_rate = 0.0
	# ---- Filter
	arp_climb.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	arp_climb.cutoff = 3000.0  # *
	arp_climb.cutoff_sweep_octaves = 0.0
	arp_climb.resonance = 0.0
	arp_climb.filter_lfo_depth = 0.0
	arp_climb.filter_lfo_rate = 3.0
	arp_climb.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	arp_climb.drive = 0.0
	arp_climb.bit_depth = 16
	arp_climb.sample_hold = 1
	# ---- Space
	arp_climb.delay_time = 0.0
	arp_climb.delay_feedback = 0.4
	arp_climb.delay_mix = 0.0
	# ---- Output
	arp_climb.volume_db = -10.0  # *
	arp_climb.normalize = true
	arp_climb.sample_rate = 44100
	arp_climb.loop = false
	arp_climb.noise_seed = 1
	arp_climb.condition = &""
	p[&"p_arp_climb"] = arp_climb

	var arp_bounce := SynthPatch.new()  # showcases: arpeggio_mode PING_PONG (up and back down)
	# ---- Oscillator
	arp_bounce.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	arp_bounce.duty = 0.5
	arp_bounce.base_freq = 392.0  # *
	arp_bounce.noise_mix = 0.0
	arp_bounce.noise_tone = 1.0
	arp_bounce.sub_mix = 0.0
	arp_bounce.detune_cents = 0.0
	arp_bounce.detune_mix = 0.0
	arp_bounce.pwm_depth = 0.0
	arp_bounce.pwm_rate = 2.0
	arp_bounce.ring_ratio = 0.0
	arp_bounce.ring_mix = 0.0
	# ---- Pitch motion
	arp_bounce.pitch_sweep_semitones = 0.0
	arp_bounce.pitch_sweep_curve = 1.0
	arp_bounce.vibrato_depth = 0.0
	arp_bounce.vibrato_rate = 6.0
	arp_bounce.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	arp_bounce.vibrato_fade_in = 0.0
	arp_bounce.arpeggio = [0, 7, 12, 19]  # *
	arp_bounce.arpeggio_rate = 16.0  # *
	arp_bounce.arpeggio_mode = SynthPatch.ArpMode.PING_PONG  # * choices: LOOP ONCE PING_PONG RANDOM
	arp_bounce.arpeggio_glide = 0.0
	# ---- FM
	arp_bounce.fm_ratio = 0.0
	arp_bounce.fm_depth = 0.0
	arp_bounce.fm_decay = 0.0
	# ---- Amp envelope
	arp_bounce.attack = 0.0  # *
	arp_bounce.decay = 0.2  # *
	arp_bounce.sustain_level = 0.6  # *
	arp_bounce.sustain_time = 0.5  # *
	arp_bounce.release = 0.2  # *
	arp_bounce.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	arp_bounce.tremolo_depth = 0.0
	arp_bounce.tremolo_rate = 6.0
	arp_bounce.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	arp_bounce.repeat_rate = 0.0
	# ---- Filter
	arp_bounce.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	arp_bounce.cutoff = 2000.0
	arp_bounce.cutoff_sweep_octaves = 0.0
	arp_bounce.resonance = 0.0
	arp_bounce.filter_lfo_depth = 0.0
	arp_bounce.filter_lfo_rate = 3.0
	arp_bounce.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	arp_bounce.drive = 0.0
	arp_bounce.bit_depth = 16
	arp_bounce.sample_hold = 1
	# ---- Space
	arp_bounce.delay_time = 0.19  # *
	arp_bounce.delay_feedback = 0.35  # *
	arp_bounce.delay_mix = 0.3  # *
	# ---- Output
	arp_bounce.volume_db = -9.0  # *
	arp_bounce.normalize = true
	arp_bounce.sample_rate = 44100
	arp_bounce.loop = false
	arp_bounce.noise_seed = 1
	arp_bounce.condition = &""
	p[&"p_arp_bounce"] = arp_bounce

	var chimes := SynthPatch.new()  # showcases: arpeggio_mode RANDOM (wind chimes)
	# ---- Oscillator
	chimes.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	chimes.duty = 0.5
	chimes.base_freq = 1047.0  # *
	chimes.noise_mix = 0.0
	chimes.noise_tone = 1.0
	chimes.sub_mix = 0.0
	chimes.detune_cents = 0.0
	chimes.detune_mix = 0.0
	chimes.pwm_depth = 0.0
	chimes.pwm_rate = 2.0
	chimes.ring_ratio = 0.0
	chimes.ring_mix = 0.0
	# ---- Pitch motion
	chimes.pitch_sweep_semitones = 0.0
	chimes.pitch_sweep_curve = 1.0
	chimes.vibrato_depth = 0.0
	chimes.vibrato_rate = 6.0
	chimes.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	chimes.vibrato_fade_in = 0.0
	chimes.arpeggio = [0, 2, 4, 7, 9, 12, 14, 16]  # *
	chimes.arpeggio_rate = 9.0  # *
	chimes.arpeggio_mode = SynthPatch.ArpMode.RANDOM  # * choices: LOOP ONCE PING_PONG RANDOM
	chimes.arpeggio_glide = 0.0
	# ---- FM
	chimes.fm_ratio = 3.0  # *
	chimes.fm_depth = 1.5  # *
	chimes.fm_decay = 0.15  # *
	# ---- Amp envelope
	chimes.attack = 0.0  # *
	chimes.decay = 0.3  # *
	chimes.sustain_level = 0.5  # *
	chimes.sustain_time = 0.9  # *
	chimes.release = 0.6  # *
	chimes.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	chimes.tremolo_depth = 0.0
	chimes.tremolo_rate = 6.0
	chimes.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	chimes.repeat_rate = 0.0
	# ---- Filter
	chimes.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	chimes.cutoff = 2000.0
	chimes.cutoff_sweep_octaves = 0.0
	chimes.resonance = 0.0
	chimes.filter_lfo_depth = 0.0
	chimes.filter_lfo_rate = 3.0
	chimes.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	chimes.drive = 0.0
	chimes.bit_depth = 16
	chimes.sample_hold = 1
	# ---- Space
	chimes.delay_time = 0.22  # *
	chimes.delay_feedback = 0.5  # *
	chimes.delay_mix = 0.45  # *
	# ---- Output
	chimes.volume_db = -12.0  # *
	chimes.normalize = true
	chimes.sample_rate = 44100
	chimes.loop = false
	chimes.noise_seed = 1
	chimes.condition = &""
	p[&"p_chimes"] = chimes

	var glide_lead := SynthPatch.new()  # showcases: arpeggio_glide (portamento between notes)
	# ---- Oscillator
	glide_lead.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	glide_lead.duty = 0.5
	glide_lead.base_freq = 220.0  # *
	glide_lead.noise_mix = 0.0
	glide_lead.noise_tone = 1.0
	glide_lead.sub_mix = 0.0
	glide_lead.detune_cents = 0.0
	glide_lead.detune_mix = 0.0
	glide_lead.pwm_depth = 0.0
	glide_lead.pwm_rate = 2.0
	glide_lead.ring_ratio = 0.0
	glide_lead.ring_mix = 0.0
	# ---- Pitch motion
	glide_lead.pitch_sweep_semitones = 0.0
	glide_lead.pitch_sweep_curve = 1.0
	glide_lead.vibrato_depth = 0.0
	glide_lead.vibrato_rate = 6.0
	glide_lead.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glide_lead.vibrato_fade_in = 0.0
	glide_lead.arpeggio = [0, 12, 7, -5, 0]  # *
	glide_lead.arpeggio_rate = 4.0  # *
	glide_lead.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	glide_lead.arpeggio_glide = 0.08  # *
	# ---- FM
	glide_lead.fm_ratio = 0.0
	glide_lead.fm_depth = 0.0
	glide_lead.fm_decay = 0.0
	# ---- Amp envelope
	glide_lead.attack = 0.02  # *
	glide_lead.decay = 0.1  # *
	glide_lead.sustain_level = 0.8  # *
	glide_lead.sustain_time = 1.0  # *
	glide_lead.release = 0.2  # *
	glide_lead.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	glide_lead.tremolo_depth = 0.0
	glide_lead.tremolo_rate = 6.0
	glide_lead.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	glide_lead.repeat_rate = 0.0
	# ---- Filter
	glide_lead.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	glide_lead.cutoff = 1500.0  # *
	glide_lead.cutoff_sweep_octaves = 0.0
	glide_lead.resonance = 0.4  # *
	glide_lead.filter_lfo_depth = 0.0
	glide_lead.filter_lfo_rate = 3.0
	glide_lead.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	glide_lead.drive = 0.0
	glide_lead.bit_depth = 16
	glide_lead.sample_hold = 1
	# ---- Space
	glide_lead.delay_time = 0.0
	glide_lead.delay_feedback = 0.4
	glide_lead.delay_mix = 0.0
	# ---- Output
	glide_lead.volume_db = -10.0  # *
	glide_lead.normalize = true
	glide_lead.sample_rate = 44100
	glide_lead.loop = false
	glide_lead.noise_seed = 1
	glide_lead.condition = &""
	p[&"p_glide_lead"] = glide_lead

	var pwm_lead := SynthPatch.new()  # showcases: pwm_depth / pwm_rate (pulse-width modulation)
	# ---- Oscillator
	pwm_lead.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	pwm_lead.duty = 0.5
	pwm_lead.base_freq = 220.0  # *
	pwm_lead.noise_mix = 0.0
	pwm_lead.noise_tone = 1.0
	pwm_lead.sub_mix = 0.0
	pwm_lead.detune_cents = 0.0
	pwm_lead.detune_mix = 0.0
	pwm_lead.pwm_depth = 0.35  # *
	pwm_lead.pwm_rate = 1.5  # *
	pwm_lead.ring_ratio = 0.0
	pwm_lead.ring_mix = 0.0
	# ---- Pitch motion
	pwm_lead.pitch_sweep_semitones = 0.0
	pwm_lead.pitch_sweep_curve = 1.0
	pwm_lead.vibrato_depth = 0.0
	pwm_lead.vibrato_rate = 6.0
	pwm_lead.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pwm_lead.vibrato_fade_in = 0.0
	pwm_lead.arpeggio = []
	pwm_lead.arpeggio_rate = 20.0
	pwm_lead.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pwm_lead.arpeggio_glide = 0.0
	# ---- FM
	pwm_lead.fm_ratio = 0.0
	pwm_lead.fm_depth = 0.0
	pwm_lead.fm_decay = 0.0
	# ---- Amp envelope
	pwm_lead.attack = 0.01  # *
	pwm_lead.decay = 0.1  # *
	pwm_lead.sustain_level = 0.8  # *
	pwm_lead.sustain_time = 0.9  # *
	pwm_lead.release = 0.2  # *
	pwm_lead.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pwm_lead.tremolo_depth = 0.0
	pwm_lead.tremolo_rate = 6.0
	pwm_lead.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pwm_lead.repeat_rate = 0.0
	# ---- Filter
	pwm_lead.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	pwm_lead.cutoff = 2500.0  # *
	pwm_lead.cutoff_sweep_octaves = 0.0
	pwm_lead.resonance = 0.0
	pwm_lead.filter_lfo_depth = 0.0
	pwm_lead.filter_lfo_rate = 3.0
	pwm_lead.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pwm_lead.drive = 0.0
	pwm_lead.bit_depth = 16
	pwm_lead.sample_hold = 1
	# ---- Space
	pwm_lead.delay_time = 0.0
	pwm_lead.delay_feedback = 0.4
	pwm_lead.delay_mix = 0.0
	# ---- Output
	pwm_lead.volume_db = -10.0  # *
	pwm_lead.normalize = true
	pwm_lead.sample_rate = 44100
	pwm_lead.loop = false
	pwm_lead.noise_seed = 1
	pwm_lead.condition = &""
	p[&"p_pwm_lead"] = pwm_lead

	var fat_bass := SynthPatch.new()  # showcases: detune_cents / detune_mix and sub_mix
	# ---- Oscillator
	fat_bass.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	fat_bass.duty = 0.5
	fat_bass.base_freq = 55.0  # *
	fat_bass.noise_mix = 0.0
	fat_bass.noise_tone = 1.0
	fat_bass.sub_mix = 0.4  # *
	fat_bass.detune_cents = 12.0  # *
	fat_bass.detune_mix = 0.5  # *
	fat_bass.pwm_depth = 0.0
	fat_bass.pwm_rate = 2.0
	fat_bass.ring_ratio = 0.0
	fat_bass.ring_mix = 0.0
	# ---- Pitch motion
	fat_bass.pitch_sweep_semitones = 0.0
	fat_bass.pitch_sweep_curve = 1.0
	fat_bass.vibrato_depth = 0.0
	fat_bass.vibrato_rate = 6.0
	fat_bass.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	fat_bass.vibrato_fade_in = 0.0
	fat_bass.arpeggio = []
	fat_bass.arpeggio_rate = 20.0
	fat_bass.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	fat_bass.arpeggio_glide = 0.0
	# ---- FM
	fat_bass.fm_ratio = 0.0
	fat_bass.fm_depth = 0.0
	fat_bass.fm_decay = 0.0
	# ---- Amp envelope
	fat_bass.attack = 0.01  # *
	fat_bass.decay = 0.2  # *
	fat_bass.sustain_level = 0.7  # *
	fat_bass.sustain_time = 0.5  # *
	fat_bass.release = 0.2  # *
	fat_bass.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	fat_bass.tremolo_depth = 0.0
	fat_bass.tremolo_rate = 6.0
	fat_bass.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	fat_bass.repeat_rate = 0.0
	# ---- Filter
	fat_bass.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	fat_bass.cutoff = 500.0  # *
	fat_bass.cutoff_sweep_octaves = -1.0  # *
	fat_bass.resonance = 0.3  # *
	fat_bass.filter_lfo_depth = 0.0
	fat_bass.filter_lfo_rate = 3.0
	fat_bass.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	fat_bass.drive = 0.3  # *
	fat_bass.bit_depth = 16
	fat_bass.sample_hold = 1
	# ---- Space
	fat_bass.delay_time = 0.0
	fat_bass.delay_feedback = 0.4
	fat_bass.delay_mix = 0.0
	# ---- Output
	fat_bass.volume_db = -6.0  # *
	fat_bass.normalize = true
	fat_bass.sample_rate = 44100
	fat_bass.loop = false
	fat_bass.noise_seed = 1
	fat_bass.condition = &""
	p[&"p_fat_bass"] = fat_bass

	var robot_voice := SynthPatch.new()  # showcases: ring_ratio / ring_mix (ring modulation)
	# ---- Oscillator
	robot_voice.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	robot_voice.duty = 0.5
	robot_voice.base_freq = 150.0  # *
	robot_voice.noise_mix = 0.0
	robot_voice.noise_tone = 1.0
	robot_voice.sub_mix = 0.0
	robot_voice.detune_cents = 0.0
	robot_voice.detune_mix = 0.0
	robot_voice.pwm_depth = 0.0
	robot_voice.pwm_rate = 2.0
	robot_voice.ring_ratio = 0.37  # *
	robot_voice.ring_mix = 1.0  # *
	# ---- Pitch motion
	robot_voice.pitch_sweep_semitones = 0.0
	robot_voice.pitch_sweep_curve = 1.0
	robot_voice.vibrato_depth = 3.0  # *
	robot_voice.vibrato_rate = 9.0  # *
	robot_voice.vibrato_shape = SynthPatch.LfoShape.RANDOM  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	robot_voice.vibrato_fade_in = 0.0
	robot_voice.arpeggio = []
	robot_voice.arpeggio_rate = 20.0
	robot_voice.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	robot_voice.arpeggio_glide = 0.0
	# ---- FM
	robot_voice.fm_ratio = 0.0
	robot_voice.fm_depth = 0.0
	robot_voice.fm_decay = 0.0
	# ---- Amp envelope
	robot_voice.attack = 0.01  # *
	robot_voice.decay = 0.1  # *
	robot_voice.sustain_level = 0.8  # *
	robot_voice.sustain_time = 0.6  # *
	robot_voice.release = 0.1  # *
	robot_voice.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	robot_voice.tremolo_depth = 0.0
	robot_voice.tremolo_rate = 6.0
	robot_voice.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	robot_voice.repeat_rate = 0.0
	# ---- Filter
	robot_voice.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	robot_voice.cutoff = 1200.0  # *
	robot_voice.cutoff_sweep_octaves = 0.0
	robot_voice.resonance = 0.4  # *
	robot_voice.filter_lfo_depth = 0.0
	robot_voice.filter_lfo_rate = 3.0
	robot_voice.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	robot_voice.drive = 0.0
	robot_voice.bit_depth = 16
	robot_voice.sample_hold = 1
	# ---- Space
	robot_voice.delay_time = 0.0
	robot_voice.delay_feedback = 0.4
	robot_voice.delay_mix = 0.0
	# ---- Output
	robot_voice.volume_db = -8.0  # *
	robot_voice.normalize = true
	robot_voice.sample_rate = 44100
	robot_voice.loop = false
	robot_voice.noise_seed = 1
	robot_voice.condition = &""
	p[&"p_robot_voice"] = robot_voice

	var ring_bell := SynthPatch.new()  # showcases: ring mod on a sine, envelope_curve EXPONENTIAL
	# ---- Oscillator
	ring_bell.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	ring_bell.duty = 0.5
	ring_bell.base_freq = 660.0  # *
	ring_bell.noise_mix = 0.0
	ring_bell.noise_tone = 1.0
	ring_bell.sub_mix = 0.0
	ring_bell.detune_cents = 0.0
	ring_bell.detune_mix = 0.0
	ring_bell.pwm_depth = 0.0
	ring_bell.pwm_rate = 2.0
	ring_bell.ring_ratio = 2.76  # *
	ring_bell.ring_mix = 0.8  # *
	# ---- Pitch motion
	ring_bell.pitch_sweep_semitones = 0.0
	ring_bell.pitch_sweep_curve = 1.0
	ring_bell.vibrato_depth = 0.0
	ring_bell.vibrato_rate = 6.0
	ring_bell.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ring_bell.vibrato_fade_in = 0.0
	ring_bell.arpeggio = []
	ring_bell.arpeggio_rate = 20.0
	ring_bell.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	ring_bell.arpeggio_glide = 0.0
	# ---- FM
	ring_bell.fm_ratio = 0.0
	ring_bell.fm_depth = 0.0
	ring_bell.fm_decay = 0.0
	# ---- Amp envelope
	ring_bell.attack = 0.0  # *
	ring_bell.decay = 1.0  # *
	ring_bell.sustain_level = 0.0
	ring_bell.sustain_time = 0.0
	ring_bell.release = 0.3  # *
	ring_bell.envelope_curve = SynthPatch.EnvCurve.EXPONENTIAL  # * choices: LINEAR EXPONENTIAL
	ring_bell.tremolo_depth = 0.0
	ring_bell.tremolo_rate = 6.0
	ring_bell.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	ring_bell.repeat_rate = 0.0
	# ---- Filter
	ring_bell.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	ring_bell.cutoff = 2000.0
	ring_bell.cutoff_sweep_octaves = 0.0
	ring_bell.resonance = 0.0
	ring_bell.filter_lfo_depth = 0.0
	ring_bell.filter_lfo_rate = 3.0
	ring_bell.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	ring_bell.drive = 0.0
	ring_bell.bit_depth = 16
	ring_bell.sample_hold = 1
	# ---- Space
	ring_bell.delay_time = 0.2  # *
	ring_bell.delay_feedback = 0.4
	ring_bell.delay_mix = 0.3  # *
	# ---- Output
	ring_bell.volume_db = -8.0  # *
	ring_bell.normalize = true
	ring_bell.sample_rate = 44100
	ring_bell.loop = false
	ring_bell.noise_seed = 1
	ring_bell.condition = &""
	p[&"p_ring_bell"] = ring_bell

	var helicopter := SynthPatch.new()  # showcases: tremolo_shape SQUARE and noise_tone (rotor loop)
	# ---- Oscillator
	helicopter.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	helicopter.duty = 0.5
	helicopter.base_freq = 440.0
	helicopter.noise_mix = 0.0
	helicopter.noise_tone = 0.08  # *
	helicopter.sub_mix = 0.0
	helicopter.detune_cents = 0.0
	helicopter.detune_mix = 0.0
	helicopter.pwm_depth = 0.0
	helicopter.pwm_rate = 2.0
	helicopter.ring_ratio = 0.0
	helicopter.ring_mix = 0.0
	# ---- Pitch motion
	helicopter.pitch_sweep_semitones = 0.0
	helicopter.pitch_sweep_curve = 1.0
	helicopter.vibrato_depth = 0.0
	helicopter.vibrato_rate = 6.0
	helicopter.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	helicopter.vibrato_fade_in = 0.0
	helicopter.arpeggio = []
	helicopter.arpeggio_rate = 20.0
	helicopter.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	helicopter.arpeggio_glide = 0.0
	# ---- FM
	helicopter.fm_ratio = 0.0
	helicopter.fm_depth = 0.0
	helicopter.fm_decay = 0.0
	# ---- Amp envelope
	helicopter.attack = 0.0  # *
	helicopter.decay = 0.0  # *
	helicopter.sustain_level = 1.0  # *
	helicopter.sustain_time = 1.5  # *
	helicopter.release = 0.0  # *
	helicopter.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	helicopter.tremolo_depth = 1.0  # *
	helicopter.tremolo_rate = 14.0  # *
	helicopter.tremolo_shape = SynthPatch.LfoShape.SQUARE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	helicopter.repeat_rate = 0.0
	# ---- Filter
	helicopter.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	helicopter.cutoff = 2000.0
	helicopter.cutoff_sweep_octaves = 0.0
	helicopter.resonance = 0.0
	helicopter.filter_lfo_depth = 0.0
	helicopter.filter_lfo_rate = 3.0
	helicopter.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	helicopter.drive = 0.5  # *
	helicopter.bit_depth = 16
	helicopter.sample_hold = 1
	# ---- Space
	helicopter.delay_time = 0.0
	helicopter.delay_feedback = 0.4
	helicopter.delay_mix = 0.0
	# ---- Output
	helicopter.volume_db = -8.0  # *
	helicopter.normalize = true
	helicopter.sample_rate = 44100
	helicopter.loop = true  # *
	helicopter.noise_seed = 1
	helicopter.condition = &""
	p[&"p_helicopter"] = helicopter

	var stutter_zap := SynthPatch.new()  # showcases: repeat_rate (envelope restarts: a stutter)
	# ---- Oscillator
	stutter_zap.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	stutter_zap.duty = 0.3  # *
	stutter_zap.base_freq = 1200.0  # *
	stutter_zap.noise_mix = 0.0
	stutter_zap.noise_tone = 1.0
	stutter_zap.sub_mix = 0.0
	stutter_zap.detune_cents = 0.0
	stutter_zap.detune_mix = 0.0
	stutter_zap.pwm_depth = 0.0
	stutter_zap.pwm_rate = 2.0
	stutter_zap.ring_ratio = 0.0
	stutter_zap.ring_mix = 0.0
	# ---- Pitch motion
	stutter_zap.pitch_sweep_semitones = -20.0  # *
	stutter_zap.pitch_sweep_curve = 0.6  # *
	stutter_zap.vibrato_depth = 0.0
	stutter_zap.vibrato_rate = 6.0
	stutter_zap.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stutter_zap.vibrato_fade_in = 0.0
	stutter_zap.arpeggio = []
	stutter_zap.arpeggio_rate = 20.0
	stutter_zap.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	stutter_zap.arpeggio_glide = 0.0
	# ---- FM
	stutter_zap.fm_ratio = 0.0
	stutter_zap.fm_depth = 0.0
	stutter_zap.fm_decay = 0.0
	# ---- Amp envelope
	stutter_zap.attack = 0.0  # *
	stutter_zap.decay = 0.07  # *
	stutter_zap.sustain_level = 0.0
	stutter_zap.sustain_time = 0.52  # *
	stutter_zap.release = 0.01  # *
	stutter_zap.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	stutter_zap.tremolo_depth = 0.0
	stutter_zap.tremolo_rate = 6.0
	stutter_zap.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	stutter_zap.repeat_rate = 12.0  # *
	# ---- Filter
	stutter_zap.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	stutter_zap.cutoff = 2000.0
	stutter_zap.cutoff_sweep_octaves = 0.0
	stutter_zap.resonance = 0.0
	stutter_zap.filter_lfo_depth = 0.0
	stutter_zap.filter_lfo_rate = 3.0
	stutter_zap.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	stutter_zap.drive = 0.0
	stutter_zap.bit_depth = 16
	stutter_zap.sample_hold = 1
	# ---- Space
	stutter_zap.delay_time = 0.0
	stutter_zap.delay_feedback = 0.4
	stutter_zap.delay_mix = 0.0
	# ---- Output
	stutter_zap.volume_db = -10.0  # *
	stutter_zap.normalize = true
	stutter_zap.sample_rate = 44100
	stutter_zap.loop = false
	stutter_zap.noise_seed = 1
	stutter_zap.condition = &""
	p[&"p_stutter_zap"] = stutter_zap

	var machine_gun := SynthPatch.new()  # showcases: repeat_rate on a noisy thump
	# ---- Oscillator
	machine_gun.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	machine_gun.duty = 0.5
	machine_gun.base_freq = 140.0  # *
	machine_gun.noise_mix = 0.6  # *
	machine_gun.noise_tone = 1.0
	machine_gun.sub_mix = 0.0
	machine_gun.detune_cents = 0.0
	machine_gun.detune_mix = 0.0
	machine_gun.pwm_depth = 0.0
	machine_gun.pwm_rate = 2.0
	machine_gun.ring_ratio = 0.0
	machine_gun.ring_mix = 0.0
	# ---- Pitch motion
	machine_gun.pitch_sweep_semitones = -18.0  # *
	machine_gun.pitch_sweep_curve = 0.3  # *
	machine_gun.vibrato_depth = 0.0
	machine_gun.vibrato_rate = 6.0
	machine_gun.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	machine_gun.vibrato_fade_in = 0.0
	machine_gun.arpeggio = []
	machine_gun.arpeggio_rate = 20.0
	machine_gun.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	machine_gun.arpeggio_glide = 0.0
	# ---- FM
	machine_gun.fm_ratio = 0.0
	machine_gun.fm_depth = 0.0
	machine_gun.fm_decay = 0.0
	# ---- Amp envelope
	machine_gun.attack = 0.0  # *
	machine_gun.decay = 0.08  # *
	machine_gun.sustain_level = 0.0
	machine_gun.sustain_time = 0.7  # *
	machine_gun.release = 0.01  # *
	machine_gun.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	machine_gun.tremolo_depth = 0.0
	machine_gun.tremolo_rate = 6.0
	machine_gun.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	machine_gun.repeat_rate = 9.0  # *
	# ---- Filter
	machine_gun.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	machine_gun.cutoff = 3000.0  # *
	machine_gun.cutoff_sweep_octaves = -2.0  # *
	machine_gun.resonance = 0.0
	machine_gun.filter_lfo_depth = 0.0
	machine_gun.filter_lfo_rate = 3.0
	machine_gun.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	machine_gun.drive = 0.7  # *
	machine_gun.bit_depth = 16
	machine_gun.sample_hold = 1
	# ---- Space
	machine_gun.delay_time = 0.0
	machine_gun.delay_feedback = 0.4
	machine_gun.delay_mix = 0.0
	# ---- Output
	machine_gun.volume_db = -3.0  # *
	machine_gun.normalize = true
	machine_gun.sample_rate = 44100
	machine_gun.loop = false
	machine_gun.noise_seed = 1
	machine_gun.condition = &""
	p[&"p_machine_gun"] = machine_gun

	var pulse_pad := SynthPatch.new()  # showcases: tremolo_shape SINE on a detuned pad (loop)
	# ---- Oscillator
	pulse_pad.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	pulse_pad.duty = 0.5
	pulse_pad.base_freq = 110.0  # *
	pulse_pad.noise_mix = 0.0
	pulse_pad.noise_tone = 1.0
	pulse_pad.sub_mix = 0.0
	pulse_pad.detune_cents = 8.0  # *
	pulse_pad.detune_mix = 0.5  # *
	pulse_pad.pwm_depth = 0.0
	pulse_pad.pwm_rate = 2.0
	pulse_pad.ring_ratio = 0.0
	pulse_pad.ring_mix = 0.0
	# ---- Pitch motion
	pulse_pad.pitch_sweep_semitones = 0.0
	pulse_pad.pitch_sweep_curve = 1.0
	pulse_pad.vibrato_depth = 0.0
	pulse_pad.vibrato_rate = 6.0
	pulse_pad.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pulse_pad.vibrato_fade_in = 0.0
	pulse_pad.arpeggio = []
	pulse_pad.arpeggio_rate = 20.0
	pulse_pad.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	pulse_pad.arpeggio_glide = 0.0
	# ---- FM
	pulse_pad.fm_ratio = 0.0
	pulse_pad.fm_depth = 0.0
	pulse_pad.fm_decay = 0.0
	# ---- Amp envelope
	pulse_pad.attack = 0.0  # *
	pulse_pad.decay = 0.0  # *
	pulse_pad.sustain_level = 1.0  # *
	pulse_pad.sustain_time = 2.0  # *
	pulse_pad.release = 0.0  # *
	pulse_pad.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	pulse_pad.tremolo_depth = 0.6  # *
	pulse_pad.tremolo_rate = 4.0  # *
	pulse_pad.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	pulse_pad.repeat_rate = 0.0
	# ---- Filter
	pulse_pad.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	pulse_pad.cutoff = 700.0  # *
	pulse_pad.cutoff_sweep_octaves = 0.0
	pulse_pad.resonance = 0.3  # *
	pulse_pad.filter_lfo_depth = 0.0
	pulse_pad.filter_lfo_rate = 3.0
	pulse_pad.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	pulse_pad.drive = 0.0
	pulse_pad.bit_depth = 16
	pulse_pad.sample_hold = 1
	# ---- Space
	pulse_pad.delay_time = 0.0
	pulse_pad.delay_feedback = 0.4
	pulse_pad.delay_mix = 0.0
	# ---- Output
	pulse_pad.volume_db = -14.0  # *
	pulse_pad.normalize = true
	pulse_pad.sample_rate = 44100
	pulse_pad.loop = true  # *
	pulse_pad.noise_seed = 1
	pulse_pad.condition = &""
	p[&"p_pulse_pad"] = pulse_pad

	var wah_sweep := SynthPatch.new()  # showcases: filter_lfo_depth / filter_lfo_rate (auto-wah)
	# ---- Oscillator
	wah_sweep.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wah_sweep.duty = 0.5
	wah_sweep.base_freq = 165.0  # *
	wah_sweep.noise_mix = 0.0
	wah_sweep.noise_tone = 1.0
	wah_sweep.sub_mix = 0.0
	wah_sweep.detune_cents = 0.0
	wah_sweep.detune_mix = 0.0
	wah_sweep.pwm_depth = 0.0
	wah_sweep.pwm_rate = 2.0
	wah_sweep.ring_ratio = 0.0
	wah_sweep.ring_mix = 0.0
	# ---- Pitch motion
	wah_sweep.pitch_sweep_semitones = 0.0
	wah_sweep.pitch_sweep_curve = 1.0
	wah_sweep.vibrato_depth = 0.0
	wah_sweep.vibrato_rate = 6.0
	wah_sweep.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wah_sweep.vibrato_fade_in = 0.0
	wah_sweep.arpeggio = []
	wah_sweep.arpeggio_rate = 20.0
	wah_sweep.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wah_sweep.arpeggio_glide = 0.0
	# ---- FM
	wah_sweep.fm_ratio = 0.0
	wah_sweep.fm_depth = 0.0
	wah_sweep.fm_decay = 0.0
	# ---- Amp envelope
	wah_sweep.attack = 0.01  # *
	wah_sweep.decay = 0.1  # *
	wah_sweep.sustain_level = 0.8  # *
	wah_sweep.sustain_time = 1.0  # *
	wah_sweep.release = 0.2  # *
	wah_sweep.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wah_sweep.tremolo_depth = 0.0
	wah_sweep.tremolo_rate = 6.0
	wah_sweep.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wah_sweep.repeat_rate = 0.0
	# ---- Filter
	wah_sweep.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wah_sweep.cutoff = 600.0  # *
	wah_sweep.cutoff_sweep_octaves = 0.0
	wah_sweep.resonance = 0.8  # *
	wah_sweep.filter_lfo_depth = 2.5  # *
	wah_sweep.filter_lfo_rate = 2.0  # *
	wah_sweep.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wah_sweep.drive = 0.0
	wah_sweep.bit_depth = 16
	wah_sweep.sample_hold = 1
	# ---- Space
	wah_sweep.delay_time = 0.0
	wah_sweep.delay_feedback = 0.4
	wah_sweep.delay_mix = 0.0
	# ---- Output
	wah_sweep.volume_db = -8.0  # *
	wah_sweep.normalize = true
	wah_sweep.sample_rate = 44100
	wah_sweep.loop = false
	wah_sweep.noise_seed = 1
	wah_sweep.condition = &""
	p[&"p_wah_sweep"] = wah_sweep

	var wobble_bass := SynthPatch.new()  # showcases: filter_lfo_shape TRIANGLE (dubstep wobble)
	# ---- Oscillator
	wobble_bass.wave = SynthPatch.Wave.SAW  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	wobble_bass.duty = 0.5
	wobble_bass.base_freq = 55.0  # *
	wobble_bass.noise_mix = 0.0
	wobble_bass.noise_tone = 1.0
	wobble_bass.sub_mix = 0.3  # *
	wobble_bass.detune_cents = 0.0
	wobble_bass.detune_mix = 0.0
	wobble_bass.pwm_depth = 0.0
	wobble_bass.pwm_rate = 2.0
	wobble_bass.ring_ratio = 0.0
	wobble_bass.ring_mix = 0.0
	# ---- Pitch motion
	wobble_bass.pitch_sweep_semitones = 0.0
	wobble_bass.pitch_sweep_curve = 1.0
	wobble_bass.vibrato_depth = 0.0
	wobble_bass.vibrato_rate = 6.0
	wobble_bass.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wobble_bass.vibrato_fade_in = 0.0
	wobble_bass.arpeggio = []
	wobble_bass.arpeggio_rate = 20.0
	wobble_bass.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	wobble_bass.arpeggio_glide = 0.0
	# ---- FM
	wobble_bass.fm_ratio = 0.0
	wobble_bass.fm_depth = 0.0
	wobble_bass.fm_decay = 0.0
	# ---- Amp envelope
	wobble_bass.attack = 0.01  # *
	wobble_bass.decay = 0.1  # *
	wobble_bass.sustain_level = 0.9  # *
	wobble_bass.sustain_time = 1.2  # *
	wobble_bass.release = 0.15  # *
	wobble_bass.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	wobble_bass.tremolo_depth = 0.0
	wobble_bass.tremolo_rate = 6.0
	wobble_bass.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	wobble_bass.repeat_rate = 0.0
	# ---- Filter
	wobble_bass.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	wobble_bass.cutoff = 300.0  # *
	wobble_bass.cutoff_sweep_octaves = 0.0
	wobble_bass.resonance = 0.7  # *
	wobble_bass.filter_lfo_depth = 3.0  # *
	wobble_bass.filter_lfo_rate = 6.0  # *
	wobble_bass.filter_lfo_shape = SynthPatch.LfoShape.TRIANGLE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	wobble_bass.drive = 0.5  # *
	wobble_bass.bit_depth = 16
	wobble_bass.sample_hold = 1
	# ---- Space
	wobble_bass.delay_time = 0.0
	wobble_bass.delay_feedback = 0.4
	wobble_bass.delay_mix = 0.0
	# ---- Output
	wobble_bass.volume_db = -6.0  # *
	wobble_bass.normalize = true
	wobble_bass.sample_rate = 44100
	wobble_bass.loop = false
	wobble_bass.noise_seed = 1
	wobble_bass.condition = &""
	p[&"p_wobble_bass"] = wobble_bass

	var brown_rumble := SynthPatch.new()  # showcases: noise_tone near 0 (brown noise, loop)
	# ---- Oscillator
	brown_rumble.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	brown_rumble.duty = 0.5
	brown_rumble.base_freq = 440.0
	brown_rumble.noise_mix = 0.0
	brown_rumble.noise_tone = 0.03  # *
	brown_rumble.sub_mix = 0.0
	brown_rumble.detune_cents = 0.0
	brown_rumble.detune_mix = 0.0
	brown_rumble.pwm_depth = 0.0
	brown_rumble.pwm_rate = 2.0
	brown_rumble.ring_ratio = 0.0
	brown_rumble.ring_mix = 0.0
	# ---- Pitch motion
	brown_rumble.pitch_sweep_semitones = 0.0
	brown_rumble.pitch_sweep_curve = 1.0
	brown_rumble.vibrato_depth = 0.0
	brown_rumble.vibrato_rate = 6.0
	brown_rumble.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	brown_rumble.vibrato_fade_in = 0.0
	brown_rumble.arpeggio = []
	brown_rumble.arpeggio_rate = 20.0
	brown_rumble.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	brown_rumble.arpeggio_glide = 0.0
	# ---- FM
	brown_rumble.fm_ratio = 0.0
	brown_rumble.fm_depth = 0.0
	brown_rumble.fm_decay = 0.0
	# ---- Amp envelope
	brown_rumble.attack = 0.0  # *
	brown_rumble.decay = 0.0  # *
	brown_rumble.sustain_level = 1.0  # *
	brown_rumble.sustain_time = 2.5  # *
	brown_rumble.release = 0.0  # *
	brown_rumble.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	brown_rumble.tremolo_depth = 0.0
	brown_rumble.tremolo_rate = 6.0
	brown_rumble.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	brown_rumble.repeat_rate = 0.0
	# ---- Filter
	brown_rumble.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	brown_rumble.cutoff = 2000.0
	brown_rumble.cutoff_sweep_octaves = 0.0
	brown_rumble.resonance = 0.0
	brown_rumble.filter_lfo_depth = 0.0
	brown_rumble.filter_lfo_rate = 3.0
	brown_rumble.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	brown_rumble.drive = 0.4  # *
	brown_rumble.bit_depth = 16
	brown_rumble.sample_hold = 1
	# ---- Space
	brown_rumble.delay_time = 0.0
	brown_rumble.delay_feedback = 0.4
	brown_rumble.delay_mix = 0.0
	# ---- Output
	brown_rumble.volume_db = -10.0  # *
	brown_rumble.normalize = true
	brown_rumble.sample_rate = 44100
	brown_rumble.loop = true  # *
	brown_rumble.noise_seed = 1
	brown_rumble.condition = &""
	p[&"p_brown_rumble"] = brown_rumble

	var crackle := SynthPatch.new()  # showcases: tremolo_shape RANDOM on noise (fire crackle)
	# ---- Oscillator
	crackle.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	crackle.duty = 0.5
	crackle.base_freq = 440.0
	crackle.noise_mix = 0.0
	crackle.noise_tone = 0.6  # *
	crackle.sub_mix = 0.0
	crackle.detune_cents = 0.0
	crackle.detune_mix = 0.0
	crackle.pwm_depth = 0.0
	crackle.pwm_rate = 2.0
	crackle.ring_ratio = 0.0
	crackle.ring_mix = 0.0
	# ---- Pitch motion
	crackle.pitch_sweep_semitones = 0.0
	crackle.pitch_sweep_curve = 1.0
	crackle.vibrato_depth = 0.0
	crackle.vibrato_rate = 6.0
	crackle.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	crackle.vibrato_fade_in = 0.0
	crackle.arpeggio = []
	crackle.arpeggio_rate = 20.0
	crackle.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	crackle.arpeggio_glide = 0.0
	# ---- FM
	crackle.fm_ratio = 0.0
	crackle.fm_depth = 0.0
	crackle.fm_decay = 0.0
	# ---- Amp envelope
	crackle.attack = 0.0  # *
	crackle.decay = 0.1  # *
	crackle.sustain_level = 0.9  # *
	crackle.sustain_time = 1.2  # *
	crackle.release = 0.2  # *
	crackle.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	crackle.tremolo_depth = 1.0  # *
	crackle.tremolo_rate = 40.0  # *
	crackle.tremolo_shape = SynthPatch.LfoShape.RANDOM  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	crackle.repeat_rate = 0.0
	# ---- Filter
	crackle.filter_mode = SynthPatch.FilterMode.HIGHPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	crackle.cutoff = 1800.0  # *
	crackle.cutoff_sweep_octaves = 0.0
	crackle.resonance = 0.0
	crackle.filter_lfo_depth = 0.0
	crackle.filter_lfo_rate = 3.0
	crackle.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	crackle.drive = 0.0
	crackle.bit_depth = 16
	crackle.sample_hold = 1
	# ---- Space
	crackle.delay_time = 0.0
	crackle.delay_feedback = 0.4
	crackle.delay_mix = 0.0
	# ---- Output
	crackle.volume_db = -12.0  # *
	crackle.normalize = true
	crackle.sample_rate = 44100
	crackle.loop = false
	crackle.noise_seed = 1
	crackle.condition = &""
	p[&"p_crackle"] = crackle

	var exp_pluck := SynthPatch.new()  # showcases: envelope_curve EXPONENTIAL (natural decay)
	# ---- Oscillator
	exp_pluck.wave = SynthPatch.Wave.TRIANGLE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	exp_pluck.duty = 0.5
	exp_pluck.base_freq = 330.0  # *
	exp_pluck.noise_mix = 0.0
	exp_pluck.noise_tone = 1.0
	exp_pluck.sub_mix = 0.0
	exp_pluck.detune_cents = 0.0
	exp_pluck.detune_mix = 0.0
	exp_pluck.pwm_depth = 0.0
	exp_pluck.pwm_rate = 2.0
	exp_pluck.ring_ratio = 0.0
	exp_pluck.ring_mix = 0.0
	# ---- Pitch motion
	exp_pluck.pitch_sweep_semitones = 0.0
	exp_pluck.pitch_sweep_curve = 1.0
	exp_pluck.vibrato_depth = 0.0
	exp_pluck.vibrato_rate = 6.0
	exp_pluck.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	exp_pluck.vibrato_fade_in = 0.0
	exp_pluck.arpeggio = []
	exp_pluck.arpeggio_rate = 20.0
	exp_pluck.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	exp_pluck.arpeggio_glide = 0.0
	# ---- FM
	exp_pluck.fm_ratio = 2.0  # *
	exp_pluck.fm_depth = 1.2  # *
	exp_pluck.fm_decay = 0.1  # *
	# ---- Amp envelope
	exp_pluck.attack = 0.002  # *
	exp_pluck.decay = 0.7  # *
	exp_pluck.sustain_level = 0.0
	exp_pluck.sustain_time = 0.0
	exp_pluck.release = 0.1  # *
	exp_pluck.envelope_curve = SynthPatch.EnvCurve.EXPONENTIAL  # * choices: LINEAR EXPONENTIAL
	exp_pluck.tremolo_depth = 0.0
	exp_pluck.tremolo_rate = 6.0
	exp_pluck.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	exp_pluck.repeat_rate = 0.0
	# ---- Filter
	exp_pluck.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	exp_pluck.cutoff = 2000.0
	exp_pluck.cutoff_sweep_octaves = 0.0
	exp_pluck.resonance = 0.0
	exp_pluck.filter_lfo_depth = 0.0
	exp_pluck.filter_lfo_rate = 3.0
	exp_pluck.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	exp_pluck.drive = 0.0
	exp_pluck.bit_depth = 16
	exp_pluck.sample_hold = 1
	# ---- Space
	exp_pluck.delay_time = 0.0
	exp_pluck.delay_feedback = 0.4
	exp_pluck.delay_mix = 0.0
	# ---- Output
	exp_pluck.volume_db = -10.0  # *
	exp_pluck.normalize = true
	exp_pluck.sample_rate = 44100
	exp_pluck.loop = false
	exp_pluck.noise_seed = 1
	exp_pluck.condition = &""
	p[&"p_exp_pluck"] = exp_pluck

	var lofi_blip := SynthPatch.new()  # showcases: sample_rate 22050 and normalize off
	# ---- Oscillator
	lofi_blip.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	lofi_blip.duty = 0.5
	lofi_blip.base_freq = 990.0  # *
	lofi_blip.noise_mix = 0.0
	lofi_blip.noise_tone = 1.0
	lofi_blip.sub_mix = 0.0
	lofi_blip.detune_cents = 0.0
	lofi_blip.detune_mix = 0.0
	lofi_blip.pwm_depth = 0.0
	lofi_blip.pwm_rate = 2.0
	lofi_blip.ring_ratio = 0.0
	lofi_blip.ring_mix = 0.0
	# ---- Pitch motion
	lofi_blip.pitch_sweep_semitones = 7.0  # *
	lofi_blip.pitch_sweep_curve = 1.0
	lofi_blip.vibrato_depth = 0.0
	lofi_blip.vibrato_rate = 6.0
	lofi_blip.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	lofi_blip.vibrato_fade_in = 0.0
	lofi_blip.arpeggio = []
	lofi_blip.arpeggio_rate = 20.0
	lofi_blip.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	lofi_blip.arpeggio_glide = 0.0
	# ---- FM
	lofi_blip.fm_ratio = 0.0
	lofi_blip.fm_depth = 0.0
	lofi_blip.fm_decay = 0.0
	# ---- Amp envelope
	lofi_blip.attack = 0.0  # *
	lofi_blip.decay = 0.08  # *
	lofi_blip.sustain_level = 0.0
	lofi_blip.sustain_time = 0.0
	lofi_blip.release = 0.02  # *
	lofi_blip.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	lofi_blip.tremolo_depth = 0.0
	lofi_blip.tremolo_rate = 6.0
	lofi_blip.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	lofi_blip.repeat_rate = 0.0
	# ---- Filter
	lofi_blip.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	lofi_blip.cutoff = 2000.0
	lofi_blip.cutoff_sweep_octaves = 0.0
	lofi_blip.resonance = 0.0
	lofi_blip.filter_lfo_depth = 0.0
	lofi_blip.filter_lfo_rate = 3.0
	lofi_blip.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	lofi_blip.drive = 0.0
	lofi_blip.bit_depth = 16
	lofi_blip.sample_hold = 1
	# ---- Space
	lofi_blip.delay_time = 0.0
	lofi_blip.delay_feedback = 0.4
	lofi_blip.delay_mix = 0.0
	# ---- Output
	lofi_blip.volume_db = -14.0  # *
	lofi_blip.normalize = false  # *
	lofi_blip.sample_rate = 22050  # *
	lofi_blip.loop = false
	lofi_blip.noise_seed = 1
	lofi_blip.condition = &""
	p[&"p_lofi_blip"] = lofi_blip

	var grit_alt := SynthPatch.new()  # showcases: noise_seed (a different noise texture)
	# ---- Oscillator
	grit_alt.wave = SynthPatch.Wave.NOISE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	grit_alt.duty = 0.5
	grit_alt.base_freq = 440.0
	grit_alt.noise_mix = 0.0
	grit_alt.noise_tone = 1.0
	grit_alt.sub_mix = 0.0
	grit_alt.detune_cents = 0.0
	grit_alt.detune_mix = 0.0
	grit_alt.pwm_depth = 0.0
	grit_alt.pwm_rate = 2.0
	grit_alt.ring_ratio = 0.0
	grit_alt.ring_mix = 0.0
	# ---- Pitch motion
	grit_alt.pitch_sweep_semitones = 0.0
	grit_alt.pitch_sweep_curve = 1.0
	grit_alt.vibrato_depth = 0.0
	grit_alt.vibrato_rate = 6.0
	grit_alt.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	grit_alt.vibrato_fade_in = 0.0
	grit_alt.arpeggio = []
	grit_alt.arpeggio_rate = 20.0
	grit_alt.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	grit_alt.arpeggio_glide = 0.0
	# ---- FM
	grit_alt.fm_ratio = 0.0
	grit_alt.fm_depth = 0.0
	grit_alt.fm_decay = 0.0
	# ---- Amp envelope
	grit_alt.attack = 0.0  # *
	grit_alt.decay = 0.15
	grit_alt.sustain_level = 0.0
	grit_alt.sustain_time = 0.0
	grit_alt.release = 0.05
	grit_alt.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	grit_alt.tremolo_depth = 0.0
	grit_alt.tremolo_rate = 6.0
	grit_alt.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	grit_alt.repeat_rate = 0.0
	# ---- Filter
	grit_alt.filter_mode = SynthPatch.FilterMode.BANDPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	grit_alt.cutoff = 1100.0  # *
	grit_alt.cutoff_sweep_octaves = 0.0
	grit_alt.resonance = 0.5  # *
	grit_alt.filter_lfo_depth = 0.0
	grit_alt.filter_lfo_rate = 3.0
	grit_alt.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	grit_alt.drive = 0.0
	grit_alt.bit_depth = 16
	grit_alt.sample_hold = 3  # *
	# ---- Space
	grit_alt.delay_time = 0.0
	grit_alt.delay_feedback = 0.4
	grit_alt.delay_mix = 0.0
	# ---- Output
	grit_alt.volume_db = -6.0  # *
	grit_alt.normalize = true
	grit_alt.sample_rate = 44100
	grit_alt.loop = false
	grit_alt.noise_seed = 7  # *
	grit_alt.condition = &""
	p[&"p_grit_alt"] = grit_alt

	var anvil := SynthPatch.new()  # showcases: condition flag (always plays under "metal")
	# ---- Oscillator
	anvil.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	anvil.duty = 0.5
	anvil.base_freq = 440.0
	anvil.noise_mix = 0.3  # *
	anvil.noise_tone = 1.0
	anvil.sub_mix = 0.0
	anvil.detune_cents = 0.0
	anvil.detune_mix = 0.0
	anvil.pwm_depth = 0.0
	anvil.pwm_rate = 2.0
	anvil.ring_ratio = 0.0
	anvil.ring_mix = 0.0
	# ---- Pitch motion
	anvil.pitch_sweep_semitones = 0.0
	anvil.pitch_sweep_curve = 1.0
	anvil.vibrato_depth = 0.0
	anvil.vibrato_rate = 6.0
	anvil.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	anvil.vibrato_fade_in = 0.0
	anvil.arpeggio = []
	anvil.arpeggio_rate = 20.0
	anvil.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	anvil.arpeggio_glide = 0.0
	# ---- FM
	anvil.fm_ratio = 0.0
	anvil.fm_depth = 0.0
	anvil.fm_decay = 0.0
	# ---- Amp envelope
	anvil.attack = 0.0  # *
	anvil.decay = 0.4  # *
	anvil.sustain_level = 0.0
	anvil.sustain_time = 0.0
	anvil.release = 0.1  # *
	anvil.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	anvil.tremolo_depth = 0.0
	anvil.tremolo_rate = 6.0
	anvil.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	anvil.repeat_rate = 0.0
	# ---- Filter
	anvil.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	anvil.cutoff = 2000.0
	anvil.cutoff_sweep_octaves = 0.0
	anvil.resonance = 0.0
	anvil.filter_lfo_depth = 0.0
	anvil.filter_lfo_rate = 3.0
	anvil.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	anvil.drive = 0.0
	anvil.bit_depth = 16
	anvil.sample_hold = 1
	# ---- Space
	anvil.delay_time = 0.0
	anvil.delay_feedback = 0.4
	anvil.delay_mix = 0.0
	# ---- Output
	anvil.volume_db = -5.0  # *
	anvil.normalize = true
	anvil.sample_rate = 44100
	anvil.loop = false
	anvil.noise_seed = 1
	anvil.condition = &"metal"  # *
	p[&"p_anvil"] = anvil

	var tremolo_drone := SynthPatch.new()  # showcases: tremolo + vibrato TRIANGLE together (loop)
	# ---- Oscillator
	tremolo_drone.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	tremolo_drone.duty = 0.5
	tremolo_drone.base_freq = 165.0  # *
	tremolo_drone.noise_mix = 0.0
	tremolo_drone.noise_tone = 1.0
	tremolo_drone.sub_mix = 0.3  # *
	tremolo_drone.detune_cents = 0.0
	tremolo_drone.detune_mix = 0.0
	tremolo_drone.pwm_depth = 0.0
	tremolo_drone.pwm_rate = 2.0
	tremolo_drone.ring_ratio = 0.0
	tremolo_drone.ring_mix = 0.0
	# ---- Pitch motion
	tremolo_drone.pitch_sweep_semitones = 0.0
	tremolo_drone.pitch_sweep_curve = 1.0
	tremolo_drone.vibrato_depth = 0.4  # *
	tremolo_drone.vibrato_rate = 0.8  # *
	tremolo_drone.vibrato_shape = SynthPatch.LfoShape.TRIANGLE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	tremolo_drone.vibrato_fade_in = 0.0
	tremolo_drone.arpeggio = []
	tremolo_drone.arpeggio_rate = 20.0
	tremolo_drone.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	tremolo_drone.arpeggio_glide = 0.0
	# ---- FM
	tremolo_drone.fm_ratio = 0.0
	tremolo_drone.fm_depth = 0.0
	tremolo_drone.fm_decay = 0.0
	# ---- Amp envelope
	tremolo_drone.attack = 0.0  # *
	tremolo_drone.decay = 0.0  # *
	tremolo_drone.sustain_level = 1.0  # *
	tremolo_drone.sustain_time = 2.5  # *
	tremolo_drone.release = 0.0  # *
	tremolo_drone.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	tremolo_drone.tremolo_depth = 0.4  # *
	tremolo_drone.tremolo_rate = 2.5  # *
	tremolo_drone.tremolo_shape = SynthPatch.LfoShape.TRIANGLE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	tremolo_drone.repeat_rate = 0.0
	# ---- Filter
	tremolo_drone.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	tremolo_drone.cutoff = 2000.0
	tremolo_drone.cutoff_sweep_octaves = 0.0
	tremolo_drone.resonance = 0.0
	tremolo_drone.filter_lfo_depth = 0.0
	tremolo_drone.filter_lfo_rate = 3.0
	tremolo_drone.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	tremolo_drone.drive = 0.0
	tremolo_drone.bit_depth = 16
	tremolo_drone.sample_hold = 1
	# ---- Space
	tremolo_drone.delay_time = 0.0
	tremolo_drone.delay_feedback = 0.4
	tremolo_drone.delay_mix = 0.0
	# ---- Output
	tremolo_drone.volume_db = -14.0  # *
	tremolo_drone.normalize = true
	tremolo_drone.sample_rate = 44100
	tremolo_drone.loop = true  # *
	tremolo_drone.noise_seed = 1
	tremolo_drone.condition = &""
	p[&"p_tremolo_drone"] = tremolo_drone

	var Projectile_Magic1 := SynthPatch.new()
	# ---- Oscillator
	Projectile_Magic1.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	Projectile_Magic1.duty = 0.5
	Projectile_Magic1.base_freq = 440.0
	Projectile_Magic1.noise_mix = 0.0
	Projectile_Magic1.noise_tone = 1.0
	Projectile_Magic1.sub_mix = 0.2  # *
	Projectile_Magic1.detune_cents = 0.0
	Projectile_Magic1.detune_mix = 0.0
	Projectile_Magic1.pwm_depth = 0.0
	Projectile_Magic1.pwm_rate = 2.0
	Projectile_Magic1.ring_ratio = 0.0
	Projectile_Magic1.ring_mix = 0.0
	# ---- Pitch motion
	Projectile_Magic1.pitch_sweep_semitones = 0.0
	Projectile_Magic1.pitch_sweep_curve = 0.8  # *
	Projectile_Magic1.vibrato_depth = 1.2  # *
	Projectile_Magic1.vibrato_rate = 16.0  # *
	Projectile_Magic1.vibrato_shape = SynthPatch.LfoShape.SQUARE  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	Projectile_Magic1.vibrato_fade_in = 1.2  # *
	Projectile_Magic1.arpeggio = [0, 7, 12]  # *
	Projectile_Magic1.arpeggio_rate = 50.0  # *
	Projectile_Magic1.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	Projectile_Magic1.arpeggio_glide = 0.0
	# ---- FM
	Projectile_Magic1.fm_ratio = 0.0
	Projectile_Magic1.fm_depth = 0.0
	Projectile_Magic1.fm_decay = 0.0
	# ---- Amp envelope
	Projectile_Magic1.attack = 0.055  # *
	Projectile_Magic1.decay = 0.15
	Projectile_Magic1.sustain_level = 0.5  # *
	Projectile_Magic1.sustain_time = 0.9  # *
	Projectile_Magic1.release = 1.595  # *
	Projectile_Magic1.envelope_curve = SynthPatch.EnvCurve.EXPONENTIAL  # * choices: LINEAR EXPONENTIAL
	Projectile_Magic1.tremolo_depth = 0.0
	Projectile_Magic1.tremolo_rate = 6.0
	Projectile_Magic1.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	Projectile_Magic1.repeat_rate = 0.0
	# ---- Filter
	Projectile_Magic1.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	Projectile_Magic1.cutoff = 2000.0
	Projectile_Magic1.cutoff_sweep_octaves = 0.0
	Projectile_Magic1.resonance = 0.0
	Projectile_Magic1.filter_lfo_depth = 0.0
	Projectile_Magic1.filter_lfo_rate = 3.0
	Projectile_Magic1.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	Projectile_Magic1.drive = 0.0
	Projectile_Magic1.bit_depth = 16
	Projectile_Magic1.sample_hold = 1
	# ---- Space
	Projectile_Magic1.delay_time = 0.71  # *
	Projectile_Magic1.delay_feedback = 0.8  # *
	Projectile_Magic1.delay_mix = 0.0
	# ---- Output
	Projectile_Magic1.volume_db = 0.0
	Projectile_Magic1.normalize = false  # *
	Projectile_Magic1.sample_rate = 44100
	Projectile_Magic1.loop = false
	Projectile_Magic1.noise_seed = 1
	Projectile_Magic1.condition = &""
	p[&"Projectile_Magic1"] = Projectile_Magic1

	var projectile_Magic2 := SynthPatch.new()
	# ---- Oscillator
	projectile_Magic2.wave = SynthPatch.Wave.SINE  # * choices: SINE SQUARE SAW TRIANGLE NOISE
	projectile_Magic2.duty = 0.5
	projectile_Magic2.base_freq = 440.0
	projectile_Magic2.noise_mix = 0.0
	projectile_Magic2.noise_tone = 1.0
	projectile_Magic2.sub_mix = 0.2  # *
	projectile_Magic2.detune_cents = 0.0
	projectile_Magic2.detune_mix = 0.0
	projectile_Magic2.pwm_depth = 0.0
	projectile_Magic2.pwm_rate = 2.0
	projectile_Magic2.ring_ratio = 0.0
	projectile_Magic2.ring_mix = 0.0
	# ---- Pitch motion
	projectile_Magic2.pitch_sweep_semitones = 0.0
	projectile_Magic2.pitch_sweep_curve = 0.8  # *
	projectile_Magic2.vibrato_depth = 1.2  # *
	projectile_Magic2.vibrato_rate = 16.0  # *
	projectile_Magic2.vibrato_shape = SynthPatch.LfoShape.RANDOM  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
	projectile_Magic2.vibrato_fade_in = 1.2  # *
	projectile_Magic2.arpeggio = [0, 7, 12, 7, 12]  # *
	projectile_Magic2.arpeggio_rate = 15.0  # *
	projectile_Magic2.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	projectile_Magic2.arpeggio_glide = 0.0
	# ---- FM
	projectile_Magic2.fm_ratio = 0.0
	projectile_Magic2.fm_depth = 0.0
	projectile_Magic2.fm_decay = 0.0
	# ---- Amp envelope
	projectile_Magic2.attack = 0.055  # *
	projectile_Magic2.decay = 0.15
	projectile_Magic2.sustain_level = 0.5  # *
	projectile_Magic2.sustain_time = 0.9  # *
	projectile_Magic2.release = 15.595  # *
	projectile_Magic2.envelope_curve = SynthPatch.EnvCurve.EXPONENTIAL  # * choices: LINEAR EXPONENTIAL
	projectile_Magic2.tremolo_depth = 0.0
	projectile_Magic2.tremolo_rate = 6.0
	projectile_Magic2.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	projectile_Magic2.repeat_rate = 0.0
	# ---- Filter
	projectile_Magic2.filter_mode = SynthPatch.FilterMode.LOWPASS  # * choices: NONE LOWPASS HIGHPASS BANDPASS
	projectile_Magic2.cutoff = 2000.0
	projectile_Magic2.cutoff_sweep_octaves = 0.0
	projectile_Magic2.resonance = 0.0
	projectile_Magic2.filter_lfo_depth = 0.0
	projectile_Magic2.filter_lfo_rate = 3.0
	projectile_Magic2.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	projectile_Magic2.drive = 0.0
	projectile_Magic2.bit_depth = 16
	projectile_Magic2.sample_hold = 1
	# ---- Space
	projectile_Magic2.delay_time = 0.71  # *
	projectile_Magic2.delay_feedback = 0.8  # *
	projectile_Magic2.delay_mix = 0.0
	# ---- Output
	projectile_Magic2.volume_db = 0.0
	projectile_Magic2.normalize = false  # *
	projectile_Magic2.sample_rate = 44100
	projectile_Magic2.loop = false
	projectile_Magic2.noise_seed = 1
	projectile_Magic2.condition = &""
	p[&"projectile_Magic2"] = projectile_Magic2

	var new_sound := SynthPatch.new()
	# ---- Oscillator
	new_sound.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	new_sound.duty = 0.5
	new_sound.base_freq = 440.0
	new_sound.noise_mix = 0.0
	new_sound.noise_tone = 1.0
	new_sound.sub_mix = 0.0
	new_sound.detune_cents = 0.0
	new_sound.detune_mix = 0.0
	new_sound.pwm_depth = 0.0
	new_sound.pwm_rate = 2.0
	new_sound.ring_ratio = 0.0
	new_sound.ring_mix = 0.0
	# ---- Pitch motion
	new_sound.pitch_sweep_semitones = 0.0
	new_sound.pitch_sweep_curve = 1.0
	new_sound.vibrato_depth = 0.0
	new_sound.vibrato_rate = 6.0
	new_sound.vibrato_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	new_sound.vibrato_fade_in = 0.0
	new_sound.arpeggio = []
	new_sound.arpeggio_rate = 20.0
	new_sound.arpeggio_mode = SynthPatch.ArpMode.LOOP  # choices: LOOP ONCE PING_PONG RANDOM
	new_sound.arpeggio_glide = 0.0
	# ---- FM
	new_sound.fm_ratio = 0.0
	new_sound.fm_depth = 0.0
	new_sound.fm_decay = 0.0
	# ---- Amp envelope
	new_sound.attack = 0.005
	new_sound.decay = 0.15
	new_sound.sustain_level = 0.0
	new_sound.sustain_time = 0.0
	new_sound.release = 0.05
	new_sound.envelope_curve = SynthPatch.EnvCurve.LINEAR  # choices: LINEAR EXPONENTIAL
	new_sound.tremolo_depth = 0.0
	new_sound.tremolo_rate = 6.0
	new_sound.tremolo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	new_sound.repeat_rate = 0.0
	# ---- Filter
	new_sound.filter_mode = SynthPatch.FilterMode.NONE  # choices: NONE LOWPASS HIGHPASS BANDPASS
	new_sound.cutoff = 2000.0
	new_sound.cutoff_sweep_octaves = 0.0
	new_sound.resonance = 0.0
	new_sound.filter_lfo_depth = 0.0
	new_sound.filter_lfo_rate = 3.0
	new_sound.filter_lfo_shape = SynthPatch.LfoShape.SINE  # choices: SINE TRIANGLE SQUARE SAW RANDOM
	# ---- Dirt
	new_sound.drive = 0.0
	new_sound.bit_depth = 16
	new_sound.sample_hold = 1
	# ---- Space
	new_sound.delay_time = 0.0
	new_sound.delay_feedback = 0.4
	new_sound.delay_mix = 0.0
	# ---- Output
	new_sound.volume_db = 0.0
	new_sound.normalize = true
	new_sound.sample_rate = 44100
	new_sound.loop = false
	new_sound.noise_seed = 1
	new_sound.condition = &""
	p[&"new_sound"] = new_sound

	return p
