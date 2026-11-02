extends AudioLab
## Sound Lab: audition every sound, hear it snapped to the beat of your own songs, edit sounds
## as text, add and delete them. sfx_palette.gd is the only place a synth sound lives, and this
## lab reads and writes it. Run this scene on its own (F6).
##
## The editor panel under the log line works on the selected sound:
## - Its palette block appears in the text box; edit, then Apply & commit writes it back into
##   sfx_palette.gd. Play selected plays it from the same spot every time. Revert text shows the
##   live sound again.
## - New sound appends new_sound (every knob at its default) to the palette and selects it.
##   Change the name in the last line and Apply: a fresh, untouched new sound is renamed, any
##   other sound is copied under the new name.
## - Delete sound asks first, then removes the block and the running copy.
## Reload patches re-reads sfx_palette.gd from disk, so edits made in Godot's script editor
## show up too. Layout is shared with the Condition Lab (AudioLab).

var selected: StringName = &""


func _lab_title() -> String:
	return "Sound Lab"


func _tool_buttons() -> Array:
	return [
		["Reload patches", _on_reload],
		["Export all as .wav", _on_export_wavs],
		["Stop all sounds", stop_all_sounds],
	]


func _focus_text() -> String:
	if selected.is_empty():
		return "Selected: (click a sound)"
	if not Sfx.has_sound(selected):
		return "Selected: %s  (no longer loaded)" % selected
	var text := "Selected: %s  [%s]" % [selected, Sfx.category_of(selected)]
	var condition := Sfx.resolve_condition(selected)
	if not condition.is_empty():
		text += "  [condition: %s]" % condition
	return text


func _build_extra(column: VBoxContainer) -> void:
	_build_code_editor(column, "sound", {
		play = _on_play_selected, apply = _on_apply_code, revert = _show_selected_code,
		create = _on_new_sound, delete = _on_delete_sound,
	})


func _sound_pressed(sound: StringName) -> void:
	selected = sound
	refresh_focus()
	_show_selected_code()
	super(sound)


# ------------------------------------------------------------------ Code editor

## Put the selected sound's palette block in the editor.
func _show_selected_code() -> void:
	if _code_edit == null:
		return
	if selected.is_empty():
		set_code_text("")
		_code_report([], "")
		return
	if Sfx.source_of(selected) == Sfx.SOURCE_FILE:
		set_code_text("# %s is an audio file in SoundEngine/Samples; edit it in your DAW." % selected)
		_code_report([], "Audio file: nothing to edit here.")
		return
	if not Sfx.patches.has(selected):
		set_code_text("")
		_code_report(PackedStringArray(["%s is not loaded any more. Click another sound." % selected]), "")
		return
	set_code_text(PaletteWriter.patch_to_code(selected, Sfx.patches[selected],
			PaletteWriter.palette_var_name(PaletteWriter.PALETTE_PATH, "p", selected), true))
	_code_report([], "%s: every knob, # * = changed from its default. Edit any line, then Apply & commit." % selected)


func _on_play_selected() -> void:
	if selected.is_empty() or not Sfx.has_sound(selected):
		log_line("Click a sound first.")
		return
	Sfx.play_with(selected, {quantize = quantize, pitch_jitter = pitch_jitter})


## Read the editor text back into a patch, make it live, and write it into sfx_palette.gd.
func _on_apply_code() -> void:
	if selected.is_empty() or _code_edit.text.strip_edges().is_empty():
		log_line("Click a sound first.")
		return
	if Sfx.source_of(selected) == Sfx.SOURCE_FILE:
		log_line("%s is an audio file; there is nothing to commit to code." % selected)
		return
	var patch := PaletteWriter.code_to_patch(_code_edit.text)
	var problems := PaletteWriter.last_problems
	if not problems.is_empty():
		_code_report(problems, "")
		log_line("Nothing committed: fix the lines named in the editor status first.")
		return
	var key := PaletteWriter.key_in_code(_code_edit.text)
	if key.is_empty():
		key = selected
	if key != selected and Sfx.has_sound(key) and Sfx.source_of(key) == Sfx.SOURCE_FILE:
		_code_report(PackedStringArray(["'%s' is an audio file name; pick another key" % key]), "")
		return
	# A New sound nobody has touched is renamed; anything else is copied under the new name.
	var previous := selected
	var renaming := key != previous and Sfx.is_default_patch(previous) \
			and String(previous).begins_with(Sfx.NEW_SOUND_NAME)
	Sfx.register(key, patch)
	if not Sfx.commit_patch(key):
		_code_report(problems, "")
		log_line("Could not write %s to sfx_palette.gd (see Output panel)." % key)
		return
	if renaming:
		Sfx.delete_patch(previous)
	selected = key
	rebuild_sounds()
	refresh_focus()
	_show_selected_code()
	var how := "renamed to" if renaming else ("copied to" if key != previous else "written as")
	_code_report([], "Applied and %s %s in sfx_palette.gd. Press Play selected." % [how, key])
	log_line("Committed %s from the editor." % key)


func _on_new_sound() -> void:
	var key := Sfx.create_patch()
	if key.is_empty():
		log_line("Could not add a sound (see Output panel).")
		return
	selected = key
	rebuild_sounds()
	refresh_focus()
	set_code_text(PaletteWriter.patch_to_code(key, Sfx.patches[key], String(key), true))
	_code_report([], ("%s added to sfx_palette.gd with every knob at its default. Change the name in the "
			+ "last line and the knobs you want, then Apply & commit; knobs left at default drop out of the block.") % key)
	log_line("Added %s (User created section)." % key)


func _on_delete_sound() -> void:
	if selected.is_empty() or not Sfx.has_sound(selected):
		log_line("Click a sound first.")
		return
	if Sfx.source_of(selected) == Sfx.SOURCE_FILE:
		log_line("%s is an audio file; delete it from SoundEngine/Samples yourself." % selected)
		return
	_confirm_delete(("Delete '%s'?\n\nIts block is removed from sfx_palette.gd. "
			+ "Git still has the old version.") % selected, _delete_selected)


func _delete_selected() -> void:
	var gone := selected
	if not Sfx.delete_patch(gone):
		log_line("Could not delete %s (see Output panel)." % gone)
		return
	selected = &""
	rebuild_sounds()
	refresh_focus()
	_show_selected_code()
	log_line("Deleted %s from sfx_palette.gd." % gone)


# ------------------------------------------------------------------ Tool buttons

func _on_reload() -> void:
	Sfx.reload()
	rebuild_sounds()
	rebuild_conditions()
	restart_music_if_playing()
	var note := ""
	if not selected.is_empty() and not Sfx.has_sound(selected):
		note = " %s is gone from the palette, so the selection was cleared." % selected
		selected = &""
		refresh_focus()
	_show_selected_code()
	log_line("Reloaded %d sounds, %d songs and %d conditions.%s" % [
			Sfx.names().size(), songs.size(), Sfx.conditions.size(), note])


func _on_export_wavs() -> void:
	var count := Sfx.export_wavs()
	log_line("Wrote %d .wav files to res://SoundEngine/Exported" % count)
