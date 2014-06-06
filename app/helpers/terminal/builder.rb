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
      """window.terminal = term = new Terminal({
  rows: #{opt[:rows]}
  greeting: '# #{opt[:id]} terminal enabled'
  id: '_#{opt[:id]}'
  termDiv: 'term_#{opt[:id]}'
  crsrBlinkMode: true
  handler: ->
    this.newLine()
    cmd = this.lineBuffer#{opt[:commands]}
    this.prompt()
  exitHandler: -> if term.closed==true then term.close()
  textColor: '#00FF00'})
term.open()
term.focus()"""     
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
      logger.info{string}
      js = CoffeeScript.compile(string, :bare => true)
      script = javascript_tag(js, {:id => "_#{opt[:id]}"})
      wrapped = content_tag(:div, script, {:id => "term_#{opt[:id]}"})
      content_tag(:div, wrapped, {:class => 'term-wrap'})
    end

  end
end
