json.array!(@prices) do |price|
  json.extract! price, :id, :price, :express_id, :weight_id
  json.url price_path(price, format: :json)
end
