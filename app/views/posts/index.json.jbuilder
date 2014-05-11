json.array!(@posts) do |post|
  json.extract! post, :id, :author, :title, :doc
  json.url post_url(post, format: :json)
end
