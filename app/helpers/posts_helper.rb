require "#{File.dirname(__FILE__)}/coffee_syntax"
require "#{File.dirname(__FILE__)}/ace/builder"

module PostsHelper

  include AceHelper::Builder

  # view more on http://richonrails.com/articles/rendering-markdown-with-redcarpet
  def markdown_for(post)
    markdown = Redcarpet::Markdown.new(Syntax::Markdown::RENDERER)
    html = markdown.render(post.doc)
    syntax_highlighter(html, post).html_safe
  end

  def syntax_highlighter(html, post)
     # saves whole code and create a new html fragment
    doc = Nokogiri::HTML(html)

    # replace code with div
    # TODO kill empty <p/> 
    hear = []
    doc.css('code').each_with_index do |code, i|
      code.replace Pygments.highlight code.text, :lexer => Syntax::CoffeeScript::LEXER, :options => Syntax::CoffeeScript::OPTIONS
      a =  Nokogiri::XML::Node.new "a", doc
      a.content = "Hear"
      a[:href] = "/posts/#{post.id}/hear?q=#{i}&c=#{code.text}"
      hear.push a
    end
    
    doc.css('.highlighttable').each_with_index do |table, i|
      table.add_next_sibling hear[i]
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

  def yaknow_include_tags
    javascript_include_tag "gibberish_2.0.js", "coffee-script", "ace", "mode-coffee", "worker-coffee", "theme-monokai"
  end
  

end

