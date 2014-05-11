module PostsHelper

  # view more on http://richonrails.com/articles/rendering-markdown-with-redcarpet
  def markdown_for(post)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true, 
      fenced_code_blocks: true,
      gh_blockcode: true,
    }
 
    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    html = markdown.render(post.doc)
    syntax_highlighter(html).html_safe
  end

  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
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
