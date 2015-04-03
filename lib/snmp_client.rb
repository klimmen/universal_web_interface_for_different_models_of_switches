module SnmpClient

  def snmp_get(oid, host, community)

    get_value = ''
    SNMP::Manager.open(:host => host, :community => community ) do |manager|
      response = manager.get(oid)
      response.each_varbind do |vb|
        get_value = vb.value
      end
    end
    p "111111111"
    p oid
    p get_value
    p"2222222222"
    get_value
  end

  def snmp_walk(oid, host, community)
    walk_values = []
    SNMP::Manager.open(:host => host, :community => community) do |manager|
      manager.walk(oid) do |vb|
        walk_values<<vb.value.to_s
      end
    end
    p "444444444444"
    p oid
    p walk_values
    p"555555555555"
    walk_values
  end

  def snmp_set_integer(oid, value, host, community)
    manager = SNMP::Manager.new(:host => host, :community => community)
    varbind = SNMP::VarBind.new(oid, SNMP::Integer32.new(value))
    manager.set(varbind)
    manager.close
  end

  def snmp_set_string(oid, value, host, community)
    manager =  SNMP::Manager.new(:host => host, :community => community)
    varbind =  SNMP::VarBind.new(oid, SNMP::OctetString.new(value))
    manager.set(varbind)
    manager.close
  end

  def snmp_walk_all_data(oid, host, community)
    result= {oid:[],value:[]}
    SNMP::Manager.open(:host => host, :community => community) do |manager|
      manager.walk(oid) do |vb|
        result[:oid]<<vb.name.to_s.split(".")
        result[:value]<<vb.value.to_s
      end
    end
    p "666666666666"
    p oid
    p result
    p"77777777777"
    result
  end

end