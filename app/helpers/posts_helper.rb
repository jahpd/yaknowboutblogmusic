require "#{File.dirname(__FILE__)}/coffee_syntax"
require "#{File.dirname(__FILE__)}/ace/builder"
require "#{File.dirname(__FILE__)}/terminal/builder"
require 'lzma'

module PostsHelper

  include AceHelper::Builder
  include TerminalJS::Builder

  # Renders entire post to markdown in .erb views. 
  # It already highlight a custom mrkdown for codes
  # ---
  # FIXME
  # Needs a better parsing to allow any language
  # +++
  #
  # usage:: ```# assuming you already setted a post in controllers\n
  # <%= markdown_for @post ```
  # more_on:: http://richonrails.com/articles/rendering-markdown-with-redcarpet
  def markdown_for(post)
    markdown = Redcarpet::Markdown.new(Syntax::Markdown::RENDERER)
    html = markdown.render(post.doc)
    syntax_highlighter(html, post).html_safe
  end

  # Highlights code snippet and generate an appropriate 
  # Html element for code
  # This generate to a <a/> tag for edit/hear code
  # below highlight syntax
  # usage:: use only in helper
  def syntax_highlighter(html, post)
     # saves whole code and create a new html fragment
    doc = Nokogiri::HTML(html)

    # replace code with div
    # TODO kill empty <p/> 
    hear = []
    doc.css('code').each_with_index do |code, i|
      # Highlight text code
      code.replace Pygments.highlight code.text, :lexer => Syntax::CoffeeScript::LEXER, :options => Syntax::CoffeeScript::OPTIONS

      # now from code, generate an <a/> tag that redirect
      # to editor
      a =  Nokogiri::XML::Node.new "a", doc
      a.content = "Hear"

      # Now the code text needs to be encoded in Hex with LZMA
      lzma  = compress_for code.text
      a[:href] = "/posts/#{post.id}/hear?q=#{i}&c=#{lzma}"
      hear.push a
    end
    
    doc.css('.highlighttable').each_with_index do |table, i|
      table.add_next_sibling hear[i]
    end

    doc.to_s
  end


  # Decompress a chunk of code already compressed with
  # with compress_for method.
  # Compression occurs when we highlight code and generate a link for
  # it
  # usage:: ```
  # #=> In some controller
  # @code = params[:c]
  # #=> In view
  # <%= build_script decompress_for(@code) %>
  # ```
  def decompress_for(compressed_string)
    hex = [compressed_string].pack("H*")
    string = LZMA.decompress hex
    string
  end

  private

  # Creates an <h5/> HTML element, verifying if post was created in
  # that moment or was updated.
  def choice_created_or_updated_at_for(post)
    unless post.created_at == post.updated_at
      content_tag :h5, "Updated #{time_ago_in_words post.updated_at} ago"
    else
      content_tag :h5, "Published #{time_ago_in_words post.created_at} ago"
    end
  end

  # Compress a chunk of code (assuming this code is a real code) in
  # hexadecimal format to use as secure query parameter.
  # usage:: use inside this class with ```syntax_highlighter```
  def compress_for(text)
    lzma  = LZMA.compress text
    hex = lzma.unpack('H*')[0]
  end

end

