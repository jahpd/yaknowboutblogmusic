# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
i = 0

[
{title:"Hello World!", doc: """
_Hello world_ is a term used in all pedagogic efforts to write any program.  Here, any program will be a music; but first let's try something basic, as return a message to us:

### Write on Ace the command `terminal.type('Hello World!')`:

[Ace](http://ace.c9.io/#nav=about) is the editor used to write programs;

    terminal.type 'Hello World!'

### Type run on Terminal

[Termlib.js](http://www.masswerk.at/termlib/) is a terminal emulator used to run and stop programs; type `help` to see all options, but now type `run`""" },
{title: "Simple Synth", doc:"""This is a simple synthesizer described [here](http://bigbadotis.gitbooks.io/gibber-user-manual/content/chapters/audio_synthesizers.html); you give a set of notes (let's say 1) and then give a rythm for it (let's say whole note):

    Synth().note.seq [0], 4

You can add more Synths if you want:

    a = Synth().note.seq [0], 4
    b = Synth().note.seq [0, 1], 3

Let's try add another one?

    a = Synth().note.seq [0], 4
    b = Synth().note.seq [0, 1], 3
    c = Synth().note.seq [0, 1, 2], 2

What you will hear if you add more and more?

    a = Synth().note.seq [0], 55
    b = Synth().note.seq [0, 1], 34
    c = Synth().note.seq [0, 1, 2], 21
    d = Synth().note.seq [0, 1, 2, 3], 13
    g = Synth().note.seq [0, 1, 2, 3, 5, 8], 8
    h = Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 21, 34], 5
    i = Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 13, 8, 5, 3, 2, 1, 0], 3

"""},

{title: "Simple Synth", doc:"""This is a simple synthesizer described [here](http://bigbadotis.gitbooks.io/gibber-user-manual/content/chapters/audio_synthesizers.html); you give a set of notes (let's say 1) and then give a rythm for it (let's say whole note):

    Synth().note.seq [0], 4

You can add more Synths if you want:

    a = Synth().note.seq [0], 4
    b = Synth().note.seq [0, 1], 3

Let's try add another one?

    a = Synth().note.seq [0], 4
    b = Synth().note.seq [0, 1], 3
    c = Synth().note.seq [0, 1, 2], 2

What you will hear if you add more and more?

    Synth().note.seq [0], 55
    Synth().note.seq [0, 1], 34
    Synth().note.seq [0, 1, 2], 21
    Synth().note.seq [0, 1, 2, 3], 13
    Synth().note.seq [0, 1, 2, 3, 5, 8], 8
    Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 21, 34], 5
    Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 13, 8, 5, 3, 2, 1, 0], 3

"""},
{title: "Change the intensity of synth", doc: """

As you can hear, the previous post have some problems with volume: the sounds are too heavy in intensity ('volume') that some sound creates distortions.

Today, the majority of acoustic instruments have sound intensity dynamics, or in 'musician language', _pianissimos_ to _fortissimos_; with eletroacoustic media (our computers) can be manipulated like an instrument and you can change this with some property called *amplitude*; in some program language this will be called _amp_. So let's recreate our synths an give them some different amplitudes.

## The hard way

### Assign variables

You can call some synth with a name; this will be very helpfull, and then give to them amplitudes:

    a = Synth().note.seq [0], 55
    b = Synth().note.seq [0, 1], 34
    c = Synth().note.seq [0, 1, 2], 21
    d = Synth().note.seq [0, 1, 2, 3], 13
    e  =Synth().note.seq [0, 1, 2, 3, 5, 8], 8
    f = Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 21, 34], 5
    g = Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 13, 8, 5, 3, 2, 1, 0], 3
    a.amp = 1; b.amp = a.amp/2; c.amp = b.amp/2; d.amp = c.amp/2; e.amp = d.amp/2; f.amp = e.amp/2; g.amp = f.amp/2;

But this is very very repetitive way to write things; above we 

## The algorithimic way

We can say that every synth is a voice on some instrument called *synths* (that will be stored in something that we call _Array_). An _Array_ will be defined with *[ ]* brackets; you can _append_ to *synths* every synths you want (at least, until your computer have strenght to do this):

    synths = [
      Synth().note.seq [0], 55
      Synth().note.seq [0, 1], 34
      Synth().note.seq [0, 1, 0], 21
      Synth().note.seq [0, 1, 2, 1, 0], 13
      Synth().note.seq [0, 1, 2, 3, 3, 2, 1, 0], 5
      Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 8, 5, 3, 2, 1, 0], 3
      Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 0], 2
    ]
    
    for synth in synths
      if _i is 0
         synth.amp = 0.71
      else 
         synth.amp = synths[_i-1].amp/2 

This can be writed in one more simply way:

    synths = [
      Synth().note.seq [0], 55
      Synth().note.seq [0, 1], 34
      Synth().note.seq [0, 1, 0], 21
      Synth().note.seq [0, 1, 2, 1, 0], 13
      Synth().note.seq [0, 1, 2, 3, 3, 2, 1, 0], 5
      Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 8, 5, 3, 2, 1, 0], 3
      Synth().note.seq [0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 0], 2
    ]
    
    if _i is 0 then synth.amp = 0.71 else synth.amp = synths[_i-1].amp/2 for synth in synths

## Chalange

Can you simplify the way that synths will be writed?   
"""},
{title: "Change envelope of your synth", doc:"""Acoustic instruments have what musicians call a 'history of a sound', or more techncaly, an *envelope*. Envelope says to us: _I born, I change and someday I will cease to exist_; think in a one played note on piano or guitar: can we synthesize sounds like this?

    s = Synth useADSR: true
    s.note.seq [0,1,2,3], 1

Or in more specified way:

    s = Synth useADSR:true, requireReleaseTrigger:false, attack:ms 1, decay:ms 50, sustain: ms 500, release:ms 50
    s.note.seq [0,1,2,3], 3

Attack, Decay, Sustain and Release can be named as ADSR:

![imagem](http://midsiku.net/midsiku/adsr_envelope01.gif)

"""},
{title:"Lounge music", doc: """The original code can be found in [Gibber environment](http://gibber.mat.ucsb.edu/#), so this is a modification to us; it's a simple delay system with some drum pattern as input. A complete explanation about this system can be found [here](http://www.dspguide.com/ch7/1.htm), but summarizing, this is a shift delta function described above:

![delay](http://www.dspguide.com/graphics/F_7_1.gif)

    a = Drums('x*o*x*o-')
    a.pitch = 60

    b = FM attack:  ms(1000), index: a.Out, cmRatio: 0.75

    b.fx.add Delay time: ms(900), feedback: 0.75

    b.play ['c2', 'c#2', 'd#2','e2','f#4','g3', 'a2', 'a#2'].random(),
      [1, 1/2, 1/4,1/8,1/16].random(1/16,2) 


"""},
{title:"Some other experiment with delays ", doc:"""

    a = Drums('xoooooooox*-x')
    a.pitch = 33
    fm  = FM attack: ms 300, index: a.Out, cmRatio: 0.75

    delay =  900
    feedback = 1
    delays = 9
    for i in [2..delays+2]
      _ms = ms delay-((1/i)*delay)
      _fb = feedback * (1/i)
      fm.fx.add Delay time: _ms, feedback: _fb
  
    fm.play ['c2', 'c#2', 'd#2','e2','f#4','g3', 'a2', 'a#2'].random(),
      [1, 1/2, 1/4,1/8,1/16].random(1/16,2) 

"""}
].each{|e|
  e[:id] = i
  e[:author] = user.name
  post = Post.create(e)
  puts "CREATED POST: " << post.title
  i += 1
}

###
#karplus = GEN "KarplusStrong", 
#        blend: Add 0.95, RAND("Triangle", amp:0.05, freq:[0.1, 2])
#        damping: Add 0.95, RAND("Sine", amp:0.05, freq:[0.1, 2])
#
#    buffer = RAND "BufferShuffler",
#        input: karplus
#        chance:[.5, .99]
#        amount:[441, 44100]
#        rate:44100
#        pitchMin:[-12, -0.1]
#        pitchMax:[0.1, 12]

#    RAND "Reverb", 
#        input: buffer
#        roomSize: [0.1, 1]
#        wet:[0.75, 0.9]
#        dry:[0.5, 0.75]
#     , (g) -> g.connect()

#    SEQ 
#        target: karplus
#        durations: ->
#            min = Gibberish.rndi(30, 500)
#            max = Gibberish.rndi(970, 1100)
#            [ms(min)..ms(max)]
#        keysAndValues:
#            note: ->
#                a = []
#                a[i] = Math.pow(2, i+8) for i in [0..7]
#                a[Gibberish.rndi(0, a.length-1)] for i in [0..21]
#            amp: ->
#                a = []
#                a[i] = Math.pow(2, i+8) for i in [0..7]
#                a[Gibberish.rndi(0, a.length-1)]/16384 for i in [0..13]
###

###
#sine = RAND "Sine", 
#        amp: [0.25, 0.71]
#        freq: [100, 1000]

#    pwm = RAND "PWM",
#        amp: [0.25, 0.71]
#        freq: [100, 1000]
#        pulsewidth: [0.1, 0.9]

#    noise = GEN "Noise", 
#        amp: Add sine, pwm

#    buffer = RAND "BufferShuffler",
#        input: Mul noise, pwm
#        chance: [.45, 0.75]
#        amount: [44, 4410]
#        rate:44100
#        pitchMin:[-12, -1]
#        pitchMax:[1, 12]

#    svf =  RAND "SVF", 
#        input: Mul buffer, sine
#        cutoff: [200, 800]
#        Q: [0.1, 7]
#        mode:[0,3]

#    reverb = RAND "Reverb",
#        input: Mul svf, buffer
#        roomSize: [0.7, 1]
#        wet:[0.7, 1]
#        dry:[0.1, 0.5]
