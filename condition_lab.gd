extends AudioLab
## Condition Lab: audition every sound under a condition, edit conditions as text, add and
## delete them. condition_palette.gd is the only place a condition lives, and this lab reads and
## writes it. Run this scene on its own (F6).
##
## Pick a condition in the dropdown (every sound now plays through it). The editor panel under
## the log line works on it:
## - Its palette block appears in the text box; edit, then Apply & commit writes it back into
##   condition_palette.gd. Play selected replays the last sound you clicked under the condition.
##   Revert text shows the live condition again.
## - New condition appends an empty new_condition and shows commented examples of every field.
##   Change the name in the last line and Apply: an untouched new condition is renamed, any
##   other is copied.
## - Delete condition asks first, then removes the block and the running copy.
## Reload conditions re-reads condition_palette.gd from disk. Layout is shared with the Sound Lab.

var selected_sound: StringName = &""


func _lab_title() -> String:
	return "Condition Lab"


func _tool_buttons() -> Array:
	return [
		["Reload conditions", _on_reload_conditions],
		["Export all as .wav", _on_export_wavs],
		["Stop all sounds", stop_all_sounds],
	]


func _focus_text() -> String:
	var condition := selected_condition()
	var sound := "" if selected_sound.is_empty() else "   sound: %s" % selected_sound
	if condition.is_empty():
		return "Condition: (none selected)%s" % sound
	return "Condition: %s%s" % [condition, sound]


func _build_extra(column: VBoxContainer) -> void:
	_build_code_editor(column, "condition", {
		play = _on_play_selected, apply = _on_apply_code, revert = _show_selected_code,
		create = _on_new_condition, delete = _on_delete_condition,
	})


func _sound_pressed(sound: StringName) -> void:
	selected_sound = sound
	refresh_focus()
	super(sound)


func _condition_changed(_condition: StringName) -> void:
	_show_selected_code()


## Pick [param condition] in the dropdown (and apply it), if it is listed.
func _select_condition(condition: StringName) -> void:
	for i in _condition_picker.item_count:
		if _condition_picker.get_item_text(i) == String(condition):
			_condition_picker.select(i)
			_on_condition_selected(i)
			return


# ------------------------------------------------------------------ Code editor

func _show_selected_code() -> void:
	if _code_edit == null:
		return
	var condition := selected_condition()
	if condition.is_empty() or not Sfx.conditions.has(condition):
		set_code_text("")
		_code_report([], "Pick a condition to see its code, or press New condition.")
		return
	set_code_text(PaletteWriter.condition_to_code(condition, Sfx.conditions[condition],
			PaletteWriter.palette_var_name(PaletteWriter.CONDITION_PALETTE_PATH, "c", condition), true))
	_code_report([], "%s: every field, # * = changed from its default. Edit any line, then Apply & commit." % condition)


## Replay the last clicked sound under the selected condition.
func _on_play_selected() -> void:
	if selected_sound.is_empty() or not Sfx.has_sound(selected_sound):
		log_line("Click a sound first; Play selected replays it under the condition.")
		return
	Sfx.play_with(selected_sound, {quantize = quantize, pitch_jitter = pitch_jitter})


## Read the editor text back into a condition, rebuild its bus, write it to condition_palette.gd.
func _on_apply_code() -> void:
	var condition := selected_condition()
	if condition.is_empty() or _code_edit.text.strip_edges().is_empty():
		log_line("Pick a condition first.")
		return
	var cond := PaletteWriter.code_to_condition(_code_edit.text)
	var problems := PaletteWriter.last_problems
	if not problems.is_empty():
		_code_report(problems, "")
		log_line("Nothing committed: fix the lines named in the editor status first.")
		return
	var key := PaletteWriter.key_in_code(_code_edit.text)
	if key.is_empty():
		key = condition
	# A New condition nobody has touched is renamed; anything else is copied under the new name.
	var renaming := key != condition and Sfx.is_default_condition(condition) \
			and String(condition).begins_with(Sfx.NEW_CONDITION_NAME)
	Sfx.conditions[key] = cond
	if not Sfx.commit_condition(key):
		_code_report(problems, "")
		log_line("Could not write %s to condition_palette.gd (see Output panel)." % key)
		return
	if renaming:
		Sfx.delete_condition(condition)
	rebuild_conditions()
	_select_condition(key)
	var how := "renamed to" if renaming else ("copied to" if key != condition else "written as")
	_code_report([], "Applied and %s %s in condition_palette.gd. Press Play selected." % [how, key])
	log_line("Committed %s from the editor." % key)


func _on_new_condition() -> void:
	var key := Sfx.create_condition()
	if key.is_empty():
		log_line("Could not add a condition (see Output panel).")
		return
	rebuild_conditions()
	_select_condition(key)
	set_code_text(PaletteWriter.condition_to_code(key, Sfx.conditions[key], String(key), true))
	_code_report([], ("%s added to condition_palette.gd, doing nothing yet. Add an effect or uncomment an override, "
			+ "change the name in the last line, then Apply & commit.") % key)
	log_line("Added %s. Every sound now plays through it (no effects yet)." % key)


func _on_delete_condition() -> void:
	var condition := selected_condition()
	if condition.is_empty():
		log_line("Pick a condition first.")
		return
	_confirm_delete(("Delete '%s'?\n\nIts block is removed from condition_palette.gd. "
			+ "Sounds whose patch names this condition fall back to none. "
			+ "Git still has the old version.") % condition, _delete_selected_condition)


func _delete_selected_condition() -> void:
	var gone := selected_condition()
	if not Sfx.delete_condition(gone):
		log_line("Could not delete %s (see Output panel)." % gone)
		return
	rebuild_conditions()
	log_line("Deleted %s from condition_palette.gd." % gone)


# ------------------------------------------------------------------ Tool buttons

func _on_reload_conditions() -> void:
	Sfx.reload_conditions()
	rebuild_conditions()
	rescan_songs()
	log_line("Reloaded %d conditions (sounds untouched)." % Sfx.conditions.size())


func _on_export_wavs() -> void:
	var count := Sfx.export_wavs()
	log_line("Wrote %d .wav files to res://SoundEngine/Exported" % count)
