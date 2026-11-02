class_name PatternBaker
extends RefCounted
## Turns a .pattern text file into a looping synth layer at a song's tempo.
##
## A .pattern file is plain text: a few song-level lines, then one or more [track] sections.
## Every field is listed in Music/TEMPLATE.pattern and README section 7.4. Two ways to write
## the steps:
## [codeblock]
## # Compact: one character per step; pitch comes from the notes list in turn.
## pattern = x.x.X.x.|x.x.X.x.
## notes = 0 3 7 12
##
## # Readable: one token per step, pitch written in place. ! accent, ~ soft, | bar line.
## pattern = 0 . 7 . 12! . 7 . | D4 . F4 . A4~ . D5 .
## [/codeblock]
## Numbers are semitones from the song's root (or the patch's own pitch when no root is set);
## note names are absolute at A4 = 440. Every note is rendered by [SynthRenderer] and mixed at
## an exact sample, so the loop is sample-accurate and wraps seamlessly. Problems found while
## parsing are collected in [member last_problems] for the lab to show.

const SAMPLE_RATE := 44100
const SONG_KEYS := ["bars", "steps_per_beat", "transpose", "root"]
const TRACK_KEYS := ["patch", "pattern", "notes", "gain_db", "transpose", "condition"]
## Step characters (compact form) and the gain each plays at.
const STEP_GAIN := {"x": 0.7, "X": 1.0, "o": 0.35}
const REST_CHARS := ".-_"
const ACCENT_SUFFIX := "!"
const SOFT_SUFFIX := "~"
const MAX_BARS := 64

const NOTE_INDEX := {"c": 0, "d": 2, "e": 4, "f": 5, "g": 7, "a": 9, "b": 11}

## Human-readable problems from the most recent [method parse] or [method bake].
static var last_problems: PackedStringArray = []


# ------------------------------------------------------------------- Parsing

## Parse a .pattern file. Returns { bars, steps_per_beat, transpose, root, tracks: [...] } where
## each track is { patch, patterns (Array of lines), notes, gain_db, transpose, condition }.
static func parse(path: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		last_problems = PackedStringArray(["cannot read %s" % path])
		return {bars = 2, steps_per_beat = 4, transpose = 0.0, root = "", tracks = []}
	return parse_text(text, path.get_file())


## Parse pattern text (the lab edits text directly). [param label] names it in problems.
static func parse_text(text: String, label := "pattern") -> Dictionary:
	last_problems = PackedStringArray()
	var def := {bars = 2, steps_per_beat = 4, transpose = 0.0, root = "", tracks = []}
	var track: Dictionary = {}
	var line_number := 0
	for raw_line in text.split("\n"):
		line_number += 1
		var line := raw_line.strip_edges()
		# A # starts a comment only at the start of a line or after whitespace, so F#4 stays a note.
		var comment_at := _comment_start(line)
		if comment_at != -1:
			line = line.left(comment_at).strip_edges()
		if line.is_empty():
			continue
		if line.to_lower() == "[track]":
			if not track.is_empty():
				def.tracks.append(track)
			track = {patch = &"", patterns = [], notes = [0.0], gain_db = 0.0, transpose = 0.0, condition = &""}
			continue
		var eq := line.find("=")
		if eq == -1:
			_problem(label, line_number, "expected key = value, got '%s'" % line)
			continue
		var key := line.left(eq).strip_edges().to_lower()
		var value := line.substr(eq + 1).strip_edges()
		if track.is_empty():
			match key:
				"bars":
					def.bars = clampi(int(value), 1, MAX_BARS)
					if int(value) < 1 or int(value) > MAX_BARS:
						_problem(label, line_number, "bars must be 1 to %d" % MAX_BARS)
				"steps_per_beat":
					def.steps_per_beat = clampi(int(value), 1, 16)
				"transpose":
					def.transpose = float(value)
				"root":
					if value.is_valid_float() or _is_note_name(value):
						def.root = value
					else:
						_problem(label, line_number, "root must be a note name like C4 or a frequency in Hz")
				_:
					if key in TRACK_KEYS:
						_problem(label, line_number, "'%s' belongs inside a [track] section" % key)
					else:
						_problem(label, line_number, "unknown song key '%s' (song keys: %s)" % [key, ", ".join(SONG_KEYS)])
		else:
			match key:
				"patch":
					track.patch = StringName(value)
				"pattern":
					_check_pattern_line(value, label, line_number)
					track.patterns.append(value)
				"notes":
					track.notes = _parse_notes(value, label, line_number)
				"gain_db":
					track.gain_db = float(value)
				"transpose":
					track.transpose = float(value)
				"condition":
					track.condition = StringName(value)
				_:
					if key in SONG_KEYS:
						_problem(label, line_number, "'%s' belongs above the first [track]" % key)
					else:
						_problem(label, line_number, "unknown track key '%s' (track keys: %s)" % [key, ", ".join(TRACK_KEYS)])
	if not track.is_empty():
		def.tracks.append(track)
	if def.tracks.is_empty():
		_problem(label, 0, "no [track] sections")
	return def


## The steps of a track as a list of { rest: bool, gain: float, pitch: Variant } where pitch is
## null (take the next entry from notes), a float (semitones), or a String (note name).
## Several pattern lines join up; a line with spaces is read one token per step, otherwise one
## character per step. "|" is a bar line and is ignored.
static func steps_of(track: Dictionary) -> Array:
	var lines: Array = track.patterns
	var token_mode := false
	for line in lines:
		if " " in String(line).strip_edges() or "\t" in String(line):
			token_mode = true
	var steps: Array = []
	if token_mode:
		var joined := " ".join(lines).replace("|", " ")
		for token in joined.split(" ", false):
			steps.append(_token_step(token))
	else:
		var joined := "".join(lines).replace("|", "")
		for ch in joined:
			if STEP_GAIN.has(ch):
				steps.append({rest = false, gain = STEP_GAIN[ch], pitch = null})
			else:
				steps.append({rest = true, gain = 0.0, pitch = null})
	return steps


# -------------------------------------------------------------------- Baking

## Render a parsed pattern into a looping stream exactly [code]bars[/code] long at [param bpm].
static func bake(def: Dictionary, bpm: float, beats_per_bar: int) -> AudioStreamWAV:
	var steps_per_beat: int = def.steps_per_beat
	var seconds_per_step := 60.0 / bpm / steps_per_beat
	var total_steps: int = def.bars * beats_per_bar * steps_per_beat
	var loop_samples := int(roundf(total_steps * seconds_per_step * SAMPLE_RATE))
	var mix := PackedFloat32Array()
	mix.resize(loop_samples)
	var song_transpose: float = def.transpose
	var root_midi := _root_midi(def.root)

	var cache: Dictionary = {}
	for track in def.tracks:
		var patch: SynthPatch = Sfx.patches.get(track.patch)
		if patch == null:
			_problem("bake", 0, "no sound named '%s'" % track.patch)
			continue
		var steps := steps_of(track)
		if steps.is_empty():
			continue
		var cond: SfxCondition = Sfx.conditions.get(track.condition) if track.condition != &"" else null
		if track.condition != &"" and cond == null:
			_problem("bake", 0, "no condition named '%s'" % track.condition)
		var notes: Array = track.notes
		var gain := db_to_linear(float(track.gain_db))
		var base_patch: SynthPatch = cond.apply_to(patch) if cond else patch
		var base_midi := _freq_to_midi(patch.base_freq)
		# Numbers count from the root when one is set, else from the patch's own pitch.
		var number_shift := (root_midi - base_midi) if root_midi > 0.0 else 0.0
		var note_index := 0
		for step in total_steps:
			var s: Dictionary = steps[step % steps.size()]
			if s.rest:
				continue
			var pitch: Variant = s.pitch
			if pitch == null:
				pitch = notes[note_index % notes.size()]
				note_index += 1
			var semitones := _resolve(pitch, base_midi, number_shift) + song_transpose + float(track.transpose)
			var key := "%s|%s@%.2f" % [track.patch, track.condition, semitones]
			if not cache.has(key):
				var voice := base_patch.transposed(semitones)
				voice.sample_rate = SAMPLE_RATE
				voice.loop = false
				cache[key] = SynthRenderer.render(voice)
			var offset := int(roundf(step * seconds_per_step * SAMPLE_RATE))
			SynthRenderer.mix_into(mix, cache[key], offset, gain * float(s.gain))

	# Leave headroom so stacked layers do not clip the Music bus.
	var peak := 0.0
	for v in mix:
		peak = maxf(peak, absf(v))
	if peak > 0.0:
		var norm := 0.7 / peak
		for i in mix.size():
			mix[i] *= norm
	return SynthRenderer.to_wav(mix, SAMPLE_RATE, true)


## Convenience: file straight to stream.
static func bake_file(path: String, bpm: float, beats_per_bar: int) -> AudioStreamWAV:
	return bake(parse(path), bpm, beats_per_bar)


## Length of the loop a pattern definition produces, in seconds, at a tempo.
static func loop_seconds(def: Dictionary, bpm: float, beats_per_bar: int) -> float:
	return def.bars * beats_per_bar * 60.0 / bpm


# ------------------------------------------------------------------ Internals

static func _token_step(raw: String) -> Dictionary:
	var token := raw
	var gain := 0.7
	if token.ends_with(ACCENT_SUFFIX):
		gain = 1.0
		token = token.left(token.length() - 1)
	elif token.ends_with(SOFT_SUFFIX):
		gain = 0.35
		token = token.left(token.length() - 1)
	if token.is_empty() or token in [".", "-", "_"]:
		return {rest = true, gain = 0.0, pitch = null}
	if STEP_GAIN.has(token):
		return {rest = false, gain = STEP_GAIN[token] if raw == token else gain, pitch = null}
	if token.is_valid_float():
		return {rest = false, gain = gain, pitch = float(token)}
	if _is_note_name(token):
		return {rest = false, gain = gain, pitch = token}
	return {rest = true, gain = 0.0, pitch = null}


static func _check_pattern_line(value: String, label: String, line_number: int) -> void:
	if " " in value or "\t" in value:
		for token in value.replace("|", " ").split(" ", false):
			var t := token
			if t.ends_with(ACCENT_SUFFIX) or t.ends_with(SOFT_SUFFIX):
				t = t.left(t.length() - 1)
			if not (t in [".", "-", "_"] or STEP_GAIN.has(t) or t.is_valid_float() or _is_note_name(t)):
				_problem(label, line_number, "step '%s' is not a rest (.), a hit (x X o), a number or a note name" % token)
				return
	else:
		for ch in value:
			if not STEP_GAIN.has(ch) and not ch in REST_CHARS and ch != "|":
				_problem(label, line_number, "pattern has '%s'; use x X o for hits, . for rests, | for bar lines (or write steps separated by spaces)" % ch)
				return


## "0 3 7" are semitone numbers; "D4 F#4 A4" are note names. Stored as floats or Strings.
static func _parse_notes(value: String, label: String, line_number: int) -> Array:
	var notes: Array = []
	for token in value.split(" ", false):
		var t := token.strip_edges()
		if t.is_valid_float():
			notes.append(float(t))
		elif _is_note_name(t):
			notes.append(t)
		else:
			_problem(label, line_number, "note '%s' is not a number or a note name like D4" % t)
	return notes if not notes.is_empty() else [0.0]


static func _is_note_name(token: String) -> bool:
	return RegEx.create_from_string("^[A-Ga-g][#b]?-?\\d$").search(token) != null


## Semitones to render at, relative to the patch pitch (midi [param base_midi]).
static func _resolve(pitch: Variant, base_midi: float, number_shift: float) -> float:
	if typeof(pitch) == TYPE_FLOAT or typeof(pitch) == TYPE_INT:
		return float(pitch) + number_shift
	return _note_to_midi(String(pitch)) - base_midi


static func _note_to_midi(name: String) -> float:
	var lower := name.to_lower()
	var letter := lower[0]
	var rest := lower.substr(1)
	var accidental := 0
	if rest.begins_with("#"):
		accidental = 1
		rest = rest.substr(1)
	elif rest.begins_with("b"):
		accidental = -1
		rest = rest.substr(1)
	var octave := int(rest)
	return float(12 * (octave + 1) + int(NOTE_INDEX[letter]) + accidental)


static func _freq_to_midi(freq: float) -> float:
	return 69.0 + 12.0 * log(freq / 440.0) / log(2.0)


## MIDI number of the song root, or 0 when none is set.
static func _root_midi(root: String) -> float:
	if root.is_empty():
		return 0.0
	if root.is_valid_float():
		return _freq_to_midi(float(root))
	return _note_to_midi(root)


static func _comment_start(line: String) -> int:
	for i in line.length():
		if line[i] == "#" and (i == 0 or line[i - 1] == " " or line[i - 1] == "\t"):
			return i
	return -1


static func _problem(label: String, line_number: int, text: String) -> void:
	var where := "%s line %d: " % [label, line_number] if line_number > 0 else "%s: " % label
	last_problems.append(where + text)
	push_warning("PatternBaker: " + where + text)
