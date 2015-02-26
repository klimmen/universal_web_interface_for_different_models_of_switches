json.array!(@switches) do |switch|
  json.extract! switch, :id, :name, :ip, :login, :pass, :snmp
  json.url switch_url(switch, format: :json)
end
