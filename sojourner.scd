// == SERVER ==
s = Server.local; s.boot; // BOOT
s.quit;                   // QUIT (PANIC) C-c C-p q
s.recorder

// == SYNTHS ==
(
SynthDef(\arpeggiator, {|outBus, inBus, mul, add|
    /*
    Arp:
    - on/off b
    - hold b
    - mode b
    - range
    - rate
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\lfo, {|outBus, inBus, mul, add|
    /*
    LFO:
    - rate
    - delay
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\carrier, {|outBus, inBus, mul, add|
    /*
    Carrier:
    - range b
    - freq mod
    - freq mod lfo/env1 b
    - additive/FM b
    - suboscillator
    - feedback
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\hpf, {|outBus, inBus, mul, add|
    /*
    HPF:
    - freq
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\modulator, {|outBus, inBus, mul, add|
    /*
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
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\vca, {|outBus, inBus, mul, add|
    /*
    VCA:
    - env1/gate b
    - level
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\env, {|outBus, inBus, mul, add|
    /*
    Env 1 & 2:
    - sustain b
    - attack
    - decay/release
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\chorus, {|outBus, inBus, mul, add|
    /*
    Chorus:
    - on/off b
    - I/II/I&II
    */
    var src;
    src = In.ar(inBus, 2); // stereo fx
    Out.ar(outBus, src);
}).add;

SynthDef(\reverb, {|outBus, inBus, mul, add|
    /*
    Reverb:
    - on/off b
    - room/plate/hall
    */
    var src;
    src = In.ar(inBus, 2); // stereo fx
    16.do({ src = AllpassC.ar(src, 0.04, Rand(0.001,0.04), 3)});
    Out.ar(outBus, src);
}).add;
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

    Reverb:
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