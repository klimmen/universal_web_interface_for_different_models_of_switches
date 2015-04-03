module TestSnmpClient

  def snmp_get(oid, host, community)
    p "33333333333333333333333333333333333333"
    case oid
      when "1.3.6.1.2.1.1.1.0" then return "MES3500-24"
      when "1.3.6.1.4.1.890.1.5.8.68.1.1.0" then return "4"
      when "1.3.6.1.4.1.890.1.5.8.68.1.2.0" then return "0"
      when "1.3.6.1.4.1.890.1.5.8.68.1.3.0" then return "AABB"
      when "1.3.6.1.4.1.890.1.5.8.68.1.4.0" then return "3"
      when "1.3.6.1.4.1.890.1.5.8.68.1.5.0" then return "6"
      when "1.3.6.1.4.1.890.1.5.8.68.1.6.0" then return "11"
      when "1.3.6.1.4.1.890.1.5.8.68.1.7.0" then return "2014"
      when "1.3.6.1.6.3.10.2.1.1.0" then return "\x80\x00\x03z\x03\xB0\xB2\xDC\xB7v("
      when "1.3.6.1.2.1.1.1.0" then return "MES3500-24"
      when "1.3.6.1.2.1.2.1.0" then return "28"
      when "1.3.6.1.2.1.17.7.1.4.3.1.1.1" then return "1"
      when "1.3.6.1.2.1.17.7.1.4.3.1.4.1" then return "\xFF\xFF\xFF\xF0\x00\x00\x00\x00"
      when "1.3.6.1.2.1.17.7.1.4.2.1.4.0.1" then return "\xFF\xFF\xFF\xF0\x00\x00\x00\x00"
      when "1.3.6.1.2.1.17.7.1.4.3.1.3.1" then return "\x00\x00\x00\x00\x00\x00\x00\x00"
      when ".3.6.1.2.1.17.7.1.4.3.1.5.1" then return "1"
      when "1.3.6.1.2.1.17.7.1.4.3.1.1.22" then return "root_vlan"
      when "1.3.6.1.2.1.17.7.1.4.3.1.4.22" then return "\xFF\xFF\xFF\x00\x00\x00\x00\x00"
      when "1.3.6.1.2.1.17.7.1.4.2.1.4.0.22" then return "\x00\x00\x00\xF0\x00\x00\x00\x00"
      when "1.3.6.1.2.1.17.7.1.4.3.1.3.22" then return "\xFF\xFF\xFF\x00\x00\x00\x00\x00"
      when "1.3.6.1.2.1.17.7.1.4.3.1.5.22" then return "1"
    end
  end

  def snmp_walk(oid, host, community)
    walk_values = []
    SNMP::Manager.open(:host => host, :community => community) do |manager|
      manager.walk(oid) do |vb|
        walk_values<<vb.value.to_s
      end
    end
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
    result
  end

end