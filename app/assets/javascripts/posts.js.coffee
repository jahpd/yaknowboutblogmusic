# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# SOCKET.IO

# this is helper code to check arguments in audio user code
checkfloats= (k, v)->
    b = false
    for t in ['freq', 'amp', 'pulsewidth', 'chance', 'pitchMin', 'pitchMax', 'pitchChance', 'cutoff', 'Q', 'roomSize', 'dry', 'wet']
      if (typeof(v) is 'object') and k == t
        b = true
        break
    b

checkUGEN = (ugen) ->
    b = false
    for t in ["sine", "sine2", "saw", "saw2", "triangle", "triangle2", "pwm", "SVF", "reverb"]
      if typeof(ugen) is 'object' and ugen.name == t
        b = true
        break
    b
      
# this is helper code to check arguments in audio user code
checkints = (k, v)->
    b = false
    for t in ['mode', 'rate', 'amount']
      if (typeof(v) is 'object') and k == t
        b = true
        break
    b

window.run = (data, callback) ->
  $(document).ready ->
      terminal.type "#{Date.now()}: Compiling"
      terminal.newLine()
      try
        ### following http://24ways.org/2005/dont-be-eval/ ###
        terminal.type "requesting server..."
        terminal.newLine()
        url = document.URL.replace('hear', 'compile')
        url = url.split("?c=")[0]
        terminal.type "Compressing code ..."
        terminal.newLine()
        LZMA.compress data,1, (result) ->
          compressed = ""
          compressed += s for s in window.convert_to_formated_hex(result).split(" ")
          url += "?c=#{compressed}"
          $.getJSON url, (json) ->
            terminal.type "Compiled at #{json['done']}"
            terminal.newLine();
            terminal.type "Executing ..."
            Gibber.init()
            callback !json['callback'], json['callback']
            terminal.newLine()
            terminal.prompt()
            
      catch e
        terminal.type "#{e.stack}"
        terminal.newLine()
        terminal.prompt()

window.exec = null
        
window.stop = (callback) ->
  $(document).ready ->
      terminal.type "#{Date.now()}: Cleaning"
      terminal.newLine()
      try
        ### following http://24ways.org/2005/dont-be-eval/ ###
        terminal.type "requesting server..."
        terminal.newLine()
        url = document.URL.replace('hear', 'compile')
        url = url.split("?c=")[0]
        terminal.type "Stopping code ..."
        terminal.newLine()
        LZMA.compress "Gibber.clear(); null", 1, (result) ->
          compressed = ""
          compressed += s for s in window.convert_to_formated_hex(result).split(" ")
          url += "?c=#{compressed}"
          $.getJSON url, (json) ->
            callback !json['callback'], json['callback']
            terminal.type "Stopped at #{json['done']}"
            terminal.newLine()
            terminal.prompt()
            
      catch e
        terminal.type "#{e.stack}"
        terminal.newLine()
        terminal.prompt()

window.rndf = Gibber.Audio.Core.Rndf()
window.rndi = Gibber.Audio.Core.Rndi()

window.RAND = (name, o, callback) ->
  for k, v of o
    if checkfloats(k, v)
      o[k] = rndf v[0], v[v.length-1] 
    else if checkints(k, v)
      o[k] = rndi v[0], v[v.length-1]
    else
      o[k] = v
  ugen = Gibber.Audio.Oscillators[name] o
  if callback then callback ugen else ugen

