require 'open-uri'

module PostsHelper

  
  # view more on http://richonrails.com/articles/rendering-markdown-with-redcarpet
  def markdown_for(post)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true
    }
 
    extensions = {
      autolink:                     true,
      superscript:                  true,
      #disable_indented_code_blocks: true,
      #fenced_code_blocks:           true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    html = markdown.render(post.doc)
    syntax_highlighter(html).html_safe
  end

  def syntax_highlighter(html)
     # saves whole code and create a new html fragment
    doc = Nokogiri::HTML(html)

    # loop through all posts:
    # div.panel-body is where text located
    # copy text from <p><code/></p> and parse it
    # remove <p><code/></p>
    doc.css('code').each do |code|
      code.replace Pygments.highlight(code.text, :lexer => "coffee-script")
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
