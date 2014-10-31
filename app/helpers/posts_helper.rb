dir = File.dirname(__FILE__)
require "#{dir}/coffee_syntax"
require 'lzma'
require 'ace/helper'
#require 'termlib/helper'

module PostsHelper

  include Ace::Helper::Builder
  include Termlib::Helper::Builder
  
  # A simple <div/> to wrap editor
  # to Ace
  def create_ace(src, opt)
    js = ace(src)
    content_tag(:div, js, :id => opt[:id])
  end

  
  # Creates <div/> to wrap
  # termlib.js
  def create_terminal(opt)
    js = termlib(opt)
    content_tag(:div, js, :id => opt[:id])
  end

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
      a[:href] = "/posts/#{post.id}/hear?c=#{lzma}"
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

  def decompress_for_a(compressed_array)
    hex = compressed_array.split(" ")
    hex.each{|e| e.to_i}
    hex = hex.pack("H*")
    puts hex
    string = LZMA.decompress hex
    string
  end

  # Include all necessary scripts
  # You can choice your ace theme:
  #
  # - Default: 
  #
  #     <%= coffeesound_js_tags :theme => :monokai %> 
  #     same as
  #     <%= coffeesound_js_tags %>
  #
  # - Custom:
  #   - First include a necessary theme-#{theme}.js file in
  #   /vendor/assets/javascripts
  #
  #     <%= coffeesound_js_tags :theme => :emacs%>
  def coffeesound_js_tags(opt={:theme => :monokai})
     javascript_include_tag("gibber.lib.min", "termlib", "ace", "mode-coffee", "worker-coffee", "theme-#{opt[:theme]}", "lzma_worker", "lzma2string")
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

  def set_json_compile
      code = decompress_for params[:c]
      # ident code to insert in try block
      code = code.split("\n").map do |line| 
        (" "*2) +  line
      end.join("\n")

      string = """window.update = ->
  if not window.Master then Gibber.init globalize: true, target: window
"""
      string << code
      puts string
      cs = CoffeeScript.compile(string, {:bare => true})
      puts cs
      set_json({:type=> "run", :callback =>cs, :error => !cs})
    end

    def set_json_stop
      string = "window.update = -> if window.Master.Out then Gibber.clear()"
      cs = CoffeeScript.compile(string, {:bare => true})
      puts cs
      set_json({:type => "stop", :callback =>cs, :error => !cs})
    end

end

