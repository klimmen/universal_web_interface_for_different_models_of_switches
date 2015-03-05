json.array!(@value_oids) do |value_oid|
  json.extract! value_oid, :id, :name
  json.url value_oid_url(value_oid, format: :json)
end
