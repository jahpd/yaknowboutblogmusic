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

execute = (url)->
  $.getJSON url, (json) ->
    (new Function json['callback'])()
    window.update()

compress = (data, fn) ->
  url = changecurrenturl 'hear', 'compile'
  LZMA.compress data, 1, (result) ->
    compressed = ""
    compressed += s for s in window.convert_to_formated_hex(result).split(" ")
    url += "?c=#{compressed}"
    fn url
    
changecurrenturl = (a, b) ->
  terminal.type "requesting server..."
  terminal.newLine()
  url = document.URL.replace(a, b)
  url.split("?c=")[0]

window.update = null

window.stop = -> execute changecurrenturl 'hear', 'stop'
  
window.run = (data) -> compress data, (url) -> execute url
            
          
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
