module TerminalJS
  
  module Base
    DEFAULT_COLOR ="#3d31a2"
    DEFAULT_TEXT_COLOR = "#7c70da"
    TERM_COMMANDS = {
      :clear => {
        :exec =>"this.clear()",
        :help => "clear terminal"
      },
      :exit  => {
        :exec => "this.type('# By!', '#0FA')\n      this.close()",
        :help => "kill terminal"
      },
      :id => {
        :exec => "this.type this.id", 
        :help => "show terminal id"
      },
      :stop => {
        :exec => "gac.clear (err, js) -> if not err then this.type('# Gibberish.js stopped', '#0FA')",
        :help => "stop coffeed gibberish.js audio machine!"
      },
      :run => {
        :exec =>"gac.run (err, js) -> if not err then this.type('# Running gibberish.js', '#F00')",
        :help => "run coffeed gibberish.js audio machine!"
      },
      :offset => {
        "\n    " => [:clear, :exit, :id, :stop, :run, :ace]
      }
    }

  end

end
