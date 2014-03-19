json.array!(@categories) do |category|
  json.extract! category, :id, :name_cn, :name_en, :remark
  json.url category_url(category, format: :json)
end
