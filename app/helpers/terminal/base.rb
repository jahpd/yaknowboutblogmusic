require "#{File.dirname(__FILE__)}/../ace/base"

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
        :exec => AceHelper::Base::BASE_CLEAR,
        :help => "stop coffeed gibberish.js audio machine!"
      },
      :run => {
        :exec => AceHelper::Base::BASE_RUN,
        :help => "run coffeed gibberish.js audio machine!"
      },
      :offset => {
        "\n    " => [:clear, :exit, :id, :stop, :run]
      }
    }

  end

end
