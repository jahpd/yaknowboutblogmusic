require "#{File.dirname(__FILE__)}/base"

module AceHelper
  
  module Builder

    include AceHelper::Base
    
    AUDIO_CLIENT = 'gibberish_2.0'
    MODE = :coffee
    THEME = :monokai
    CLIENT_EVAL = 'coffee-script'
    AUDIO_EXTENSION = :RAILS
    EDITOR = [
      :ace,
      "theme-#{THEME}",
      "mode-#{MODE}",
      "worker-#{MODE}",
    ]
    RENDER_OPTIONS = {
      :lang => MODE,                       # The running-language of web-application
      :theme => THEME,                     # Initial theme to Ace editor
      :commands => {                       # Commands Of Ace editor, please use CoffeeScript syntax
        :render => {
          :bindKeys => "win: 'Ctrl-Enter', linux: 'Ctrl-Enter', mac: 'Command-Enter'",
          :exec => "exec: (e) -> RAILS.cleanAndCompile e, (js) -> eval js"
        },
        :stop => {
          :bindKeys => "win: 'Ctrl-.', linux: 'Ctrl-.', mac: 'Command-.'",
          :exec => "exec: (e) -> RAILS.clean -> console.log 'yay! cleaned!'"
        }
      }
    }
  end
end
