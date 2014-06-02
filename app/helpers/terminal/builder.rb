require "#{File.dirname(__FILE__)}/base"

module TerminalJS

  module Builder

    include TerminalJS::Base

    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper

    def terminal_include_tag
      javascript_include_tag "termlib"
    end

    def terminal_build(opt)
      string = "term = new Terminal({rows: #{opt[:rows]}, greeting: 'Coffee-sound Terminal; type help for info' ,id: 0 , termDiv: '#{opt[:id]}',crsrBlinkMode: true,handler: termHandler, exitHandler: termExitHandler, frameColor: '#00FF00'})\n"
      #string << "term.bgColor '#00FFAA'\n"
      string << "term.open()\n"
      string << "term.focus()\n"
      string << "termHandler = ->\n"
      string << "  this.newLine()\n"
      string << "  cmd=this.lineBuffer\n"
      string << "  if cmd=='clear' then this.clear()\n"
      string << "  if cmd=='exit' then this.close()\n"
      string << "  if cmd=='help'\n"
      string << "     this.write(['> Terminal Help',\n"
      string << "       'help ....... show this message'\n"
      string << "       '\n'])\n"
      string << "  if cmd=='id' then this.write(['terminal id: '+this.id])\n"
      string << "  if cmd=='stop'\n"
      string << "    gac.clear (err, js) ->\n"
      string << "      if not err\n"
      string << "        this.write ['stop: DONE']\n"
      string << "  if cmd=='render'\n"
      string << "      gac.run (err, js) ->\n"
      string << "        if not err\n"
      string << "          this.write ['render: DONE']\n"
      string << "        else\n"
      string << "          this.write [err]\n"
      string << "  this.prompt()\n"
      string << "termExitHandler = -> if term.closed==true then term.close()\n"
      js = javascript_tag(CoffeeScript.compile(string, :bare => true), {:id => "_#{opt[:id]}"})
      content_tag(:div, js, opt)
    end

  end
end
