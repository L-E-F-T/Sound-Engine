class_name ConditionPalette
extends RefCounted
## The game's conditions, as a table: named colourings that any sound can be played under.
## Mirrors SfxPalette: that file holds SynthPatch recipes, this one holds SfxCondition recipes.
##
## Use them to make one sound serve many objects: play "hit" under "wood" for a crate and under
## "metal" for a cannon, or play anything under "underwater" when the ship dives. Pick one in
## the Sound Lab's Condition dropdown to hear it applied to every sound.
##
## Each entry is an [SfxCondition]. Bus effects are Godot's built-in AudioEffect resources and
## apply to synth sounds and audio files alike; patch_overrides only affect synth sounds.
##
## Every block lists every field: each effect with all its properties, volume and pitch, and every
## synth knob in patch_overrides (commented out unless overridden). A trailing `# *` marks a value
## changed from its default. The Condition Lab's editor reads and writes this layout and keeps
## your own comments. The helpers at the bottom (_lowpass, _reverb, ...) still work for blocks you
## write by hand.


static func build() -> Dictionary[StringName, SfxCondition]:
	var c: Dictionary[StringName, SfxCondition] = {}

	# -------------------------------------------------------------- Materials
	# What the object being hit is made of. Pair with generic hits/breaks or with any sound.

	var wood := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var wood_fx0 := AudioEffectBandPassFilter.new()
	wood_fx0.cutoff_hz = 900.0  # *
	wood_fx0.resonance = 0.6  # *
	wood_fx0.db = 0  # 6 dB
	var wood_fx1 := AudioEffectDistortion.new()
	wood_fx1.mode = 3  # * Overdrive
	wood_fx1.pre_gain = 0.0
	wood_fx1.keep_hf_hz = 16000.0
	wood_fx1.drive = 0.15  # *
	wood_fx1.post_gain = -3.0  # *
	wood.effects = [wood_fx0, wood_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	wood.volume_db = 0.0
	wood.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	wood.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		"filter_mode": SynthPatch.FilterMode.BANDPASS,  # * choices: NONE LOWPASS HIGHPASS BANDPASS
		"cutoff": 800.0,  # *
		# "cutoff_sweep_octaves": 0.0,
		"resonance": 0.55,  # *
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		"sample_hold": 3,  # *
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"wood"] = wood

	var metal := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var metal_fx0 := AudioEffectHighPassFilter.new()
	metal_fx0.cutoff_hz = 300.0  # *
	metal_fx0.resonance = 0.3  # *
	metal_fx0.db = 0  # 6 dB
	var metal_fx1 := AudioEffectReverb.new()
	metal_fx1.predelay_msec = 150.0
	metal_fx1.predelay_feedback = 0.4
	metal_fx1.room_size = 0.35  # *
	metal_fx1.damping = 0.12  # *
	metal_fx1.spread = 1.0
	metal_fx1.hipass = 0.0
	metal_fx1.dry = 1.0
	metal_fx1.wet = 0.5
	metal.effects = [metal_fx0, metal_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	metal.volume_db = 0.0
	metal.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	metal.patch_overrides = {
		"wave": SynthPatch.Wave.SINE,  # * choices: SINE SQUARE SAW TRIANGLE NOISE
		# "duty": 0.5,
		"base_freq": 520.0,  # *
		"noise_mix": 0.3,  # *
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		"fm_ratio": 2.41,  # *
		"fm_depth": 7.0,  # *
		"fm_decay": 0.25,  # *
		# "attack": 0.005,
		"decay": 0.5,  # *
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		"filter_mode": SynthPatch.FilterMode.NONE,  # * choices: NONE LOWPASS HIGHPASS BANDPASS
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"metal"] = metal

	var stone := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var stone_fx0 := AudioEffectLowPassFilter.new()
	stone_fx0.cutoff_hz = 1400.0  # *
	stone_fx0.resonance = 0.3  # *
	stone_fx0.db = 0  # 6 dB
	var stone_fx1 := AudioEffectDistortion.new()
	stone_fx1.mode = 3  # * Overdrive
	stone_fx1.pre_gain = 0.0
	stone_fx1.keep_hf_hz = 16000.0
	stone_fx1.drive = 0.3  # *
	stone_fx1.post_gain = -3.0  # *
	stone.effects = [stone_fx0, stone_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	stone.volume_db = 0.0
	stone.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	stone.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		"filter_mode": SynthPatch.FilterMode.LOWPASS,  # * choices: NONE LOWPASS HIGHPASS BANDPASS
		"cutoff": 1300.0,  # *
		"cutoff_sweep_octaves": -2.5,  # *
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		"drive": 0.5,  # *
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"stone"] = stone

	var glass := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var glass_fx0 := AudioEffectHighPassFilter.new()
	glass_fx0.cutoff_hz = 2500.0  # *
	glass_fx0.resonance = 0.4  # *
	glass_fx0.db = 0  # 6 dB
	var glass_fx1 := AudioEffectReverb.new()
	glass_fx1.predelay_msec = 150.0
	glass_fx1.predelay_feedback = 0.4
	glass_fx1.room_size = 0.2  # *
	glass_fx1.damping = 0.3  # *
	glass_fx1.spread = 1.0
	glass_fx1.hipass = 0.0
	glass_fx1.dry = 1.0
	glass_fx1.wet = 0.4  # *
	glass.effects = [glass_fx0, glass_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	glass.volume_db = 0.0
	glass.pitch_scale = 1.5  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	glass.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		"filter_mode": SynthPatch.FilterMode.HIGHPASS,  # * choices: NONE LOWPASS HIGHPASS BANDPASS
		"cutoff": 3000.0,  # *
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		"sample_hold": 2,  # *
		"delay_time": 0.03,  # *
		"delay_feedback": 0.5,  # *
		"delay_mix": 0.4,  # *
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"glass"] = glass

	# ----------------------------------------------------------- Environments
	# Where the listener or the sound is. Usually set on everything at once from gameplay.

	var underwater := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var underwater_fx0 := AudioEffectLowPassFilter.new()
	underwater_fx0.cutoff_hz = 500.0  # *
	underwater_fx0.resonance = 0.5
	underwater_fx0.db = 0  # 6 dB
	underwater.effects = [underwater_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	underwater.volume_db = -4.0  # *
	underwater.pitch_scale = 0.9  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	underwater.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"underwater"] = underwater

	var distant := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var distant_fx0 := AudioEffectLowPassFilter.new()
	distant_fx0.cutoff_hz = 1800.0  # *
	distant_fx0.resonance = 0.2  # *
	distant_fx0.db = 0  # 6 dB
	var distant_fx1 := AudioEffectReverb.new()
	distant_fx1.predelay_msec = 150.0
	distant_fx1.predelay_feedback = 0.4
	distant_fx1.room_size = 0.8
	distant_fx1.damping = 0.5
	distant_fx1.spread = 1.0
	distant_fx1.hipass = 0.0
	distant_fx1.dry = 1.0
	distant_fx1.wet = 0.6  # *
	distant.effects = [distant_fx0, distant_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	distant.volume_db = -10.0  # *
	distant.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	distant.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"distant"] = distant

	var shielded := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var shielded_fx0 := AudioEffectBandPassFilter.new()
	shielded_fx0.cutoff_hz = 1200.0  # *
	shielded_fx0.resonance = 0.8  # *
	shielded_fx0.db = 0  # 6 dB
	var shielded_fx1 := AudioEffectPhaser.new()
	shielded_fx1.range_min_hz = 440.0
	shielded_fx1.range_max_hz = 1600.0
	shielded_fx1.rate_hz = 2.5  # *
	shielded_fx1.feedback = 0.7
	shielded_fx1.depth = 1.0
	shielded.effects = [shielded_fx0, shielded_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	shielded.volume_db = -3.0  # *
	shielded.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	shielded.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"shielded"] = shielded

	var cavern := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var cavern_fx0 := AudioEffectReverb.new()
	cavern_fx0.predelay_msec = 150.0
	cavern_fx0.predelay_feedback = 0.4
	cavern_fx0.room_size = 0.9  # *
	cavern_fx0.damping = 0.3  # *
	cavern_fx0.spread = 1.0
	cavern_fx0.hipass = 0.0
	cavern_fx0.dry = 1.0
	cavern_fx0.wet = 0.7  # *
	cavern.effects = [cavern_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	cavern.volume_db = 0.0
	cavern.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	cavern.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"cavern"] = cavern

	# ---------------------------------------------------------------- Flavour
	# Character changes for variety: the same sound as something bigger, smaller, or broken.

	var huge := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var huge_fx0 := AudioEffectLowPassFilter.new()
	huge_fx0.cutoff_hz = 2500.0  # *
	huge_fx0.resonance = 0.3  # *
	huge_fx0.db = 0  # 6 dB
	var huge_fx1 := AudioEffectDistortion.new()
	huge_fx1.mode = 3  # * Overdrive
	huge_fx1.pre_gain = 0.0
	huge_fx1.keep_hf_hz = 16000.0
	huge_fx1.drive = 0.2  # *
	huge_fx1.post_gain = -3.0  # *
	var huge_fx2 := AudioEffectReverb.new()
	huge_fx2.predelay_msec = 150.0
	huge_fx2.predelay_feedback = 0.4
	huge_fx2.room_size = 0.6  # *
	huge_fx2.damping = 0.4  # *
	huge_fx2.spread = 1.0
	huge_fx2.hipass = 0.0
	huge_fx2.dry = 1.0
	huge_fx2.wet = 0.4  # *
	huge.effects = [huge_fx0, huge_fx1, huge_fx2]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	huge.volume_db = 2.0  # *
	huge.pitch_scale = 0.7  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	huge.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"huge"] = huge

	var tiny := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var tiny_fx0 := AudioEffectHighPassFilter.new()
	tiny_fx0.cutoff_hz = 600.0  # *
	tiny_fx0.resonance = 0.2  # *
	tiny_fx0.db = 0  # 6 dB
	tiny.effects = [tiny_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	tiny.volume_db = -6.0  # *
	tiny.pitch_scale = 1.6  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	tiny.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"tiny"] = tiny

	var radio := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var radio_fx0 := AudioEffectBandPassFilter.new()
	radio_fx0.cutoff_hz = 1500.0  # *
	radio_fx0.resonance = 0.9  # *
	radio_fx0.db = 0  # 6 dB
	var radio_fx1 := AudioEffectDistortion.new()
	radio_fx1.mode = 3  # * Overdrive
	radio_fx1.pre_gain = 0.0
	radio_fx1.keep_hf_hz = 16000.0
	radio_fx1.drive = 0.45  # *
	radio_fx1.post_gain = -3.0  # *
	radio.effects = [radio_fx0, radio_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	radio.volume_db = -3.0  # *
	radio.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	radio.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"radio"] = radio

	var magic := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var magic_fx0 := AudioEffectChorus.new()
	magic_fx0.voice_count = 2
	magic_fx0.dry = 1.0
	magic_fx0.wet = 0.4  # *
	magic_fx0.set("voice/1/delay_ms", 15.0)
	magic_fx0.set("voice/1/rate_hz", 0.8)
	magic_fx0.set("voice/1/depth_ms", 2.0)
	magic_fx0.set("voice/1/level_db", 0.0)
	magic_fx0.set("voice/1/cutoff_hz", 8000.0)
	magic_fx0.set("voice/1/pan", -0.5)
	magic_fx0.set("voice/2/delay_ms", 20.0)
	magic_fx0.set("voice/2/rate_hz", 1.2)
	magic_fx0.set("voice/2/depth_ms", 3.0)
	magic_fx0.set("voice/2/level_db", 0.0)
	magic_fx0.set("voice/2/cutoff_hz", 8000.0)
	magic_fx0.set("voice/2/pan", 0.5)
	var magic_fx1 := AudioEffectReverb.new()
	magic_fx1.predelay_msec = 150.0
	magic_fx1.predelay_feedback = 0.4
	magic_fx1.room_size = 0.5  # *
	magic_fx1.damping = 0.2  # *
	magic_fx1.spread = 1.0
	magic_fx1.hipass = 0.0
	magic_fx1.dry = 1.0
	magic_fx1.wet = 0.45  # *
	magic.effects = [magic_fx0, magic_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	magic.volume_db = 0.0
	magic.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	magic.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		"fm_ratio": 3.01,  # *
		"fm_depth": 3.0,  # *
		"fm_decay": 0.2,  # *
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		"delay_time": 0.12,  # *
		"delay_feedback": 0.45,  # *
		"delay_mix": 0.35,  # *
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"magic"] = magic

	# ------------------------------------------------------------- Modulating
	# Conditions that move: synth-knob overrides add tremolo, vibrato, filter wobble or stutter
	# to any synth sound, and the bus effects give files a related motion. Each uses an effect
	# type or override no other condition uses, named in its comment.

	var haunted := SfxCondition.new()  # showcases: RANDOM vibrato + tremolo overrides, AudioEffectDelay
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var haunted_fx0 := AudioEffectDelay.new()
	haunted_fx0.dry = 1.0
	haunted_fx0.tap1_active = true
	haunted_fx0.tap1_delay_ms = 180.0  # *
	haunted_fx0.tap1_level_db = -7.9588003  # *
	haunted_fx0.tap1_pan = 0.2
	haunted_fx0.tap2_active = false  # *
	haunted_fx0.tap2_delay_ms = 500.0
	haunted_fx0.tap2_level_db = -12.0
	haunted_fx0.tap2_pan = -0.4
	haunted_fx0.feedback_active = true  # *
	haunted_fx0.feedback_delay_ms = 180.0  # *
	haunted_fx0.feedback_level_db = -6.9357495  # *
	haunted_fx0.feedback_lowpass = 16000.0
	var haunted_fx1 := AudioEffectReverb.new()
	haunted_fx1.predelay_msec = 150.0
	haunted_fx1.predelay_feedback = 0.4
	haunted_fx1.room_size = 0.8
	haunted_fx1.damping = 0.2  # *
	haunted_fx1.spread = 1.0
	haunted_fx1.hipass = 0.0
	haunted_fx1.dry = 1.0
	haunted_fx1.wet = 0.5
	haunted.effects = [haunted_fx0, haunted_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	haunted.volume_db = 0.0
	haunted.pitch_scale = 0.9  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	haunted.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		"vibrato_depth": 1.5,  # *
		"vibrato_rate": 5.0,  # *
		"vibrato_shape": SynthPatch.LfoShape.RANDOM,  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		"tremolo_depth": 0.6,  # *
		"tremolo_rate": 7.0,  # *
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"haunted"] = haunted

	var pulsing := SfxCondition.new()  # showcases: SQUARE tremolo override (rhythmic chop)
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var pulsing_fx0 := AudioEffectDelay.new()
	pulsing_fx0.dry = 1.0
	pulsing_fx0.tap1_active = true
	pulsing_fx0.tap1_delay_ms = 125.0  # *
	pulsing_fx0.tap1_level_db = -10.457575  # *
	pulsing_fx0.tap1_pan = 0.2
	pulsing_fx0.tap2_active = false  # *
	pulsing_fx0.tap2_delay_ms = 500.0
	pulsing_fx0.tap2_level_db = -12.0
	pulsing_fx0.tap2_pan = -0.4
	pulsing_fx0.feedback_active = true  # *
	pulsing_fx0.feedback_delay_ms = 125.0  # *
	pulsing_fx0.feedback_level_db = -10.457575  # *
	pulsing_fx0.feedback_lowpass = 16000.0
	pulsing.effects = [pulsing_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	pulsing.volume_db = 0.0
	pulsing.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	pulsing.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		"tremolo_depth": 1.0,  # *
		"tremolo_rate": 8.0,  # *
		"tremolo_shape": SynthPatch.LfoShape.SQUARE,  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"pulsing"] = pulsing

	var wobbly := SfxCondition.new()  # showcases: filter LFO override, AudioEffectNotchFilter
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var wobbly_fx0 := AudioEffectNotchFilter.new()
	wobbly_fx0.cutoff_hz = 1200.0  # *
	wobbly_fx0.resonance = 0.5
	wobbly_fx0.gain = 1.0
	wobbly_fx0.db = 0  # 6 dB
	var wobbly_fx1 := AudioEffectPhaser.new()
	wobbly_fx1.range_min_hz = 440.0
	wobbly_fx1.range_max_hz = 1600.0
	wobbly_fx1.rate_hz = 2.5  # *
	wobbly_fx1.feedback = 0.7
	wobbly_fx1.depth = 1.0
	wobbly.effects = [wobbly_fx0, wobbly_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	wobbly.volume_db = 0.0
	wobbly.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	wobbly.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		"filter_mode": SynthPatch.FilterMode.LOWPASS,  # * choices: NONE LOWPASS HIGHPASS BANDPASS
		"cutoff": 800.0,  # *
		# "cutoff_sweep_octaves": 0.0,
		"resonance": 0.7,  # *
		"filter_lfo_depth": 2.5,  # *
		"filter_lfo_rate": 5.0,  # *
		"filter_lfo_shape": SynthPatch.LfoShape.TRIANGLE,  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"wobbly"] = wobbly

	var stuttered := SfxCondition.new()  # showcases: repeat_rate override (stutter), short slapback delay
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var stuttered_fx0 := AudioEffectDelay.new()
	stuttered_fx0.dry = 1.0
	stuttered_fx0.tap1_active = true
	stuttered_fx0.tap1_delay_ms = 40.0  # *
	stuttered_fx0.tap1_level_db = -10.457575  # *
	stuttered_fx0.tap1_pan = 0.2
	stuttered_fx0.tap2_active = false  # *
	stuttered_fx0.tap2_delay_ms = 500.0
	stuttered_fx0.tap2_level_db = -12.0
	stuttered_fx0.tap2_pan = -0.4
	stuttered_fx0.feedback_active = true  # *
	stuttered_fx0.feedback_delay_ms = 40.0  # *
	stuttered_fx0.feedback_level_db = -13.9794  # *
	stuttered_fx0.feedback_lowpass = 16000.0
	stuttered.effects = [stuttered_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	stuttered.volume_db = 0.0
	stuttered.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	stuttered.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		"repeat_rate": 12.0,  # *
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"stuttered"] = stuttered

	var drunk := SfxCondition.new()  # showcases: slow SAW vibrato override, AudioEffectPitchShift down
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var drunk_fx0 := AudioEffectPitchShift.new()
	drunk_fx0.pitch_scale = 0.94  # *
	drunk_fx0.oversampling = 4
	drunk_fx0.fft_size = 3  # 2048
	var drunk_fx1 := AudioEffectChorus.new()
	drunk_fx1.voice_count = 2
	drunk_fx1.dry = 1.0
	drunk_fx1.wet = 0.4  # *
	drunk_fx1.set("voice/1/delay_ms", 15.0)
	drunk_fx1.set("voice/1/rate_hz", 0.8)
	drunk_fx1.set("voice/1/depth_ms", 2.0)
	drunk_fx1.set("voice/1/level_db", 0.0)
	drunk_fx1.set("voice/1/cutoff_hz", 8000.0)
	drunk_fx1.set("voice/1/pan", -0.5)
	drunk_fx1.set("voice/2/delay_ms", 20.0)
	drunk_fx1.set("voice/2/rate_hz", 1.2)
	drunk_fx1.set("voice/2/depth_ms", 3.0)
	drunk_fx1.set("voice/2/level_db", 0.0)
	drunk_fx1.set("voice/2/cutoff_hz", 8000.0)
	drunk_fx1.set("voice/2/pan", 0.5)
	drunk.effects = [drunk_fx0, drunk_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	drunk.volume_db = 0.0
	drunk.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	drunk.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		"vibrato_depth": 2.0,  # *
		"vibrato_rate": 1.2,  # *
		"vibrato_shape": SynthPatch.LfoShape.SAW,  # * choices: SINE TRIANGLE SQUARE SAW RANDOM
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"drunk"] = drunk

	var chiptune := SfxCondition.new()  # showcases: PWM + bitcrush overrides, AudioEffectEQ6
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var chiptune_fx0 := AudioEffectEQ6.new()
	chiptune_fx0.set("band_db/32_hz", -6.0)  # *
	chiptune_fx0.set("band_db/100_hz", 0.0)
	chiptune_fx0.set("band_db/320_hz", 3.0)  # *
	chiptune_fx0.set("band_db/1000_hz", 4.0)  # *
	chiptune_fx0.set("band_db/3200_hz", 0.0)
	chiptune_fx0.set("band_db/10000_hz", -8.0)  # *
	chiptune.effects = [chiptune_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	chiptune.volume_db = 0.0
	chiptune.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	chiptune.patch_overrides = {
		"wave": SynthPatch.Wave.SQUARE,  # * choices: SINE SQUARE SAW TRIANGLE NOISE
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		"pwm_depth": 0.3,  # *
		"pwm_rate": 3.0,  # *
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		"bit_depth": 5,  # *
		"sample_hold": 3,  # *
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		"sample_rate": 22050,  # *
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"chiptune"] = chiptune

	var dreamy := SfxCondition.new()  # showcases: detune + sub overrides, AudioEffectHighShelfFilter cut
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var dreamy_fx0 := AudioEffectHighShelfFilter.new()
	dreamy_fx0.cutoff_hz = 4000.0  # *
	dreamy_fx0.resonance = 0.5
	dreamy_fx0.gain = -9.0  # *
	dreamy_fx0.db = 0  # 6 dB
	var dreamy_fx1 := AudioEffectChorus.new()
	dreamy_fx1.voice_count = 2
	dreamy_fx1.dry = 1.0
	dreamy_fx1.wet = 0.4  # *
	dreamy_fx1.set("voice/1/delay_ms", 15.0)
	dreamy_fx1.set("voice/1/rate_hz", 0.8)
	dreamy_fx1.set("voice/1/depth_ms", 2.0)
	dreamy_fx1.set("voice/1/level_db", 0.0)
	dreamy_fx1.set("voice/1/cutoff_hz", 8000.0)
	dreamy_fx1.set("voice/1/pan", -0.5)
	dreamy_fx1.set("voice/2/delay_ms", 20.0)
	dreamy_fx1.set("voice/2/rate_hz", 1.2)
	dreamy_fx1.set("voice/2/depth_ms", 3.0)
	dreamy_fx1.set("voice/2/level_db", 0.0)
	dreamy_fx1.set("voice/2/cutoff_hz", 8000.0)
	dreamy_fx1.set("voice/2/pan", 0.5)
	var dreamy_fx2 := AudioEffectReverb.new()
	dreamy_fx2.predelay_msec = 150.0
	dreamy_fx2.predelay_feedback = 0.4
	dreamy_fx2.room_size = 0.7  # *
	dreamy_fx2.damping = 0.4  # *
	dreamy_fx2.spread = 1.0
	dreamy_fx2.hipass = 0.0
	dreamy_fx2.dry = 1.0
	dreamy_fx2.wet = 0.45  # *
	dreamy.effects = [dreamy_fx0, dreamy_fx1, dreamy_fx2]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	dreamy.volume_db = 0.0
	dreamy.pitch_scale = 0.85  # *
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	dreamy.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		"sub_mix": 0.3,  # *
		"detune_cents": 10.0,  # *
		"detune_mix": 0.5,  # *
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		"vibrato_depth": 0.4,  # *
		"vibrato_rate": 4.5,  # *
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		"vibrato_fade_in": 0.5,  # *
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"dreamy"] = dreamy

	# ------------------------------------------------------------ Mix flavour
	# Static colourings using effect types the materials and environments do not.

	var chipmunk := SfxCondition.new()  # showcases: AudioEffectPitchShift up (small creature)
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var chipmunk_fx0 := AudioEffectPitchShift.new()
	chipmunk_fx0.pitch_scale = 1.5  # *
	chipmunk_fx0.oversampling = 4
	chipmunk_fx0.fft_size = 3  # 2048
	chipmunk.effects = [chipmunk_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	chipmunk.volume_db = -2.0  # *
	chipmunk.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	chipmunk.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"chipmunk"] = chipmunk

	var giant := SfxCondition.new()  # showcases: pitch shift down with a low-shelf boost
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var giant_fx0 := AudioEffectPitchShift.new()
	giant_fx0.pitch_scale = 0.6  # *
	giant_fx0.oversampling = 4
	giant_fx0.fft_size = 3  # 2048
	var giant_fx1 := AudioEffectLowShelfFilter.new()
	giant_fx1.cutoff_hz = 200.0  # *
	giant_fx1.resonance = 0.5
	giant_fx1.gain = 6.0  # *
	giant_fx1.db = 0  # 6 dB
	giant.effects = [giant_fx0, giant_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	giant.volume_db = 2.0  # *
	giant.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	giant.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"giant"] = giant

	var punchy := SfxCondition.new()  # showcases: AudioEffectCompressor (louder, flatter, in-your-face)
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var punchy_fx0 := AudioEffectCompressor.new()
	punchy_fx0.threshold = -18.0  # *
	punchy_fx0.ratio = 6.0  # *
	punchy_fx0.gain = 0.0
	punchy_fx0.attack_us = 20.0
	punchy_fx0.release_ms = 150.0  # *
	punchy_fx0.mix = 1.0
	punchy_fx0.sidechain = &""
	var punchy_fx1 := AudioEffectAmplify.new()
	punchy_fx1.volume_db = 4.0  # *
	punchy.effects = [punchy_fx0, punchy_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	punchy.volume_db = 0.0
	punchy.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	punchy.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"punchy"] = punchy

	var warm := SfxCondition.new()  # showcases: AudioEffectLowShelfFilter + high-shelf cut
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var warm_fx0 := AudioEffectLowShelfFilter.new()
	warm_fx0.cutoff_hz = 300.0  # *
	warm_fx0.resonance = 0.5
	warm_fx0.gain = 4.0  # *
	warm_fx0.db = 0  # 6 dB
	var warm_fx1 := AudioEffectHighShelfFilter.new()
	warm_fx1.cutoff_hz = 5000.0  # *
	warm_fx1.resonance = 0.5
	warm_fx1.gain = -6.0  # *
	warm_fx1.db = 0  # 6 dB
	warm.effects = [warm_fx0, warm_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	warm.volume_db = 0.0
	warm.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	warm.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"warm"] = warm

	var wide := SfxCondition.new()  # showcases: AudioEffectStereoEnhance (2D sounds feel wider)
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var wide_fx0 := AudioEffectStereoEnhance.new()
	wide_fx0.pan_pullout = 1.0
	wide_fx0.time_pullout_ms = 0.0
	wide_fx0.surround = 0.6  # *
	var wide_fx1 := AudioEffectReverb.new()
	wide_fx1.predelay_msec = 150.0
	wide_fx1.predelay_feedback = 0.4
	wide_fx1.room_size = 0.4  # *
	wide_fx1.damping = 0.3  # *
	wide_fx1.spread = 1.0
	wide_fx1.hipass = 0.0
	wide_fx1.dry = 1.0
	wide_fx1.wet = 0.25  # *
	wide.effects = [wide_fx0, wide_fx1]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	wide.volume_db = 0.0
	wide.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	wide.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"wide"] = wide

	var left := SfxCondition.new()  # showcases: AudioEffectPanner (hard left, for 2D UI/cutscene use)
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var left_fx0 := AudioEffectPanner.new()
	left_fx0.pan = -0.8  # *
	left.effects = [left_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	left.volume_db = 0.0
	left.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	left.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"left"] = left

	var right := SfxCondition.new()
	# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.
	# Classes (each starts with AudioEffect): LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, Amplify, Panner, StereoEnhance
	var right_fx0 := AudioEffectPanner.new()
	right_fx0.pan = 0.8  # *
	right.effects = [right_fx0]  # *
	# ---- Whole-condition pitch and volume (files and synth sounds alike)
	right.volume_db = 0.0
	right.pitch_scale = 1.0
	# ---- Synth knob overrides for every synth sound under this condition (audio files ignore
	# them). Uncomment a line to override that knob; the value shown is the knob's default.
	right.patch_overrides = {
		# "wave": SynthPatch.Wave.SQUARE,
		# "duty": 0.5,
		# "base_freq": 440.0,
		# "noise_mix": 0.0,
		# "noise_tone": 1.0,
		# "sub_mix": 0.0,
		# "detune_cents": 0.0,
		# "detune_mix": 0.0,
		# "pwm_depth": 0.0,
		# "pwm_rate": 2.0,
		# "ring_ratio": 0.0,
		# "ring_mix": 0.0,
		# "pitch_sweep_semitones": 0.0,
		# "pitch_sweep_curve": 1.0,
		# "vibrato_depth": 0.0,
		# "vibrato_rate": 6.0,
		# "vibrato_shape": SynthPatch.LfoShape.SINE,
		# "vibrato_fade_in": 0.0,
		# "arpeggio": [],
		# "arpeggio_rate": 20.0,
		# "arpeggio_mode": SynthPatch.ArpMode.LOOP,
		# "arpeggio_glide": 0.0,
		# "fm_ratio": 0.0,
		# "fm_depth": 0.0,
		# "fm_decay": 0.0,
		# "attack": 0.005,
		# "decay": 0.15,
		# "sustain_level": 0.0,
		# "sustain_time": 0.0,
		# "release": 0.05,
		# "envelope_curve": SynthPatch.EnvCurve.LINEAR,
		# "tremolo_depth": 0.0,
		# "tremolo_rate": 6.0,
		# "tremolo_shape": SynthPatch.LfoShape.SINE,
		# "repeat_rate": 0.0,
		# "filter_mode": SynthPatch.FilterMode.NONE,
		# "cutoff": 2000.0,
		# "cutoff_sweep_octaves": 0.0,
		# "resonance": 0.0,
		# "filter_lfo_depth": 0.0,
		# "filter_lfo_rate": 3.0,
		# "filter_lfo_shape": SynthPatch.LfoShape.SINE,
		# "drive": 0.0,
		# "bit_depth": 16,
		# "sample_hold": 1,
		# "delay_time": 0.0,
		# "delay_feedback": 0.4,
		# "delay_mix": 0.0,
		# "volume_db": 0.0,
		# "normalize": true,
		# "sample_rate": 44100,
		# "loop": false,
		# "noise_seed": 1,
	}
	c[&"right"] = right

	return c


# ------------------------------------------------------------- Effect helpers
# Thin wrappers so the presets above read like a recipe.

static func _lowpass(cutoff_hz: float, resonance: float) -> AudioEffectLowPassFilter:
	var fx := AudioEffectLowPassFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.resonance = resonance
	return fx


static func _highpass(cutoff_hz: float, resonance: float) -> AudioEffectHighPassFilter:
	var fx := AudioEffectHighPassFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.resonance = resonance
	return fx


static func _bandpass(cutoff_hz: float, resonance: float) -> AudioEffectBandPassFilter:
	var fx := AudioEffectBandPassFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.resonance = resonance
	return fx


static func _distortion(drive: float) -> AudioEffectDistortion:
	var fx := AudioEffectDistortion.new()
	fx.mode = AudioEffectDistortion.MODE_OVERDRIVE
	fx.drive = drive
	fx.post_gain = -3.0
	return fx


static func _reverb(room_size: float, damping: float, wet: float) -> AudioEffectReverb:
	var fx := AudioEffectReverb.new()
	fx.room_size = room_size
	fx.damping = damping
	fx.wet = wet
	fx.dry = 1.0
	return fx


static func _phaser() -> AudioEffectPhaser:
	var fx := AudioEffectPhaser.new()
	fx.rate_hz = 2.5
	fx.depth = 1.0
	return fx


static func _chorus() -> AudioEffectChorus:
	var fx := AudioEffectChorus.new()
	fx.wet = 0.4
	return fx


static func _delay(ms: float, feedback: float, wet: float) -> AudioEffectDelay:
	var fx := AudioEffectDelay.new()
	fx.tap1_active = true
	fx.tap1_delay_ms = ms
	fx.tap1_level_db = linear_to_db(maxf(wet, 0.001))
	fx.tap2_active = false
	fx.feedback_active = feedback > 0.0
	fx.feedback_delay_ms = ms
	fx.feedback_level_db = linear_to_db(maxf(feedback, 0.001))
	fx.dry = 1.0
	return fx


static func _pitch(scale: float) -> AudioEffectPitchShift:
	var fx := AudioEffectPitchShift.new()
	fx.pitch_scale = scale
	return fx


static func _notch(cutoff_hz: float, resonance: float) -> AudioEffectNotchFilter:
	var fx := AudioEffectNotchFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.resonance = resonance
	return fx


static func _lowshelf(cutoff_hz: float, gain_db: float) -> AudioEffectLowShelfFilter:
	var fx := AudioEffectLowShelfFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.gain = gain_db
	return fx


static func _highshelf(cutoff_hz: float, gain_db: float) -> AudioEffectHighShelfFilter:
	var fx := AudioEffectHighShelfFilter.new()
	fx.cutoff_hz = cutoff_hz
	fx.gain = gain_db
	return fx


## Six-band EQ, gains in dB for 32, 100, 320, 1000, 3200, 10000 Hz.
static func _eq6(gains_db: Array) -> AudioEffectEQ6:
	var fx := AudioEffectEQ6.new()
	for i in mini(gains_db.size(), 6):
		fx.set_band_gain_db(i, gains_db[i])
	return fx


static func _compressor(threshold_db: float, ratio: float) -> AudioEffectCompressor:
	var fx := AudioEffectCompressor.new()
	fx.threshold = threshold_db
	fx.ratio = ratio
	fx.attack_us = 20.0
	fx.release_ms = 150.0
	fx.gain = 0.0
	return fx


static func _amplify(volume_db: float) -> AudioEffectAmplify:
	var fx := AudioEffectAmplify.new()
	fx.volume_db = volume_db
	return fx


static func _stereo(pan_pullout: float, surround: float) -> AudioEffectStereoEnhance:
	var fx := AudioEffectStereoEnhance.new()
	fx.pan_pullout = pan_pullout
	fx.surround = surround
	return fx


static func _panner(pan: float) -> AudioEffectPanner:
	var fx := AudioEffectPanner.new()
	fx.pan = pan
	return fx
