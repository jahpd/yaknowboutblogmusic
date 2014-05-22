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

    def build_script(code)
      string = hook_editor()
      string << hook_post_script(code)
      string << hook_commands()
      javascript_tag CoffeeScript.compile(string, :bare => true)
    end

    protected

    def hook_post_script(code)
      src = "editor.setValue '#{escape_javascript(code)}'\n"
      src << "console.log 'code script embeeded to editor!'\n"
    end

    def hook_editor
      src= "window.editor = editor =  ace.edit('coffee_editor')\n"
      src << "editor.setTheme 'ace/theme/monokai'\n" 
      src << "editor.getSession().setMode 'ace/mode/coffee'\n"
      src << "console.log 'Ace editor loaded!'\n"""
    end

    def hook_commands
      src = ""
      RENDER_OPTIONS[:commands].each{|k, v|
        src << "editor.commands.addCommand\n"
        src << "  name: '#{k}'\n"
        v.each_pair{|kk, vv| 
          src << "  #{kk}: #{vv}\n" 
        }
        src << "  readOnly: true\n"
      }
      src << "console.log 'commands added to editor!'"
    end

    def hook_run
      "RAILS.run()"
    end

    private
      
      VENDOR = "../../../vendor"
      JAVASCRIPTS = "assets/javascripts/controllers/"
      FOLDER = "#{File.dirname(__FILE__)}/#{VENDOR}/#{JAVASCRIPTS}"

      def active_script(action)
        src = ""
        File.foreach("#{FOLDER}/#{action}.js.coffee") { |line| src << line }
        src
      end
  end
end
