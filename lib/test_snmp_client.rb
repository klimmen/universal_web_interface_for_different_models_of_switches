module TestSnmpClient
  def snmp_get(oid, host, community)
    case host
      when '172.24.18.195'
        TestZteSnmpClient.new.snmp_get(oid, host, community)
      when '172.24.18.196'
        TestZyxelSnmpClient.new.snmp_get(oid, host, community)
    end
  end

  def snmp_walk(oid, host, community)
    case host
      when '172.24.18.195'
        TestZteSnmpClient.new.snmp_walk(oid, host, community)
      when '172.24.18.196'
        TestZyxelSnmpClient.new.snmp_walk(oid, host, community)
    end
  end

  def snmp_set_integer(oid, value, host, community)
    case host
      when '172.24.18.195'
        TestZteSnmpClient.new.snmp_set_integer(oid, value, host, community)
      when '172.24.18.196'
        TestZyxelSnmpClient.new.snmp_set_integer(oid, value, host, community)
    end
  end

  def snmp_set_string(oid, value, host, community)
    case host
      when '172.24.18.195'
        TestZteSnmpClient.new.snmp_set_string(oid, value, host, community)
      when '172.24.18.196'
        TestZyxelSnmpClient.new.snmp_set_string(oid, value, host, community)
    end
  end

  def snmp_walk_all_data(oid, host, community)
    case host
      when '172.24.18.195'
        TestZteSnmpClient.new.snmp_walk_all_data(oid, host, community)
      when '172.24.18.196'
        TestZyxelSnmpClient.new.snmp_walk_all_data(oid, host, community)
    end
  end
end