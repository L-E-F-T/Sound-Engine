> Written with Claude Code

> **Adding a sound effect to something in the game? Go straight to
> [section 3: Using sounds in game code (developer guide)](#3-using-sounds-in-game-code-developer-guide).**
> It defines every parameter, shows a block that sounds like its material, and sets the one
> convention the team follows: the thing that changes state plays the sound.

# SoundEngine: procedural sounds for TrogJam

This folder is the game's whole audio system. There are no sound files in it. Every sound is a
recipe (a `SynthPatch`) that a small synthesizer turns into audio when the game starts. Music is
the track you make in your DAW, dropped into a folder, and it drives a beat clock that sound
effects can snap to.

**Where this file lives:** `trog-jam/SoundEngine/README.md`, next to the scripts. Godot's
FileSystem dock may not show `.md` files, so open it from Windows Explorer with Notepad or
VS Code. Paths below are relative to the `trog-jam` project folder, which Godot calls `res://`.

Contents

1. [Try it in two minutes](#1-try-it-in-two-minutes)
2. [The pieces](#2-the-pieces)
3. [Using sounds in game code (developer guide)](#3-using-sounds-in-game-code-developer-guide)
4. [Making and tweaking sounds](#4-making-and-tweaking-sounds)
5. [What every knob does](#5-what-every-knob-does)
6. [Recipes](#6-recipes)
7. [Music: adaptive songs from your DAW, with synth layers](#7-music-adaptive-songs-from-your-daw-with-synth-layers)
8. [How beat sync works](#8-how-beat-sync-works)
9. [Troubleshooting](#9-troubleshooting)
10. [Glossary](#10-glossary)

```
SynthPatch (recipe) --> SynthRenderer --> AudioStreamWAV (cached once) --> Sfx autoload --> speakers
																				^
Your .ogg track in Music/ --> MusicPlayer (AudioStreamPlayer) --> BeatClock (the beat grid)
```

---

## 1. Try it in two minutes

1. Open the project in Godot 4.7.
2. In the FileSystem dock (bottom left) open `SoundEngine/SoundLab.tscn`, then press **F6**
   (run current scene).
3. Click any sound button.
4. Turn on the **Music** switch. Set **Quantize** to "Beat". Click a sound off-rhythm: it waits
   and lands on the beat. Mash the button: it fires only once per beat.
5. Open `SoundEngine/sfx_palette.gd` in the script editor, change any number, save, go back to
   the running lab and press **Reload patches**. Click the sound again.

If step 3 is silent, see [Troubleshooting](#9-troubleshooting).

---

## 2. The pieces

| File | What it is | You will touch it when |
| --- | --- | --- |
| `synth_patch.gd` | The recipe for one sound: every knob, with its range and a doc comment | Reading what a knob means |
| `synth_renderer.gd` | The synthesizer. Patch in, samples out | Curious how sound is made; adding a new effect |
| `sfx_palette.gd` | Every named sound, written as code | **Adding or tweaking a sound (most common)** |
| `sfx.gd` | Autoload `Sfx`: plays sounds from anywhere, snaps them to the beat | Calling `Sfx.play(...)` from game code |
| `condition_palette.gd` | Named colourings (wood, metal, underwater, huge...) that any sound can play under | **Adding or tweaking a condition** |
| `sfx_condition.gd` | The resource one condition is: bus effects, pitch, volume, synth-knob overrides | Reading what a condition can do |
| `beat_clock.gd` | Autoload `BeatClock`: knows the current beat; emits beat and bar signals | Making visuals pulse, or gating gameplay to the beat |
| `music_library.gd` | Finds songs in `Music/` (files and folders of parts), reads the BPM from the name, forces looping | Never directly; the lab and MusicPlayer use it |
| `pattern_baker.gd` | Renders a `.pattern` text file into a synth loop at the song's tempo | Never directly; MusicPlayer bakes patterns when a song loads |
| `music_player.gd` | Plays a song (all parts in sync), switches levels on the bar, drives the clock | Adding music to a scene; changing level from gameplay |
| `Music.tscn` | A ready-made node with that script; set its `song` to a filename | Dropping music into a scene |
| `Music/` | **Drop your songs here**: a file `name_128bpm.ogg`, or a folder `name_128bpm/` of numbered parts | Adding a track from your DAW; building an adaptive song |
| `Music/TEMPLATE.pattern` | Every field a `.pattern` file can use, commented. Copy it into a song folder | Writing a synth layer |
| `SoundLab.tscn` + `sound_lab.gd` | Audition, quantize, edit a sound as text and commit it, add and delete sounds, export | Listening and iterating |
| `ConditionLab.tscn` + `condition_lab.gd` | Same transport and sound buttons, but the editor acts on conditions | Tuning materials and environments by ear |
| `SongLab.tscn` + `song_lab.gd` | Load a song or song folder, start at level 1, advance, force parts on/off, renumber and save | Building and testing adaptive songs |
| `palette_writer.gd` | Turns a sound or condition into palette code and back, and adds, rewrites or removes its block in the palette file | Never directly; the labs' editor buttons use it |
| `Samples/` | **Drop your own sound-effect files here**; the filename becomes the sound name | Using DAW-made effects alongside synth ones |
| `Exported/` (created on demand) | `.wav` files of every sound | Handing sounds to someone who wants plain files |

The two autoloads are registered in `project.godot` under `[autoload]`. That is what lets any
script write `Sfx.play(...)` without loading anything.

### 2.1 `SynthPatch` (the recipe)

A `Resource` with about fifty knobs, grouped as Oscillator, Pitch motion, FM, Amp envelope,
Filter, Dirt, Space, Output. Every knob is explained in
[section 5](#5-what-every-knob-does).

| Method | Returns |
| --- | --- |
| `envelope_length()` | Seconds the amp envelope lasts (attack + decay + sustain_time + release) |
| `total_length()` | Envelope length plus the echo tail, if any. This is the rendered length |
| `transposed(semitones)` | A copy of the patch with `base_freq` shifted by that many semitones |

### 2.2 `SynthRenderer` (the synthesizer)

Static functions, no state. Called by `Sfx`; you rarely call it yourself.

| Function | What it does |
| --- | --- |
| `render(patch) -> PackedFloat32Array` | Computes the sound, one sample at a time, values in -1..1 |
| `to_wav(samples, sample_rate, loop) -> AudioStreamWAV` | Packs samples into a playable 16-bit stream |
| `render_to_stream(patch) -> AudioStreamWAV` | The two above in one call |

Rendering all presets (about 100, roughly two minutes of audio) takes a few seconds, so it runs
on a background thread at startup; a sound played before its turn is rendered on the spot.

### 2.3 `SfxPalette` (the sounds)

One static function, `build()`, returning a dictionary of name to `SynthPatch`. The names are
what you pass to `Sfx.play`. They are grouped by the game system they serve; each group's
comment in the file says what makes that family sound the way it does, so you can make variants.

**Naming rule.** Every preset that ships with the engine is keyed with the `p_` prefix. Sounds
you add yourself get no prefix. The labs use this to sort sounds into three sections: **Presets**
(`p_` names), **User created** (unprefixed names from `sfx_palette.gd`), and **From files**
(audio files in `Samples/`). A file in `Samples/` named like a
preset, `p_hit.wav`, replaces that preset; one with a new name is a user sound of its own.

**Every block lists every knob.** Each sound in `sfx_palette.gd` lists all 54 knobs, grouped
like section 5 (`# ---- Oscillator`, `# ---- Pitch motion`, ...), so you can see everything there
is to turn without opening the knob table. A trailing `# *` marks a knob changed from its default;
those lines are what make the sound itself. Enum knobs list their choices
(`# choices: SINE SQUARE SAW TRIANGLE NOISE`). Every block in `condition_palette.gd` likewise lists
every field. The Sound and Condition labs read and write exactly this layout, and keep any comment
you put inside a block above the line it was above. A block you write by hand only needs the lines
you change; the next Apply fills in the rest. The "Modulation showcase" group has one sound per
modulation knob, named in a comment on its first line, built to be copied.

| Group | Names |
| --- | --- |
| Artillery (the ship's gun) | `p_artillery_load`, `p_artillery_lock`, `p_artillery_charge`, `p_artillery_fire`, `p_artillery_flyby`, `p_artillery_impact`, `p_artillery_ready` |
| Spells, attack | `p_cast_fire`, `p_cast_arcane`, `p_cast_void`, `p_cast_lightning`, `p_cast_ice`, `p_cast_wind`, `p_cast_big_blast` |
| Spells, utility and defense | `p_cast_slow`, `p_cast_haste`, `p_cast_pull`, `p_shield_up`, `p_shield_hit`, `p_shield_down`, `p_warp`, `p_mana_empty` |
| Rituals and runes | `p_ritual_tick`, `p_ritual_complete`, `p_rune_activate`, `p_rune_break` |
| Materials: stone | `p_stone_hit`, `p_stone_break`, `p_stone_rumble`, `p_debris_fall`, `p_fortress_collapse` |
| Materials: wood | `p_wood_hit`, `p_wood_break`, `p_wood_creak` |
| Materials: metal and glass | `p_metal_hit`, `p_metal_clang`, `p_metal_break`, `p_glass_hit`, `p_glass_break` |
| Generic impacts | `p_hit`, `p_thump`, `p_explosion`, `p_hurt`, `p_death` |
| Ship and enemies | `p_ship_engine` (loop), `p_ship_hit`, `p_ship_bell`, `p_ship_alarm`, `p_enemy_fire`, `p_anchor_drop`, `p_sail_flap` |
| Treasure | `p_coin`, `p_treasure_collect`, `p_chest_open`, `p_pickup_mana`, `p_pickup_rare` |
| Player | `p_jump`, `p_land`, `p_footstep`, `p_dash`, `p_heal` |
| Planning phase and UI | `p_ui_click`, `p_ui_confirm`, `p_ui_back`, `p_ui_place`, `p_ui_remove`, `p_ui_tick`, `p_ui_error`, `p_ui_begin_assault`, `p_ui_phase_riser` |
| Outcomes | `p_win_fanfare`, `p_lose_sting` |
| Weather and water | `p_thunder`, `p_rain_loop` (loop), `p_wind_loop` (loop), `p_bubble`, `p_drip`, `p_splash` |
| Creatures | `p_growl`, `p_roar`, `p_space_gull` |
| Sci-fi and misc | `p_whoosh`, `p_laser`, `p_teleport_out`, `p_powerup`, `p_sparkle`, `p_static_crackle`, `p_hover_hum` (loop), `p_low_drone` (loop), `p_heartbeat`, `p_countdown_beep`, `p_clock_tick` |
| Music instruments (for `.pattern` layers) | `p_inst_kick`, `p_inst_hat`, `p_inst_bass`, `p_inst_pluck`, `p_inst_pad` |
| Modulation showcase (one new knob each) | `p_trill`, `p_siren`, `p_burble`, `p_swell`, `p_arp_climb`, `p_arp_bounce`, `p_chimes`, `p_glide_lead`, `p_pwm_lead`, `p_fat_bass`, `p_robot_voice`, `p_ring_bell`, `p_helicopter` (loop), `p_stutter_zap`, `p_machine_gun`, `p_pulse_pad` (loop), `p_wah_sweep`, `p_wobble_bass`, `p_brown_rumble` (loop), `p_crackle`, `p_exp_pluck`, `p_lofi_blip`, `p_grit_alt`, `p_anvil`, `p_tremolo_drone` (loop) |

Sounds marked (loop) are meant for `Sfx.get_stream` on your own
`AudioStreamPlayer` so they run continuously (an engine, weather, a hum) rather than for
`Sfx.play`.

**How the families are built, so you can make more.** Every material is one recipe: a short
burst of noise through a filter whose cutoff says what the material is. Stone is a low-pass
around 1.4 kHz closing fast; wood is a band-pass knock near 800 Hz with resonance; metal is a
sine with an inharmonic FM ratio (3.14, 2.41) ringing out; glass is the same idea two octaves
up with a high-pass fizz. A break is the hit stretched three to five times longer with
`sample_hold` for crackle and a low rumble for mass. So a "crystal_break" is `p_glass_break` with
`delay_feedback` raised and a `p_sparkle` played with it from code; an "iron_door" is `p_metal_clang`
with `base_freq` halved. Spells follow the same logic by element: fire is noisy and falls, ice is
high and crystalline, wind is swept noise, void is low FM. Utility spells are pitch bends.

### 2.4 `Sfx` (autoload: play sounds)

**Functions**

| Call | What it does |
| --- | --- |
| `Sfx.play(name, condition = &"")` | Play a 2D (non-positional) sound now |
| `Sfx.play_at(name, position, condition = &"")` | Play at a world position now, through a pooled `AudioStreamPlayer3D` |
| `Sfx.play_with(name, options)` / `Sfx.play_at_with(name, position, options)` | Same, with a dictionary of options: `quantize`, `volume_db`, `pitch_scale`, `pitch_jitter`, `condition` (see section 3.1) |
| `Sfx.get_stream(name) -> AudioStream` | The stream, for your own player (looping hums, for example). For a file sound with variants, a random one |
| `Sfx.stop_all()` | Stop every playing sound effect, looping ones included, and clear anything booked on the grid. Music is untouched |
| `Sfx.pool_size_2d`, `Sfx.pool_size_3d` | Players available at once (12 / 16). An idle player is always used first; only when all are busy is the oldest sound cut, which can pop |
| `Sfx.has_sound(name) -> bool` | True for synth and file sounds alike |
| `Sfx.register(name, patch)` | Add or replace a synth sound at runtime |
| `Sfx.reload()` | Rebuild from `sfx_palette.gd` and `Samples/`, re-render in the background. In the editor the palette is read from disk, so unsaved-to-memory edits show up |
| `Sfx.names() -> Array[StringName]` | Sorted list of sound names, files included |
| `Sfx.source_of(name) -> String` | `"code"` or `"file"`: where that sound comes from |
| `Sfx.commit_patch(name) -> bool` | Write the sound's current values into its block in `sfx_palette.gd` (or append a new block), keep the values live |
| `Sfx.create_patch() -> StringName` | Append a sound with every knob at its default, named `new_sound` (or `new_sound_2`, ...); returns the name |
| `Sfx.delete_patch(name) -> bool` | Remove the sound's block from `sfx_palette.gd` and from the running game. Never touches files in `Samples/` |
| `Sfx.export_wavs(dir = "res://SoundEngine/Exported") -> int` | Write every sound as `.wav`; returns the count |

**Conditions** (see [section 4.5](#45-conditions-one-sound-many-objects))

| Call | What it does |
| --- | --- |
| `Sfx.play(name, condition)` / `Sfx.play_at(name, position, condition)` | Play under a named condition |
| `{condition = &"..."}` in `play_with` / `play_at_with` | The same as an option |
| `Sfx.condition_override` | Set it and every sound plays under that condition until you clear it (`&""`). The lab's Condition dropdown sets this |
| `Sfx.resolve_condition(name, requested = &"")` | What a play would use: override, else requested, else the patch's own `condition`, else none |
| `Sfx.get_stream(name, condition)` | A synth sound re-rendered with the condition's knob overrides (cached per pair); files unchanged |
| `Sfx.conditions`, `Sfx.condition_names()`, `Sfx.bus_for(condition)` | The table, its sorted names, and the bus a condition routes through (`SFX_<name>`) |
| `Sfx.reload_conditions()` | Rebuild conditions from `condition_palette.gd` (read from disk in the editor), rebuild their buses, leave sounds alone |
| `Sfx.commit_condition(name)`, `Sfx.create_condition()`, `Sfx.delete_condition(name)` | The condition versions of commit_patch, create_patch and delete_patch |

**Quantize constants** (grid size in beats): `Sfx.NOW` (0, play immediately), `Sfx.SIXTEENTH`
(0.25), `Sfx.EIGHTH` (0.5), `Sfx.BEAT` (1.0), `Sfx.BAR` (a whole bar, whatever the clock's
`beats_per_bar` is).

**Parameters**

- `quantize`: wait for the next grid line of this size. If no music is running, plays at once.
- `volume_db`: 0 is the patch's own level; -6 is roughly half as loud.
- `pitch_scale`: 1.0 is normal, 2.0 is an octave up and twice as short.
- `pitch_jitter`: random pitch change up to this many semitones each play, so repeats do not
  sound like a machine gun. 1.0 is subtle, 3.0 is wild.

**Exported settings** (edit at the top of `sfx.gd`)

| Setting | Default | Meaning |
| --- | --- | --- |
| `pool_size_2d` | 12 | How many 2D sounds can overlap. The oldest is cut when exceeded |
| `pool_size_3d` | 16 | Same for 3D sounds |
| `default_quantize` | `Sfx.NOW` (off) | Grid used by plain `play` / `play_at` and by `_with` calls that omit `quantize`. Set to `Sfx.SIXTEENTH` to put the whole game on the grid |
| `extra_lead_seconds` | 0.0 | Fire quantized sounds this much earlier (+) or later (-). A calibration knob |
| `max_distance_3d` | 60 | Metres at which 3D sounds fade to silence |

**Rules it enforces**

- A sound asked for twice for the same grid line plays once. Button mashing never stacks.
- Sounds go to the `SFX` bus; music to the `Music` bus. Both are created at runtime if the
  project's bus layout lacks them, so `AudioServer.set_bus_volume_db` works for a settings menu.
- The `SFX` bus carries a hard limiter (ceiling -0.5 dB). Several loud hits landing together
  cannot push the bus past full scale and crackle; it does nothing until the mix gets hot.

### 2.5 `BeatClock` (autoload: musical time)

**Signals**

| Signal | Fires |
| --- | --- |
| `beat(beat_index)` | Every beat (quarter note) |
| `bar(bar_index)` | Every bar (every `beats_per_bar` beats) |
| `step(step_index)` | Every subdivision (`steps_per_beat` per beat, default 4 = sixteenths) |

**Settings**

| Setting | Default | Meaning |
| --- | --- | --- |
| `bpm` | 110 | Tempo. Set automatically by `start()` and `play_stream()` |
| `beats_per_bar` | 4 | Time signature top number |
| `steps_per_beat` | 4 | How finely `step` fires |
| `offset_seconds` | 0 | Shift the grid if a music file has silence or a pickup before its first downbeat |

**Functions**

| Call | Returns |
| --- | --- |
| `start(player = null, bpm, beats_per_bar)` | Starts counting. With a playing `AudioStreamPlayer`, time comes from the audio hardware; without one it free-runs from the system clock |
| `stop()` | Stops; quantized sounds then play instantly |
| `running` | `true` while counting |
| `get_time()` | Seconds since beat 0, as heard right now |
| `get_beat()` | Fractional beat, e.g. 5.25 |
| `get_beat_in_bar()`, `get_bar()` | For UI counters |
| `next_grid_beat(quantize)` | The next grid line of that size, in beats |
| `seconds_until(quantize)` | Seconds until that grid line (use to delay gameplay to the beat) |
| `seconds_per_beat()` | 60 / bpm |

### 2.6 `MusicPlayer` and `Music.tscn`

`Music.tscn` is a Node with the `MusicPlayer` script. Drop it into a scene, type a song filename into
its `song` field, and that scene has music and a running clock. Everything about music is in
[section 7](#7-music-your-own-track-from-a-daw).

### 2.7 Sound Lab

Run `SoundLab.tscn` with F6. Both labs share one layout (`lab_base.gd`), so every control is in
the same place in each: title; transport row (Music, Song, Level, Quantize, Pitch jitter, beat
light, status); tools row (Condition picker, a focus label, three buttons in fixed slots); the log
line; the code editor (a row of five buttons and a text box); then three sound sections, Presets,
User created and From files, in that order.

| Control | Does |
| --- | --- |
| Music switch | Plays the song in the dropdown and starts the clock |
| Song | Any file or folder in `SoundEngine/Music` (disabled until there is one). Switching while playing re-locks the clock to the new tempo. The log line reports BPM, bar count, and any loop problem |
| Level | The playing song's levels, by filename number, with what each switches on. Picking one changes level on the next bar, as the game does. Disabled until a song plays |
| Condition | First slot of the tools row. "None (as written)" or any condition from `condition_palette.gd`. Picking one applies it to every sound you play, synth or file. The log line says what it does |
| Quantize | Grid for the buttons: Off, 1/16, 1/8, Beat, Bar |
| Pitch jitter | Adds 1 semitone of random pitch to each click |
| Coloured square | Flashes blue on beats, orange on bar starts |
| Status text | BPM, current bar and beat |
| Sound buttons | In three sections: Presets (`p_` names), User created, From files. Click to play with the current quantize and select it. Keys 1 to 9 trigger the first nine on screen. The whole lab scrolls when there are more than fit |
| Selected: ... | The last sound you clicked, its section, and the condition it would play under, if any |
| Selected sound as palette code | A text box holding every knob of the selected sound, grouped as in section 5, with its current value. A `# *` comment marks each knob that differs from its default, and enum knobs list their choices. Lines you change are tinted as you type. Audio files show a note instead |
| Play selected | Plays the selected sound again with the current quantize and jitter, so you can click the same spot every time instead of finding the button in the list |
| Apply & commit | Reads the text box back, makes the sound live and writes its block into `sfx_palette.gd`. A typo stops the commit and the status text beside the buttons names the line. Changing the key in the last line (`p[&"new_name"] = ...`) copies the sound under that name, or renames an untouched New sound |
| Revert text | Throws away your edits and shows the live sound again |
| New sound | Appends `new_sound` with every knob at its default and selects it (see [4.2](#42-adding-copying-renaming-and-deleting-sounds-sound-lab)) |
| Delete sound | Asks for confirmation, then removes the selected sound's block from `sfx_palette.gd` |
| Reload patches | Re-reads `sfx_palette.gd` from disk, `Samples/` and `Music/`, re-renders, restarts music if it was on |
| Export all as .wav | Writes `SoundEngine/Exported/*.wav` |
| Stop all sounds | Silences every sound effect, which is how you end a looping one. Escape does the same |

### 2.8 Condition Lab

Run `ConditionLab.tscn` with F6. It is the same layout as the Sound Lab, control for control, with
the same three sound sections; the difference is that the editor acts on the condition in the
picker, and each sound click plays under that condition.

| Control | Does |
| --- | --- |
| Condition | The condition under test; applies to every sound |
| Selected condition as palette code | Every field of the picked condition: each effect with all of its properties (`var wood_fx0 := AudioEffectBandPassFilter.new()` ...), `effects`, `volume_db`, `pitch_scale`, and `patch_overrides` listing every synth knob, commented out unless overridden. `# *` marks values changed from their defaults; changed lines are tinted as you type |
| Play selected | Plays the last sound you clicked again, under the condition |
| Apply & commit | Reads the text back, rebuilds the condition's bus and writes the block into `condition_palette.gd`. A typo stops the commit; the status text names the line |
| Revert text | Shows the live condition again |
| New condition | Appends an empty `new_condition` and shows every field, with a commented example effect |
| Delete condition | Asks for confirmation, then removes the condition's block from `condition_palette.gd` |
| Reload conditions | Re-reads `condition_palette.gd` from disk and rebuilds the buses. Sounds are not touched |
| Export all as .wav | Writes `SoundEngine/Exported/*.wav` |
| Stop all sounds | Silences every sound effect (Escape too) |

### 2.9 Song Lab

Run `SongLab.tscn` with F6. Same top rows as the other labs minus the sound-effect controls
(no Condition, Quantize or Pitch jitter: conditions and quantize never apply to music, which has
its own bus with no effects), no sound grids; below the log line is one row per part of the
playing song. Every change here, level or On/Off, lands on the next bar.

| Control | Does |
| --- | --- |
| Start at level 1 | Plays the song in the Song dropdown from its lowest level, all parts running in sync |
| Advance level | Moves to the next level number in the folder, on the next bar |
| Reload songs | Rescans `Music/` (and sounds), restarts the song if it was playing |
| Save numbering | Renames the files in the song folder to match the Level, Stop and Layer columns, then reloads |
| Level column | Editable. The number a part switches on at |
| Stop column | Editable. The level at which the part goes silent again; 0 means it plays to the end. Saved as `_stopN` in the filename |
| Part, Kind | Name and whether it is an audio file or a `.pattern` |
| Layer box | Ticked = stacks on top (a layer); unticked = replaces the others (a version). Saved as the `_layer` / `_version` token in the filename |
| State | PLAYING or silent, live, with the fade shown as a bar. Highlighted rows are what you hear right now |
| Override | Auto follows the level. On forces the part to play at any level; Off silences it, both from the next bar. For hearing a layer over any section |
| Stop all sounds | Stops the song, its layers, and every sound effect (Escape too) |

A single-file song shows one row with editing disabled.

**Pattern workshop** (below the parts table): pick one of the song's `.pattern` parts and its text
appears in an editor with a status line (bars, steps, tracks, loop seconds, or the problems found).

| Control | Does |
| --- | --- |
| Pattern | The `.pattern` parts of the playing song |
| Reload from disk | Re-reads the file (after editing it in another program) and re-bakes it in place |
| Save & reload | Writes the editor text to the file and swaps the new loop in at the current song position, so you hear the change without restarting |
| Solo this pattern | Forces this pattern on and the other patterns off from the next bar; versions keep playing, so you hear it over whichever section is current. Advance level to try it over the next section |
| Unsolo | Every part back to Auto from the next bar |

The parts table and the Level dropdown keep working while you edit, so the loop is: Advance to
the section you want, Solo the pattern, edit, Save & reload, listen, repeat.

---

## 3. Using sounds in game code (developer guide)

Everything goes through the `Sfx` autoload. It is available in every script with no setup.
Sound names are `StringName`s written as `&"name"`; a plain `"name"` also works.

### 3.1 The play functions

Two simple calls cover almost everything. Two "with options" calls exist for the rest.

```gdscript
Sfx.play(sound, condition)                      # 2D, right now
Sfx.play_at(sound, position, condition)         # 3D, right now
Sfx.play_with(sound, options)                   # 2D with options
Sfx.play_at_with(sound, position, options)      # 3D with options
```

`play` is non-positional (UI, the player's own actions, stings). `play_at` places the sound in
the 3D world: it gets quieter with distance and pans with the camera. `condition` is optional on
both. Both play instantly by default. They follow `Sfx.default_quantize`, which ships as `Sfx.NOW`
(off); the quantized-actions pass can later set it to `Sfx.SIXTEENTH` to put every plain call on
the grid in one place. The `_with` versions take a dictionary of named options, so a call reads as what it does
instead of a row of numbers.

**Simple-call parameters**

| Parameter | Type | Default | Meaning |
| --- | --- | --- | --- |
| `sound` | `StringName` | required | A name from `sfx_palette.gd` or a file in `Samples/` (without extension). Unknown names print a warning and play nothing |
| `position` | `Vector3` | required for `play_at` | World position of the sound, usually `global_position` of the thing making it |
| `condition` | `StringName` | `&""` | A name from `condition_palette.gd` to colour the sound (`&"wood"`, `&"metal"`, `&"underwater"`). Empty means the sound's own default condition, or none |

**Options** (any subset, in the dictionary passed to `play_with` / `play_at_with`)

| Key | Type | Default | Meaning |
| --- | --- | --- | --- |
| `quantize` | `float` | `Sfx.default_quantize` (off) | Snap to the next grid line of this many beats. Use the constants below. `Sfx.NOW` plays instantly. With no music playing it is ignored and the sound plays at once |
| `volume_db` | `float` | `0.0` | Loudness change in decibels on top of the sound's own level. `-6` is about half as loud, `-12` a quarter. Rarely above `0` |
| `pitch_scale` | `float` | `1.0` | Playback speed multiplier. `2.0` is an octave up and half as long, `0.5` an octave down |
| `pitch_jitter` | `float` | `0.0` | Random pitch change of up to this many semitones each play, so repeats do not sound identical. `1.0` is subtle, `2.0` clearly varied, `4.0` comic |
| `condition` | `StringName` | `&""` | Same as the simple call's `condition` |

A misspelled key prints a warning naming the valid keys, so typos do not fail silently.

**Quantize constants:** `Sfx.NOW` (instant), `Sfx.SIXTEENTH` (0.25 beat), `Sfx.EIGHTH` (0.5),
`Sfx.BEAT` (1.0), `Sfx.BAR` (one bar of whatever the song is in). Any float works too;
`2.0` is a half note.

**Condition precedence:** `Sfx.condition_override` (global, used by the labs and for
"everything is underwater now") beats the `condition` you pass, which beats the sound's own
`condition` flag set in the palette.

### 3.2 Examples

```gdscript
Sfx.play(&"p_ui_click")                                   # a button
Sfx.play_at(&"p_explosion", global_position)              # 3D, now
Sfx.play_at(&"p_hit", global_position, &"metal")          # 3D hit coloured as metal
Sfx.play(&"p_hit", &"wood")                               # 2D hit coloured as wood

Sfx.play_with(&"p_cast_arcane", {quantize = Sfx.EIGHTH})                        # a wider grid
Sfx.play_at_with(&"p_footstep", global_position, {volume_db = -6.0, pitch_jitter = 1.5})  # quieter, varied
Sfx.play_at_with(&"p_cast_fire", global_position, {condition = &"huge", quantize = Sfx.SIXTEENTH})
```

Two sounds played together are how you layer: `p_explosion` plus `p_debris_fall` is a bigger
break than either alone.

### 3.3 Team convention: the thing that changes state makes the sound

Pick one place for each sound and keep it there, so nobody adds a second copy and nothing is
missed. The rule for this project is **receiver-side**: whatever changes state plays the sound
for that change.

| Event | Who plays it | Why |
| --- | --- | --- |
| A block is hit or breaks | The block, in its hit reaction / health code | It owns its material, and it works no matter what hit it (fireball, cannonball, debris) |
| A spell is cast | The caster | It knows the spell type and the beat |
| A projectile flies or launches | The projectile | It knows its own position every frame |
| The player takes damage, jumps, dies | The player | It owns that state |
| A menu or planner button is pressed | The UI node | It owns the interaction |
| The music or the world changes (dive, shield up) | The system that changed it, via `Sfx.condition_override` | One place sets the global state |

Attackers never play the victim's sound. A projectile plays its launch and its flyby; the thing
it hits plays the impact.

### 3.4 Worked example: a block that sounds like its material

**1. Tag the block.** On the block's root script (the node the physics engine reports, not a
child mesh), expose the material so level builders set it in the Inspector:

```gdscript
class_name FortressBlock
extends RigidBody3D

## Condition that hits and breaks on this block play under. Pick a name from condition_palette.gd.
@export var material: StringName = &"stone"
```

**2. The block plays its own hit and break.** In the component that receives damage (the
project's `HitReactionComponent`, or the block script itself), the material is right there:

```gdscript
func receive_damage(packet: DamagePacket) -> void:
	var block := get_parent() as FortressBlock
	Sfx.play_at(&"p_hit", block.global_position, block.material)
	...


func _on_health_depleted() -> void:
	var block := get_parent() as FortressBlock
	Sfx.play_at(&"p_explosion", block.global_position, block.material)
	Sfx.play_at(&"p_debris_fall", block.global_position, block.material)
	block.queue_free()
```

**3. The attacker plays only its own sounds.** The fireball keeps its launch (`p_cast_fire` on
the caster) and plays nothing on impact; the block handles that:

```gdscript
func _on_body_entered(body: Node) -> void:
	if body.has_node("HitReactionComponent"):
		body.get_node("HitReactionComponent").receive_damage(damage_packet)
	queue_free()
```

One `p_hit` and one `p_explosion` now cover every material in the fortress. To add a material,
add a condition in `condition_palette.gd` (or in the Condition Lab) and type its name on a block.
To make hits heavier for bigger damage, pass a volume option:
`Sfx.play_at_with(&"p_hit", block.global_position, {condition = block.material, volume_db = -12.0 + 12.0 * clampf(packet.total() / 50.0, 0.0, 1.0)})`.

### 3.5 Other conventions

- **3D or 2D.** Anything with a place in the world uses `play_at`. UI, the player's own body
  sounds, and stings use `play`.
- **Quantization is off by default.** Plain `play` / `play_at` are instant, so nobody has to
  think about the beat. Quantizing is a separate pass on its own branch later: it will flip the
  single switch `Sfx.default_quantize` to `Sfx.SIXTEENTH` (every plain call then snaps to the
  grid while music plays) and give wind-up actions such as casts a wider grid with
  `{quantize = Sfx.BEAT}` in a `_with` call. Impacts, landing, damage and explosions should stay
  instant even then, with `{quantize = Sfx.NOW}`; a delayed impact reads as lag.
- **Repeats get jitter.** Footsteps, rapid hits, UI ticks: use `play_with` with `pitch_jitter` of `1.0` to
  `2.0`, or drop numbered files into `Samples/` for real variants.
- **Loudness lives in the palette, not the call.** Set a sound's base level with its
  `volume_db` in `sfx_palette.gd`; use the call's `volume_db` only for situational changes
  (distance is already handled by 3D, damage scaling is a good use).
- **Loops** (`p_ship_engine`, `p_wind_loop`, `p_hover_hum`) are not played with `play`. Get the
  stream with `Sfx.get_stream(&"p_ship_engine")`, put it on your own `AudioStreamPlayer3D` on the
  ship, and start and stop that player.
- **Names are data.** Keep them in the palette and in `@export` fields rather than scattering
  string literals through gameplay code, so a rename is one edit.

### 3.6 Music and the beat

To give a scene music and a beat, instance `SoundEngine/Music.tscn` and set its `song` field
(see section 7). To make something react to the beat:

```gdscript
func _ready() -> void:
	BeatClock.beat.connect(_on_beat)


func _on_beat(index: int) -> void:
	scale = Vector3.ONE * 1.2   # then tween back down
```

To make the *action* wait for the beat, not just the sound:

```gdscript
await get_tree().create_timer(BeatClock.seconds_until(Sfx.SIXTEENTH)).timeout
fire_projectile()
Sfx.play_at(&"p_cast_fire", global_position)
```

---

## 4. Making and tweaking sounds

A synth sound lives in exactly one place: its block in `sfx_palette.gd`. You can edit that file in
Godot's script editor, or let the Sound Lab edit it for you: it shows the selected sound's block in
a text box, and **Apply & commit**, **New sound** and **Delete sound** write straight back into the
file. Both routes end in the same file, so mix them freely.

### 4.1 In code (`sfx_palette.gd`)

1. Find the sound closest to what you want in [section 6](#6-recipes).
2. Copy its block in `sfx_palette.gd`, rename the variable and the dictionary key. Leave the
   `p_` prefix off your own sounds; that is how they land in the "User created" section:

   ```gdscript
   var dash := SynthPatch.new()
   dash.wave = SynthPatch.Wave.SQUARE
   dash.base_freq = 300.0
   dash.pitch_sweep_semitones = 14.0
   dash.decay = 0.2
   dash.volume_db = -6.0
   p[&"p_dash"] = dash
   ```

3. Save. In the running Sound Lab press **Reload patches**. The new button appears.
4. Change one knob at a time and reload. Ears learn faster than reading.

Any knob you do not set keeps the default from `synth_patch.gd`.

If you would rather start from everything visible, copy this block. It is every knob there is,
at its default, in signal order; section 5 explains each one:

```gdscript
	# Full template: every knob a sound can set, at its default. Delete the lines you do not change.
	var my_sound := SynthPatch.new()
	my_sound.wave = SynthPatch.Wave.SQUARE
	my_sound.duty = 0.5
	my_sound.base_freq = 440.0
	my_sound.noise_mix = 0.0
	my_sound.noise_tone = 1.0
	my_sound.sub_mix = 0.0
	my_sound.detune_cents = 0.0
	my_sound.detune_mix = 0.0
	my_sound.pwm_depth = 0.0
	my_sound.pwm_rate = 2.0
	my_sound.ring_ratio = 0.0
	my_sound.ring_mix = 0.0
	my_sound.pitch_sweep_semitones = 0.0
	my_sound.pitch_sweep_curve = 1.0
	my_sound.vibrato_depth = 0.0
	my_sound.vibrato_rate = 6.0
	my_sound.vibrato_shape = SynthPatch.LfoShape.SINE
	my_sound.vibrato_fade_in = 0.0
	my_sound.arpeggio_rate = 20.0
	my_sound.arpeggio_mode = SynthPatch.ArpMode.LOOP
	my_sound.arpeggio_glide = 0.0
	my_sound.fm_ratio = 0.0
	my_sound.fm_depth = 0.0
	my_sound.fm_decay = 0.0
	my_sound.attack = 0.005
	my_sound.decay = 0.15
	my_sound.sustain_level = 0.0
	my_sound.sustain_time = 0.0
	my_sound.release = 0.05
	my_sound.envelope_curve = SynthPatch.EnvCurve.LINEAR
	my_sound.tremolo_depth = 0.0
	my_sound.tremolo_rate = 6.0
	my_sound.tremolo_shape = SynthPatch.LfoShape.SINE
	my_sound.repeat_rate = 0.0
	my_sound.filter_mode = SynthPatch.FilterMode.NONE
	my_sound.cutoff = 2000.0
	my_sound.cutoff_sweep_octaves = 0.0
	my_sound.resonance = 0.0
	my_sound.filter_lfo_depth = 0.0
	my_sound.filter_lfo_rate = 3.0
	my_sound.filter_lfo_shape = SynthPatch.LfoShape.SINE
	my_sound.drive = 0.0
	my_sound.bit_depth = 16
	my_sound.sample_hold = 1
	my_sound.delay_time = 0.0
	my_sound.delay_feedback = 0.4
	my_sound.delay_mix = 0.0
	my_sound.volume_db = 0.0
	my_sound.normalize = true
	my_sound.sample_rate = 44100
	my_sound.loop = false
	my_sound.noise_seed = 1
	my_sound.condition = &""
	p[&"my_sound"] = my_sound
```

**The same loop without leaving the lab.** Click the sound. The text box under the log line shows
every knob it has, grouped like section 5, each at its current value:

```gdscript
	var jump := SynthPatch.new()
	# Every knob, at its current value. A trailing * comment marks one changed from its default.
	# ---- Oscillator
	jump.wave = SynthPatch.Wave.SQUARE  # choices: SINE SQUARE SAW TRIANGLE NOISE
	jump.duty = 0.4  # *
	jump.base_freq = 260.0  # *
	jump.noise_mix = 0.0
	...
	p[&"p_jump"] = jump
```

`# *` means "changed from the default". Enum knobs list the values they accept. Edit any number:
the line is tinted at once if it now differs from the default, and its `# *` is rewritten when
you press **Apply & commit**. Then press **Play selected**; both buttons stay in the same place
however long the sound list gets. Apply & commit makes the sound live at once and rewrites that
one block in `sfx_palette.gd` in the same layout you see, `# *` marks and all. Comments you added
inside the block stay above the line they were above, and a comment after the first line
(`# showcases: ...`) stays there too. Setting a knob back to its default value removes its `# *`.
If a line cannot be read, nothing is written and the status text beside the buttons says which
line and why.

**Reload patches reads the file from disk.** Edits you make in Godot's script editor, and blocks
the lab added or removed, show up the moment you press it; you do not need to restart the lab. If
the file has a typo, the lab keeps playing the version it started with, and the Output panel says
so, until you fix it and reload again.

### 4.2 Adding, copying, renaming and deleting sounds (Sound Lab)

**Add a sound.** Press **New sound**. A block named `new_sound` (then `new_sound_2`, ...) is
appended to `sfx_palette.gd`, it lands in the **User created** section, and the lab selects it.
The text box shows every knob at its default, none marked yet.

**Name it.** Change the variable and the key, for example `var laser := SynthPatch.new()` ...
`laser.wave = ...` ... `p[&"laser"] = laser`, change any knobs, and press **Apply & commit**. The
variable name only has to be the same on every line; the key in the last line is the name you
play. Because `new_sound` was untouched, it is *renamed*: the `new_sound` block disappears and
`laser` takes its place, with `# *` on the knobs you changed.

**Copy a sound.** Click any existing sound, change the key in the last line
(`p[&"p_jump"] = jump` to `p[&"jump_high"] = jump`), edit what you like, and Apply. The original
stays as it was and a new block is appended under the new name. Leave the `p_` prefix off your own
sounds so they sort into User created.

**Delete a sound.** Select it and press **Delete sound**. A dialog asks you to confirm; only
**Delete** removes the block from `sfx_palette.gd`, and Cancel or Escape leaves everything alone.
Git still has every committed version, so a mistake can be recovered with
`git checkout -- SoundEngine/sfx_palette.gd` (which also throws away other unsaved edits to that
file). Audio files in `Samples/` cannot be deleted from the lab; remove the file yourself.

### 4.3 Your own audio files (from a DAW or a sound library)

Drop `.wav`, `.ogg` or `.mp3` files into `SoundEngine/Samples/`. Press **Reload patches** (or
restart) and each file is a sound with the filename as its name, marked "(file)" in the lab.
It plays through exactly the same `Sfx.play` and `play_at`, with the same quantize, 3D pools and
anti-spam rule; the engine applies no processing of its own, so what you exported is what plays.

```
Samples/cannon_boom.wav           Sfx.play(&"cannon_boom")
Samples/wood_hit_1.wav
Samples/wood_hit_2.wav            Sfx.play(&"wood_hit")  picks one of the three at random
Samples/wood_hit_3.wav
Samples/cast_fire.wav             replaces the synth cast_fire everywhere, no code change
```

Export checklist, because the file is played as-is:

- **Trim leading silence to zero.** The beat grid fires at the first sample; 20 ms of silence at
  the start is 20 ms late on every beat.
- **Peak around -6 dBFS** so files sit at the same level as the synth sounds (which normalize
  to -1 dBFS and then apply their `volume_db`, mostly -4 to -12).
- **Mono** for anything positioned in 3D; Godot mixes stereo down for `AudioStreamPlayer3D`.
- **WAV** for short one-shots (no decode cost, exact start), **OGG** for anything long.
- Tails are fine. They only cost memory, and quantization cares about the start, not the end.
  Fade the last 10 ms so the file does not click when it ends.

When to use a file instead of a synth sound: anything that needs real-world texture (voices,
cloth, water, recorded foley), layered sounds built in a DAW, or a sound you have already made
that you like. Keep synth sounds for things that must vary by pitch or length at runtime, for
tiny UI blips, and for anything you want to tweak quickly in the lab.

### 4.4 As plain .wav files

Press **Export all as .wav**. `SoundEngine/Exported/` fills with ordinary audio files you can
open in Audacity or a DAW, send to a teammate, or drag onto an `AudioStreamPlayer` like any
asset. The engine does not use them; they are a product of it.

### 4.5 Conditions: one sound, many objects

A condition is a named colouring applied when a sound plays. Materials: `wood`, `metal`,
`stone`, `glass`. Environments: `underwater`, `distant`, `shielded`, `cavern`. Flavour: `huge`,
`tiny`, `radio`, `magic`. Modulating (they add tremolo, vibrato, filter wobble or stutter to
synth sounds and a matching bus effect to everything): `haunted`, `pulsing`, `wobbly`,
`stuttered`, `drunk`, `chiptune`, `dreamy`. Mix flavour: `chipmunk`, `giant`, `punchy`, `warm`,
`wide`, `left`, `right`. Each entry in `condition_palette.gd` names the effect type or override
it showcases in a comment. One
generic `p_hit` played under `wood` and under `metal` gives two different objects, so you do not
need a sound per material. The same idea covers "the whole world sounds like this now" (dive
underwater, inside a shield) and "make this one bigger".

**Three ways to apply one, in order of precedence (highest first):**

1. `Sfx.condition_override = &"underwater"` applies to every play until cleared. The lab's
   Condition dropdown sets this, which is how you audition a condition on the whole palette.
2. Pass it when playing: `Sfx.play(&"p_hit", &"wood")`, `Sfx.play_at(&"break", global_position,
   &"metal")`, or `{condition = &"metal"}` in the options of `play_with` / `play_at_with`.
3. Set it on the sound in `sfx_palette.gd` as a flag: `anchor_drop.condition = &"metal"`.
   That sound then always plays under it unless 1 or 2 says otherwise.

**What a condition is made of** (`sfx_condition.gd`), and why there are two layers:

- `effects`: Godot `AudioEffect`s on a dedicated bus named `SFX_<condition>` that sends into
  `SFX`. Low/high/band-pass filters, distortion, reverb, phaser, chorus, EQ. This layer works on
  everything, including your own audio files, because it happens at playback.
- `pitch_scale` and `volume_db`: applied to the player. `huge` plays at 0.7x pitch, `tiny` at
  1.6x.
- `patch_overrides`: a dictionary of SynthPatch knob -> value applied to a copy of a synth sound
  before it is rendered. This can change timbre in ways a filter cannot: `metal` adds FM ringing,
  `wood` adds a resonant band-pass plus crackle. Rendered variants are cached per sound and
  condition. Audio files ignore this layer, so for them a material is only the bus effects.

**Adding or changing a condition.** Open `condition_palette.gd`, copy an entry, change the
effects (the `_lowpass`, `_reverb` helpers at the bottom keep it readable), save, press Reload
patches in the lab, pick it in the dropdown. Everything you click now plays through it. Bus
effects are live, so a condition can also be adjusted at runtime from the Audio panel while the
game runs: open the bottom Audio tab, find the `SFX_wood` bus, and drag its filter.

**In gameplay**, the usual pattern is a material on the thing being hit:

```gdscript
func _on_body_entered(body: Node) -> void:
	var material: StringName = body.get_meta(&"material", &"stone")
	Sfx.play_at(&"p_hit", global_position, material)
```

and an environment on the listener:

```gdscript
func _on_submerged() -> void:
	Sfx.condition_override = &"underwater"

func _on_surfaced() -> void:
	Sfx.condition_override = &""
```

### 4.6 Editing conditions (Condition Lab)

Conditions live in one place, `condition_palette.gd`, and get their own lab: open
`SoundEngine/ConditionLab.tscn` and press F6. It has the music transport and every sound button,
but the editor panel acts on the condition in the dropdown, never on sounds.

1. Pick a condition in the dropdown. Every sound you click now plays through it, and every field
   it has appears in the text box, `# *` marking those changed from their defaults:
   - each bus effect, written out explicitly (`var wood_fx0 := AudioEffectBandPassFilter.new()`)
     with **all** of its properties, not just the ones the palette sets;
   - `effects = [...]`, the order the effects run in;
   - `volume_db` and `pitch_scale` for the whole condition;
   - `patch_overrides`, listing **every** synth knob. Overridden ones are live lines marked
     `# *`; the rest are commented out at the knob's default, ready to uncomment.
2. Change a cutoff, uncomment an override, add or remove an effect. Any `AudioEffect` class works
   in a `var x_fx0 := ...new()` line as long as `effects = [...]` lists it; the header comment
   names the common ones. After Apply, a newly added effect shows all its properties too.
   Properties whose names contain a slash (EQ6 bands, Chorus voices) are written as
   `x_fx0.set("band_db/32_hz", -6.0)`, because `x_fx0.band_db/32_hz = ...` is not valid GDScript.
3. Press **Apply & commit**, then **Play selected** to hear the last sound you clicked under the
   new version. The bus is rebuilt at once and the block in `condition_palette.gd` is replaced
   with what you see in the editor, `# *` marks included.

**New condition** appends an empty `new_condition` (doing nothing yet) and shows every field,
with a commented example effect. Add what you need, change the name in the last line, and Apply:
the untouched `new_condition` is renamed. Changing the key of an existing condition copies
it instead. **Delete condition** asks first, then removes the block; sounds whose patch names that
condition simply play without one. **Reload conditions** re-reads `condition_palette.gd` from disk,
so edits made in the script editor show up without restarting.

---

## 5. What every knob does

Read `synth_renderer.gd` top to bottom alongside this. It is one loop over samples, about 100
lines, and every stage is labeled. Signal order: oscillator (with sub, detune, PWM), FM, ring mod, noise, envelope (with
tremolo and repeat), filter (with its LFO), drive, bitcrush, delay, volume.

### Oscillator

| Knob | Range | What it does |
| --- | --- | --- |
| `wave` | SINE, SQUARE, SAW, TRIANGLE, NOISE | The raw tone. Sine is pure (bells, sub bass, pickups). Square is hollow and video-gamey. Saw is bright and buzzy (brass, bass, fire). Triangle is a soft square. Noise ignores pitch; it is the raw material of impacts, explosions, hiss and hats |
| `duty` | 0.05 to 0.95 | Square only. 0.5 is a full square; 0.1 is a thin nasal buzz |
| `base_freq` | 20 to 8000 Hz | Starting pitch. 440 is A4. Each octave doubles the number |
| `noise_mix` | 0 to 1 | Blend white noise into any wave. Fire and hurt sounds sit around 0.3 to 0.6 |
| `noise_tone` | 0.01 to 1 | Darken the noise. 1 is white hiss, 0.3 is pinkish, 0.05 is a dull brown rumble. Only touches noise |
| `sub_mix` | 0 to 1 | Blend in a sine one octave below the pitch for weight. 0.5 is an equal blend |
| `detune_cents` | -100 to 100 | A second copy of the wave shifted by this many cents (100 = a semitone). 5 to 15 is fat and chorus-like, 50 is out of tune. Needs `detune_mix` |
| `detune_mix` | 0 to 1 | How much of the detuned copy to blend in. 0.5 is equal |
| `pwm_depth` | 0 to 0.45 | Pulse-width modulation for SQUARE: the duty wobbles by this much. 0.3 is the classic chip lead |
| `pwm_rate` | 0.1 to 20 Hz | Speed of that wobble |
| `ring_ratio` | 0 to 12 | Ring modulation: multiply by a sine at this multiple of the pitch. Fractions are metallic and robotic |
| `ring_mix` | 0 to 1 | How much ring modulation. 1 is full (classic robot voice) |

### Pitch motion (where most character lives)

| Knob | Range | What it does |
| --- | --- | --- |
| `pitch_sweep_semitones` | -48 to 48 | Pitch drift over the sound. Falling = heavy, dangerous. Rising = positive, energetic |
| `pitch_sweep_curve` | 0.1 to 4 | Shape of the drift. Below 1 moves early then settles (kick drums use 0.3). Above 1 starts slow then dives |
| `vibrato_depth` | 0 to 12 semitones | Pitch wobble. 0.2 is warmth, 3 is alarm |
| `vibrato_rate` | 0.1 to 40 Hz | Wobble speed |
| `arpeggio` | list of semitones | Steps through these offsets very fast. `[0, 7, 12]` is the classic coin sparkle; it is how 8-bit games faked chords |
| `arpeggio_rate` | 1 to 60 per second | How fast the steps go |
| `vibrato_shape` | SINE, TRIANGLE, SQUARE, SAW, RANDOM | SINE wobbles, SQUARE trills between two notes, SAW is a siren, RANDOM burbles (new random pitch each cycle) |
| `vibrato_fade_in` | 0 to 2 s | Seconds for the vibrato to grow from nothing to full depth, like a singer or a swelling spell |
| `arpeggio_mode` | LOOP, ONCE, PING_PONG, RANDOM | LOOP repeats the list, ONCE stops on the last note, PING_PONG bounces up and down, RANDOM picks a new note each step (wind chimes) |
| `arpeggio_glide` | 0 to 0.5 s | Slide between arpeggio notes instead of jumping. 0.05 is a portamento, 0.2 is a theremin |

### FM (frequency modulation)

| Knob | Range | What it does |
| --- | --- | --- |
| `fm_ratio` | 0 to 12 | A second oscillator at this multiple of the pitch wiggles the first. Whole numbers = bells and brass. Odd fractions like 1.41 or 3.01 = metallic, magical |
| `fm_depth` | 0 to 20 | How hard it wiggles. Brightness. 0 is off |
| `fm_decay` | 0 to 2 s | Brightness fades over this time, like a struck object. 0 means no fade |

### Amp envelope (loudness shape)

| Knob | Range | What it does |
| --- | --- | --- |
| `attack` | 0 to 2 s | Time to reach full volume. 0 is a hit; 0.1 is a swell |
| `decay` | 0 to 3 s | Time to fall from full to `sustain_level` |
| `sustain_level` | 0 to 1 | Volume held after decay. 0 makes it percussive |
| `sustain_time` | 0 to 4 s | How long it holds |
| `release` | 0 to 4 s | Fade to silence at the end |
| `envelope_curve` | LINEAR, EXPONENTIAL | EXPONENTIAL drops fast then trails off, which is how most real objects decay |
| `tremolo_depth` | 0 to 1 | Volume wobble. 0.5 pulses, 1 cuts fully to silence each cycle |
| `tremolo_rate` | 0.1 to 40 Hz | Speed of the wobble. 4 is a pulse, 14 is a helicopter, 40 is a crackle |
| `tremolo_shape` | SINE, TRIANGLE, SQUARE, SAW, RANDOM | SINE pulses smoothly, SQUARE chops, RANDOM crackles |
| `repeat_rate` | 0 to 40 per second | Restart the envelope and pitch sweep this often (sfxr "repeat"). 8 is a stutter, 20 is a machine gun. Total length does not change |

### Filter

| Knob | Range | What it does |
| --- | --- | --- |
| `filter_mode` | NONE, LOWPASS, HIGHPASS, BANDPASS | Low-pass removes highs (darker, heavier, farther). High-pass keeps only fizz (hats, sparkle). Band-pass is telephone-like |
| `cutoff` | 20 to 14000 Hz | Where the filter starts cutting |
| `cutoff_sweep_octaves` | -8 to 8 | Cutoff moves this many octaves over the sound. Closing a low-pass on noise is the single most useful trick for impacts: "whoomp" |
| `resonance` | 0 to 1 | A whistle at the cutoff. Sweep it for lasers and sci-fi |
| `filter_lfo_depth` | 0 to 4 octaves | Wobble the cutoff by this much (auto-wah). Needs a filter mode and some resonance to hear |
| `filter_lfo_rate` | 0.1 to 20 Hz | Speed of the wobble. 2 is a wah, 6 is a dubstep wobble |
| `filter_lfo_shape` | SINE, TRIANGLE, SQUARE, SAW, RANDOM | Shape of the wobble |

### Dirt

| Knob | Range | What it does |
| --- | --- | --- |
| `drive` | 0 to 1 | Soft clipping: louder, fatter, grittier |
| `bit_depth` | 2 to 16 | Fewer bits = crunchier. 16 is clean, 5 is a Game Boy |
| `sample_hold` | 1 to 32 | Repeats each sample N times: a cheap, grainy lo-fi |

### Space

| Knob | Range | What it does |
| --- | --- | --- |
| `delay_time` | 0 to 1 s | Echo spacing. 60 to 120 ms adds size; 200 ms+ adds a vast tail. Set to a note length at the song's BPM (`60 / bpm * 0.75` for a dotted eighth) and the echoes land on the grid |
| `delay_feedback` | 0 to 0.95 | How much each echo feeds the next. Higher = longer tail |
| `delay_mix` | 0 to 1 | Echo volume. 0 turns the delay off |

### Output

| Knob | Default | What it does |
| --- | --- | --- |
| `volume_db` | 0 | Final level. Use this, not the other knobs, for relative loudness |
| `normalize` | true | Scale the loudest sample to full before volume, so presets are comparable |
| (declick) | always | Every one-shot gets a 1.5 ms fade at each end and every loop a 10 ms crossfade of its tail into its head, so no sound starts, stops or wraps with a tick. Not a knob; mentioned so the first samples of a render make sense |
| `sample_rate` | 44100 | Render rate. 22050 halves render time and file size; fine for lo-fi |
| `loop` | false | Make the stream loop seamlessly (engines, hums, shields). The loop is exactly the envelope; any echo tail is folded back onto the start so echoes wrap instead of leaving a silent gap |
| `noise_seed` | 1 | Random seed so the same patch always renders the same bytes |
| `condition` | none | Default condition this sound plays under, e.g. `&"metal"`. A condition passed at play time, or the override, wins |

---

## 6. Recipes

| Want | Start from | Key moves |
| --- | --- | --- |
| Fire, flame, whoosh | `p_cast_fire` | saw + noise mix, pitch falls, low-pass closes, some drive |
| Arcane, sparkle, magic | `p_cast_arcane` | sine + inharmonic FM, fast rising arpeggio, echo |
| Dark, void, gravity | `p_cast_void` | low sine, FM ratio 0.5, slow pitch dive, vibrato, echo |
| Zap, lightning | `p_cast_lightning` | thin square, huge fast pitch drop, fast vibrato, bitcrush |
| Impact | `p_hit` / `p_thump` | noise, zero attack, 100 ms decay, low-pass closing; add a sine thump for weight |
| Explosion | `p_explosion` | long noisy decay, filter closes 4 octaves, drive, short echo |
| Hurt | `p_hurt` | saw falling fast, bitcrush |
| Power up, shield | `p_shield_up` | triangle, rising arpeggio, filter opening, echo |
| Pickup | `p_pickup_mana` | sine, 3-note rising arpeggio, 100 ms, quiet |
| UI | `p_ui_click` | square, 30 ms, 1 to 2 kHz, quiet; confirm rises, back falls |
| Warp, teleport | `p_warp` | sine rising three octaves with a slow curve, vibrato, long echo |
| Engine hum (loop) | `p_ship_engine` or `p_low_drone` | saw, low-pass, slow vibrato, `loop = true`, play via `Sfx.get_stream` on your own player |

For a family of related sounds (three fire spells), keep the shape and change pitch, length and
drive.

---

## 7. Music: adaptive songs from your DAW, with synth layers

Music is made in the DAW and dropped into `SoundEngine/Music/`. A song can be one file, or a
folder of numbered parts that the engine plays in sync and switches between on the beat: a calm
version for the planning phase, a battle version when the real-time phase starts, more intense
versions as the player closes in on the goal, and synth patterns baked by the in-game synth that
layer on top. The beat clock follows the song, so every quantized sound effect stays on its grid.

### 7.1 Export it right (any part)

1. Beat 1 at the very first sample: no silence or pickup. If you cannot trim it, measure the
   lead-in and set `BeatClock.offset_seconds`.
2. Constant tempo. Swing in the drums is fine; the grid is what matters.
3. An **exact number of bars**. Every part loops on its own, and parts stay aligned only because
   each restarts on a bar line. The lab warns if a part is off and by how many milliseconds.
4. **OGG** is the best format (small, seamless loop). WAV and MP3 also work.
5. All parts of one song at the same tempo and key, exported from the same session, so they can
   play over each other. Parts may be different lengths as long as each is whole bars.

### 7.2 A single-file song

Copy the file into `SoundEngine/Music/` with the tempo in the name: `space_wizard_128bpm.ogg`.
Add `_3-4` for three beats per bar. That is a one-part song; everything below still applies,
there is just nothing to switch to.

### 7.3 An adaptive song: a folder of parts

Make a folder named like a song file and put the parts inside. **The number at the front of
each filename is the level that part switches on at.** That is the whole system; everything else
follows from it.

```
Music/space_wizard_128bpm/
    1_calm.ogg               the main song, planning phase          (level 1)
    2_battle.ogg             the main song, real-time phase         (level 2)
    3_arp.pattern            a synth pattern that joins at level 3
    3_choir_layer.ogg        your own audio that also joins at level 3
    4_final.ogg              the main song, last stretch            (level 4)
    5_drums.pattern          one more synth pattern at level 5
```

Two kinds of part:

- **The main song** is a set of **versions**. At any level only the highest-numbered version at
  or below the level plays. Above, `calm`, `battle` and `final` are versions: at level 1 you hear
  calm; at level 2 battle replaces it; at level 4 final replaces battle. They never overlap.
- **Layers** stack on top of whatever version is playing. Every layer numbered at or below the
  level plays. Above, `arp` and `choir` join at level 3 and stay on; `drums` joins at level 5.

So the song plays out like this as the game raises the level:

| Level | What you hear |
| --- | --- |
| 1 | calm |
| 2 | battle |
| 3 | battle + arp + choir |
| 4 | final + arp + choir |
| 5 | final + arp + choir + drums |

**How a file knows whether it is a version or a layer.** Audio files (`.ogg`, `.wav`, `.mp3`)
are versions unless their name contains `_layer`. Pattern files (`.pattern`) are layers unless
their name contains `_version`. That is why `3_choir_layer.ogg` stacks: it is your own audio used
exactly like a pattern. If you want a synth pattern to be a full version of the song instead,
name it `2_battle_version.pattern`.

**Stopping a part again.** By default a layer, once on, plays to the end of the song. Add
`_stopM` to the filename to silence it from level `M` on: `3_arp_stop5.pattern` plays at levels 3
and 4 and is gone at 5. The stop level counts as a level of its own, so `advance()` visits it even
if nothing starts there. Add `2_riser_layer_stop3.ogg` to the example above and you get a riser
under battle that drops out one step later: level 2 is battle + riser, level 3 is battle + arp +
choir with the riser gone.

**Rules of thumb.** Several parts may share a number and come in together (the two 3s above).
Numbers may skip. Every part must be an exact number of bars at the song's tempo; they can be
different lengths (calm 8 bars, battle 16, arp 2). You will normally go up only; levels can go
down, but the game design here never does.

**How it stays seamless.** All parts start in the same frame and loop, so they are mixed from the
same sample and stay aligned bar for bar. A part that is not switched on is simply silent.
Changing level crossfades the gains, by default at the next bar line, so a phase change always
lands on the music. Nothing is ever restarted or re-synced.

**How you trigger it from the game.** There is one call per event:

```gdscript
$Music.set_level(2)          # "Begin Assault" pressed: battle takes over on the next bar
$Music.advance()             # a milestone reached: the next level number up, on the next bar
$Music.set_progress(0.75)    # or map a 0..1 progress value onto the levels evenly
```

`advance()` is the one to reach for: each time the player hits a milestone (a wall down, a rune
broken, treasure in sight), call it once and the song moves to the next number in the folder.
You decide what counts as a milestone in gameplay code; the music does not know or care.

### 7.4 Synth layers: `.pattern` files

A `.pattern` part is a small text file that the in-game synth renders into a loop at the song's
tempo when the song loads. Every note is placed at an exact sample, so the loop is
sample-accurate and wraps seamlessly; a note that runs past the end continues at the start. The
complete, commented template is `Music/TEMPLATE.pattern`; copy it into a song folder as
`N_name.pattern`, where `N` is the level it joins at (add `_stopM` to make it leave again at
level `M`).

```
# 3_arp_stop5.pattern: joins at level 3, silent from level 5
bars = 2
steps_per_beat = 4
root = D4

[track]
patch = p_inst_pluck
pattern = 0 . 7 . 12! . 7 . | 3 . 7 . 12! . 10 .
pattern = 0 . 7 . 12! . 7 . | 5 . 7 . 12! . 7~ .
gain_db = -4

[track]
patch = p_inst_kick
pattern = X...x...X...x...|X...x...X..xx...
```

**File rules.** One `key = value` per line. A `#` that starts a line or follows a space begins a
comment (so `F#4` is still a note). Blank lines are ignored. Keys are case-insensitive.
Song-level keys go above the first `[track]`; each `[track]` section is one instrument line and
there can be as many as you like, all mixed into the one loop. Problems (unknown key, bad step,
unknown sound) are reported with their line number in the Song Lab's workshop status line and in
Godot's Output panel; the rest of the file still bakes.

#### Song-level keys (above the first `[track]`)

| Key | Default | Range | Meaning |
| --- | --- | --- | --- |
| `bars` | 2 | 1 to 64 | Loop length in whole bars. Equal to, or a divisor of, the audio parts' length so it lines up with them (1, 2, 4, 8). The loop is `bars × beats per bar × 60 ÷ BPM` seconds: 4 bars at 128 BPM in 4/4 is 7.5 s |
| `steps_per_beat` | 4 | 1 to 16 | Grid resolution. 4 = sixteenths (16 steps per 4/4 bar), 2 = eighths, 3 = triplets, 8 = thirty-seconds |
| `root` | none | note name or Hz | What the number `0` means in every track: `root = D4` makes `7` play A4 on every instrument, whatever its own tuning. Without it, numbers count from each patch's `base_freq`. Note names ignore `root` |
| `transpose` | 0 | semitones | Added to every track. Shift the whole pattern to another key |

#### Track keys (inside a `[track]`)

| Key | Default | Meaning |
| --- | --- | --- |
| `patch` | required | Any sound name: a `p_` preset, or your own unprefixed sound from `sfx_palette.gd`. The `p_inst_*` instruments are tuned for music, but anything works: `p_glass_hit` as a bell, `p_stone_hit` as a drum |
| `pattern` | required | The steps, in either form below. May appear several times in one track; the lines join up, so write one bar per line |
| `notes` | `0` | Pitches used by `x X o` steps, one per hit in turn, cycling: numbers (from root) or note names, mixed freely. Not needed when every step names its own pitch |
| `gain_db` | 0 | Track volume. `-6` is about half as loud. The finished loop is normalized to leave headroom, so this sets the balance between tracks, not absolute loudness |
| `transpose` | 0 | Semitones added to this track only |
| `condition` | none | Render through a condition's synth knob overrides (`metal`, `glass`, `haunted`...). Only the knob overrides apply to a baked pattern, not the bus effects |

#### Steps: readable form

Tokens separated by spaces, one per step. `|` is a bar line and is ignored, so you can mark bars
however you like.

| Token | Means |
| --- | --- |
| `7`, `-5`, `12` | A hit, that many semitones from `root` (or from the patch's tuning if no root) |
| `D4`, `F#4`, `Bb3` | A hit at that note. A4 = 440 Hz. Sharps `#`, flats `b` |
| `x` | A hit on the next entry of `notes` (normal level) |
| `X` | The same, accented (full level) |
| `o` | The same, soft |
| `.` | A rest. `-` and `_` also rest |
| `!` suffix | Accent: full level. `7!`, `D5!`, `x!` |
| `~` suffix | Soft: about a third. `7~`, `A4~` |

Volume per step is therefore: accent `!` or `X` = full, plain = 0.7 (about −3 dB), soft `~` or
`o` = 0.35 (about −9 dB). Multiply by the track's `gain_db` for the final balance.

#### Steps: compact form

One character per step, no spaces, pitch taken from `notes` in turn: `x` normal, `X` accent,
`o` soft, `.` `-` `_` rest, `|` ignored. `x.x.X.x.|x.x.X.x.` is eight steps per bar in eighths,
or half a bar in sixteenths.

**Length.** The loop has `bars × beats per bar × steps_per_beat` steps (32 for two 4/4 bars in
sixteenths). A shorter pattern repeats to fill the loop; a longer one is cut at the end. Patterns
may be up to 64 bars, but a short loop re-bakes faster while you edit in the Song Lab. Patterns
and audio parts loop independently and stay aligned because each is whole bars: a 2-bar pattern
over an 8-bar audio part simply plays four times per pass.

#### Notes and numbers (A4 = 440 Hz)

With `root = C4`, the numbers in a pattern are these; every octave adds 12.

| Note | Number from C | Octave 3 Hz | Octave 4 Hz | Octave 5 Hz |
| --- | --- | --- | --- | --- |
| C | 0 | 130.8 | 261.6 | 523.3 |
| C# / Db | 1 | 138.6 | 277.2 | 554.4 |
| D | 2 | 146.8 | 293.7 | 587.3 |
| D# / Eb | 3 | 155.6 | 311.1 | 622.3 |
| E | 4 | 164.8 | 329.6 | 659.3 |
| F | 5 | 174.6 | 349.2 | 698.5 |
| F# / Gb | 6 | 185.0 | 370.0 | 740.0 |
| G | 7 | 196.0 | 392.0 | 784.0 |
| G# / Ab | 8 | 207.7 | 415.3 | 830.6 |
| A | 9 | 220.0 | 440.0 | 880.0 |
| A# / Bb | 10 | 233.1 | 466.2 | 932.3 |
| B | 11 | 246.9 | 493.9 | 987.8 |

The same numbers work from any root: with `root = D4`, `0` is D4, `7` is A4, `12` is D5. Scale
and chord cheat sheet, as numbers from the root:

| Shape | Numbers |
| --- | --- |
| Major scale | 0 2 4 5 7 9 11 12 |
| Natural minor scale | 0 2 3 5 7 8 10 12 |
| Minor pentatonic | 0 3 5 7 10 12 |
| Major pentatonic | 0 2 4 7 9 12 |
| Major chord | 0 4 7 |
| Minor chord | 0 3 7 |
| Power chord / fifth | 0 7 12 |
| Octave bounce | 0 12 0 12 |

**Instrument tunings.** `p_inst_pluck` is D4 (293.7 Hz), `p_inst_bass` D2 (73.4 Hz),
`p_inst_pad` D3 (146.8 Hz); `p_inst_kick` and `p_inst_hat` are unpitched. Set `root` to the song's
key and the numbers mean the same on every track; or use note names and never think about it.
Retune an instrument in the Sound Lab by changing its `base_freq`.

### 7.5 Hear it

Run the **Song Lab** (`SongLab.tscn`): pick the song, press Start at level 1, then Advance level
to walk through the song the way the game will. The parts table shows every part, lights up the
ones playing, and lets you force any part on or off to try a layer over any section. Edit the
Level numbers or Layer boxes and press Save numbering to rewrite the folder. The Sound and
Condition labs also play songs and have the Level dropdown, for checking sound effects against
the music.

### 7.6 Use it in the game

Instance `Music.tscn` in the scene and type the song name (file without extension, or folder
name) into its `song` field. It starts at the lowest level in the folder (normally 1) with the clock locked. Then:

```gdscript
$Music.set_level(2)                              # "Begin Assault": level 2 on the next bar
$Music.advance()                                 # next level number up, next bar
$Music.set_progress(progress_toward_goal)        # 0..1 mapped evenly onto the levels
$Music.set_level(4, MusicPlayer.Transition.NOW)  # immediate crossfade (a hit, a death)
$Music.set_level(1, MusicPlayer.Transition.NEXT_BEAT)
```

`fade_seconds` (0.6 by default) and `default_transition` are exports on the node. The
`level_changed(level)` signal fires when a change takes effect, which is the moment to flash
something on screen. `stop()` stops every part and the clock.

**`MusicPlayer` reference:** exports `song`, `volume_db`, `fade_seconds`, `default_transition`;
`play_song_named(name)`, `play_song(entry)`, `play_stream(stream, bpm, beats_per_bar)`,
`set_level(number, transition)`, `advance(transition)`, `set_progress(0..1, transition)`,
`set_part_state(index, PartState.AUTO | ON | OFF, transition)` (force one part regardless of level, on the next bar),
`level` (the current filename number), `levels()` (the numbers present, e.g. `[1, 2, 3, 5]`),
`level_count()`, `layer_names()` (what each level switches on or off), `stop()`, `current_song`,
`player` (the first part's player, which drives the clock).

**`MusicLibrary`** (static helpers): `scan()` lists songs as `{name, path, bpm, beats_per_bar,
has_bpm, parts}` where each part is `{order, name, path, kind, additive}`; `scan_parts(folder)`;
`load_stream(path)` loads any audio file with looping forced on; `loop_warning(entry, stream)`.
**`PatternBaker`**: `parse(path)`, `bake(def, bpm, beats_per_bar)`, `bake_file(path, bpm, beats_per_bar)`.

---

## 8. How beat sync works

Godot cannot schedule a sound to start at an exact future sample, so the engine does the next
best thing in three parts.

**Reading musical time.** `BeatClock.get_time()` uses the formula from Godot's "Sync the
gameplay with audio and music" guide:

```
heard = playback_position + time_since_last_mix - output_latency
```

`playback_position` only updates each mix chunk; adding `time_since_last_mix` interpolates
between chunks; subtracting `output_latency` corrects for the hardware buffer so the time
reflects what the player's ears are getting now. Dividing by seconds-per-beat gives a fractional
beat. The clock keeps counting upward across the music's loop seam.

**Booking the grid line.** `Sfx.play(name, q)` computes the next multiple of `q` beats at or
after now and stores the request. A second request for the same sound and grid line is dropped,
so mashing a button cannot pile ten copies on the downbeat (ten identical waves summed is also
20 dB louder, so this is a safety rule too).

**Firing a little early.** Each frame, `Sfx` fires any request whose grid line is less than
`output_latency + one frame + extra_lead_seconds` away. Audio started now is heard one latency
later, so leading by that much lands it on the line. The remaining error is up to one frame plus
one mix chunk, about 10 to 25 ms, below where rhythm feels off. If sounds feel late or early on
a particular PC, adjust `Sfx.extra_lead_seconds`, like a rhythm game's audio offset.

**If sample-accurate SFX are ever needed:** feed an `AudioStreamGenerator` from `_process`,
keeping a list of active voices (rendered arrays plus a start-sample index) and summing each at
its exact offset. That gives perfect alignment at the cost of 3D positioning for those voices and
a per-frame GDScript cost. The current design was chosen because 3D positioning and zero
per-frame cost matter more for a jam than the last 15 ms.

---

## 9. Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| No sound at all | Windows output device, or Godot's master bus muted | Check the Audio panel at the bottom of the editor; check the OS mixer |
| Error `Identifier "Sfx" not declared` | The autoloads are not registered in this project | Project Settings > Globals > Autoload: add `SoundEngine/sfx.gd` as `Sfx` and `SoundEngine/beat_clock.gd` as `BeatClock` |
| Error `Could not find type "SynthPatch"` | Godot has not scanned the new scripts yet | Project > Reload Current Project |
| Quantized sounds play instantly | No music is running | Turn on the Music switch, or instance `Music.tscn` in the scene |
| Quantized sounds feel late or early | Audio latency differs per PC | Adjust `extra_lead_seconds` in `sfx.gd` |
| Sounds drift off the beat after the song loops | Loop file is not an exact number of bars, or beat 1 is not at sample 0 | Re-export; the lab's log line says how far off it is. For a lead-in, set `BeatClock.offset_seconds` |
| A song is missing from the Song dropdown | Wrong folder or extension, or the lab was open before you added it | A file must be `.ogg`, `.wav` or `.mp3` in `SoundEngine/Music`; a folder needs at least one numbered part. Press Reload |
| A part in a song folder is ignored | No number prefix | Name parts `1_calm.ogg`, `2_battle.ogg`, ... |
| Parts drift apart after a while | A part is not a whole number of bars | Re-export; every part loops on its own and only bar-exact loops stay aligned |
| Song plays at the wrong tempo | No `_128bpm` in the filename (assumed 120) | Rename the file and press Reload |
| A sound stops abruptly when many play | Pool is full | Raise `pool_size_2d` or `pool_size_3d` |
| Edited `sfx_palette.gd` but nothing changed | The file was not saved (Ctrl+S), or the lab was not reloaded | Save, then press Reload patches |
| Reload patches changed nothing and the Output panel says the palette "does not compile right now" | A typo in `sfx_palette.gd` | Fix the line Godot underlines in red, save, reload. The lab keeps the last good version until then |
| Every sound suddenly sounds filtered, far away or pitched | A condition override is set (the lab's Condition dropdown, or `Sfx.condition_override` in code) | Set the dropdown back to "None" or clear the override |
| Edited `condition_palette.gd` but nothing changed | The file was not saved, or the lab was not reloaded | Save, then press Reload conditions |
| A file sound ignores a material condition's character | Audio files only get the bus effects, not the synth knob overrides | Add stronger `effects` to that condition, or export material-specific files |
| A looping sound has a silent gap at the end of each pass | Older render: echo tail was inside the loop region | Fixed; the tail now folds back onto the loop start. Press Reload patches |
| A looping sound will not stop | Loops play until stopped | Press Stop all sounds (or Escape) in a lab; in the game, call `Sfx.stop_all()` or use your own player for loops |
| Save numbering says a file already exists | Two parts would get the same filename after renaming | Give them different names or numbers; two parts may share a number only if their names differ |
| After Save numbering a renamed audio part is silent | The editor has not re-imported the renamed file yet | Reload songs once Godot finishes its scan (a moment), or click the editor window to trigger it |
| A sound clicks or crackles | Three known causes, all handled: a waveform starting away from zero (declick fades), a busy player being cut to reuse it (idle players are picked first; raise `pool_size_2d` / `pool_size_3d` if many sounds overlap), several loud sounds summing past full scale (hard limiter on the SFX bus) | If it still happens, note which sound and condition; a `drive` plus positive `volume_db` can also be the culprit |
| Yellow warnings in the Script editor | With default project settings the SoundEngine scripts produce none. Warnings about inferred types, discarded return values or unsafe calls only appear if someone turned those optional checks on in Project Settings > Debug > GDScript | Safe to ignore, or turn the optional checks back off |
| Red "Failed to instantiate an autoload" / "Unrecognized UID" on first open | An autoload registered by `uid://` cannot resolve until the editor has rescanned the project, typically right after pulling a branch that added the script | Register autoloads by `res://` path (done for Globals). Reopening the project also clears it |
| A sound is distorted | `drive` plus loud `volume_db` | Lower `volume_db`; `normalize` keeps peaks at 90 percent before volume |
| A sound played in the first seconds stutters once | It was rendered on the spot because the background warm-up had not reached it yet | Expected; only happens once per sound per run |

---

## 10. Glossary

- **Autoload**: a script Godot loads once at startup and keeps alive for the whole game, reachable
  from any script by name. `Sfx` and `BeatClock` are autoloads.
- **Resource**: Godot's type for a bundle of settings. `SynthPatch` and `SfxCondition` are
  resources; the palettes build them in code.
- **Sample**: one number describing the speaker position at one instant. 44100 of them per second.
- **Oscillator**: something that produces a repeating wave at a pitch.
- **Envelope**: how a value (usually loudness) changes over the life of a sound. ADSR = attack,
  decay, sustain, release.
- **Filter**: removes some frequencies. Low-pass keeps the lows, high-pass keeps the highs.
- **Cutoff**: the frequency where a filter starts cutting.
- **FM**: one oscillator wobbling another's pitch very fast, which makes new overtones.
- **Semitone**: the smallest step on a piano. 12 per octave. Pitch knobs here use semitones so
  that "+7" is always a musical fifth regardless of the base pitch.
- **Quantize**: delay something until the next grid line of the beat.
- **Bus**: a mixer channel in Godot's Audio panel. Sounds here go to `SFX`, music to `Music`.
- **Latency**: the delay between asking for a sound and hearing it, from hardware buffering.
# Sound-Engine
