require "#{File.dirname(__FILE__)}/ace/builder"
require "#{File.dirname(__FILE__)}/processing/builder"

module ApplicationHelper
  
  include AceHelper::Builder
  include ProcessingHelper::Builder

  def gibberails_include_tag
    javascript_include_tag CLIENT_EVAL, AUDIO_CLIENT, PROCESSING_CLIENT, EDITOR[0], EDITOR[1], EDITOR[2], EDITOR[3]
  end

  def build_ace(post, options)
    #stylish
    options[:position] = :absolute
    style = ""
    options.each_pair {|k, v|
      style << "#{k}: #{v};"
    }
    content_tag(:div, "", id: "#{post.id}_#{RENDER_OPTIONS[:lang]}_editor", style: style)
  end

  def build_processing_without_post(options)
    content_tag(:canvas, 
      javascript_tag(options[:src], :type => "text/processing"),
      id: "sketch"
    )
  end

  def build_processing(post, options)
    content_tag(:canvas, 
      javascript_tag(options[:src], :type => "text/processing"),
      id: "#{post.id}_sketch"
    )
  end

  
  def integrate_gibberish_and_ace(post)  
    # inject inline a compiled auto-generated coffee-script
    _src =  hook_gibberails
    _src << hook_editor(post, RENDER_OPTIONS[:lang], RENDER_OPTIONS[:theme])
    _src << hook_post_code(post)
    _src << hook_commands(post, RENDER_OPTIONS[:commands])
    _src = CoffeeScript.compile _src, :bare => true
      
    javascript_tag _src, :id => "#{post.id}_runner"        
  end  
end
