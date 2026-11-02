# Drop sound-effect files here

Any `.wav`, `.ogg` or `.mp3` in this folder becomes a sound you can play exactly like a synth
one, with the same quantize, 3D positioning and anti-spam rules:

```
Samples/cannon_boom.wav        ->  Sfx.play(&"cannon_boom")
Samples/wood_hit_1.wav
Samples/wood_hit_2.wav         ->  Sfx.play(&"wood_hit")   picks one at random each time
Samples/wood_hit_3.wav
```

A file whose name matches a sound replaces it, so `p_cast_fire.wav` here overrides the
preset `p_cast_fire` everywhere in the game without touching any code.

Export checklist, since the engine plays files as-is:

- Trim leading silence to zero; the beat grid fires at the first sample.
- Peak around -6 dBFS so files sit at the same level as the synth sounds.
- Mono for anything that will be positioned in 3D (stereo files are mixed down).
- WAV for short one-shots, OGG for anything over a couple of seconds.
- Tails are fine; they only cost memory. Fade the last 10 ms so there is no click at the end.

See `../README.md` section 4.3.
