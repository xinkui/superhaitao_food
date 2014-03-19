json.array!(@weights) do |weight|
  json.extract! weight, :id, :weight
  json.url weight_path(weight, format: :json)
end
