json.array!(@events) do |event|
  json.extract! event, :id, :title, :from, :to, :timings, :description
  json.url event_url(event, format: :json)
end
