module ProcessingHelper

  module Base
    
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::JavaScriptHelper
  
    def hook_setup(code)
      "setup = (processing) ->\n#{code}"
    end

    def hook_draw(code)
      "draw = (processing) ->\n#{code}"
    end

    def hook_processing
      javascript_include_tag "processing.min"
    end
 
  end

end
