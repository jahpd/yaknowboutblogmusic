# ---
# gac is acronym for gibberish audio client
# ---
# 
# # Style code:
# 
# every method needs a callback;
#
#     func = (args..., callback) -> # code
# 
gac = 
  # wow... auto-answered ;)
  initialized: false

  # cleans if  gac.initialized is true
  # used with init method
  clean: (callback) ->
    console.log 'Operating cleaning...'
    if gac.initialized
      Gibberish.clear()
      gac.initialized = false
    callback(not gac.initialized)

  # Initialize Gibberish; takes the default
  # form:
  # 
  # - Gibberish.init()
  # 
  # - Gibberish.Time.export()
  # 
  # - Gibberish.Binops.export()
  init: (callback) ->
    console.log 'initializing Gibberish Audio Client'
    try 
      Gibberish.init()
      Gibberish.Time.export()
      Gibberish.Binops.export()
      gac.initialized = true
      if callback then callback gac.initialized
    catch e
      callback e

  # Execute; this method needs a more secure aproach;
  # maybe $.ajax or socket.io
  execute: (compile, data, callback) ->
    try
      # Unsecure mode: running CoffeeScript client
      js = unescape(data)
      js = compile js, bare:true, map:{}
      js = unescape js
      if callback then callback !js, js
      # TODO Run ajax requesting, compiling on server
      # and return the js code
    catch e
      callback true, "#{compile.prototype.name}:\n#{js.map}#{e}"

  # Runs the code   
  run: (callback)->
    console.log 'Operating compilation...'
    gac.execute CoffeeScript.compile, window.editor.getValue(), (err, js) -> if callback then callback(err, js) else eval(err, eval(js))

  # this is helper code to check arguments in user code
  checkfloats: (k, v)->
    b = false
    for t in ['freq', 'amp', 'pulsewidth', 'chance', 'pitchMin', 'pitchMax', 'pitchChance', 'cutoff', 'Q', 'roomSize', 'dry', 'wet']
      if (typeof(v) is 'object') and k == t
        b = true
        break
    b

  # this is helper code to check arguments in user code
  checkints: (k, v)->
    b = false
    for t in ['mode', 'rate', 'amount']
      if (typeof(v) is 'object') and k == t
        b = true
        break
    b
    
# As funções abaixo são apenas para serem utilizadas
# dentro do ambiente dado pela função `eval()` durante
# o processo do JIT
  
# Após inicializar, limpe, re-inicie o servidor de audio e execute a função
# dada pelo usuario depois de um tempo determinado
window.INIT = (time, callback) -> 
  setTimeout ->
    gac.clean (cleaned) ->
      gac.init (initialized)->
        callback cleaned and initialized
  , time

# Um gerador de audio
# 
#    sinG = new Gibberish.Sine(445, 0.71)
#    sin = window.GEN "Sine", amp:440, freq: 0.71 # similar ao anterior
#    sinG.connect()  
#    sin.connect()
window.GEN = (n, o, c) ->
  try
    u = new Gibberish[n]
    console.log "#{u} #{n}:"
    (console.log "  #{k}:#{v}" ; u[k] = v) for k, v of o
    if c then c u else u
  catch e
    alert e

# Um gerador de audio, mas com valores randomicos; é interessante notar que
# se você quiser um número randômico, forneça um Array de dois valores; se você
# não quiser, deixe como quiser
#
#    sinG = new Gibberish.Sine(Gibberish.rndf(440, 445), 0.71)
#    sin = GEN_RANDOM "Sine", amp: 0.71, freq: [440, 445] # similar ao anterior
#    sinG.connect()  
#    sin.connect()
window.GEN_RAND = (n, o, c) ->
  for k, v of o
    if gac.checkfloats(k, v)
      o[k] = Gibberish.rndf v[0], v[v.length-1] 
    else if gac.checkints(k, v)
      o[k] = Gibberish.rndi v[0], v[v.length-1]
    else
      o[k] = v     
  window.GEN n, o, c

# Um gerador de audio, mas com valores dados por uma função; é interessante notar que
# se você quiser um número algoritico, forneça uma função geradora que retorne um
# objeto (Hash) com as propriedades necessárias para a Unidade geradora de audio; se você
# não quiser, deixe como quiser
# 
#    freq = Gibberish.rndf(440, 445)
#    amp = 1/o.freq 
#    sinG = new Gibberish.Sine(freq, amp)
#    sin = GEN_FN "Sine", freq: -> Gibberish.rndf(440, 445), amp: (freq)-> 1/freq
#    sinG.connect()  
#    sin.connect()
window.GEN_FN = (n, o, c) ->
  for k, v of o
    if (typeof(v) is 'Function') 
      o[k] = v()
  window.GEN n, o, c

# Um simples sequenciador, onde se passa funções geradoras de arrays;
# Aqui se nota um processo de composição algoritimica, onde passsa-se qualquer
# função geradora de uma série de valores numericos
#
#    GEN_SEQ 
#      target: karplus
#      durations: ->
#        min = Gibberish.rndi(30, 500)
#        max = Gibberish.rndi(970, 1100)
#        [ms(min)..ms(max)]
#      keysAndValues:
#        note: ->
#          a = []
#          a[i] = Math.pow(2, i+8) for i in [0..7]
#          a[Gibberish.rndi(0, a.length-1)] for i in [0..21]
#        amp: ->
#          a = []
#          a[i] = Math.pow(2, i+8) for i in [0..7]
#          a[Gibberish.rndi(0, a.length-1)]/16384 for i in [0..13]
window.GEN_SEQ = (o, c) ->
  o.keysAndValues[k] = v() for k, v of o.keysAndValues 
  o.durations = o.durations()
  u = new Gibberish.Sequencer(o)
  if c then c u else u
