json.array!(@microposts) do |micropost|
  json.extract! micropost, :id, :title, :content
  json.url micropost_url(micropost, format: :json)
end
