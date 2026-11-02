extends Node
## Autoload "Sfx": play procedural sounds from anywhere, optionally snapped to the music grid.
##
## [codeblock]
## Sfx.play(&"ui_click")                                  # right now, 2D
## Sfx.play(&"cast_fire", Sfx.EIGHTH)                      # on the next eighth note
## Sfx.play_at(&"explosion", global_position, Sfx.BEAT)    # 3D, on the next beat
## [/codeblock]
##
## Quantize values are grid sizes in beats. Sounds asked for during the same grid window are
## merged into one hit so spamming a button never stacks ten copies on the downbeat.
##
## Sounds come from two places: code in [SfxPalette] (sfx_palette.gd) and audio files in
## [constant SAMPLE_DIR]. The labs edit sfx_palette.gd through [method commit_patch],
## [method create_patch] and [method delete_patch].

const NOW := 0.0
const SIXTEENTH := 0.25
const EIGHTH := 0.5
const BEAT := 1.0
## Sentinel resolved to [member BeatClock.beats_per_bar] at play time.
const BAR := -1.0
## Keys accepted by [method play_with] and [method play_at_with].
const OPTION_KEYS := ["quantize", "volume_db", "pitch_scale", "pitch_jitter", "condition"]

const SFX_BUS := &"SFX"
const MUSIC_BUS := &"Music"

const SOURCE_CODE := "code"
## A sound that is an audio file from [constant SAMPLE_DIR], not a synth patch.
const SOURCE_FILE := "file"

## Presets that ship with the engine are keyed "p_<name>" in sfx_palette.gd; sounds without the
## prefix are the team's own. The labs group sounds by this.
const PRESET_PREFIX := "p_"
## Names the labs' New buttons start from: new_sound, new_sound_2, ... (and new_condition).
const NEW_SOUND_NAME := "new_sound"
const NEW_CONDITION_NAME := "new_condition"
const CATEGORY_PRESET := "preset"
const CATEGORY_USER := "user"
const CATEGORY_FILE := "file"

## Drop .wav/.ogg/.mp3 files here to use them as sounds. The filename is the sound name;
## "hit_1.wav", "hit_2.wav", "hit_3.wav" become one sound "hit" that picks a variant at random.
const SAMPLE_DIR := "res://SoundEngine/Samples"
const SAMPLE_EXTENSIONS := ["wav", "ogg", "mp3"]

## Grid that plain play() / play_at() and any options call without `quantize` snap to, in beats.
## Off (Sfx.NOW) by default: sounds play instantly. Set it to Sfx.SIXTEENTH to put the whole game
## on the music grid in one place; individual calls can still pass their own quantize.
@export var default_quantize := NOW
@export var pool_size_2d := 12
@export var pool_size_3d := 16
## Extra seconds to fire early on top of the measured output latency. Raise it if quantized sounds
## feel late on your machine, lower it if they feel early. Same idea as a rhythm game's calibration.
@export var extra_lead_seconds := 0.0
## 3D players attenuate to silence by this distance.
@export var max_distance_3d := 60.0

var patches: Dictionary[StringName, SynthPatch] = {}
## Where each sound comes from: [constant SOURCE_CODE] or [constant SOURCE_FILE].
var sources: Dictionary[StringName, String] = {}
## Named colourings from [ConditionPalette]: "wood", "metal", "underwater", ...
var conditions: Dictionary[StringName, SfxCondition] = {}
## Where each condition comes from (always [constant SOURCE_CODE]; kept for callers).
var condition_sources: Dictionary[StringName, String] = {}
## When set, every sound plays under this condition regardless of what was asked for. The Sound
## Lab uses it to audition a condition on everything; gameplay can use it for "the whole world is
## underwater now".
var condition_override: StringName = &""

var _streams: Dictionary[StringName, AudioStream] = {}
var _streams_mutex := Mutex.new()
## File-based sounds: name -> one or more loaded streams (variants).
var _samples: Dictionary[StringName, Array] = {}
var _warm_thread: Thread
var _warm_cancel := false
var _players_2d: Array[AudioStreamPlayer] = []
var _players_3d: Array[AudioStreamPlayer3D] = []
var _next_2d := 0
var _next_3d := 0
## Each entry: { name, beat, volume_db, pitch_scale, position (Vector3 or null) }
var _pending: Array[Dictionary] = []


func _ready() -> void:
	_ensure_bus(SFX_BUS)
	_ensure_bus(MUSIC_BUS)
	_ensure_limiter(SFX_BUS)
	for _i in pool_size_2d:
		var player := AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		_players_2d.append(player)
	for _i in pool_size_3d:
		var player := AudioStreamPlayer3D.new()
		player.bus = SFX_BUS
		player.max_distance = max_distance_3d
		add_child(player)
		_players_3d.append(player)
	reload()


func _process(delta: float) -> void:
	if _pending.is_empty():
		return
	if not BeatClock.running:
		for entry in _pending:
			_fire(entry)
		_pending.clear()
		return
	# Fire anything whose grid line arrives before our next chance to act. Audio started now is
	# heard one output-latency later, so lead by that amount plus one frame.
	var lead := AudioServer.get_output_latency() + delta + extra_lead_seconds
	var fire_before_beat := BeatClock.get_beat() + lead / BeatClock.seconds_per_beat()
	var i := 0
	while i < _pending.size():
		var entry: Dictionary = _pending[i]
		if entry.beat <= fire_before_beat:
			_fire(entry)
			_pending.remove_at(i)
		else:
			i += 1


## Play a non-positional sound (UI, the player's own actions, stings) now (or on the default grid).
## [param condition] optionally colours it: [code]Sfx.play(&"hit", &"wood")[/code].
func play(sound: StringName, condition: StringName = &"") -> void:
	_request(sound, default_quantize, 0.0, 1.0, null, condition)


## Play a sound at a world position (through a pooled [AudioStreamPlayer3D]) now (or on the default grid).
## [param condition] optionally colours it: [code]Sfx.play_at(&"hit", global_position, &"metal")[/code].
func play_at(sound: StringName, position: Vector3, condition: StringName = &"") -> void:
	_request(sound, default_quantize, 0.0, 1.0, position, condition)


## [method play] with options. Every key is optional:
## [codeblock]
## Sfx.play_with(&"cast_arcane", {quantize = Sfx.EIGHTH, pitch_jitter = 1.0})
## {
##     quantize = Sfx.NOW,     # beats; grid to snap to (default: Sfx.default_quantize; NOW = instant)
##     volume_db = 0.0,        # loudness change on top of the sound's own level
##     pitch_scale = 1.0,      # playback speed; 2.0 is an octave up
##     pitch_jitter = 0.0,     # random pitch of up to this many semitones each play
##     condition = &"",        # a name from condition_palette.gd
## }
## [/codeblock]
func play_with(sound: StringName, options: Dictionary = {}) -> void:
	_request_with(sound, null, options)


## [method play_at] with options; same keys as [method play_with].
## [codeblock]Sfx.play_at_with(&"hit", global_position, {condition = &"metal", volume_db = -6.0})[/codeblock]
func play_at_with(sound: StringName, position: Vector3, options: Dictionary = {}) -> void:
	_request_with(sound, position, options)


func _request_with(sound: StringName, position: Variant, options: Dictionary) -> void:
	for key in options:
		if not String(key) in OPTION_KEYS:
			push_warning("Sfx: unknown option '%s' (valid: %s)" % [key, ", ".join(OPTION_KEYS)])
	var pitch_scale: float = options.get("pitch_scale", 1.0)
	var jitter: float = options.get("pitch_jitter", 0.0)
	_request(sound, options.get("quantize", default_quantize), options.get("volume_db", 0.0),
			_jitter(pitch_scale, jitter), position, options.get("condition", &""))

## Render (or fetch from cache) the stream for a sound. Use this to feed your own players,
## for example a looping engine hum on a ship node. With a [param condition] that has
## patch_overrides, a synth sound is re-rendered with them (cached per pair); file sounds are
## returned as-is and get the condition's bus effects at play time instead.
func get_stream(sound: StringName, condition: StringName = &"") -> AudioStream:
	if _samples.has(sound):
		var variants: Array = _samples[sound]
		return variants[randi() % variants.size()]
	if not patches.has(sound):
		push_warning("Sfx: no sound named '%s'" % sound)
		return null
	var cond: SfxCondition = conditions.get(condition)
	var key := sound
	if cond != null and cond.has_overrides():
		key = StringName("%s|%s" % [sound, condition])
	_streams_mutex.lock()
	var cached: AudioStream = _streams.get(key)
	_streams_mutex.unlock()
	if cached != null:
		return cached
	var patch: SynthPatch = patches[sound]
	if key != sound:
		patch = cond.apply_to(patch)
	var stream := SynthRenderer.render_to_stream(patch)
	_streams_mutex.lock()
	_streams[key] = stream
	_streams_mutex.unlock()
	return stream


## Which condition a sound will play under: the lab override, else the one passed in, else the
## patch's own default, else none.
func resolve_condition(sound: StringName, requested: StringName = &"") -> StringName:
	if not condition_override.is_empty():
		return condition_override
	if not requested.is_empty():
		return requested
	if patches.has(sound):
		return patches[sound].condition
	return &""


## The audio bus a condition routes through ("SFX" when the condition is empty or unknown).
func bus_for(condition: StringName) -> StringName:
	if condition.is_empty() or not conditions.has(condition):
		return SFX_BUS
	return StringName("SFX_" + String(condition))


func condition_names() -> Array[StringName]:
	var list: Array[StringName] = []
	list.assign(conditions.keys())
	_sort_names(list)
	return list


## True for synth sounds and file sounds alike.
func has_sound(sound: StringName) -> bool:
	return patches.has(sound) or _samples.has(sound)


## Stop every sound effect that is playing (looping hums included) and forget anything booked on
## the beat grid. Music is not touched; stop it through its MusicPlayer.
func stop_all() -> void:
	_pending.clear()
	for player in _players_2d:
		player.stop()
	for player in _players_3d:
		player.stop()


## Add or replace a patch at runtime. The old render is dropped.
func register(sound: StringName, patch: SynthPatch, source := SOURCE_CODE) -> void:
	patches[sound] = patch
	sources[sound] = source
	_streams.erase(sound)


## Rebuild the palette from sfx_palette.gd (read from disk in the editor), add the audio files in
## Samples/, then render everything on a background thread so startup stays smooth. A sound played
## before its turn is simply rendered on the spot.
func reload() -> void:
	_stop_warm_up()
	_streams.clear()
	_samples.clear()
	patches.assign(_fresh_build(PaletteWriter.PALETTE_PATH, SfxPalette.build))
	sources.clear()
	for sound in patches:
		sources[sound] = SOURCE_CODE
	_load_sample_files()
	reload_conditions()
	_start_warm_up()


## Rebuild only the conditions from condition_palette.gd (read from disk in the editor), then
## their buses. Sounds are
## left alone, except that synth variants rendered under a condition are dropped so they pick up
## the new knob overrides next time they play.
func reload_conditions() -> void:
	conditions.assign(_fresh_build(PaletteWriter.CONDITION_PALETTE_PATH, ConditionPalette.build))
	condition_sources.clear()
	for condition in conditions:
		condition_sources[condition] = SOURCE_CODE
	_build_condition_buses()
	_streams_mutex.lock()
	for key in _streams.keys():
		if "|" in String(key):
			_streams.erase(key)
	_streams_mutex.unlock()


## [constant SOURCE_CODE] for a known condition, or "" if unknown.
func condition_source_of(condition: StringName) -> String:
	return condition_sources.get(condition, "")


## Write the condition's current values into its block in condition_palette.gd (or append a
## new block) and keep it live. Returns true on success.
func commit_condition(condition: StringName) -> bool:
	if not conditions.has(condition):
		return false
	var cond: SfxCondition = conditions[condition]
	if PaletteWriter.write_to_condition_palette(condition, cond) != OK:
		return false
	conditions[condition] = cond.duplicate(true)
	condition_sources[condition] = SOURCE_CODE
	_build_condition_buses()
	return true


## True while the background render of the palette is still running.
func warming_up() -> bool:
	return _warm_thread != null and _warm_thread.is_alive()


func names() -> Array[StringName]:
	var list: Array[StringName] = []
	list.assign(patches.keys())
	for sound in _samples:
		if not list.has(sound):
			list.append(sound)
	_sort_names(list)
	return list


## StringName compares by identity, not text, so sort through String.
static func _sort_names(list: Array[StringName]) -> void:
	list.sort_custom(func(a: StringName, b: StringName) -> bool: return String(a) < String(b))


## [constant CATEGORY_FILE] for an audio file from Samples/, [constant CATEGORY_PRESET] for a
## "p_" name, [constant CATEGORY_USER] for everything else.
func category_of(sound: StringName) -> String:
	if _samples.has(sound):
		return CATEGORY_FILE
	if String(sound).begins_with(PRESET_PREFIX):
		return CATEGORY_PRESET
	return CATEGORY_USER


## Sorted names in one category (see [method category_of]).
func names_in(category: String) -> Array[StringName]:
	var list: Array[StringName] = []
	for sound in names():
		if category_of(sound) == category:
			list.append(sound)
	return list


## [constant SOURCE_CODE] or [constant SOURCE_FILE], or "" if unknown.
func source_of(sound: StringName) -> String:
	return sources.get(sound, "")


## Write the sound's current values into its block in sfx_palette.gd (or append a new block),
## and keep the values live in this running game. Returns true on success.
func commit_patch(sound: StringName) -> bool:
	if not patches.has(sound) or _samples.has(sound):
		return false
	var patch: SynthPatch = patches[sound]
	if PaletteWriter.write_to_palette(sound, patch) != OK:
		return false
	# The running game still has the old compiled palette; keep the committed values in memory
	# so the lab keeps playing what was just committed until the next full run.
	var detached: SynthPatch = patch.duplicate()
	register(sound, detached, SOURCE_CODE)
	return true



## In the editor, re-read a palette script from disk and build from that, so Reload sees blocks
## the labs (or you) added or removed since the game started. The compiled copy in memory only
## changes when Godot itself reloads the script. If the file does not compile right now, the
## compiled copy is used and a warning says so. Exported games always use the compiled copy.
static func _fresh_build(script_path: String, compiled: Callable) -> Dictionary:
	if OS.has_feature("editor"):
		# Compile the file text into a detached script, never through the resource cache: loading
		# a broken file by path would replace the live SfxPalette class and break every later
		# reload. class_name is blanked (same line count) so it does not clash with the live one.
		var source := FileAccess.get_file_as_string(script_path)
		if not source.is_empty():
			var script := GDScript.new()
			script.source_code = RegEx.create_from_string(r"(?m)^class_name\s+\w+").sub(source, "", true)
			if script.reload() == OK:
				return script.call("build")
		push_warning("Sfx: %s does not compile right now; using the version loaded at startup." % script_path)
	return compiled.call()


## Add a sound with every knob at its default, named new_sound (or new_sound_2, ...), and write
## its full block into sfx_palette.gd. Returns the name, or "" if the palette could not be written.
func create_patch() -> StringName:
	var sound := _unique_name(NEW_SOUND_NAME, has_sound)
	register(sound, SynthPatch.new())
	if PaletteWriter.write_to_palette(sound, patches[sound]) != OK:
		patches.erase(sound)
		sources.erase(sound)
		return &""
	return sound


## Remove a sound from sfx_palette.gd and from this running game. Audio files from Samples/ are
## never touched. Returns true if something was deleted.
func delete_patch(sound: StringName) -> bool:
	if not patches.has(sound) or _samples.has(sound):
		return false
	var removed := PaletteWriter.remove_from_palette(sound)
	if removed != OK and removed != ERR_DOES_NOT_EXIST:
		return false
	patches.erase(sound)
	sources.erase(sound)
	_forget_streams(sound)
	return true


## True when the sound still has every knob at its default (a fresh New sound nobody touched).
func is_default_patch(sound: StringName) -> bool:
	if not patches.has(sound):
		return false
	var defaults := SynthPatch.new()
	var patch: SynthPatch = patches[sound]
	for prop in patch.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and patch.get(prop.name) != defaults.get(prop.name):
			return false
	return true


## Add an empty condition named new_condition (or new_condition_2, ...), write its block into
## condition_palette.gd and give it a bus. Returns the name, or "" on failure.
func create_condition() -> StringName:
	var condition := _unique_name(NEW_CONDITION_NAME, func(n: StringName) -> bool: return conditions.has(n))
	conditions[condition] = SfxCondition.new()
	if PaletteWriter.write_to_condition_palette(condition, conditions[condition]) != OK:
		conditions.erase(condition)
		return &""
	_build_condition_buses()
	return condition


## Remove a condition from condition_palette.gd and from this running game. Its bus stays
## (empty, feeding SFX) so nothing playing through it is cut off. Returns true if deleted.
func delete_condition(condition: StringName) -> bool:
	if not conditions.has(condition):
		return false
	var removed := PaletteWriter.remove_from_condition_palette(condition)
	if removed != OK and removed != ERR_DOES_NOT_EXIST:
		return false
	conditions.erase(condition)
	if condition_override == condition:
		condition_override = &""
	var index := AudioServer.get_bus_index(bus_for(condition))
	if index != -1:
		while AudioServer.get_bus_effect_count(index) > 0:
			AudioServer.remove_bus_effect(index, 0)
	_streams_mutex.lock()
	for key in _streams.keys():
		if String(key).ends_with("|" + String(condition)):
			_streams.erase(key)
	_streams_mutex.unlock()
	return true


## True when the condition does nothing yet (a fresh New condition nobody touched).
func is_default_condition(condition: StringName) -> bool:
	if not conditions.has(condition):
		return false
	var cond: SfxCondition = conditions[condition]
	return cond.effects.is_empty() and cond.patch_overrides.is_empty() \
			and is_equal_approx(cond.volume_db, 0.0) and is_equal_approx(cond.pitch_scale, 1.0)


## base, base_2, base_3, ... the first that [param taken] says is free.
static func _unique_name(base: String, taken: Callable) -> StringName:
	var candidate := StringName(base)
	var n := 2
	while taken.call(candidate):
		candidate = StringName("%s_%d" % [base, n])
		n += 1
	return candidate


## Drop every rendered variant of one sound (plain and under any condition).
func _forget_streams(sound: StringName) -> void:
	_streams_mutex.lock()
	for key in _streams.keys():
		if key == sound or String(key).begins_with(String(sound) + "|"):
			_streams.erase(key)
	_streams_mutex.unlock()


## Write every rendered sound to [param dir] as .wav so the team can use them as plain assets
## or open them in an editor. Returns the number of files written.
func export_wavs(dir := "res://SoundEngine/Exported") -> int:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var count := 0
	for sound in patches:
		var stream := get_stream(sound)
		if stream is AudioStreamWAV and stream.save_to_wav("%s/%s.wav" % [dir, sound]) == OK:
			count += 1
	return count


func _request(sound: StringName, quantize: float, volume_db: float, pitch_scale: float,
		position: Variant, condition: StringName = &"") -> void:
	if not has_sound(sound):
		push_warning("Sfx: no sound named '%s'" % sound)
		return
	if quantize == BAR:
		quantize = float(BeatClock.beats_per_bar)
	var entry := {
		name = sound,
		beat = 0.0,
		volume_db = volume_db,
		pitch_scale = pitch_scale,
		position = position,
		condition = resolve_condition(sound, condition),
	}
	if quantize <= 0.0 or not BeatClock.running:
		_fire(entry)
		return
	entry.beat = BeatClock.next_grid_beat(quantize)
	for other in _pending:
		if other.name == sound and is_equal_approx(other.beat, entry.beat):
			return  # already booked for this grid line
	_pending.append(entry)


func _fire(entry: Dictionary) -> void:
	var condition: StringName = entry.condition
	var stream := get_stream(entry.name, condition)
	if stream == null:
		return
	var volume_db: float = entry.volume_db
	var pitch_scale: float = entry.pitch_scale
	var cond: SfxCondition = conditions.get(condition)
	if cond != null:
		volume_db += cond.volume_db
		pitch_scale *= cond.pitch_scale
	var bus := bus_for(condition)
	if entry.position == null:
		var player := _pick_idle_2d()
		player.bus = bus
		player.stream = stream
		player.volume_db = volume_db
		player.pitch_scale = pitch_scale
		player.play()
	else:
		var player := _pick_idle_3d()
		player.global_position = entry.position
		player.bus = bus
		player.stream = stream
		player.volume_db = volume_db
		player.pitch_scale = pitch_scale
		player.play()


## One bus per condition, named "SFX_<condition>", carrying its effects and sending to SFX.
## Safe to call again after a reload: effects are rebuilt from the current definitions.
func _build_condition_buses() -> void:
	for condition in conditions:
		var bus_name := bus_for(condition)
		_ensure_bus(bus_name, SFX_BUS)
		var index := AudioServer.get_bus_index(bus_name)
		while AudioServer.get_bus_effect_count(index) > 0:
			AudioServer.remove_bus_effect(index, 0)
		var cond: SfxCondition = conditions[condition]
		for effect in cond.effects:
			AudioServer.add_bus_effect(index, effect)


## Prefer a player that is not playing; only when every one is busy, take the next in rotation.
## Cutting a live sound to reuse its player is what makes a pop, so it is the last resort.
func _pick_idle_2d() -> AudioStreamPlayer:
	for player in _players_2d:
		if not player.playing:
			return player
	var victim := _players_2d[_next_2d]
	_next_2d = (_next_2d + 1) % _players_2d.size()
	return victim


func _pick_idle_3d() -> AudioStreamPlayer3D:
	for player in _players_3d:
		if not player.playing:
			return player
	var victim := _players_3d[_next_3d]
	_next_3d = (_next_3d + 1) % _players_3d.size()
	return victim


func _jitter(pitch_scale: float, semitones: float) -> float:
	if semitones <= 0.0:
		return pitch_scale
	return pitch_scale * pow(2.0, randf_range(-semitones, semitones) / 12.0)


func _start_warm_up() -> void:
	_warm_cancel = false
	_warm_thread = Thread.new()
	# Hand the thread its own list of (name, patch) so it never reads the dictionaries we mutate.
	var jobs: Array = []
	for sound in patches:
		jobs.append([sound, patches[sound]])
	_warm_thread.start(_warm_up_worker.bind(jobs))


func _stop_warm_up() -> void:
	if _warm_thread == null:
		return
	_warm_cancel = true
	_warm_thread.wait_to_finish()
	_warm_thread = null


func _warm_up_worker(jobs: Array) -> void:
	for job in jobs:
		if _warm_cancel:
			return
		var sound: StringName = job[0]
		_streams_mutex.lock()
		var done := _streams.has(sound)
		_streams_mutex.unlock()
		if done:
			continue
		var stream := SynthRenderer.render_to_stream(job[1])
		_streams_mutex.lock()
		if not _streams.has(sound):
			_streams[sound] = stream
		_streams_mutex.unlock()


func _exit_tree() -> void:
	_stop_warm_up()


func _notification(what: int) -> void:
	# Also join the thread if the node is freed without leaving the tree first (early engine quit).
	if what == NOTIFICATION_PREDELETE:
		_stop_warm_up()


## Audio files in SAMPLE_DIR become sounds. A trailing _1, _2, ... groups files into variants of
## one name. A file whose name matches a synth sound replaces it.
func _load_sample_files() -> void:
	if not DirAccess.dir_exists_absolute(SAMPLE_DIR):
		return
	var seen := {}
	for entry in DirAccess.get_files_at(SAMPLE_DIR):
		var file: String = entry.trim_suffix(".import")
		if not file.get_extension().to_lower() in SAMPLE_EXTENSIONS or seen.has(file):
			continue
		seen[file] = true
		var path := SAMPLE_DIR.path_join(file)
		var stream := _load_audio_file(path)
		if stream == null:
			push_warning("Sfx: could not load sample %s" % path)
			continue
		var sound := StringName(_variant_base_name(file.get_basename()))
		if not _samples.has(sound):
			_samples[sound] = []
		_samples[sound].append(stream)
		sources[sound] = SOURCE_FILE
		_streams.erase(sound)


## Strip a trailing "_<digits>" so hit_1 / hit_2 share the name "hit".
static func _variant_base_name(base: String) -> String:
	var found := RegEx.create_from_string("^(.*)_\\d+$").search(base)
	return found.get_string(1) if found else base


static func _load_audio_file(path: String) -> AudioStream:
	if ResourceLoader.exists(path):
		var loaded := load(path) as AudioStream
		if loaded != null:
			return loaded
	# Not imported yet (dropped in while running) or outside res://: read it directly.
	match path.get_extension().to_lower():
		"wav":
			return AudioStreamWAV.load_from_file(path)
		"ogg":
			return AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			return AudioStreamMP3.load_from_file(path)
	return null


## A brick-wall limiter on the SFX bus so several loud hits landing together cannot push the bus
## past 0 dBFS and crackle. It does nothing until the mix gets hot.
func _ensure_limiter(bus_name: StringName) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index == -1:
		return
	for i in AudioServer.get_bus_effect_count(index):
		if AudioServer.get_bus_effect(index, i) is AudioEffectHardLimiter:
			return
	var limiter := AudioEffectHardLimiter.new()
	limiter.ceiling_db = -0.5
	limiter.pre_gain_db = 0.0
	limiter.release = 0.1
	AudioServer.add_bus_effect(index, limiter)


func _ensure_bus(bus_name: StringName, send_to: StringName = &"Master") -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return
	var index := AudioServer.bus_count
	AudioServer.add_bus(index)
	AudioServer.set_bus_name(index, bus_name)
	AudioServer.set_bus_send(index, send_to)
