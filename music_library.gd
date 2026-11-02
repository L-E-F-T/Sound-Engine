class_name MusicLibrary
extends RefCounted
## Finds the songs the team drops into res://SoundEngine/Music and describes their parts.
##
## Two shapes of song:
## - One audio file: [code]Music/space_wizard_128bpm.ogg[/code]. A single part.
## - A folder of numbered parts, for adaptive music: [code]Music/space_wizard_128bpm/[/code]
##   containing [code]1_calm.ogg, 2_battle.ogg, 3_arp.pattern, 4_final.ogg[/code]. The tempo and
##   optional time signature go in the folder name; the number prefix is the order, which is
##   also the "level" at which the part comes in (see [MusicPlayer]).
##
## Part kinds: audio files (.ogg/.wav/.mp3, from the DAW) and .pattern text files (baked by the
## in-game synth, see [PatternBaker]). Audio parts are "versions" that replace each other;
## pattern parts are "layers" that stack. Filename tokens: [code]_layer[/code] makes an audio
## part stack, [code]_version[/code] makes a pattern part exclusive, and [code]_stopN[/code]
## silences the part from level N on ([code]3_arp_stop5.pattern[/code] plays at levels 3 and 4).
##
## Naming rule for tempo: [code]_128bpm[/code]; time signature: [code]_3-4[/code] after it.
## Anything without a BPM is listed with [constant DEFAULT_BPM] and flagged so the lab can warn.
## Loop playback is switched on at load time whatever the import settings say.

const MUSIC_DIR := "res://SoundEngine/Music"
const DEFAULT_BPM := 120.0
const EXTENSIONS := ["ogg", "wav", "mp3"]
const PATTERN_EXTENSION := "pattern"
const KIND_AUDIO := "audio"
const KIND_PATTERN := "pattern"


## One entry per song: { name, path, bpm, beats_per_bar, has_bpm, parts }. Sorted by name.
## Each part: { order, name, path, kind, additive, stop } (stop 0 = plays to the end).
static func scan(dir := MUSIC_DIR) -> Array[Dictionary]:
	var songs: Array[Dictionary] = []
	if not DirAccess.dir_exists_absolute(dir):
		return songs
	var seen := {}
	for entry in DirAccess.get_files_at(dir):
		# Exported games list "song.ogg.import" stubs; the original path still loads.
		var file: String = entry.trim_suffix(".import")
		if not file.get_extension().to_lower() in EXTENSIONS or seen.has(file):
			continue
		seen[file] = true
		var song := describe(dir.path_join(file))
		song.parts = [_describe_part(song.path, 1)]
		songs.append(song)
	for folder in DirAccess.get_directories_at(dir):
		if folder.begins_with("."):
			continue
		var song := describe(dir.path_join(folder))
		song.parts = scan_parts(song.path)
		if not song.parts.is_empty():
			songs.append(song)
	songs.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.name < b.name)
	return songs


## The ordered parts inside a song folder.
static func scan_parts(folder: String) -> Array[Dictionary]:
	var parts: Array[Dictionary] = []
	var seen := {}
	for entry in DirAccess.get_files_at(folder):
		var file: String = entry.trim_suffix(".import")
		var ext := file.get_extension().to_lower()
		if not (ext in EXTENSIONS or ext == PATTERN_EXTENSION) or seen.has(file):
			continue
		seen[file] = true
		var order_match := RegEx.create_from_string("^(\\d+)").search(file)
		if order_match == null:
			push_warning("MusicLibrary: %s has no number prefix; parts must be named like 1_calm.ogg" % file)
			continue
		parts.append(_describe_part(folder.path_join(file), int(order_match.get_string(1))))
	parts.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.order < b.order)
	return parts


## Parse tempo and time signature out of a file or folder name.
static func describe(path: String) -> Dictionary:
	var base := path.get_file().get_basename() if path.get_extension() != "" else path.get_file()
	var bpm := DEFAULT_BPM
	var has_bpm := false
	var beats_per_bar := 4
	var bpm_match := RegEx.create_from_string("(?i)(\\d+(?:\\.\\d+)?)\\s*bpm").search(base)
	if bpm_match:
		bpm = float(bpm_match.get_string(1))
		has_bpm = true
	var sig_match := RegEx.create_from_string("_(\\d+)-(\\d+)(?:_|$)").search(base)
	if sig_match:
		beats_per_bar = int(sig_match.get_string(1))
	return {
		name = base,
		path = path,
		bpm = bpm,
		beats_per_bar = beats_per_bar,
		has_bpm = has_bpm,
		parts = [],
	}


## Load any audio file as a stream with looping forced on. Works before the editor has imported
## it, and for folders outside res://.
static func load_stream(path: String) -> AudioStream:
	var stream: AudioStream = null
	if ResourceLoader.exists(path):
		stream = load(path) as AudioStream
	if stream == null:
		match path.get_extension().to_lower():
			"wav":
				stream = AudioStreamWAV.load_from_file(path)
			"ogg":
				stream = AudioStreamOggVorbis.load_from_file(path)
			"mp3":
				stream = AudioStreamMP3.load_from_file(path)
	if stream == null:
		push_warning("MusicLibrary: could not load %s" % path)
		return null
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_begin = 0
		stream.loop_end = _wav_frames(stream)
	return stream


## The song's first audio part as a stream (single-file songs: the file itself).
static func load_song(entry: Dictionary) -> AudioStream:
	for part in entry.parts:
		if part.kind == KIND_AUDIO:
			return load_stream(part.path)
	return null


## How many beats long the stream is. A whole number of bars means the loop will stay on the grid.
static func beats_in(stream: AudioStream, bpm: float) -> float:
	return stream.get_length() * bpm / 60.0


## "" if the loop length is fine, otherwise a human-readable warning for the lab.
static func loop_warning(entry: Dictionary, stream: AudioStream) -> String:
	if not entry.has_bpm:
		return "No BPM in the name; assuming %.0f. Name it like song_128bpm.ogg (or a folder song_128bpm)." % DEFAULT_BPM
	var beats := beats_in(stream, entry.bpm)
	var bar_beats := float(entry.beats_per_bar)
	var bars := beats / bar_beats
	var drift_beats := absf(bars - roundf(bars)) * bar_beats
	if drift_beats > 0.05:
		return "Loop is %.2f bars at %.0f BPM (off by %.0f ms per pass). Re-export as whole bars." % [
				bars, entry.bpm, drift_beats * 60.0 / entry.bpm * 1000.0]
	return ""


static func _describe_part(path: String, order: int) -> Dictionary:
	var file := path.get_file()
	var base := file.get_basename()
	var ext := file.get_extension().to_lower()
	var kind := KIND_PATTERN if ext == PATTERN_EXTENSION else KIND_AUDIO
	# Strip the number prefix for the display name: "3_arp" -> "arp".
	var display := RegEx.create_from_string("^\\d+[_ -]*").sub(base, "")
	if display.is_empty():
		display = base
	var additive := kind == KIND_PATTERN
	if base.ends_with("_layer") or "_layer_" in base:
		additive = true
	if base.ends_with("_version") or "_version_" in base:
		additive = false
	var stop := 0
	var stop_match := RegEx.create_from_string("_stop(\\d+)").search(base)
	if stop_match:
		stop = int(stop_match.get_string(1))
		display = display.replace(stop_match.get_string(0), "")
	display = display.replace("_layer", "").replace("_version", "")
	return {
		order = order,
		name = display,
		path = path,
		kind = kind,
		additive = additive,
		stop = stop,
	}


static func _wav_frames(wav: AudioStreamWAV) -> int:
	var bytes_per_sample := 1
	match wav.format:
		AudioStreamWAV.FORMAT_16_BITS:
			bytes_per_sample = 2
		AudioStreamWAV.FORMAT_IMA_ADPCM, AudioStreamWAV.FORMAT_QOA:
			return int(wav.get_length() * wav.mix_rate)
	var channels := 2 if wav.stereo else 1
	@warning_ignore("integer_division")
	return wav.data.size() / (bytes_per_sample * channels)
