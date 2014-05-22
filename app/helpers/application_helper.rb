require 'open-uri'
require 'nokogiri'

module ApplicationHelper
  
  def random_image(href)
    #open url and get all images
    html = Nokogiri::HTML(open(href).read)

    #choice a random image
    #attribute for empty link
    array = html.css("a img")
    array[rand(10)]

  end

end
