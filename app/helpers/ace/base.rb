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
     "worker-#{MODE}"
    ]
    
    protected

    BASE_RUN =  "gac.run (err, js) -> if not err then window.terminal.print 'render: DONE' else t.print err\n"
    BASE_CLEAR = "gac.clean (err, js) -> if not err then window.terminalr.print 'stop: DONE' else t.print err\n"

    RENDER_OPTIONS = {
      :lang => MODE,                       # The running-language of web-application
      :theme => THEME,                     # Initial theme to Ace editor
      :commands => {                       # Commands Of Ace editor, please use CoffeeScript syntax
        :render => {
          :bindKeys => "win: 'Ctrl-Enter', linux: 'Ctrl-Enter', mac: 'Ctrl-R'",
          :exec => "(e) ->\n  #{BASE_RUN}"
        },
        :stop => {
          :bindKeys => "win: 'Ctrl-.', linux: 'Ctrl-.', mac: 'Command-S'",
          :exec => "(e) ->\n  #{BASE_CLEAR}"
        }
      },
      :buttons => {
        :render =>"$('#render').click (e)->\n  #{BASE_RUN}",
        :stop => "$('#stop').click (e)->\n  #{BASE_CLEAR}"
      }
    }

    COMMENT_MESSAGE = """
                       # ======================================================================================
                       # Hi, this is an ace editor integrated with terminal                    
                       # 
                       # All previous posts in index page                                     
                       # show a way to use coffee-script language                           \/ \\
                       # See old ones if you do not know anything                          \/   \\
                       #                                                                  \/_____\\
                       # You can use coffee-script here to change the above code         \/       \\
                       # Think in a way to make music                                   \/         \\
                       # When done, you can use hotkeys to render or stop music:        ------------            
                       # - Render audio:                                               a            A
                       #   - Mac: Command + Enter                                     aaa          AAA
                       #   - Linux / Windows: Ctrl + Enter                           aa aa        AA AA  
                       # - Stop audio:                                              aa   aa      AA   AA
                       #   - Mac: Command + .                                      aaa   aaa    AAA   AAA
                       #   - Linux / Window: Ctrl + .                             aa       aa  AA       AA
                       #                                                          AA       AA  aa       aa
                       # Or you can use 'render' or 'stop' commands               AA       AA  aa       aa
                       # Above you (buttons) or type them in terminal            aaaaaaaaaaaaaAAAAAAAAAAAAA   
                       # If you find any issue, please contact me in:            AAAAAAAAAAAAAaaaaaaaaaaaaa 
                       #                                                        aaaaaaaaaaaaaAAAAAAAAAAAAAAA
                       # https://github.com/jahpd/yaknowboutblogmusic/issues   aaa          aAA           AAA        
                       #                                                      aaaaa        aaAAA         AAAAA
                       # If you want to contribute with any code, fork it!   aaaaaaa      aaaAAAA       AAAAAAA
                       #
                       # If you want to reply, some sugestion, critic  
                       # send email for xxx@yyyy.zzz  
                       # or join irc.freenode.net #labmacambira
                       #                                              
                       # Happy live-coding!
                       # (DESTROY ME AND USE EDITOR!)
                       # ======================================================================================\n"""
  end
end
