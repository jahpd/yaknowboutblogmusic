class Post < ActiveRecord::Base
  
  validate :title,{
    :format => { with: /\A[a-zA-Z]+\z/ },
    :message => "only allows letters"
  }

  validate :doc,{
    :format => { with: /((\n{2})(\t|\s{4,})(.*))/ },
    :message => "only allows letters"
  }

end
