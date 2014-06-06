require "#{File.dirname(__FILE__)}/base"

module AceHelper
  
  module Builder

    include AceHelper::Base

    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper

    def yaknow_include_tags
      javascript_include_tag "gibberish_2.0.js", "coffee-script", "ace", "mode-coffee", "worker-coffee", "theme-monokai"
    end

    def create_ace_wrapper
      content_tag(:div, "", :id => "coffee_editor")
    end

    def hook_gibberails
      "#{active_script(:RAILS)}\nconsole.log 'audio library loaded!'\n"
    end

    def build_script(code_string)
      string = hook_gac()
      string << hook_editor(MODE, THEME)
      string << hook_ace_commands(RENDER_OPTIONS[:commands], "\n  ")
      string << hook_code(code_string)
      string << hook_buttons()
      string << hook_run()
      
      javascript_tag CoffeeScript.compile(string, :bare => true), {:id => "generated_script"}
    end

    protected

    def hook_gac
      active_script("gac-0.0.1")
    end

    def hook_editor(mode, theme)
      string  = "window.editor = editor = ace.edit('#{mode}_editor')\n"
      string << "editor.setTheme 'ace/theme/#{theme}'\n" 
      string << "editor.getSession().setMode 'ace/mode/#{mode}'\n"
      string << "console.log 'Ace editor loaded!: {mode: #{mode}, theme: #{theme} }'\n"
    end

    def hook_code(code_string)
      s = "#{COMMENT_MESSAGE}#{code_string}"
      string = "editor.setValue '#{escape_javascript(s)}'\n"
      string << "console.log 'code script embeeded to editor!'\n"
    end

    def hook_ace_commands(commands, offset)
      src = ""
      commands.each{|k, v|
        src << "editor.commands.addCommand#{offset}"
        src << "name: '#{k}'#{offset}"
        v.each_pair{|kk, vv| 
          src << "#{kk}: #{vv}#{offset}" 
        }
        src << "readOnly: true\n"
      }
      src << "console.log 'commands added to editor!'\n"
    end

    def hook_buttons
      src = ""
      RENDER_OPTIONS[:buttons].each{|k, v|
        src << "\n" << v
      }
      src
    end
   
    def hook_run
      "\ngac.run()"
    end

    private
      
      VENDOR = "../../../vendor"
      JAVASCRIPTS = "assets/javascripts/"
      FOLDER = "#{File.dirname(__FILE__)}/#{VENDOR}/#{JAVASCRIPTS}"

      def active_script(action)
        src = ""
        if File.exist? "#{FOLDER}/#{action}.js.coffee"
          File.open("#{FOLDER}/#{action}.js.coffee", "r").each_line { |line| src << line }
          src
        end
      end
  end
end
