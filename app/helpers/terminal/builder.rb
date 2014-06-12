require "#{File.dirname(__FILE__)}/base"

module TerminalJS

  module Builder

    include TerminalJS::Base

    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper

    def terminal_include_tag
      javascript_include_tag "termlib"
    end

    def hook_terminal(opt)
      """term =  window.terminal = new Terminal({
  rows: #{opt[:rows]}
  ps: '$ > '
  greeting: \"#{opt[:id]} Terminal ready\"
  id: '_#{opt[:id]}'
  termDiv: 'term_#{opt[:id]}'
  crsrBlinkMode: true
  handler: ->
    this.newLine()
    cmd = this.lineBuffer#{opt[:commands]}
    this.prompt()
  exitHandler: -> if term.closed==true then term.close()
  textColor: '#00FF00'})

$('#term_#{opt[:id]}').hover((->
  TermGlobals.keylock = false
  term.focus()
), (-> 
  TermGlobals.setFocus false
))

$('#coffee_editor').hover((->
  TermGlobals.keylock = true
  window.editor.focus()
), (-> 
  window.editor.blur()
))

term.open()"""     
    end

    def hook_commands(commands)
      src = ""
      help = "this.write(["
      commands[:offset].each_pair{|k, v| 
        v.each{|e|
          commands.each_pair{|key, value|
            if key == e and  key != :offset
              src << "#{k}if cmd=='#{key}'#{k}  #{value[:exec]}"
              help << "'#{key} ... #{value[:help]}',"
            end
          }
        }
      }
      help << "])\n"
      src << "\n    if cmd=='help'\n        #{help}"
    end

    def terminal_build(opt)
      string =  hook_terminal({
        :rows => opt[:rows], 
        :id => opt[:id],
        :commands => hook_commands(TERM_COMMANDS)
      })
      js = CoffeeScript.compile(string, :bare => true)
      script = javascript_tag(js, {:id => "_#{opt[:id]}"})
      wrapped = content_tag(:div, script, {:id => "term_#{opt[:id]}"})
      content_tag(:div, wrapped, {:id => 'term-wrap'})
    end

  end
end
