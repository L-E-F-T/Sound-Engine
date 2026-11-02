extends Node
## Autoload "BeatClock": the single source of musical time for the whole game.
##
## When a music player is attached, time comes from the audio hardware itself using Godot's
## recommended formula, so it never drifts from what the player hears:
##   heard_position = playback_position + time_since_last_mix - output_latency
## Without music it free-runs from the system clock at [member bpm], so beat-quantized sounds
## still work in menus or before the track starts.
##
## Positions are expressed in beats (quarter notes). Beat 0 is the first downbeat.

signal beat(beat_index: int)
signal bar(bar_index: int)
signal step(step_index: int)

## Beats per minute of the attached music (or of the free-running clock).
@export var bpm := 110.0
@export var beats_per_bar := 4
## Subdivisions per beat that fire [signal step]. 4 means sixteenth notes.
@export var steps_per_beat := 4
## Shift the grid if the music file has silence before its first downbeat.
@export var offset_seconds := 0.0

var music_player: AudioStreamPlayer
var running := false

var _free_start_usec := 0
var _stream_length := 0.0
var _last_position := 0.0
var _loops := 0
var _last_step := -1


func _process(_delta: float) -> void:
	if not running:
		return
	var current_step := floori(get_beat() * steps_per_beat)
	if current_step == _last_step:
		return
	# Catch up one step at a time so a long frame never swallows a beat.
	while _last_step < current_step:
		_last_step += 1
		if _last_step < 0:
			continue
		step.emit(_last_step)
		if _last_step % steps_per_beat == 0:
			var beat_index := floori(_last_step / float(steps_per_beat))
			beat.emit(beat_index)
			if beat_index % beats_per_bar == 0:
				bar.emit(floori(beat_index / float(beats_per_bar)))


## Start counting. Pass the [AudioStreamPlayer] that plays the music to lock to it, or nothing
## to free-run. The player should already be playing (or start on the same frame).
func start(player: AudioStreamPlayer = null, p_bpm := bpm, p_beats_per_bar := beats_per_bar) -> void:
	bpm = p_bpm
	beats_per_bar = p_beats_per_bar
	music_player = player
	_stream_length = player.stream.get_length() if player and player.stream else 0.0
	_last_position = 0.0
	_loops = 0
	_last_step = -1
	_free_start_usec = Time.get_ticks_usec()
	running = true


func stop() -> void:
	running = false
	music_player = null


func seconds_per_beat() -> float:
	return 60.0 / bpm


## Seconds elapsed on the musical timeline, as heard by the player right now.
func get_time() -> float:
	if not running:
		return 0.0
	if music_player != null and music_player.playing:
		var position := music_player.get_playback_position() \
				+ AudioServer.get_time_since_last_mix() \
				- AudioServer.get_output_latency()
		# A looping stream wraps back to zero; keep counting upward across the seam.
		if _stream_length > 0.0 and position < _last_position - _stream_length * 0.5:
			_loops += 1
		_last_position = position
		return _loops * _stream_length + position - offset_seconds
	return (Time.get_ticks_usec() - _free_start_usec) / 1_000_000.0 - offset_seconds


## Fractional beat position, e.g. 5.25 is a sixteenth past beat 5.
func get_beat() -> float:
	return get_time() / seconds_per_beat()


## Beat within the current bar, 0-based, for UI.
func get_beat_in_bar() -> int:
	return posmod(floori(get_beat()), beats_per_bar)


func get_bar() -> int:
	return floori(get_beat() / float(beats_per_bar))


## The next grid line at or after now, in beats. [param quantize] is the grid size in beats:
## 0.25 for sixteenths, 1.0 for beats, [member beats_per_bar] for bars.
func next_grid_beat(quantize: float) -> float:
	if quantize <= 0.0:
		return get_beat()
	var now := get_beat()
	var target := ceilf(now / quantize) * quantize
	return target


## Seconds from now until the next grid line of size [param quantize] beats.
func seconds_until(quantize: float) -> float:
	return (next_grid_beat(quantize) - get_beat()) * seconds_per_beat()


## Convert a beat position to seconds on the timeline.
func beats_to_seconds(beats: float) -> float:
	return beats * seconds_per_beat()
