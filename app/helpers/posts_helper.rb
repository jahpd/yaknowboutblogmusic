require 'open-uri'

module PostsHelper
  
  # view more on http://richonrails.com/articles/rendering-markdown-with-redcarpet
  def markdown_for(post)
    options = {
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
 
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer)
    html = markdown.render(post.doc)
    syntax_highlighter(html, :title => post.title).html_safe
  end

  def syntax_highlighter(html, options)
     # saves whole code and create a new html fragment
    doc = Nokogiri::HTML(html)

    # replace code with div
    # TODO kill empty <p/> 
    doc.css('code').each do |code|
      code.replace Pygments.highlight code.text, :lexer => "coffee-script", :options => {linenos: :table, linespans: 'line'}
    end
    
    doc.to_s
  end

  def choice_created_or_updated_at_for(post)
    unless post.created_at == post.updated_at
      content_tag :h5, "Updated #{time_ago_in_words post.updated_at} ago"
    else
      content_tag :h5, "Published #{time_ago_in_words post.created_at} ago"
    end
  end
end
