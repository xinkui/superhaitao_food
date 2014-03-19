json.array!(@brands) do |brand|
  json.extract! brand, :id, :name_cn, :name_en, :remark
  json.url brand_url(brand, format: :json)
end
