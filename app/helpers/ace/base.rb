module AceHelper
  
  module Base
   
   AUDIO_CLIENT = [
     'gibberish_2.0',
     'gac-0.0.1'
   ]

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
    
    protected

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

    COMMENT_MESSAGE = """
                       # ======================================================================================
                       # Hi, this is an ace editor                        
                       # 
                       # All previous posts in index page
                       # show a way to use coffee-script language
                       # See old ones if you do not know anything
                       #                  
                       # You can use coffee-script here to change the above code           11       A 
                       # Think in a way to make music                                     111       A
                       # When done, you can use hotkeys to render or stop music:         111        A
                       # - Render audio:                                                111        AA
                       #   - Mac: Command + Enter                                        1         AAA
                       #   - Linux / Windows: Ctrl + Enter                               1        AA AA  
                       # - Stop audio:                                                   1       AA   AA
                       #   - Mac: Command + .                                            1      AAAAAAAAA
                       #   - Linux / Window: Ctrl + .                                    1     AA       AA
                       #                                                                01    AAA       AAA
                       # If you find any issue, please contact me in:                  0 0   AAAAAAAAAAAAAAA
                       # https://github.com/jahpd/yaknowboutblogmusic/issues           0 0  AAA           AAA        
                       #                                                                0
                       # If you want to contribute with any code, fork it!    
                       #
                       # If you want to reply, some sugestion, critic  
                       # send email for xxx@yyyy.zzz                                                
                       # Happy live-coding!
                       # (DESTROY ME AND USE EDITOR!)
                       # ======================================================================================
    """
   
  end
end
