json.array!(@posts) do |post|
  json.extract! post, :id, :author, :title, :doc, :code
  json.url post_url(post, format: :json)
end
