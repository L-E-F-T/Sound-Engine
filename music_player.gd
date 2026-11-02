class_name MusicPlayer
extends Node
## Adaptive music: a song is a set of parts that all run in sync, and a "level" decides which
## are heard. Raising the level crossfades at the next bar, so the planning-phase calm version
## can hand over to the battle version, and more intense versions or extra synth layers can join
## as the player closes in on the goal, without ever losing the beat.
##
## A song is either one audio file in res://SoundEngine/Music (a single part), or a folder of
## numbered parts: [code]Music/space_wizard_128bpm/1_calm.ogg, 2_battle.ogg, 3_arp.pattern,
## 4_final.ogg[/code]. Audio parts come from the DAW; .pattern parts are baked by [PatternBaker]
## with the in-game synth at the song's tempo. See [MusicLibrary] for the naming rules.
##
## The number at the front of a part's filename is the level it comes in at. Parts are
## "versions" (exclusive: only the highest-numbered one at or below the level plays) or "layers"
## (additive: every one numbered at or below the level plays). Audio parts are versions and
## .pattern parts are layers unless the filename says otherwise (_layer / _version). Several
## parts may share a number and come in together; numbers may skip.
##
## All parts start in the same frame and loop, so they stay sample-aligned; a part that is not
## heard is simply silent. Every part should be a whole number of bars at the song's tempo.

## When a level change takes effect.
enum Transition { NOW, NEXT_BEAT, NEXT_BAR }
## Per-part override used by the Song Lab: follow the level, or force a part on or off.
enum PartState { AUTO, ON, OFF }

signal level_changed(level: int)

@export var volume_db := -6.0
## Name of a song in res://SoundEngine/Music to play when this node enters the tree: a file
## without extension ("space_wizard_128bpm") or a folder. Leave empty to start silent.
@export var song := ""
## Seconds a crossfade between parts takes.
@export_range(0.05, 4.0, 0.05) var fade_seconds := 0.6
@export var default_transition: Transition = Transition.NEXT_BAR

## Layer 0's player: drives [BeatClock]. Kept under this name for anything that read it before.
var player: AudioStreamPlayer
## The [MusicLibrary] entry currently playing, or empty.
var current_song: Dictionary = {}
var bpm := 120.0
var beats_per_bar := 4
## Current level: the filename number of the highest part switched on (1 for "1_calm.ogg").
var level := 0

## One entry per part: { part: Dictionary, player: AudioStreamPlayer, gain: float, tween: Tween }
var _layers: Array[Dictionary] = []
## Parallel to _layers: a PartState per part.
var _overrides: Array[int] = []
## Part overrides waiting for their bar: [index, state, beat].
var _pending_overrides: Array = []
var _pending_level := -1
var _pending_beat := 0.0


func _ready() -> void:
	if not song.is_empty():
		var warning := play_song_named(song)
		if not warning.is_empty():
			push_warning("Music: " + warning)


func _process(delta: float) -> void:
	if _pending_level < 0 and _pending_overrides.is_empty():
		return
	if not BeatClock.running:
		if _pending_level >= 0:
			_apply_level(_pending_level)
		for item in _pending_overrides:
			_apply_override(item[0], item[1])
		_pending_overrides.clear()
		return
	var now := BeatClock.get_beat() + (AudioServer.get_output_latency() + delta) / BeatClock.seconds_per_beat()
	if _pending_level >= 0 and now >= _pending_beat:
		_apply_level(_pending_level)
	var i := 0
	while i < _pending_overrides.size():
		if now >= _pending_overrides[i][2]:
			_apply_override(_pending_overrides[i][0], _pending_overrides[i][1])
			_pending_overrides.remove_at(i)
		else:
			i += 1


# ------------------------------------------------------------------ Playing

## Play a song found by [method MusicLibrary.scan], all parts in sync, at level 0. Returns "" or
## a warning about the first audio part (missing BPM, loop not a whole number of bars).
func play_song(entry: Dictionary) -> String:
	stop()
	current_song = entry
	bpm = entry.bpm
	beats_per_bar = entry.beats_per_bar
	var warning := ""
	for part in entry.parts:
		var stream: AudioStream = null
		if part.kind == MusicLibrary.KIND_PATTERN:
			stream = PatternBaker.bake_file(part.path, bpm, beats_per_bar)
		else:
			stream = MusicLibrary.load_stream(part.path)
			if stream != null and warning.is_empty():
				warning = MusicLibrary.loop_warning(entry, stream)
		if stream == null:
			push_warning("Music: could not load part %s" % part.path)
			continue
		var layer_player := AudioStreamPlayer.new()
		layer_player.bus = Sfx.MUSIC_BUS
		layer_player.stream = stream
		add_child(layer_player)
		_layers.append({part = part, player = layer_player, gain = 0.0, tween = null})
		_overrides.append(PartState.AUTO)
	if _layers.is_empty():
		current_song = {}
		return "No playable parts in %s" % entry.path
	player = _layers[0].player
	level = levels()[0]
	_pending_level = -1
	for i in _layers.size():
		_set_layer_gain(i, 1.0 if _is_audible(i, level) else 0.0)
	# Start every part in the same frame so they are mixed from the same sample.
	for layer in _layers:
		layer.player.play()
	BeatClock.start(player, bpm, beats_per_bar)
	level_changed.emit(level)
	return warning


## Play a song by name: a file without extension, or a folder name.
func play_song_named(song_name: String) -> String:
	for entry in MusicLibrary.scan():
		if entry.name == song_name:
			return play_song(entry)
	return "No song named '%s' in %s" % [song_name, MusicLibrary.MUSIC_DIR]


## Use any single stream as the music (one part). It should loop and start on a downbeat.
func play_stream(stream: AudioStream, stream_bpm: float, stream_beats_per_bar := 4) -> void:
	var entry := {
		name = "stream", path = "", bpm = stream_bpm, beats_per_bar = stream_beats_per_bar,
		has_bpm = true, parts = [],
	}
	stop()
	current_song = entry
	bpm = stream_bpm
	beats_per_bar = stream_beats_per_bar
	player = AudioStreamPlayer.new()
	player.bus = Sfx.MUSIC_BUS
	player.stream = stream
	add_child(player)
	_layers.append({part = {name = "stream", kind = MusicLibrary.KIND_AUDIO, additive = false, order = 1}, player = player, gain = 0.0, tween = null})
	_overrides.append(PartState.AUTO)
	level = 1
	_set_layer_gain(0, 1.0)
	player.play()
	BeatClock.start(player, bpm, beats_per_bar)
	level_changed.emit(level)


func stop() -> void:
	for layer in _layers:
		if layer.tween:
			layer.tween.kill()
		layer.player.stop()
		layer.player.queue_free()
	_layers.clear()
	player = null
	_overrides.clear()
	_pending_overrides.clear()
	current_song = {}
	_pending_level = -1
	BeatClock.stop()


# ------------------------------------------------------------------- Levels

## The distinct level numbers in this song, ascending: every start number and every stop
## number from the filenames, e.g. [1, 2, 3, 5]. A stop level counts so advance() visits it.
func levels() -> Array[int]:
	var found: Array[int] = []
	for layer in _layers:
		var order: int = layer.part.order
		if not found.has(order):
			found.append(order)
		var stop_level: int = layer.part.get("stop", 0)
		if stop_level > 0 and not found.has(stop_level):
			found.append(stop_level)
	found.sort()
	return found


## How many distinct levels the song has.
func level_count() -> int:
	return levels().size()


## What each level switches on, e.g. ["calm", "battle", "arp (layer)", "final"], one entry per
## distinct level number; parts sharing a number are joined with " + ".
func layer_names() -> Array[String]:
	var names: Array[String] = []
	for lvl in levels():
		var parts: PackedStringArray = []
		for layer in _layers:
			if int(layer.part.get("stop", 0)) == lvl:
				parts.append("%s stops" % layer.part.name)
			if layer.part.order == lvl:
				var text := String(layer.part.name) + (" (layer)" if layer.part.additive else "")
				if int(layer.part.get("stop", 0)) > 0:
					text += " stops %d" % layer.part.stop
				parts.append(text)
		names.append(" + ".join(parts) if not parts.is_empty() else "(no change)")
	return names


## Move to a level. The change happens at the next bar by default so it lands on the music;
## pass [constant Transition.NOW] for an immediate crossfade (a hit, a death) or NEXT_BEAT.
func set_level(new_level: int, transition: Transition = default_transition) -> void:
	if _layers.is_empty():
		return
	var all := levels()
	new_level = clampi(new_level, all[0], all[all.size() - 1])
	if new_level == level and _pending_level < 0:
		return
	_pending_level = new_level
	if transition == Transition.NOW or not BeatClock.running:
		_apply_level(new_level)
		return
	var grid := float(beats_per_bar) if transition == Transition.NEXT_BAR else 1.0
	_pending_beat = BeatClock.next_grid_beat(grid)


## The next level number above the current one, for "the player reached the next milestone".
func advance(transition: Transition = default_transition) -> void:
	for lvl in levels():
		if lvl > level:
			set_level(lvl, transition)
			return


## Map a 0..1 progress value onto the levels evenly: 0 is the first level, 1 is the last.
func set_progress(progress: float, transition: Transition = default_transition) -> void:
	var all := levels()
	if all.is_empty():
		return
	set_level(all[int(floorf(clampf(progress, 0.0, 0.999) * all.size()))], transition)


# ------------------------------------------------------------------- Parts

## Indices of the parts that are .pattern files.
func pattern_indices() -> Array[int]:
	var found: Array[int] = []
	for i in _layers.size():
		if _layers[i].part.kind == MusicLibrary.KIND_PATTERN:
			found.append(i)
	return found


## Re-read and re-bake one .pattern part while the song keeps playing, and drop the new loop in
## at the current song position so it stays in time. Returns PatternBaker.last_problems joined,
## or "" when the file parsed cleanly. [param text] renders that text instead of the file.
func rebake_pattern(index: int, text := "") -> String:
	if index >= _layers.size() or _layers[index].part.kind != MusicLibrary.KIND_PATTERN:
		return "not a pattern part"
	var part: Dictionary = _layers[index].part
	var def := PatternBaker.parse_text(text, String(part.path).get_file()) if not text.is_empty() else PatternBaker.parse(part.path)
	var stream := PatternBaker.bake(def, bpm, beats_per_bar)
	var problems := "\n".join(PatternBaker.last_problems)
	var layer_player: AudioStreamPlayer = _layers[index].player
	var song_position := player.get_playback_position() if player and player.playing else 0.0
	layer_player.stop()
	layer_player.stream = stream
	layer_player.play(fmod(song_position, maxf(stream.get_length(), 0.001)))
	return problems


## Number of parts (files) in the playing song.
func part_count() -> int:
	return _layers.size()


## The [MusicLibrary] part dictionary at [param index]: { order, name, path, kind, additive }.
func get_part(index: int) -> Dictionary:
	return _layers[index].part if index < _layers.size() else {}


## Whether the part is switched on right now (by level or by override).
func is_part_on(index: int) -> bool:
	return index < _layers.size() and _is_audible(index, level)


## Current fade position of a part, 0 silent to 1 full.
func part_gain(index: int) -> float:
	return _layers[index].gain if index < _layers.size() else 0.0


func get_part_state(index: int) -> PartState:
	return _overrides[index] as PartState if index < _overrides.size() else PartState.AUTO


## Force a part on or off regardless of level, or back to AUTO. Like a level change it lands on
## the next bar by default (crossfaded); pass [constant Transition.NOW] for an immediate fade.
func set_part_state(index: int, state: PartState, transition: Transition = default_transition) -> void:
	if index >= _overrides.size():
		return
	if transition == Transition.NOW or not BeatClock.running:
		_apply_override(index, state)
		return
	var grid := float(beats_per_bar) if transition == Transition.NEXT_BAR else 1.0
	_pending_overrides.append([index, state, BeatClock.next_grid_beat(grid)])


func _apply_override(index: int, state: PartState) -> void:
	if index >= _overrides.size():
		return
	_overrides[index] = state
	_fade_layer(index, 1.0 if _is_audible(index, level) else 0.0)


# ------------------------------------------------------------------ Internal

## Layers (additive): every one numbered at or below the level. Versions (exclusive): only the
## highest-numbered one at or below the level (two versions sharing that number both play).
## A part with a stop level (_stopN in its filename) is silent from level N on. A part forced
## ON or OFF (see [method set_part_state]) ignores all of this.
func _is_audible(index: int, at_level: int) -> bool:
	if index < _overrides.size() and _overrides[index] != PartState.AUTO:
		return _overrides[index] == PartState.ON
	var part: Dictionary = _layers[index].part
	if not _in_range(part, at_level):
		return false
	if part.additive:
		return true
	var top := -1
	for layer in _layers:
		if not layer.part.additive and _in_range(layer.part, at_level):
			top = maxi(top, layer.part.order)
	return part.order == top


## Started at or before this level, and not yet stopped.
static func _in_range(part: Dictionary, at_level: int) -> bool:
	var stop_level: int = part.get("stop", 0)
	return part.order <= at_level and (stop_level <= 0 or at_level < stop_level)


func _apply_level(new_level: int) -> void:
	_pending_level = -1
	level = new_level
	for i in _layers.size():
		_fade_layer(i, 1.0 if _is_audible(i, level) else 0.0)
	level_changed.emit(level)


func _fade_layer(index: int, target: float) -> void:
	var layer: Dictionary = _layers[index]
	if is_equal_approx(layer.gain, target):
		return
	if layer.tween:
		layer.tween.kill()
	var tween := create_tween()
	tween.tween_method(func(g: float) -> void: _set_layer_gain(index, g), layer.gain, target, fade_seconds)
	layer.tween = tween


## Gain is linear 0..1; converted to dB on the player so a fade sounds even.
func _set_layer_gain(index: int, gain: float) -> void:
	if index >= _layers.size():
		return
	var layer: Dictionary = _layers[index]
	layer.gain = gain
	layer.player.volume_db = volume_db + (linear_to_db(gain) if gain > 0.0005 else -80.0)
