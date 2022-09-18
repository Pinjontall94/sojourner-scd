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

SynthDef(\carrier, {
    |outBus, inBus, modOscBus, lfoBus, envBus,
    mul, freq, freqMod, subMul|
    /*
    Carrier:
    - range b
    - freq mod
    - freq mod lfo/env1 b
    - additive/FM b
    - suboscillator
    - feedback

    inputs: kyb, arp, env1, lfo
    outputs: vca
    */
    var src, sub;
    src = SinOsc.ar();
    sub = SinOsc.ar();
    Out.ar(outBus, src);
}).add;

SynthDef(\hpf, {|outBus, inBus, freq|
    /*
    HPF:
    - freq
    */
    var src;
    src = In.ar(inBus, 1);
    src = HPF.ar(src, freq);
    Out.ar(outBus, src);
}).add;

SynthDef(\modulator, {
    |outBus, inBus, envBus, velBus, lfoBus, keyBus,
    mul, feedback, ratio, detune, env, vel, lfo, key|
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

    inputs: kyb, arp, env2, lfo, vel
    outputs: vca
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\vca, {|outBus, inBus, mul, add|
    /*
    VCA:
    - env1/gate b
    - velocity
    - level

    inputs: carrier; modulator
    outputs: fx bus; carrier
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

    inputs: kyb, arp
    outputs: vca1, vca2
    */
    var src;
    src = In.ar(inBus, 1);
    Out.ar(outBus, src);
}).add;

SynthDef(\chorus, {|outBus, inBus, mix, delayOffset, depth, rate|
    /*
    Chorus:
    - on/off b
    - I/II/I&II

    inputs: vca1
    outputs: reverb
    */
    var src;
    src = In.ar(inBus, 2); // stereo fx
    Out.ar(outBus, src);
}).add;

SynthDef(\reverb, {|outBus, inBus, mix, decay|
    /*
    Reverb:
    - on/off b
    - room/plate/hall

    inputs: chorus
    outputs: level
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

~mainBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);
~chorusBus = Bus.audio(s, 2);

~carrierBus = Bus.audio(s, 1);
~modBus = Bus.audio(s, 1);
~vca1Bus = Bus.audio(s, 1);
~vca2Bus = Bus.audio(s, 1);

~kybBus = Bus.control(s, 1);
~arpBus = Bus.control(s, 1);
~lfoBus = Bus.control(s, 1);
~env1Bus = Bus.control(s, 1);
~env2Bus = Bus.control(s, 1);
~velBus = Bus.control(s, 1);
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
    - detune (0-0.5x)
    - detune lfo/manual/env2 b
    - env2
    - env2 polarity (+/-)
    - env2 freq/both/level
    - velocity (amt on level)
    - lfo (amt on level)
    - keyboard (amt on level)

    VCA:
    - env1/gate b
    - velocity
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
(
~mainBus.free;
~reverbBus.free;
~chorusBus.free;

~carrierBus.free;
~modBus.free;
~vca1Bus.free;
~vca2Bus.free;

~kybBus.free;
~arpBus.free;
~lfoBus.free;
~env1Bus.free;
~env2Bus.free;
~velBus.free;
)