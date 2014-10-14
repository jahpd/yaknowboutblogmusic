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
{title:"Hello World I", doc: """#Hello World!

this is a default post write with [Markdown](). If you want learn all, see the link;
some notes about coding.

In future I will add some more notes
""" },
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

    a = Synth().note.seq [0], 4
    b = Synth().note.seq [0, 1], 3
    c = Synth().note.seq [0, 1, 2], 2
    d = Synth().note.seq [0, 1, 2, 3], 1

"""},
{title: "Add envelop to your synth", doc: """

As charlie [say](http://bigbadotis.gitbooks.io/gibber-user-manual/content/chapters/audio_synthesizers.html), you can change synth's envelop. You have 3 ways to do this:

#### First

A simple attack and decay sound; the sound will be heard as string instrument:

    a = Synth attack: ms(1), decay: 1/2
    a.note.seq [0, 2, 4, 6, 8, 10, 12], 1/2

### Second 

An attack-decay-sustain-release (ADSR) pattern; this is a generalization about instrument's beheaviour like piano:

    a = Synth
      useADSR:true,
      requireReleaseTrigger:false,
      attack: ms 1, 
      decay: ms 50,
      sustain: ms 500, 
      release: ms 50
    a.note.seq [0, 1/2, 1, 3/2, 2, 5/2, 3, 7/2, 4], 1
    
"""},
{title:"Some music to dance", doc: """##Default code to Gibber.lib.js

The original code can be found in [Gibber environment](http://gibber.mat.ucsb.edu/#), so this is a modification to us; it's a simple delay system with some drum pattern as input. A complete explanation about this system can be found [here](http://www.dspguide.com/ch7/1.htm), but summarizing, this is a shift delta function described above:

![http://www.dspguide.com/graphics/F_7_1.gif](delay)

    a = Drums('x*o*x*o-')
    a.pitch = 60

    b = FM attack:  ms(1000), index: a.Out, cmRatio: 0.5

    b.fx.add Delay time: ms(30), feedback: 0.5

    b.play 'c2','d2','e2','g4','a4'].random(),
      [1, 1/2, 1/4,1/8,1/16].random(1/16,2) 

You can hear the effects changing as we move the mouse?
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
