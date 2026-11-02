class_name AudioLab
extends Control
## Shared layout and behaviour for the Sound Lab and the Condition Lab, so every control sits in
## the same place in both. Each lab only supplies its title, its row of tool buttons, the text of
## the focus label, and what happens when a sound button is pressed.
##
## Rows, top to bottom: title; transport (Music, Song, Quantize, Pitch jitter, beat light,
## status); tools (Condition picker, focus label, six buttons); log line; then three sound
## sections: Presets, User created, From files.
## Keys 1-9 trigger the first nine sounds on screen; Escape stops every sound.

const QUANTIZE_OPTIONS := [
	["Off (instant)", Sfx.NOW],
	["1/16 note", Sfx.SIXTEENTH],
	["1/8 note", Sfx.EIGHTH],
	["Beat", Sfx.BEAT],
	["Bar", Sfx.BAR],
]
const NO_SONGS_LABEL := "(no songs in SoundEngine/Music)"
const FOCUS_LABEL_WIDTH := 340.0
const PICKER_WIDTH := 160.0
const TOOL_BUTTON_WIDTH := 150.0
## Background of editor lines whose value differs from its default.
const CHANGED_TINT := Color(1.0, 0.75, 0.2, 0.14)
const GRID_COLUMNS := 6

## Section order and headings. Categories come from [method Sfx.category_of].
const SECTIONS := [
	[Sfx.CATEGORY_PRESET, "Presets (names start with \"p_\", from sfx_palette.gd)"],
	[Sfx.CATEGORY_USER, "User created (no prefix: your own blocks in sfx_palette.gd)"],
	[Sfx.CATEGORY_FILE, "From files (audio files in SoundEngine/Samples/)"],
]

var music: MusicPlayer
var quantize: float = Sfx.NOW
var pitch_jitter := 0.0
var songs: Array[Dictionary] = []

var _music_toggle: CheckButton
var _song_picker: OptionButton
var _level_picker: OptionButton
var _condition_picker: OptionButton
var _beat_light: ColorRect
var _status: Label
var _focus_label: Label
var _log: Label
var _grids: Dictionary = {}
var _sound_buttons: Array[Button] = []
var _code_edit: TextEdit
var _code_status: Label
var _code_title: Label
var _confirm: ConfirmationDialog
var _pending_delete: Callable
var _tint_timer: Timer


func _ready() -> void:
	music = MusicPlayer.new()
	add_child(music)
	_build_ui()
	rebuild_sounds()
	rescan_songs()
	rebuild_conditions()
	rebuild_levels()
	music.level_changed.connect(func(_level: int) -> void: rebuild_levels())
	BeatClock.beat.connect(_on_beat)
	BeatClock.bar.connect(_on_bar)


func _exit_tree() -> void:
	Sfx.condition_override = &""


func _process(_delta: float) -> void:
	if BeatClock.running:
		_status.text = "%.0f BPM   bar %d   beat %d   (%.2f)" % [
			BeatClock.bpm, BeatClock.get_bar() + 1, BeatClock.get_beat_in_bar() + 1, BeatClock.get_beat()]
	else:
		_status.text = "music stopped: quantized sounds play instantly"


func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	var key := event as InputEventKey
	if key.keycode == KEY_ESCAPE:
		stop_all_sounds()
		return
	var index := key.keycode - KEY_1
	if index >= 0 and index < mini(9, _sound_buttons.size()):
		_sound_buttons[index].pressed.emit()


# ------------------------------------------------------------ Lab hooks
# Subclasses override these. Everything else is shared.

## Shown as the window title.
func _lab_title() -> String:
	return "Lab"


## The tool buttons, in order, as [text, Callable]. Keep six so both labs line up.
func _tool_buttons() -> Array:
	return []


## Text of the focus label between the Condition picker and the buttons.
func _focus_text() -> String:
	return ""


## What a sound button does. Default: play it with the lab's quantize and jitter.
func _sound_pressed(sound: StringName) -> void:
	Sfx.play_with(sound, {quantize = quantize, pitch_jitter = pitch_jitter})


## Called after the Condition picker changes the override.
func _condition_changed(_condition: StringName) -> void:
	pass


## Text shown on a condition in the picker (labs may add a source tag).
func _condition_label(condition: StringName) -> String:
	return String(condition)


## Whether to build the three sound sections. The Song Lab turns them off.
func _show_sound_sections() -> bool:
	return true


## Whether to build the sound-effect controls (Condition picker, Quantize, Pitch jitter). The
## Song Lab turns them off: conditions and quantize never apply to music.
func _show_sound_controls() -> bool:
	return true


## A lab may add its own panel below the log line.
func _build_extra(_column: VBoxContainer) -> void:
	pass


# ------------------------------------------------------------ Public helpers

func log_line(text: String) -> void:
	_log.text = text


func refresh_focus() -> void:
	_focus_label.text = _focus_text()


## The condition in the picker, or empty for "None".
func selected_condition() -> StringName:
	if _condition_picker == null or _condition_picker.selected <= 0:
		return &""
	return StringName(_condition_picker.get_item_text(_condition_picker.selected))


func stop_all_sounds() -> void:
	Sfx.stop_all()
	log_line("Stopped every sound (Escape does this too). Music keeps playing; use its switch.")


## Rebuild the three sound sections from Sfx.
func rebuild_sounds() -> void:
	_sound_buttons.clear()
	if _grids.is_empty():
		return
	for section in SECTIONS:
		var category: String = section[0]
		var grid: GridContainer = _grids[category]
		for child in grid.get_children():
			grid.remove_child(child)
			child.queue_free()
		var names := Sfx.names_in(category)
		if names.is_empty():
			var empty := Label.new()
			empty.text = "(none yet)"
			empty.modulate = Color(1, 1, 1, 0.5)
			grid.add_child(empty)
			continue
		for sound in names:
			var label := String(sound)
			var button := _make_button(label, func() -> void: _sound_pressed(sound))
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			grid.add_child(button)
			_sound_buttons.append(button)
	refresh_focus()


## Refill the Condition picker, keeping the current choice if it still exists.
func rebuild_conditions() -> void:
	if _condition_picker == null:
		return
	var previous := selected_condition()
	_condition_picker.clear()
	_condition_picker.add_item("None (as written)")
	for condition in Sfx.condition_names():
		_condition_picker.add_item(_condition_label(condition))
	_condition_picker.select(0)
	for i in _condition_picker.item_count:
		if _condition_picker.get_item_text(i) == String(previous):
			_condition_picker.select(i)
			break
	_on_condition_selected(_condition_picker.selected)


## Re-list the files in SoundEngine/Music, keeping the current choice if it still exists.
func rescan_songs() -> void:
	var previous := _song_picker.get_item_text(_song_picker.selected) if _song_picker.selected >= 0 else ""
	songs = MusicLibrary.scan()
	_song_picker.clear()
	if songs.is_empty():
		_song_picker.add_item(NO_SONGS_LABEL)
		_song_picker.disabled = true
		return
	_song_picker.disabled = false
	for entry in songs:
		_song_picker.add_item(entry.name)
	_song_picker.select(0)
	for i in _song_picker.item_count:
		if _song_picker.get_item_text(i) == previous:
			_song_picker.select(i)
			break


## Fill the Level picker with the playing song's parts; disabled when nothing plays.
func rebuild_levels() -> void:
	_level_picker.clear()
	var names := music.layer_names()
	var numbers := music.levels()
	if names.is_empty():
		_level_picker.add_item("(no song)")
		_level_picker.disabled = true
		return
	_level_picker.disabled = false
	for i in names.size():
		_level_picker.add_item("%d: %s" % [numbers[i], names[i]])
	_level_picker.select(maxi(numbers.find(music.level), 0))


## Stop and restart music if it was playing (after a reload that changed streams).
func restart_music_if_playing() -> void:
	var was_playing := BeatClock.running
	music.stop()
	rescan_songs()
	if was_playing:
		_start_music()


# ------------------------------------------------------------ Building

## The code editor panel the Sound and Condition labs share: a title; a row of buttons (Play
## selected, Apply & commit, Revert text, New <noun>, Delete <noun>) with a status label; and a
## text box holding the selected item as palette code. [param actions] maps "play", "apply",
## "revert", "create" and "delete" to callables.
func _build_code_editor(column: VBoxContainer, noun: String, actions: Dictionary) -> void:
	_code_title = _make_label("Selected %s as palette code" % noun)
	_code_title.add_theme_font_size_override("font_size", 16)
	column.add_child(_code_title)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	column.add_child(row)
	for entry in [["Play selected", "play"], ["Apply & commit", "apply"], ["Revert text", "revert"],
			["New " + noun, "create"], ["Delete " + noun, "delete"]]:
		var button := _make_button(entry[0], actions[entry[1]])
		button.custom_minimum_size.x = TOOL_BUTTON_WIDTH
		row.add_child(button)
	_code_status = _make_label("")
	_code_status.autowrap_mode = TextServer.AUTOWRAP_WORD
	row.add_child(_code_status)
	_code_edit = TextEdit.new()
	_code_edit.custom_minimum_size = Vector2(0, 380)
	_code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_code_edit.placeholder_text = "Click a sound (or pick a condition) and every one of its settings appears here. Edit, then Apply & commit."
	_code_edit.text_changed.connect(func() -> void: _tint_timer.start())
	column.add_child(_code_edit)
	_tint_timer = Timer.new()
	_tint_timer.one_shot = true
	_tint_timer.wait_time = 0.3
	_tint_timer.timeout.connect(_tint_changed_lines)
	add_child(_tint_timer)
	_confirm = ConfirmationDialog.new()
	_confirm.title = "Delete " + noun
	_confirm.ok_button_text = "Delete"
	_confirm.confirmed.connect(_on_delete_confirmed)
	add_child(_confirm)


## Put [param text] in the editor and tint its changed lines.
func set_code_text(text: String) -> void:
	_code_edit.text = text
	_tint_changed_lines()


## Tint every line whose value differs from its default, as you type. The `# *` comments are
## rewritten when the text is shown again (Apply & commit, Revert text, picking another item);
## changing them while you type would fight with undo.
func _tint_changed_lines() -> void:
	if _code_edit == null:
		return
	var marks := PaletteWriter.changed_lines(_code_edit.text)
	for i in _code_edit.get_line_count():
		_code_edit.set_line_background_color(i, CHANGED_TINT if marks.get(i, false) else Color(0, 0, 0, 0))


## Ask before deleting: the dialog's OK button runs [param on_confirm]; Cancel or Escape does nothing.
func _confirm_delete(text: String, on_confirm: Callable) -> void:
	_pending_delete = on_confirm
	_confirm.dialog_text = text
	_confirm.popup_centered()


func _on_delete_confirmed() -> void:
	if _pending_delete.is_valid():
		var action := _pending_delete
		_pending_delete = Callable()
		action.call()


## Show problems in the editor status line, or a short all-clear.
func _code_report(problems: PackedStringArray, ok_text: String) -> void:
	if _code_status == null:
		return
	if problems.is_empty():
		_code_status.modulate = Color(1, 1, 1, 0.8)
		_code_status.text = ok_text
	else:
		_code_status.modulate = Color(1.0, 0.6, 0.5)
		_code_status.text = "\n".join(problems)


func _build_ui() -> void:
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	add_child(scroll)
	var margin := MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	scroll.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	var title := Label.new()
	title.text = _lab_title()
	title.add_theme_font_size_override("font_size", 22)
	column.add_child(title)

	# --- Row 1: transport (identical in every lab) ---
	var transport := HBoxContainer.new()
	transport.add_theme_constant_override("separation", 12)
	column.add_child(transport)

	_music_toggle = CheckButton.new()
	_music_toggle.text = "Music"
	_music_toggle.toggled.connect(_on_music_toggled)
	transport.add_child(_music_toggle)

	transport.add_child(_make_label("Song:"))
	_song_picker = OptionButton.new()
	_song_picker.custom_minimum_size.x = PICKER_WIDTH
	_song_picker.fit_to_longest_item = false
	_song_picker.clip_text = true
	_song_picker.item_selected.connect(_on_song_selected)
	transport.add_child(_song_picker)

	transport.add_child(_make_label("Level:"))
	_level_picker = OptionButton.new()
	_level_picker.custom_minimum_size.x = PICKER_WIDTH
	_level_picker.fit_to_longest_item = false
	_level_picker.clip_text = true
	_level_picker.item_selected.connect(_on_level_selected)
	transport.add_child(_level_picker)

	if _show_sound_controls():
		transport.add_child(_make_label("Quantize:"))
		var quantize_picker := OptionButton.new()
		for option in QUANTIZE_OPTIONS:
			quantize_picker.add_item(option[0])
		quantize_picker.select(0)
		quantize = QUANTIZE_OPTIONS[0][1]
		quantize_picker.item_selected.connect(func(i: int) -> void: quantize = QUANTIZE_OPTIONS[i][1])
		transport.add_child(quantize_picker)

		var jitter_toggle := CheckBox.new()
		jitter_toggle.text = "Pitch jitter"
		jitter_toggle.toggled.connect(func(on: bool) -> void: pitch_jitter = 1.0 if on else 0.0)
		transport.add_child(jitter_toggle)

	_beat_light = ColorRect.new()
	_beat_light.custom_minimum_size = Vector2(28, 28)
	_beat_light.color = Color(0.2, 0.2, 0.3)
	transport.add_child(_beat_light)

	_status = _make_label("")
	transport.add_child(_status)

	# --- Row 2: tools (same slots in every lab) ---
	var tools := HBoxContainer.new()
	tools.add_theme_constant_override("separation", 12)
	column.add_child(tools)
	if _show_sound_controls():
		tools.add_child(_make_label("Condition:"))
		_condition_picker = OptionButton.new()
		_condition_picker.item_selected.connect(_on_condition_selected)
		tools.add_child(_condition_picker)
		# Fixed widths so the same slot sits at the same x in every lab, whatever the text says.
		_condition_picker.custom_minimum_size.x = PICKER_WIDTH
		_condition_picker.fit_to_longest_item = false
		_condition_picker.clip_text = true
	_focus_label = _make_label("")
	_focus_label.custom_minimum_size.x = FOCUS_LABEL_WIDTH
	_focus_label.clip_text = true
	tools.add_child(_focus_label)
	for entry in _tool_buttons():
		var button := _make_button(entry[0], entry[1])
		button.custom_minimum_size.x = TOOL_BUTTON_WIDTH
		button.clip_text = true
		tools.add_child(button)

	# --- Row 3: log line ---
	_log = _make_label("")
	_log.autowrap_mode = TextServer.AUTOWRAP_WORD
	column.add_child(_log)

	_build_extra(column)

	# --- Sound sections ---
	if not _show_sound_sections():
		return
	for section in SECTIONS:
		var heading := _make_label(section[1])
		heading.add_theme_font_size_override("font_size", 16)
		column.add_child(heading)
		var grid := GridContainer.new()
		grid.columns = GRID_COLUMNS
		grid.add_theme_constant_override("h_separation", 8)
		grid.add_theme_constant_override("v_separation", 8)
		column.add_child(grid)
		_grids[section[0]] = grid


func _make_button(text: String, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(on_pressed)
	return button


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	return label


# ------------------------------------------------------------ Shared handlers

func _on_condition_selected(index: int) -> void:
	var condition := selected_condition() if index > 0 else &""
	Sfx.condition_override = condition
	if condition.is_empty():
		log_line("Condition override off: each sound plays as written (or with its own default condition).")
	else:
		var cond: SfxCondition = Sfx.conditions[condition]
		log_line("Every sound now plays under '%s': %d bus effect(s)%s, pitch x%.2f, %+.1f dB." % [
				condition, cond.effects.size(),
				", synth knobs overridden" if cond.has_overrides() else "",
				cond.pitch_scale, cond.volume_db])
	_condition_changed(condition)
	refresh_focus()


func _start_music() -> void:
	if songs.is_empty():
		_music_toggle.set_pressed_no_signal(false)
		log_line("No songs found. Drop an .ogg/.wav/.mp3 named like song_128bpm.ogg into SoundEngine/Music and press Reload.")
		return
	var entry: Dictionary = songs[clampi(_song_picker.selected, 0, songs.size() - 1)]
	var warning := music.play_song(entry)
	rebuild_levels()
	if warning.is_empty():
		var beats := MusicLibrary.beats_in(music.player.stream, entry.bpm)
		var parts := "" if music.level_count() <= 1 else ", %d parts (use Level)" % music.level_count()
		log_line("Playing %s at %.0f BPM, %.0f bars, looping%s." % [entry.name, entry.bpm, beats / entry.beats_per_bar, parts])
	else:
		log_line("%s: %s" % [entry.name, warning])


func _on_music_toggled(on: bool) -> void:
	if on:
		_start_music()
	else:
		music.stop()
		rebuild_levels()


## Level changes land on the next bar, like the game will do it.
func _on_level_selected(index: int) -> void:
	if music.level_count() == 0:
		return
	var number: int = music.levels()[index]
	music.set_level(number)
	log_line("Level %d (%s) on the next bar." % [number, music.layer_names()[index]])


func _on_song_selected(_index: int) -> void:
	if _music_toggle.button_pressed:
		_start_music()


func _on_beat(_index: int) -> void:
	_flash(Color(0.4, 0.8, 1.0), 0.9)


func _on_bar(_index: int) -> void:
	_flash(Color(1.0, 0.6, 0.2), 1.0)


func _flash(color: Color, strength: float) -> void:
	_beat_light.color = color
	var tween := create_tween()
	tween.tween_property(_beat_light, "color", Color(0.2, 0.2, 0.3), BeatClock.seconds_per_beat() * strength)
