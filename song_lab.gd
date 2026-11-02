extends AudioLab
## Song Lab: load a song or song folder, start it at level 1, advance level by level, force any
## part on or off to try a layer over any section, renumber the parts and save the order back to
## the folder, and edit .pattern files in place while the song plays. Run this scene on its own.
##
## Top rows are the same as the other labs minus the sound-effect controls (conditions and
## quantize never touch the music). Below the log line:
## - Parts: one row per part [level] [stop] [name] [kind] [Layer?] [PLAYING / silent] [Auto / On / Off].
## - Pattern workshop: pick a .pattern part, edit its text, Save & reload swaps the new loop in
##   at the current song position; Solo hears just that pattern over the playing version.
## Every musical change (level, On/Off, solo) lands on the next bar.

const STATE_NAMES := ["Auto", "On", "Off"]
const COLOR_ON := Color(0.45, 1.0, 0.55)
const COLOR_OFF := Color(1, 1, 1, 0.45)
const COLOR_PROBLEM := Color(1.0, 0.6, 0.5)

var _parts_box: VBoxContainer
var _parts_hint: Label
## One dictionary per part row: { index, level_spin, layer_check, name_label, kind_label, state_label, state_picker, bar }
var _rows: Array[Dictionary] = []

var _pattern_picker: OptionButton
var _pattern_edit: TextEdit
var _pattern_status: Label
var _pattern_indices: Array[int] = []
var _soloed := -1


func _lab_title() -> String:
	return "Song Lab"


func _tool_buttons() -> Array:
	return [
		["Start at level 1", _on_start],
		["Advance level", _on_advance],
		["Reload songs", _on_reload],
		["Save numbering", _on_save_numbering],
		["Stop all sounds", stop_all_sounds],
	]


func _focus_text() -> String:
	if music.current_song.is_empty():
		return "Song: (pick one, then Start at level 1)"
	return "Song: %s   level %d of %s" % [music.current_song.name, music.level, music.levels()]


func _show_sound_sections() -> bool:
	return false


## Conditions and quantize are for sound effects; music never goes through them.
func _show_sound_controls() -> bool:
	return false


func _build_extra(column: VBoxContainer) -> void:
	var heading := _make_label("Parts")
	heading.add_theme_font_size_override("font_size", 16)
	column.add_child(heading)
	_parts_hint = _make_label("")
	_parts_hint.modulate = Color(1, 1, 1, 0.7)
	_parts_hint.autowrap_mode = TextServer.AUTOWRAP_WORD
	column.add_child(_parts_hint)
	_parts_box = VBoxContainer.new()
	_parts_box.add_theme_constant_override("separation", 6)
	column.add_child(_parts_box)

	# --- Pattern workshop ---
	var workshop_heading := _make_label("Pattern workshop")
	workshop_heading.add_theme_font_size_override("font_size", 16)
	column.add_child(workshop_heading)
	var hint := _make_label("Pick a .pattern part of the playing song, edit the text, Save & reload. The new loop drops in "
			+ "at the current song position. Solo forces this pattern on and the other patterns off (versions keep "
			+ "playing) so you hear it over whichever section is playing; Unsolo puts every part back to Auto. "
			+ "Fields and rules: Music/TEMPLATE.pattern and README section 7.4.")
	hint.modulate = Color(1, 1, 1, 0.7)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD
	column.add_child(hint)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	column.add_child(row)
	row.add_child(_make_label("Pattern:"))
	_pattern_picker = OptionButton.new()
	_pattern_picker.custom_minimum_size.x = 220
	_pattern_picker.item_selected.connect(func(_i: int) -> void: _load_pattern_text())
	row.add_child(_pattern_picker)
	row.add_child(_make_button("Reload from disk", _on_pattern_reload))
	row.add_child(_make_button("Save & reload", _on_pattern_save))
	row.add_child(_make_button("Solo this pattern", _on_pattern_solo))
	row.add_child(_make_button("Unsolo", _on_pattern_unsolo))
	_pattern_status = _make_label("")
	_pattern_status.autowrap_mode = TextServer.AUTOWRAP_WORD
	column.add_child(_pattern_status)
	_pattern_edit = TextEdit.new()
	_pattern_edit.custom_minimum_size = Vector2(0, 260)
	_pattern_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_pattern_edit.placeholder_text = "Start a song that has .pattern parts, then pick one above."
	column.add_child(_pattern_edit)

	music.level_changed.connect(func(_level: int) -> void: refresh_focus())


func _process(delta: float) -> void:
	super(delta)
	for row in _rows:
		var on := music.is_part_on(row.index)
		var gain := music.part_gain(row.index)
		row.state_label.text = ("PLAYING" if gain > 0.99 else "fading in") if on else ("silent" if gain < 0.01 else "fading out")
		row.state_label.modulate = COLOR_ON if on else COLOR_OFF
		row.name_label.modulate = COLOR_ON if on else Color(1, 1, 1, 1)
		row.bar.value = gain * 100.0


# ------------------------------------------------------------------ Parts table

func rebuild_parts() -> void:
	for child in _parts_box.get_children():
		_parts_box.remove_child(child)
		child.queue_free()
	_rows.clear()
	_rebuild_pattern_picker()
	if music.current_song.is_empty():
		_parts_hint.text = "No song playing. Pick a song in the Song dropdown and press Start at level 1."
		return
	var is_folder: bool = String(music.current_song.path).get_extension() == ""
	if not is_folder:
		_parts_hint.text = "A single-file song: one part, always playing. Put parts in a folder named like the file to make it adaptive."
	else:
		_parts_hint.text = "Level is where a part switches on (versions replace each other, layers stack); Stop is where it goes silent again (0 = never). " \
				+ "Auto follows the level; On / Off force a part so you can hear a layer over any section. " \
				+ "Change Level, Stop or Layer, then Save numbering renames the files."
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	for text in ["Level", "Stop", "Part", "Kind", "Layer", "State", "Override", "Volume"]:
		var label := _make_label(text)
		label.modulate = Color(1, 1, 1, 0.6)
		label.custom_minimum_size.x = 90 if text != "Part" else 220
		header.add_child(label)
	_parts_box.add_child(header)
	for i in music.part_count():
		var part: Dictionary = music.get_part(i)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		var level_spin := SpinBox.new()
		level_spin.min_value = 1
		level_spin.max_value = 99
		level_spin.value = part.order
		level_spin.custom_minimum_size.x = 90
		level_spin.editable = is_folder
		row.add_child(level_spin)
		var stop_spin := SpinBox.new()
		stop_spin.min_value = 0
		stop_spin.max_value = 99
		stop_spin.value = int(part.get("stop", 0))
		stop_spin.prefix = ""
		stop_spin.custom_minimum_size.x = 90
		stop_spin.editable = is_folder
		stop_spin.tooltip_text = "Level at which this part goes silent. 0 = plays to the end."
		row.add_child(stop_spin)
		var name_label := _make_label(String(part.name))
		name_label.custom_minimum_size.x = 220
		row.add_child(name_label)
		var kind_label := _make_label(String(part.kind))
		kind_label.custom_minimum_size.x = 90
		row.add_child(kind_label)
		var layer_check := CheckBox.new()
		layer_check.button_pressed = part.additive
		layer_check.custom_minimum_size.x = 90
		layer_check.disabled = not level_spin.editable
		row.add_child(layer_check)
		var state_label := _make_label("")
		state_label.custom_minimum_size.x = 90
		row.add_child(state_label)
		var state_picker := OptionButton.new()
		for state_name in STATE_NAMES:
			state_picker.add_item(state_name)
		state_picker.select(music.get_part_state(i))
		state_picker.custom_minimum_size.x = 90
		state_picker.item_selected.connect(func(s: int) -> void: _on_part_state(i, s))
		row.add_child(state_picker)
		var bar := ProgressBar.new()
		bar.custom_minimum_size = Vector2(120, 18)
		bar.show_percentage = false
		row.add_child(bar)
		_parts_box.add_child(row)
		_rows.append({index = i, level_spin = level_spin, stop_spin = stop_spin, layer_check = layer_check, name_label = name_label,
				kind_label = kind_label, state_label = state_label, state_picker = state_picker, bar = bar})


# ------------------------------------------------------------------ Pattern workshop

func _rebuild_pattern_picker() -> void:
	var previous := _pattern_picker.get_item_text(_pattern_picker.selected) if _pattern_picker.selected >= 0 else ""
	_pattern_picker.clear()
	_pattern_indices = music.pattern_indices()
	_soloed = -1
	if _pattern_indices.is_empty():
		_pattern_picker.add_item("(no .pattern parts in this song)")
		_pattern_picker.disabled = true
		_pattern_edit.text = ""
		_pattern_status.text = ""
		return
	_pattern_picker.disabled = false
	for i in _pattern_indices:
		var part: Dictionary = music.get_part(i)
		_pattern_picker.add_item("%d: %s" % [part.order, part.name])
	_pattern_picker.select(0)
	for i in _pattern_picker.item_count:
		if _pattern_picker.get_item_text(i) == previous:
			_pattern_picker.select(i)
			break
	_load_pattern_text()


## The part index of the pattern chosen in the picker, or -1.
func selected_pattern() -> int:
	if _pattern_indices.is_empty() or _pattern_picker.selected < 0:
		return -1
	var index: int = _pattern_indices[clampi(_pattern_picker.selected, 0, _pattern_indices.size() - 1)]
	return index if index < music.part_count() else -1


func _load_pattern_text() -> void:
	var index := selected_pattern()
	if index < 0:
		return
	var part: Dictionary = music.get_part(index)
	_pattern_edit.text = FileAccess.get_file_as_string(part.path)
	var def := PatternBaker.parse_text(_pattern_edit.text, String(part.path).get_file())
	_show_pattern_status(def, PatternBaker.last_problems)


func _show_pattern_status(def: Dictionary, problems: PackedStringArray) -> void:
	if problems.is_empty():
		_pattern_status.modulate = Color(1, 1, 1, 0.8)
		_pattern_status.text = "%d bar(s), %d steps per beat, %d track(s): %.2f s per loop at %.0f BPM." % [
				def.bars, def.steps_per_beat, def.tracks.size(),
				PatternBaker.loop_seconds(def, music.bpm, music.beats_per_bar), music.bpm]
	else:
		_pattern_status.modulate = COLOR_PROBLEM
		_pattern_status.text = "\n".join(problems)


func _on_pattern_reload() -> void:
	var index := selected_pattern()
	if index < 0:
		log_line("Pick a pattern first.")
		return
	_load_pattern_text()
	var problems := music.rebake_pattern(index)
	log_line("%s re-read from disk and re-baked%s." % [music.get_part(index).name, "" if problems.is_empty() else " with problems (see below)"])


func _on_pattern_save() -> void:
	var index := selected_pattern()
	if index < 0:
		log_line("Pick a pattern first.")
		return
	var part: Dictionary = music.get_part(index)
	var text := _pattern_edit.text
	var def := PatternBaker.parse_text(text, String(part.path).get_file())
	_show_pattern_status(def, PatternBaker.last_problems)
	var file := FileAccess.open(part.path, FileAccess.WRITE)
	if file == null:
		log_line("Could not write %s." % part.path)
		return
	file.store_string(text)
	file.close()
	var problems := music.rebake_pattern(index, text)
	log_line("Saved %s and swapped the new loop in%s." % [String(part.path).get_file(), "" if problems.is_empty() else "; it has problems (see below)"])


## Hear only this pattern over the playing version: this one On, the other patterns Off.
func _on_pattern_solo() -> void:
	var index := selected_pattern()
	if index < 0:
		log_line("Pick a pattern first.")
		return
	for i in _pattern_indices:
		if i < music.part_count():
			music.set_part_state(i, MusicPlayer.PartState.ON if i == index else MusicPlayer.PartState.OFF)
	_soloed = index
	_sync_state_pickers()
	log_line("Soloing %s from the next bar; other patterns muted, versions untouched." % music.get_part(index).name)


func _on_pattern_unsolo() -> void:
	for i in music.part_count():
		music.set_part_state(i, MusicPlayer.PartState.AUTO)
	_soloed = -1
	_sync_state_pickers()
	log_line("Every part follows the level again from the next bar.")


func _sync_state_pickers() -> void:
	for row in _rows:
		row.state_picker.select(music.get_part_state(row.index))


# ------------------------------------------------------------------ Buttons

## The Music switch and Start both come through here; keep the tables in step.
func _start_music() -> void:
	super()
	rebuild_parts()
	refresh_focus()


## Switching Music off drops the parts; drop the rows with them.
func _on_music_toggled(on: bool) -> void:
	super(on)
	if not on:
		rebuild_parts()
		refresh_focus()


func _on_start() -> void:
	if songs.is_empty():
		log_line("No songs found. Drop a file or a folder of numbered parts into SoundEngine/Music and press Reload songs.")
		return
	_music_toggle.set_pressed_no_signal(true)
	_start_music()
	if not music.current_song.is_empty():
		music.set_level(music.levels()[0], MusicPlayer.Transition.NOW)
	rebuild_levels()
	rebuild_parts()
	refresh_focus()


func _on_advance() -> void:
	if music.current_song.is_empty():
		_on_start()
		return
	var before := music.level
	music.advance()
	if music.level == before and music.levels().back() == before:
		log_line("Already at the top level (%d)." % before)
	else:
		log_line("Advancing to the next level on the next bar.")


## One Stop for everything: the song, its layers, and any sound effects.
func stop_all_sounds() -> void:
	music.stop()
	Sfx.stop_all()
	_music_toggle.set_pressed_no_signal(false)
	rebuild_levels()
	rebuild_parts()
	refresh_focus()
	log_line("Stopped the music and every sound (Escape does this too).")


func _on_reload() -> void:
	var was_playing := BeatClock.running
	music.stop()
	rescan_songs()
	Sfx.reload()
	if was_playing:
		_on_start()
	else:
		rebuild_levels()
		rebuild_parts()
		refresh_focus()
	log_line("Reloaded %d songs and %d sounds." % [songs.size(), Sfx.names().size()])


func _on_part_state(index: int, state: int) -> void:
	if index >= music.part_count():
		log_line("That part is no longer playing; press Start at level 1 and try again.")
		rebuild_parts()
		return
	music.set_part_state(index, state as MusicPlayer.PartState)
	var part: Dictionary = music.get_part(index)
	match state:
		MusicPlayer.PartState.ON:
			log_line("%s forced on from the next bar: it plays whatever the level is." % part.name)
		MusicPlayer.PartState.OFF:
			log_line("%s forced off from the next bar." % part.name)
		_:
			log_line("%s follows the level again from the next bar." % part.name)


## Rename the files in the song folder so their numbers and Layer tokens match the table.
func _on_save_numbering() -> void:
	if music.current_song.is_empty() or music.current_song.path.get_extension() != "":
		log_line("Numbering applies to song folders only.")
		return
	var folder: String = music.current_song.path
	var renames: Array = []
	for row in _rows:
		var part: Dictionary = music.get_part(row.index)
		var new_order := int(row.level_spin.value)
		var wants_layer: bool = row.layer_check.button_pressed
		var default_layer: bool = part.kind == MusicLibrary.KIND_PATTERN
		var token := ""
		if wants_layer and not default_layer:
			token = "_layer"
		elif not wants_layer and default_layer:
			token = "_version"
		var new_stop := int(row.stop_spin.value)
		if new_stop > 0 and new_stop <= new_order:
			log_line("%s: a stop level must be higher than its start level (%d)." % [part.name, new_order])
			return
		if new_stop > 0:
			token += "_stop%d" % new_stop
		var ext := String(part.path).get_extension()
		var new_file := "%d_%s%s.%s" % [new_order, part.name, token, ext]
		if new_file != String(part.path).get_file():
			renames.append([part.path, folder.path_join(new_file)])
	if renames.is_empty():
		log_line("Nothing to save: numbering already matches the files.")
		return
	var song_name: String = music.current_song.name
	var level_before := music.level
	music.stop()
	var done := 0
	for pair in renames:
		var from := ProjectSettings.globalize_path(pair[0])
		var to := ProjectSettings.globalize_path(pair[1])
		if FileAccess.file_exists(to):
			log_line("Cannot rename %s: %s already exists." % [pair[0].get_file(), pair[1].get_file()])
			continue
		if DirAccess.rename_absolute(from, to) == OK:
			done += 1
			# The editor regenerates import sidecars; drop the stale one so it does not confuse scans.
			if FileAccess.file_exists(from + ".import"):
				DirAccess.remove_absolute(from + ".import")
	rescan_songs()
	for i in _song_picker.item_count:
		if _song_picker.get_item_text(i) == song_name:
			_song_picker.select(i)
	_on_start()
	music.set_level(level_before, MusicPlayer.Transition.NOW)
	rebuild_levels()
	log_line("Renamed %d file(s) in %s and reloaded. Godot will re-import the renamed audio on its next scan." % [done, folder])
