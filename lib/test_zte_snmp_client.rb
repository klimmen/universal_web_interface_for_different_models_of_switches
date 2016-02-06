class TestZteSnmpClient

  def snmp_get(oid, host, community)
    json_parse(oid)
  end

  def snmp_walk(oid, host, community)
    json_parse(oid)
  end

  def snmp_set_integer(oid, value, host, community)
    case oid
      when '8.1.3.6.1.2.1.2.2.1.7.1' then return value
      when '8.1.3.6.1.2.1.2.2.1.7.1.2' then return value
      when "1.3.6.1.2.1.2.2.1.7.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.6.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.9.1" then return value
    end
  end

  def snmp_set_string(oid, value, host, community)
    case oid
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

end