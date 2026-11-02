class_name PaletteWriter
extends RefCounted
## Turns a [SynthPatch] or an [SfxCondition] back into palette code and writes it into the
## matching palette file (sfx_palette.gd or condition_palette.gd).
##
## The Sound and Condition labs use it: the text box shows a block, Apply & commit rewrites it,
## New appends one and Delete removes one.
##
## Two layouts, same reader. Compact lists only values that differ from the defaults. Full lists
## every knob (and, for a condition, every effect property and every possible synth override),
## grouped, with `# *` after each value changed from its default. The labs' editor shows Full;
## [constant PALETTE_FULL] picks which one the palette files get.

const PALETTE_PATH := "res://SoundEngine/sfx_palette.gd"
const CONDITION_PALETTE_PATH := "res://SoundEngine/condition_palette.gd"
## The comment that marks a value changed from its default: `jump.decay = 0.3  # *`.
const CHANGED_MARK := "*"
## Write palette blocks in the Full layout (every knob, `# *` marks) instead of Compact.
const PALETTE_FULL := true
## Knobs that make no sense as a condition's synth override (a condition inside a condition).
const NOT_OVERRIDABLE: Array[StringName] = [&"condition"]
## Effect classes listed in the condition editor's help comment. Any AudioEffect class works.
const COMMON_EFFECTS := "LowPassFilter, HighPassFilter, BandPassFilter, NotchFilter, LowShelfFilter, " \
		+ "HighShelfFilter, EQ6, Reverb, Delay, Chorus, Phaser, Distortion, Compressor, PitchShift, " \
		+ "Amplify, Panner, StereoEnhance"
## Comment lines the Full layout writes itself. Any other comment inside a block is yours, and
## rewriting the block keeps it above the same line it was above.
const GENERATED_COMMENT := "^\\t+# (---- |Every knob|Every field|Classes \\(each|Example, uncomment|" \
		+ "var [A-Za-z0-9_]+_fx[0-9]+ := |[A-Za-z0-9_]+_fx[0-9]+\\.cutoff_hz = |them\\)\\. Uncomment|\"[A-Za-z0-9_]+\": )"


# ------------------------------------------------------------------ Patches

## The code block for one sound. Compact, e.g.
## [codeblock]
## 	var jump := SynthPatch.new()
## 	jump.wave = SynthPatch.Wave.SQUARE
## 	jump.base_freq = 600.0
## 	p[&"jump"] = jump
## [/codeblock]
## With [param full], every knob is listed under its group (`# ---- Oscillator`), enum knobs
## list their choices, and changed ones end in `# *`.
static func patch_to_code(sound: StringName, patch: SynthPatch, var_name := "", full := false) -> String:
	if var_name.is_empty():
		var_name = String(sound)
	var defaults := SynthPatch.new()
	var lines: PackedStringArray = ["\tvar %s := SynthPatch.new()" % var_name]
	var group := ""
	for prop in patch.get_property_list():
		if prop.usage & PROPERTY_USAGE_CATEGORY:
			group = ""
			continue
		if prop.usage & PROPERTY_USAGE_GROUP:
			group = prop.name
			continue
		if not (prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue
		var key: StringName = prop.name
		var value: Variant = patch.get(key)
		var changed := not same_value(value, defaults.get(key))
		if not full and not changed:
			continue
		if full and not group.is_empty():
			lines.append("\t# ---- %s" % group)
			group = ""
		var code := "\t%s.%s = %s" % [var_name, key, _format_value(key, value)]
		lines.append(_with_mark(code, changed, enum_choices(key)) if full else code)
	lines.append("\tp[&\"%s\"] = %s" % [sound, var_name])
	return "\n".join(lines)


## Replace the sound's block in sfx_palette.gd, or append a new block before `return p`.
static func write_to_palette(sound: StringName, patch: SynthPatch) -> Error:
	return _write_block(PALETTE_PATH, "p", "SynthPatch", sound,
			func(var_name: String) -> String: return patch_to_code(sound, patch, var_name, PALETTE_FULL))


## "choices: SINE SQUARE ..." for an enum knob, or "" for any other knob.
static func enum_choices(key: StringName) -> String:
	var table: Dictionary = {}
	match key:
		&"wave":
			table = SynthPatch.Wave
		&"filter_mode":
			table = SynthPatch.FilterMode
		&"vibrato_shape", &"tremolo_shape", &"filter_lfo_shape":
			table = SynthPatch.LfoShape
		&"arpeggio_mode":
			table = SynthPatch.ArpMode
		&"envelope_curve":
			table = SynthPatch.EnvCurve
	return "" if table.is_empty() else "choices: " + " ".join(PackedStringArray(table.keys()))


## True when two knob values are the same setting: 440 and 440.0 match, arrays match by items,
## &"x" and "x" match.
static func same_value(a: Variant, b: Variant) -> bool:
	var numbers := [TYPE_INT, TYPE_FLOAT]
	if typeof(a) in numbers and typeof(b) in numbers:
		return float(a) == float(b)
	if typeof(a) == TYPE_ARRAY and typeof(b) == TYPE_ARRAY:
		if a.size() != b.size():
			return false
		for i in a.size():
			if not same_value(a[i], b[i]):
				return false
		return true
	if typeof(a) in [TYPE_STRING, TYPE_STRING_NAME] and typeof(b) in [TYPE_STRING, TYPE_STRING_NAME]:
		return String(a) == String(b)
	return typeof(a) == typeof(b) and a == b


## `code  # * note`, `code  # note`, `code  # *` or `code`.
static func _with_mark(code: String, changed: bool, note := "") -> String:
	var parts: PackedStringArray = []
	if changed:
		parts.append(CHANGED_MARK)
	if not note.is_empty():
		parts.append(note)
	return code if parts.is_empty() else "%s  # %s" % [code, " ".join(parts)]


## Delete the sound's block from sfx_palette.gd. ERR_DOES_NOT_EXIST if it has no block there.
static func remove_from_palette(sound: StringName) -> Error:
	return _remove_block(PALETTE_PATH, "p", "SynthPatch", sound)


# --------------------------------------------------------------- Conditions

## The code block for one condition. Effects are written out as explicit constructions so any
## AudioEffect round-trips, e.g.
## [codeblock]
## 	var wood := SfxCondition.new()
## 	var wood_fx0 := AudioEffectBandPassFilter.new()
## 	wood_fx0.cutoff_hz = 900.0
## 	wood_fx0.resonance = 0.6
## 	wood.effects = [wood_fx0]
## 	wood.patch_overrides = {
## 		"cutoff": 800.0,
## 	}
## 	c[&"wood"] = wood
## [/codeblock]
static func condition_to_code(condition: StringName, cond: SfxCondition, var_name := "", full := false) -> String:
	if var_name.is_empty():
		var_name = String(condition)
	var defaults := SfxCondition.new()
	var lines: PackedStringArray = ["\tvar %s := SfxCondition.new()" % var_name]
	if full:
		lines.append("\t# ---- Bus effects, applied in order. Add one: a var line, its properties, then list it in effects.")
		lines.append("\t# Classes (each starts with AudioEffect): %s" % COMMON_EFFECTS)
	var effect_names: PackedStringArray = []
	for i in cond.effects.size():
		var effect: AudioEffect = cond.effects[i]
		if effect == null:
			continue
		var fx_name := "%s_fx%d" % [var_name, i]
		effect_names.append(fx_name)
		lines.append("\tvar %s := %s.new()" % [fx_name, effect.get_class()])
		lines.append_array(_effect_property_lines(fx_name, effect, full))
	if full and effect_names.is_empty():
		lines.append("\t# Example, uncomment both lines and put %s_fx0 inside effects = [ ]:" % var_name)
		lines.append("\t# var %s_fx0 := AudioEffectLowPassFilter.new()" % var_name)
		lines.append("\t# %s_fx0.cutoff_hz = 900.0" % var_name)
	if full or not effect_names.is_empty():
		lines.append(_with_mark("\t%s.effects = [%s]" % [var_name, ", ".join(effect_names)],
				full and not effect_names.is_empty()))
	if full:
		lines.append("\t# ---- Whole-condition pitch and volume (files and synth sounds alike)")
	for field in [&"volume_db", &"pitch_scale"]:
		var changed := not is_equal_approx(cond.get(field), defaults.get(field))
		if full or changed:
			var code := "\t%s.%s = %s" % [var_name, field, var_to_str(cond.get(field))]
			lines.append(_with_mark(code, changed) if full else code)
	if full:
		lines.append("\t# ---- Synth knob overrides for every synth sound under this condition (audio files ignore")
		lines.append("\t# them). Uncomment a line to override that knob; the value shown is the knob's default.")
		lines.append("\t%s.patch_overrides = {" % var_name)
		var knob_defaults := SynthPatch.new()
		var listed := {}
		for prop in knob_defaults.get_property_list():
			if not (prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) or StringName(prop.name) in NOT_OVERRIDABLE:
				continue
			var key: StringName = prop.name
			listed[String(key)] = true
			if cond.patch_overrides.has(String(key)):
				lines.append(_with_mark("\t\t\"%s\": %s," % [key, _format_value(key, cond.patch_overrides[String(key)])],
						true, enum_choices(key)))
			else:
				lines.append("\t\t# \"%s\": %s," % [key, _format_value(key, knob_defaults.get(key))])
		for key in cond.patch_overrides:
			if not listed.has(String(key)):
				lines.append(_with_mark("\t\t\"%s\": %s," % [key, _format_value(StringName(key), cond.patch_overrides[key])], true))
		lines.append("\t}")
	elif not cond.patch_overrides.is_empty():
		lines.append("\t%s.patch_overrides = {" % var_name)
		for key in cond.patch_overrides:
			lines.append("\t\t\"%s\": %s," % [key, _format_value(StringName(key), cond.patch_overrides[key])])
		lines.append("\t}")
	lines.append("\tc[&\"%s\"] = %s" % [condition, var_name])
	return "\n".join(lines)


## Replace the condition's block in condition_palette.gd, or append one before `return c`.
static func write_to_condition_palette(condition: StringName, cond: SfxCondition) -> Error:
	return _write_block(CONDITION_PALETTE_PATH, "c", "SfxCondition", condition,
			func(var_name: String) -> String: return condition_to_code(condition, cond, var_name, PALETTE_FULL))


## Delete the condition's block from condition_palette.gd. ERR_DOES_NOT_EXIST if it has none.
static func remove_from_condition_palette(condition: StringName) -> Error:
	return _remove_block(CONDITION_PALETTE_PATH, "c", "SfxCondition", condition)


# ------------------------------------------------------------ Change marks

## Which lines of an editor block hold a value, and whether that value differs from its default:
## {line_index: true (changed) or false (default)}. Lines that are comments, headers or not values
## are left out. Works for both a sound block and a condition block. The labs use it to tint
## changed lines while you type, before Apply rewrites the `# *` comments.
static func changed_lines(text: String) -> Dictionary:
	var saved := last_problems
	var result := {}
	var lines := text.split("\n")
	var is_condition := text.contains("SfxCondition.new()")
	var patch_defaults := SynthPatch.new()
	var cond_defaults := SfxCondition.new()
	var effect_defaults := {}
	var in_overrides := false
	var value_re := RegEx.create_from_string("^([A-Za-z_][A-Za-z0-9_]*)\\.([A-Za-z_][A-Za-z0-9_]*)\\s*=\\s*(.+)$")
	var set_re := RegEx.create_from_string("^([A-Za-z_][A-Za-z0-9_]*)\\.set\\(\\s*\"([^\"]+)\"\\s*,\\s*(.+)\\)$")
	var decl_re := RegEx.create_from_string("^var\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*:=\\s*([A-Za-z0-9_]+)\\.new\\(\\)")
	for i in lines.size():
		var line := _strip_comment(lines[i]).strip_edges()
		if line.is_empty():
			continue
		if in_overrides:
			if line.begins_with("}"):
				in_overrides = false
			elif line.contains(":"):
				result[i] = true
			continue
		if not is_condition:
			var m := value_re.search(line)
			if m and _has_property(patch_defaults, m.get_string(2)):
				var v: Variant = _parse_value(m.get_string(3), i + 1)
				if typeof(v) != TYPE_NIL:
					result[i] = not same_value(v, patch_defaults.get(m.get_string(2)))
			continue
		var decl := decl_re.search(line)
		if decl:
			if ClassDB.class_exists(decl.get_string(2)) and ClassDB.is_parent_class(decl.get_string(2), "AudioEffect"):
				effect_defaults[decl.get_string(1)] = ClassDB.instantiate(decl.get_string(2))
			continue
		var s := set_re.search(line)
		var m := value_re.search(line)
		var owner := s.get_string(1) if s else (m.get_string(1) if m else "")
		var prop := s.get_string(2) if s else (m.get_string(2) if m else "")
		var rhs := s.get_string(3) if s else (m.get_string(3) if m else "")
		if owner.is_empty():
			continue
		if effect_defaults.has(owner):
			var v: Variant = _parse_value(rhs, i + 1)
			if typeof(v) != TYPE_NIL:
				result[i] = not same_value(v, effect_defaults[owner].get(prop))
		elif prop == "patch_overrides":
			in_overrides = rhs.count("{") > rhs.count("}")
		elif prop == "effects":
			result[i] = rhs.strip_edges() != "[]"
		elif prop in ["volume_db", "pitch_scale"]:
			var v: Variant = _parse_value(rhs, i + 1)
			if typeof(v) != TYPE_NIL:
				result[i] = not same_value(v, cond_defaults.get(prop))
	last_problems = saved
	return result


# --------------------------------------------------------- Reading code back
# The labs show a sound or condition as the same text that lives in the palette, let you edit
# it, and read it back. These parse exactly the shape patch_to_code / condition_to_code write.

## Problems from the most recent [method code_to_patch] or [method code_to_condition].
static var last_problems: PackedStringArray = []


## The variable name a palette file already uses for a key (`jump` for `p[&"p_jump"] = jump`),
## so the labs show the same text that is in the file. Falls back to the key itself.
static func palette_var_name(path: String, dict_var: String, key: StringName) -> String:
	var key_line := "\t%s[&\"%s\"] = " % [dict_var, key]
	if FileAccess.file_exists(path):
		for line in FileAccess.get_file_as_string(path).split("\n"):
			if line.begins_with(key_line):
				return line.trim_prefix(key_line).strip_edges()
	return String(key)


## The dictionary key named in a block, from its last line: `p[&"jump"] = jump` -> "jump".
static func key_in_code(text: String) -> StringName:
	var found := RegEx.create_from_string("\\b[pc]\\[&\"([A-Za-z0-9_]+)\"\\]\\s*=").search(text)
	return StringName(found.get_string(1)) if found else &""


## Build a [SynthPatch] from a block of palette text. Lines that are not `name.knob = value`
## are ignored (the `var x := SynthPatch.new()` and `p[&"x"] = x` lines included).
static func code_to_patch(text: String) -> SynthPatch:
	last_problems = PackedStringArray()
	var patch := SynthPatch.new()
	var line_number := 0
	for raw in text.split("\n"):
		line_number += 1
		var line := _strip_comment(raw).strip_edges()
		if line.is_empty() or line.begins_with("var ") or line.begins_with("p[") or line.begins_with("c["):
			continue
		var m := RegEx.create_from_string("^[A-Za-z_][A-Za-z0-9_]*\\.([A-Za-z_][A-Za-z0-9_]*)\\s*=\\s*(.+)$").search(line)
		if m == null:
			last_problems.append("line %d: expected name.knob = value" % line_number)
			continue
		var knob := m.get_string(1)
		if not _has_property(patch, knob):
			last_problems.append("line %d: SynthPatch has no knob '%s'" % [line_number, knob])
			continue
		var value: Variant = _parse_value(m.get_string(2).strip_edges(), line_number)
		if typeof(value) == TYPE_NIL:
			continue
		patch.set(knob, value)
	return patch


## Build an [SfxCondition] from a block of palette text, including `var x_fx0 := AudioEffect...`
## lines, their property lines, `x.effects = [x_fx0, ...]` and a multi-line `patch_overrides = {}`.
static func code_to_condition(text: String) -> SfxCondition:
	last_problems = PackedStringArray()
	var cond := SfxCondition.new()
	var effects: Dictionary = {}
	var lines := text.split("\n")
	var i := 0
	while i < lines.size():
		var line_number := i + 1
		var line := _strip_comment(lines[i]).strip_edges()
		i += 1
		if line.is_empty() or line.begins_with("c[") or line.begins_with("p["):
			continue
		var fx_decl := RegEx.create_from_string("^var\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*:=\\s*([A-Za-z0-9_]+)\\.new\\(\\)").search(line)
		if fx_decl:
			var class_name_str := fx_decl.get_string(2)
			if class_name_str == "SfxCondition":
				continue
			if not ClassDB.class_exists(class_name_str) or not ClassDB.is_parent_class(class_name_str, "AudioEffect"):
				last_problems.append("line %d: '%s' is not an AudioEffect class" % [line_number, class_name_str])
				continue
			effects[fx_decl.get_string(1)] = ClassDB.instantiate(class_name_str)
			continue
		# `fx.set("band_db/32_hz", -6.0)`: the form for effect properties whose names have a slash.
		var s := RegEx.create_from_string("^([A-Za-z_][A-Za-z0-9_]*)\\.set\\(\\s*\"([^\"]+)\"\\s*,\\s*(.+)\\)$").search(line)
		var m := RegEx.create_from_string("^([A-Za-z_][A-Za-z0-9_]*)\\.([A-Za-z_][A-Za-z0-9_]*)\\s*=\\s*(.*)$").search(line)
		if s == null and m == null:
			last_problems.append("line %d: expected name.property = value" % line_number)
			continue
		var owner := (s if s else m).get_string(1)
		var prop := (s if s else m).get_string(2)
		var rhs := (s if s else m).get_string(3).strip_edges()
		if s and not effects.has(owner):
			last_problems.append("line %d: .set() is only for effect properties; '%s' is not an effect declared above" % [line_number, owner])
			continue
		if effects.has(owner):
			var effect: Object = effects[owner]
			if not _has_property(effect, prop):
				last_problems.append("line %d: %s has no property '%s'" % [line_number, effect.get_class(), prop])
				continue
			var v: Variant = _parse_value(rhs, line_number)
			if typeof(v) != TYPE_NIL:
				effect.set(prop, v)
			continue
		match prop:
			"effects":
				var list: Array[AudioEffect] = []
				for name in RegEx.create_from_string("[A-Za-z_][A-Za-z0-9_]*").search_all(rhs):
					var n := name.get_string()
					if effects.has(n):
						list.append(effects[n])
					else:
						last_problems.append("line %d: effects refers to '%s', which was not declared above" % [line_number, n])
				cond.effects = list
			"patch_overrides":
				# Collect the dictionary body, which may span lines until the closing brace.
				var body := rhs
				while body.count("{") > body.count("}") and i < lines.size():
					body += "\n" + _strip_comment(lines[i])
					i += 1
				cond.patch_overrides = _parse_overrides(body, line_number)
			"volume_db", "pitch_scale":
				var v: Variant = _parse_value(rhs, line_number)
				if typeof(v) != TYPE_NIL:
					cond.set(prop, v)
			_:
				last_problems.append("line %d: SfxCondition has no property '%s'" % [line_number, prop])
	return cond


static func _parse_overrides(body: String, line_number: int) -> Dictionary:
	var result := {}
	var inner := body.strip_edges().trim_prefix("{").trim_suffix("}")
	for entry in _split_top_level(inner):
		var e := entry.strip_edges()
		if e.is_empty():
			continue
		var colon := e.find(":")
		if colon == -1:
			last_problems.append("line %d: override '%s' needs \"knob\": value" % [line_number, e])
			continue
		var key := e.left(colon).strip_edges().trim_prefix("\"").trim_suffix("\"")
		var v: Variant = _parse_value(e.substr(colon + 1).strip_edges(), line_number)
		if typeof(v) != TYPE_NIL:
			result[key] = v
	return result


## Split on commas that are not inside [ ] or quotes, so `"arpeggio": [0, 4, 7], "drive": 0.3`
## gives two entries, not four.
static func _split_top_level(text: String) -> PackedStringArray:
	var parts: PackedStringArray = []
	var depth := 0
	var quoted := false
	var start := 0
	for i in text.length():
		var ch := text[i]
		if ch == "\"":
			quoted = not quoted
		elif not quoted and ch == "[":
			depth += 1
		elif not quoted and ch == "]":
			depth -= 1
		elif not quoted and depth == 0 and ch == ",":
			parts.append(text.substr(start, i - start))
			start = i + 1
	parts.append(text.substr(start))
	return parts


## Parse the right-hand side of a palette line: numbers, true/false, &"names", "strings",
## SynthPatch.Wave.SAW style enums, and [1, 2, 3] arrays.
static func _parse_value(rhs: String, line_number: int) -> Variant:
	var s := rhs.strip_edges().trim_suffix(",").strip_edges()
	if s == "true":
		return true
	if s == "false":
		return false
	if s.is_valid_float():
		return float(s) if ("." in s or "e" in s) else int(s)
	if s.begins_with("&\"") and s.ends_with("\""):
		return StringName(s.substr(2, s.length() - 3))
	if s.begins_with("\"") and s.ends_with("\""):
		return s.substr(1, s.length() - 2)
	if s.begins_with("[") and s.ends_with("]"):
		var arr: Array[int] = []
		for item in s.substr(1, s.length() - 2).split(",", false):
			var t := item.strip_edges()
			if t.is_valid_int():
				arr.append(int(t))
			else:
				last_problems.append("line %d: array item '%s' is not a whole number" % [line_number, t])
		return arr
	var enum_match := RegEx.create_from_string("^SynthPatch\\.(Wave|FilterMode|LfoShape|ArpMode|EnvCurve)\\.([A-Z_]+)$").search(s)
	if enum_match:
		var table: Dictionary = {
			"Wave": SynthPatch.Wave, "FilterMode": SynthPatch.FilterMode, "LfoShape": SynthPatch.LfoShape,
			"ArpMode": SynthPatch.ArpMode, "EnvCurve": SynthPatch.EnvCurve,
		}[enum_match.get_string(1)]
		if table.has(enum_match.get_string(2)):
			return table[enum_match.get_string(2)]
		last_problems.append("line %d: no %s value named %s" % [line_number, enum_match.get_string(1), enum_match.get_string(2)])
		return null
	# A bare enum name like SINE or LOWPASS is accepted too; the knob decides which enum.
	for table in [SynthPatch.Wave, SynthPatch.FilterMode, SynthPatch.LfoShape, SynthPatch.ArpMode, SynthPatch.EnvCurve]:
		if table.has(s):
			return table[s]
	last_problems.append("line %d: cannot read value '%s'" % [line_number, s])
	return null


static func _has_property(object: Object, prop: String) -> bool:
	for p in object.get_property_list():
		if p.name == prop:
			return true
	return false


static func _strip_comment(line: String) -> String:
	var at := line.find("#")
	return line if at == -1 else line.left(at)


# ---------------------------------------------------------------- Internals

## Find `\tDICT[&"KEY"] = VAR` and the matching `\tvar VAR := CLASS.new()` above it, replace
## everything between (inclusive) with the generated block; or, for a new key, insert the block
## before `return DICT`. [param make_block] receives the variable name to use.
static func _write_block(path: String, dict_var: String, class_name_str: String, key: StringName,
		make_block: Callable) -> Error:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	var lines := file.get_as_text().split("\n")
	file.close()

	var end := -1
	var var_name := String(key)
	var key_line := "\t%s[&\"%s\"] = " % [dict_var, key]
	for i in lines.size():
		if lines[i].begins_with(key_line):
			end = i
			var_name = lines[i].trim_prefix(key_line).strip_edges()
			break

	var block: PackedStringArray = String(make_block.call(var_name)).split("\n")
	if end == -1:
		var ret := -1
		for i in range(lines.size() - 1, -1, -1):
			if lines[i].strip_edges() == "return " + dict_var:
				ret = i
				break
		if ret == -1:
			return ERR_FILE_CORRUPT
		var insert: PackedStringArray = block.duplicate()
		insert.append("")
		for j in insert.size():
			lines.insert(ret + j, insert[j])
	else:
		var head_re := _head_regex(var_name, class_name_str)
		var start := end
		while start > 0 and head_re.search(lines[start]) == null:
			start -= 1
		var head_match := head_re.search(lines[start])
		if head_match == null:
			return ERR_FILE_CORRUPT
		# Keep the comment on the first line (`# showcases: ...`) and every comment you wrote
		# inside the block, each above the same line it was above.
		var head_comment := head_match.get_string(1)
		if not head_comment.is_empty():
			block[0] += "  " + head_comment
		var kept := _user_comments(lines.slice(start + 1, end))
		var top := 1
		for entry in kept:
			var at := -1
			if not String(entry[1]).is_empty():
				for j in block.size():
					if _line_anchor(block[j]) == entry[1]:
						at = j
						break
			if at == -1:
				at = top
				top += 1
			block.insert(at, entry[0])
		for _i in range(end - start + 1):
			lines.remove_at(start)
		for j in block.size():
			lines.insert(start + j, block[j])

	file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string("\n".join(lines))
	file.close()
	return OK


## Matches a block's first line, `\tvar NAME := CLASS.new()`, with or without a trailing comment
## (captured as group 1).
static func _head_regex(var_name: String, class_name_str: String) -> RegEx:
	return RegEx.create_from_string("^\\tvar %s := %s\\.new\\(\\)\\s*(#.*)?$" % [var_name, class_name_str])


## The full-line comments inside a block that the Full layout did not generate, each paired with
## the anchor of the next code line below it ("" if none): [[comment_line, anchor], ...].
static func _user_comments(body: PackedStringArray) -> Array:
	var generated := RegEx.create_from_string(GENERATED_COMMENT)
	var result: Array = []
	var pending: PackedStringArray = []
	for line in body:
		if line.strip_edges().begins_with("#"):
			if generated.search(line) == null:
				pending.append(line)
			continue
		if line.strip_edges().is_empty():
			continue
		for comment in pending:
			result.append([comment, _line_anchor(line)])
		pending.clear()
	for comment in pending:
		result.append([comment, ""])
	return result


## What a code line sets, ignoring its value: `jump.decay` for `jump.decay = 0.3  # *`,
## `fx.set("band_db/32_hz"` for a set() line, `"cutoff"` for an override entry.
static func _line_anchor(line: String) -> String:
	var code := _strip_comment(line).strip_edges()
	if code.begins_with("\""):
		return code.get_slice(":", 0)
	if code.contains(".set("):
		return code.get_slice(",", 0)
	var eq := code.find(" = ")
	return code.left(eq) if eq != -1 else code


## Remove one key's block: from its `var x := Class.new()` line (when the key line names a
## variable declared just above) down to the `d[&"key"] = x` line. A one-line entry such as
## `c[&"wood"] = _lowpass(900.0)` loses just that line. Comments above the block are kept.
static func _remove_block(path: String, dict_var: String, class_name_str: String, key: StringName) -> Error:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	var lines := file.get_as_text().split("\n")
	file.close()

	var key_line := "\t%s[&\"%s\"] = " % [dict_var, key]
	var end := -1
	for i in lines.size():
		if lines[i].begins_with(key_line):
			end = i
			break
	if end == -1:
		return ERR_DOES_NOT_EXIST
	var start := end
	var head_re := _head_regex(lines[end].trim_prefix(key_line).strip_edges(), class_name_str)
	var other_key := "\t%s[&\"" % dict_var
	var scan := end - 1
	while scan > 0 and head_re.search(lines[scan]) == null and not lines[scan].begins_with(other_key):
		scan -= 1
	if head_re.search(lines[scan]) != null:
		start = scan
	for _i in range(end - start + 1):
		lines.remove_at(start)
	# Do not leave two blank lines where the block was.
	if start > 0 and start < lines.size() and lines[start].strip_edges().is_empty() \
			and lines[start - 1].strip_edges().is_empty():
		lines.remove_at(start)

	file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string("\n".join(lines))
	file.close()
	return OK


## One line per stored property of an AudioEffect: only those that differ from a fresh one, or
## with [param full] all of them, changed ones marked `# *`. Enum properties name their value
## (`# FILTER_12DB`). Names with a slash (EQ6 bands, Chorus voices) are written as
## `fx.set("band_db/32_hz", -6.0)`, since `fx.band_db/32_hz = ...` is not valid GDScript.
static func _effect_property_lines(fx_name: String, effect: AudioEffect, full := false) -> PackedStringArray:
	var lines: PackedStringArray = []
	var defaults: Object = ClassDB.instantiate(effect.get_class())
	for prop in effect.get_property_list():
		if not (prop.usage & PROPERTY_USAGE_STORAGE) or not (prop.usage & PROPERTY_USAGE_EDITOR):
			continue
		var key: String = prop.name
		if key.begins_with("resource_") or key == "script":
			continue
		var value: Variant = effect.get(key)
		var changed := defaults == null or not same_value(value, defaults.get(key))
		if not full and not changed:
			continue
		var note := ""
		if prop.hint == PROPERTY_HINT_ENUM and typeof(value) == TYPE_INT:
			var options: PackedStringArray = String(prop.hint_string).split(",")
			if value >= 0 and value < options.size():
				note = options[value].get_slice(":", 0)
		var code := ("\t%s.set(\"%s\", %s)" if "/" in key else "\t%s.%s = %s") % [fx_name, key, var_to_str(value)]
		lines.append(_with_mark(code, full and changed, note))
	return lines


static func _format_value(key: StringName, value: Variant) -> String:
	match typeof(value):
		TYPE_FLOAT:
			return var_to_str(value)
		TYPE_INT:
			match key:
				&"wave":
					return "SynthPatch.Wave.%s" % SynthPatch.Wave.keys()[value]
				&"filter_mode":
					return "SynthPatch.FilterMode.%s" % SynthPatch.FilterMode.keys()[value]
				&"vibrato_shape", &"tremolo_shape", &"filter_lfo_shape":
					return "SynthPatch.LfoShape.%s" % SynthPatch.LfoShape.keys()[value]
				&"arpeggio_mode":
					return "SynthPatch.ArpMode.%s" % SynthPatch.ArpMode.keys()[value]
				&"envelope_curve":
					return "SynthPatch.EnvCurve.%s" % SynthPatch.EnvCurve.keys()[value]
			return str(value)
		TYPE_BOOL:
			return "true" if value else "false"
		TYPE_STRING_NAME, TYPE_STRING:
			return "&\"%s\"" % value
		TYPE_ARRAY:
			var parts: PackedStringArray = []
			for item in value:
				parts.append(str(item))
			return "[%s]" % ", ".join(parts)
		_:
			return var_to_str(value)
