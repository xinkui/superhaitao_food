json.array!(@skus) do |sku|
  json.extract! sku, :id, :name, :long, :wide, :high, :volume, :actual_weight, :barcode, :remark
  json.url sku_url(sku, format: :json)
end
