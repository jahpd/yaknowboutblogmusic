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
window.gac = 
  # wow... auto-answered ;)
  initialized: false

  log: (msgs...) ->
    if window.terminal then terminal.newLine()
    if window.terminal then terminal.write msgs
    
  # cleans if  gac.initialized is true
  # used with init method
  clean: (callback) ->
    gac.log "#{Date.now()}: Cleaning"
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
    gac.log "#{Date.now()}: Initializing Gibberish"
    try 
      Gibberish.init()
      Gibberish.Time.export()
      Gibberish.Binops.export()
      gac.initialized = true
      if callback then callback()
    catch e
      if callback then callback e else gac.log e

  # Execute; this method needs a more secure aproach;
  # maybe $.ajax or socket.io
  execute: (compile, data, callback) ->
    gac.log "#{Date.now()}: Compiling"
    try
      # FIX Unsecure mode: running CoffeeScript client
      # TODO Try socket.io instead
      js = unescape(data)
      js = compile js, bare:true, map:{}
      js = unescape js
      callback !js, js
    catch e
      callback true, "#{compile.prototype.name}:\n#{js.map}\n#{e}"

  # Runs the code
  # example
  #
  #     gac.run (err, js) -> #Do something awesome  
  run: (callback)-> gac.execute CoffeeScript.compile, window.editor.getValue(), callback

  # this is helper code to check arguments in audio user code
  checkfloats: (k, v)->
    b = false
    for t in ['freq', 'amp', 'pulsewidth', 'chance', 'pitchMin', 'pitchMax', 'pitchChance', 'cutoff', 'Q', 'roomSize', 'dry', 'wet']
      if (typeof(v) is 'object') and k == t
        b = true
        break
    b

  checkUGEN: (ugen) ->
    b = false
    for t in ["sine", "sine2", "saw", "saw2", "triangle", "triangle2", "pwm", "SVF", "reverb"]
      if typeof(ugen) is 'object' and ugen.name == t
        b = true
        break
    b
      
  # this is helper code to check arguments in audio user code
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
  try
    gac.clean (cleaned) ->
      if cleaned
        setTimeout ->
          gac.init (error)->
            if error
              gac.log error.message
              gac.log error.stack
            else
              callback()
        , time
  catch e
    gac.log "!ERROR", "#{Date.now}: #{e}"
    
# Uma simples tarefa a ser executada apos
# um certo tempo, durante um certo tempo;
# util para estruturar secoes de uma musica
#
#   INIT 100, -> 
#     TASK 200, 1000, ->
#        GEN "Sine", amp: 0.71, freq: 440 
#     TASK 800, 1000, ->
#        GEN "Sine", amp: 0.35, freq: 880 
window.TASK = (time, dur,  callback) ->
  try
    setTimeout ->
      gac.log "#{Date.now()}: PLAY"
      ugen = callback()
      setTimeout ->
        gac.log "#{Date.now()}: STOP"
        if gac.checkUGEN ugen
          gac.clean()
        else
          ugen.stop()
      , dur
      if gac.checkUGEN ugen
        ugen.connect()
      else
        ugen.start()
    , time
  catch e
    gac.log "#{Date.now()}: #{e}"
    
# Um gerador de audio
# 
#    sinG = new Gibberish.Sine(445, 0.71)
#    sin = window.GEN "Sine", amp:440, freq: 0.71 # similar ao anterior
#    sinG.connect()  
#    sin.connect()
window.GEN = (n, o, c) ->
  try
    gac.log n
    gac.log "  #{k}: #{v}" for k, v of o
    u = new Gibberish[n]
    u[k] = v for k, v in o
    if c then c u else u
  catch e
    gac.log "!ERROR", "#{Date.now()}: #{e}"

# Um gerador de audio, mas com valores randomicos; é interessante notar que
# se você quiser um número randômico, forneça um Array de dois valores; se você
# não quiser, deixe como quiser
#
#    sinG = new Gibberish.Sine(Gibberish.rndf(440, 445), 0.71)
#    sin = GEN_RANDOM "Sine", amp: 0.71, freq: [440, 445] # similar ao anterior
#    sinG.connect()  
#    sin.connect()
window.RAND = (n, o, c) ->
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
#    sin = GEN_FN "Sine", freq: -> Gibberish.rndf(440, 445), amp: (freq)-> 1/freq
#    sinG.connect()  
#    sin.connect()
window.FN = (n, o, c) ->
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
window.SEQ = (o, c) ->
  o.keysAndValues[k] = v() for k, v of o.keysAndValues
  o.durations = o.durations()
  u = new Gibberish.Sequencer(o)
  gac.log "#{Date.now()}: #{o.keysAndValues}", "#{Date.now()}: #{o.durations}"
  if c then c u else u

# Some Patch
window[e] = Gibberish.Binops[e] for e in ["Add","Div", "Map", "Merge", "Mod", "Mul", "Pow", "Sqrt", "Sub"]

### following http://24ways.org/2005/dont-be-eval/ ###
window.eval_cs = ->
  $(document).ready ->
    gac.log "requesting server..."
    try
      url = document.URL.replace('hear', 'compress')
      url = url.split("?c=")[0]
      gac.log "compressing code..."
      window.LZMA.compress editor.getValue(), 1, (result) ->
        url += "?c=#{result}"
        $.getJSON url, (data) ->
          gac.log "compressed at #{data['compressed_at']}"
          url = url.replace('compress', 'compile')
          url = url.split("?c=")
          url += "?c="+data['lzma']
          $.getJSON url, (data) ->
            gac.log "verified at #{data['compiled_at']}"
            eval data['fn']
      , (percent) ->
        s = ['<','^','>','v']
        if window.terminal
          Terminal.newLine()
          Terminal.typeAt  "#{s[Math.floor(Math.Random()*4)]}"
    catch e
      gac.log "Error: #{e}\n See javascript console for more"
      console.log "#{e.stack}"
            
    
    
            
  ###
  $.ajax(
    url: url
    dataType: 'jsonp'
    crossDomain: true
    success: (data) ->
      gac.log "OK"
  ).done (data) ->
    
  ###
