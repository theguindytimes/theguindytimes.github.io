json.array!(@downloads) do |download|
  json.extract! download, :id, :title, :category, :description, :edition
  json.url download_url(download, format: :json)
end
