class TestZteSnmpClient

  def snmp_get(oid, host, community)
    json_parse(oid)
  end

  def snmp_walk(oid, host, community)
    json_parse(oid)
  end

  def snmp_set_integer(oid, value, host, community)
    oid_array = oid.split(".")
    port = oid.split(".").last.to_i
    oid_array.pop
    oid = oid_array.join(".")
    case oid
      when '8.1.3.6.1.2.1.2.2.1.7.1'
        update_value('1.3.6.1.4.1.3902.15.2.11.2.4.1.6', port, value)
      when '8.1.3.6.1.2.1.2.2.1.7.1.2'
        update_value('1.3.6.1.2.1.2.2.1.7', port, value)
      when '8.1.3.6.1.2.1.2.2.3.7.3'
        update_value('1.3.6.1.2.1.2.2.1.25', port, value)
      when "1.3.6.1.2.1.2.2.1.7.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.6.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.9.1" then return value
    end
  end

  def snmp_set_string(oid, value, host, community)
    oid_array = oid.split(".")
    port = oid.split(".").last.to_i
    oid_array.pop
    oid = oid_array.join(".")
    case oid
      when '7.3.6.1.3.1.3.5.1.4.2.1.1.5'
        update_value('1.3.6.1.4.1.3902.15.2.11.2.4.1.3', port, value)
      when "8.1.3.6.1.4.1.3902.15.2.11.2.4.1.3.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.3.1" then return value
    end
  end

  def snmp_walk_all_data(oid, host, community)
    json_parse(oid).symbolize_keys
  end

  def json_parse(oid)
    file = IO.read('172_24_18_195.json')
    my_hash = JSON.parse(file)
    my_hash[oid]
  end

  def update_value(oid_set, port, value)
    file = IO.read('172_24_18_195.json')
    json = JSON.parse(file)
    json[oid_set][port -1] = value.to_s
    File.open('172_24_18_195.json',"w") do |f|
      f.write(JSON.pretty_generate(json))
    end
  end

end