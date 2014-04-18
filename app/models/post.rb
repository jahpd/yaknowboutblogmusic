class Post < ActiveRecord::Base

   belongs_to :user

   validates :title, presence: true
   validates :doc, presence: true
   validates :code, presence: true

end
