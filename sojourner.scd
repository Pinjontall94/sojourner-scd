// == SERVER ==
s = Server.local; s.boot; // BOOT
s.quit;                   // QUIT (PANIC) C-c C-p q
s.recorder

// == SYNTHS ==
(
SynthDef(\decaySinEx, {|outBus = 0, effectBus, mix = 0.5, freq = 220|
    var src;
    src = Pan2.ar(Decay2.ar(Impulse.ar(Rand(0.3, 1), 0, 0.125), 0.3, 1,
        SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq))), Rand(-1.0, 1.0));
    Out.ar(outBus, src * mix);
    Out.ar(effectBus, src * (1 - mix));
}).add;

SynthDef(\reverbEx, {|outBus = 0, inBus|
    var input;
    input = In.ar(inBus, 2);
    16.do({ input = AllpassC.ar(input, 0.04, Rand(0.001,0.04), 3)});
    Out.ar(outBus, input);
}).add;

SynthDef(\carrier, {}).add;
SynthDef(\modulator, {}).add;
SynthDef(\env, {}).add;
SynthDef(\lfo, {}).add;
SynthDef(\chorus, {}).add;
SynthDef(\reverb, {}).add;
SynthDef(\arp, {}).add;
)


// == ROUTING ==
(
~sources = Group.new;
~effects = Group.after(~sources);     // make sure it's after
~bus = Bus.audio(s, 2);         // this will be our stereo effects bus
)


// == PERFORMANCE ==
(
x = Synth(\reverbEx, [\inBus, ~bus], ~effects);
y = Synth(\decaySinEx, [\effectBus, ~bus, \outBus, 0], ~sources);
z = Synth(\decaySinEx, [\effectBus, ~bus, \outBus, 0, \freq, 660], ~sources);
)

// == PARAMS ==
/*
Arp:
    - on/off b
    - hold b
    - mode b
    - range
    - rate

LFO:
    - rate
    - delay

Carrier:
    - range b
    - freq mod
    - freq mod lfo/env1 b
    - additive/FM b
    - suboscillator
    - feedback

HPF:
    - freq

Modulator:
    - level
    - ratio (0-7x)
    - detune
    - detune lfo/manual/env2 b
    - env2
    - env2 polarity (+/-)
    - env2 freq/both/level
    - velocity (amt on level)
    - lfo (amt on level)
    - keyboard (amt on level)

VCA:
    - env1/gate b
    - level

Env 1 & 2:
    - sustain b
    - attack
    - decay/release

Chorus:
    - on/off b
    - I/II/I&II

Rever:
    - on/off b
    - room/plate/hall

Memory:
    - bank 1-8
    - patch 1-8
    - write
    - manual
*/

~sources.free; ~effects.free; // Turn off sources and effects
~bus.free;                    // Unplug the cables