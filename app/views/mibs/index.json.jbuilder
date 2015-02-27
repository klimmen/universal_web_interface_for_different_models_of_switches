json.array!(@mibs) do |mib|
  json.extract! mib, :id, :name
  json.url mib_url(mib, format: :json)
end
