class_name SfxCondition
extends Resource
## A named way of colouring a sound at play time: "wood", "metal", "underwater", "distant".
##
## Two layers, so it works on synth sounds and audio files alike:
## 1. [member effects] run on a dedicated audio bus ("SFX_<name>") that the sound is routed
##    through. Filters, distortion, reverb, EQ. This is the only layer files get.
## 2. [member patch_overrides] change knobs on a synth sound before it is rendered, which can
##    alter timbre in ways a filter cannot (add FM ringing for metal, crackle for wood).
##    Ignored for audio files. Rendered variants are cached per sound and condition.

## Audio effects applied on this condition's bus, in order.
@export var effects: Array[AudioEffect] = []
## Level change for sounds played under this condition.
@export_range(-24.0, 12.0, 0.5) var volume_db := 0.0
## Playback speed/pitch multiplier. 0.8 is bigger and darker, 1.3 is smaller and lighter.
@export_range(0.25, 4.0, 0.01) var pitch_scale := 1.0
## SynthPatch property name -> value, applied to a copy of the patch before rendering.
## Example: {"fm_ratio": 2.41, "fm_depth": 6.0, "fm_decay": 0.3}
@export var patch_overrides: Dictionary = {}


func has_overrides() -> bool:
	return not patch_overrides.is_empty()


## A copy of [param patch] with the overrides applied.
func apply_to(patch: SynthPatch) -> SynthPatch:
	var copy: SynthPatch = patch.duplicate()
	for key in patch_overrides:
		copy.set(key, patch_overrides[key])
	return copy
