class_name SynthPatch
extends Resource
## A recipe for one procedural sound. Every field is a knob you can turn in the Inspector.
##
## Signal flow (left to right):
##   Oscillator (+ sub, detune, PWM) -> FM -> Ring mod -> Noise mix -> Amp envelope (+ tremolo)
##   -> Filter (+ filter LFO) -> Drive -> Bitcrush -> Delay -> Volume
##
## Pitch is controlled by [member base_freq] plus modulators that add semitones: a sweep over the
## sound's life, a vibrato LFO, and an arpeggio that steps through notes. Every knob below its
## group's first few is optional flavour; a knob at its default costs nothing.

enum Wave { SINE, SQUARE, SAW, TRIANGLE, NOISE }
enum FilterMode { NONE, LOWPASS, HIGHPASS, BANDPASS }
## Shape of a low-frequency oscillator (vibrato, tremolo, filter LFO). RANDOM holds a new random
## value each cycle (sample-and-hold), which bubbles and burbles.
enum LfoShape { SINE, TRIANGLE, SQUARE, SAW, RANDOM }
## How the arpeggio walks its list. LOOP repeats, ONCE stops on the last note, PING_PONG bounces,
## RANDOM picks a new note each step.
enum ArpMode { LOOP, ONCE, PING_PONG, RANDOM }
## LINEAR fades evenly; EXPONENTIAL drops fast then trails, like most real sounds.
enum EnvCurve { LINEAR, EXPONENTIAL }

@export_group("Oscillator")
@export var wave: Wave = Wave.SQUARE
## Pulse width for SQUARE. 0.5 is a hollow square, 0.1 is a thin nasal buzz.
@export_range(0.05, 0.95, 0.01) var duty := 0.5
## Starting pitch in Hz. 440 is A4. Each octave doubles the number.
@export_range(20.0, 8000.0, 1.0, "exp") var base_freq := 440.0
## Blend in white noise. 0 is pure tone, 1 is pure noise. Hits and explosions live near 1.
@export_range(0.0, 1.0, 0.01) var noise_mix := 0.0
## Darken the noise. 1 is white (hiss), 0.1 is a dull rumble. Only affects noise.
@export_range(0.01, 1.0, 0.01) var noise_tone := 1.0
## Mix in a sine one octave below the pitch for weight. 0 is off, 0.5 is an equal blend.
@export_range(0.0, 1.0, 0.01) var sub_mix := 0.0
## A second copy of the wave, shifted by this many cents (100 cents = 1 semitone). Fat and
## chorus-like at 5 to 15, out of tune at 50. Needs [member detune_mix] above 0.
@export_range(-100.0, 100.0, 1.0) var detune_cents := 0.0
## How much of the detuned copy to blend in. 0.5 is an equal blend.
@export_range(0.0, 1.0, 0.01) var detune_mix := 0.0
## Pulse-width modulation for SQUARE: the duty wobbles by this much. 0.3 is the classic chip lead.
@export_range(0.0, 0.45, 0.01) var pwm_depth := 0.0
@export_range(0.1, 20.0, 0.1) var pwm_rate := 2.0
## Ring modulation: multiply by a sine at this multiple of the pitch. Metallic, robotic.
@export_range(0.0, 12.0, 0.01) var ring_ratio := 0.0
@export_range(0.0, 1.0, 0.01) var ring_mix := 0.0

@export_group("Pitch motion")
## Total pitch drift over the sound, in semitones. Negative falls, positive rises.
@export_range(-48.0, 48.0, 0.5) var pitch_sweep_semitones := 0.0
## Shape of the sweep. 1 is linear, <1 moves fast then settles, >1 starts slow then dives.
@export_range(0.1, 4.0, 0.05) var pitch_sweep_curve := 1.0
@export_range(0.0, 12.0, 0.1) var vibrato_depth := 0.0
@export_range(0.1, 40.0, 0.1) var vibrato_rate := 6.0
## SINE wobbles, SQUARE trills between two notes, SAW is a siren, RANDOM burbles.
@export var vibrato_shape: LfoShape = LfoShape.SINE
## Seconds for the vibrato to grow from nothing to full depth. 0 starts at full depth.
@export_range(0.0, 2.0, 0.01) var vibrato_fade_in := 0.0
## Semitone offsets stepped through in order, e.g. [0, 7, 12] for a rising chord.
@export var arpeggio: Array[int] = []
## How many arpeggio steps happen per second.
@export_range(1.0, 60.0, 0.5) var arpeggio_rate := 20.0
@export var arpeggio_mode: ArpMode = ArpMode.LOOP
## Seconds to slide between arpeggio notes instead of jumping. 0 jumps; 0.05 is a portamento.
@export_range(0.0, 0.5, 0.005) var arpeggio_glide := 0.0

@export_group("FM")
## Frequency of the modulator relative to the carrier. Whole numbers are harmonic (bell, brass);
## fractions like 1.41 are inharmonic (metal, magic).
@export_range(0.0, 12.0, 0.01) var fm_ratio := 0.0
## How hard the modulator bends the pitch. 0 is off, 3 is a bright bell, 10 is chaos.
@export_range(0.0, 20.0, 0.1) var fm_depth := 0.0
## Seconds for the FM depth to fade to about a third. 0 means it never fades.
@export_range(0.0, 2.0, 0.01) var fm_decay := 0.0

@export_group("Amp envelope")
@export_range(0.0, 2.0, 0.005) var attack := 0.005
@export_range(0.0, 3.0, 0.005) var decay := 0.15
@export_range(0.0, 1.0, 0.01) var sustain_level := 0.0
@export_range(0.0, 4.0, 0.005) var sustain_time := 0.0
@export_range(0.0, 4.0, 0.005) var release := 0.05
@export var envelope_curve: EnvCurve = EnvCurve.LINEAR
## Volume wobble. 0 is off, 0.5 pulses, 1 cuts fully to silence each cycle.
@export_range(0.0, 1.0, 0.01) var tremolo_depth := 0.0
@export_range(0.1, 40.0, 0.1) var tremolo_rate := 6.0
## SINE pulses smoothly, SQUARE chops (helicopter, stutter), RANDOM crackles.
@export var tremolo_shape: LfoShape = LfoShape.SINE
## Restart the envelope and pitch sweep this many times per second. 0 is off; 8 is a stutter,
## 20 is a machine gun. The sound's total length does not change.
@export_range(0.0, 40.0, 0.5) var repeat_rate := 0.0

@export_group("Filter")
@export var filter_mode: FilterMode = FilterMode.NONE
@export_range(20.0, 14000.0, 1.0, "exp") var cutoff := 2000.0
## Cutoff drift over the sound, in octaves. -4 closes the filter dramatically (classic "whoomp").
@export_range(-8.0, 8.0, 0.1) var cutoff_sweep_octaves := 0.0
## 0 is a gentle slope, near 1 is a whistling peak at the cutoff.
@export_range(0.0, 1.0, 0.01) var resonance := 0.0
## Wobble the cutoff by this many octaves (auto-wah). Needs a filter mode and some resonance.
@export_range(0.0, 4.0, 0.1) var filter_lfo_depth := 0.0
@export_range(0.1, 20.0, 0.1) var filter_lfo_rate := 3.0
@export var filter_lfo_shape: LfoShape = LfoShape.SINE

@export_group("Dirt")
## Soft clipping. Adds grit and sustain to anything.
@export_range(0.0, 1.0, 0.01) var drive := 0.0
## Fewer bits means crunchier. 16 is clean.
@export_range(2, 16, 1) var bit_depth := 16
## Hold each sample this many times. 1 is clean; 8 is an old handheld console.
@export_range(1, 32, 1) var sample_hold := 1

@export_group("Space")
@export_range(0.0, 1.0, 0.001) var delay_time := 0.0
@export_range(0.0, 0.95, 0.01) var delay_feedback := 0.4
@export_range(0.0, 1.0, 0.01) var delay_mix := 0.0

@export_group("Output")
@export_range(-40.0, 12.0, 0.5) var volume_db := 0.0
## Scale the loudest sample to full scale before applying volume. Keeps presets comparable.
@export var normalize := true
@export var sample_rate := 44100
## Make the rendered stream loop (for engines, hums, shields).
@export var loop := false
## Seed for the noise generator so the same patch always renders the same bytes.
@export var noise_seed := 1
## Play this sound under a named [SfxCondition] by default (e.g. &"metal"). A condition passed
## to [method Sfx.play], or the lab's override, takes precedence. Empty means none.
@export var condition: StringName = &""


## Length of the envelope in seconds, not counting any delay tail.
func envelope_length() -> float:
	return attack + decay + sustain_time + release


## Full rendered length including the echo tail.
func total_length() -> float:
	var tail := 0.0
	if delay_mix > 0.0 and delay_time > 0.0:
		if delay_feedback > 0.0:
			# Number of repeats until the echo is quieter than -40 dB.
			var repeats := ceilf(log(0.01) / log(delay_feedback))
			tail = delay_time * minf(repeats, 40.0)
		else:
			tail = delay_time
	return envelope_length() + tail


## Return a copy transposed by [param semitones].
func transposed(semitones: float) -> SynthPatch:
	var copy: SynthPatch = duplicate()
	copy.base_freq = base_freq * pow(2.0, semitones / 12.0)
	return copy
