module AceHelper
  
  module Base
    
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper
   
    def hook_gibberails
      "#{active_script(:RAILS)}\nconsole.log 'audio library loaded!'\n"
    end

    def hook_post_code(post)
      if post.code
        src = "editor.setValue '#{escape_javascript(post.code)}'\n"
        src << "console.log 'post #{post.id} script embeeded to editor!'\n"
      end
    end

    def hook_editor(post, lang, theme)
      src= "window.editor = editor =  ace.edit('#{post.id}_#{lang}_editor')\n"
      src << "editor.setTheme 'ace/theme/#{theme}'\n"
      src << "editor.getSession().setMode 'ace/mode/#{lang}'\n"
      src << "console.log 'Ace editor loaded!'\n"""
    end

    def hook_commands(post, commands)
      src = ""
      commands.each{|k, v|
        src << "editor.commands.addCommand\n"
        src << "  name: '#{k}_#{post.id}'\n"
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
