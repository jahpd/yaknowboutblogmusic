module Syntax
 
  module Markdown
    OPTIONS = {
      no_intra_emphasis:   true,
      tables:              true,
      fenced_code_blocks:  true,
      autolink:            true,
      strikethrough:       true,
      space_after_headers: true,
      superscript:         true,
      filter_html:         true,
      hard_wrap:           true, 
      link_attributes:     { rel: 'nofollow', target: "_blank" },
      space_after_headers: true
    }
    
    RENDERER = Redcarpet::Render::HTML.new(OPTIONS)
  end

  module CoffeeScript
    LEXER = "coffee-script"
    OPTIONS =  {linenos: :table, linespans: 'line'}
  end

end
