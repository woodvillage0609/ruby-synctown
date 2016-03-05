json.array!(@articles) do |article|
  json.extract! article, :id, :photo, :title, :content, :url, :source
  json.url article_url(article, format: :json)
end
