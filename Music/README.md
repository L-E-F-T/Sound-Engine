# Drop songs here

**One file = one-part song.** Put the tempo in the name:

```
space_wizard_128bpm.ogg          128 BPM, 4/4
boss_fight_140bpm_3-4.ogg        140 BPM, 3 beats per bar
```

**One folder = adaptive song.** Name the folder like a song file and number the parts in the
order they come in. Audio parts are "versions" that replace each other; `.pattern` parts are
synth "layers" that stack on top:

```
space_wizard_128bpm/
    1_calm.ogg            planning phase
    2_battle.ogg          real-time phase
    3_arp.pattern         synth layer that joins as the goal nears
    4_final.ogg           last stretch
```

All parts start together and loop in sync; the game picks the level and the change lands on the
next bar. Export every part from the same session: same tempo, same key, beat 1 at the first
sample, an exact number of bars. OGG is the best format. Looping is switched on automatically.
A `.pattern` file is a few lines of text (see `../README.md` section 7.4 for the format).
