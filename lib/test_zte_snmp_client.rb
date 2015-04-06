module TestZteSnmpClient

  def snmp_get(oid, host, community)
    case oid
      when "1.3.6.1.2.1.2.1.0" then return "52"
      when "1.3.6.1.2.1.17.7.1.4.3.1.1.1" then return " NULL "
      when "1.3.6.1.4.1.3902.15.2.11.3.3.1.4.1" then return "00000000000000"
      when "1.3.6.1.2.1.17.7.1.4.2.1.5.1" then return "fffffffffffff000"
      when "1.3.6.1.4.1.3902.15.2.11.3.3.1.6.1" then return "1"
      when "1.3.6.1.2.1.17.7.1.4.3.1.1.22" then return "root_22"
      when "1.3.6.1.4.1.3902.15.2.11.3.3.1.4.22" then return "000000000000f0"
      when "1.3.6.1.2.1.17.7.1.4.2.1.5.22" then return "0000000000000000"
      when "1.3.6.1.4.1.3902.15.2.11.3.3.1.6.22" then return "1"
    end
  end

  def snmp_walk(oid, host, community)
    case oid
      #walk ports
      when "1.3.6.1.2.1.2.2.1.7" then return ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.3" then return ["GOOD", "kjgvjh", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free1", "", "", "", ""]
      when "1.3.6.1.2.1.2.2.1.8" then return ["2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "1", "1", "2", "2"]
      when "1.3.6.1.2.1.2.2.1.2" then return ["ZXR10 2952-SI 100BaseT port  1", "ZXR10 2952-SI 100BaseT port  2", "ZXR10 2952-SI 100BaseT port  3", "ZXR10 2952-SI 100BaseT port  4", "ZXR10 2952-SI 100BaseT port  5", "ZXR10 2952-SI 100BaseT port  6", "ZXR10 2952-SI 100BaseT port  7", "ZXR10 2952-SI 100BaseT port  8", "ZXR10 2952-SI 100BaseT port  9", "ZXR10 2952-SI 100BaseT port  10", "ZXR10 2952-SI 100BaseT port  11", "ZXR10 2952-SI 100BaseT port  12", "ZXR10 2952-SI 100BaseT port  13", "ZXR10 2952-SI 100BaseT port  14", "ZXR10 2952-SI 100BaseT port  15", "ZXR10 2952-SI 100BaseT port  16", "ZXR10 2952-SI 100BaseT port  17", "ZXR10 2952-SI 100BaseT port  18", "ZXR10 2952-SI 100BaseT port  19", "ZXR10 2952-SI 100BaseT port  20", "ZXR10 2952-SI 100BaseT port  21", "ZXR10 2952-SI 100BaseT port  22", "ZXR10 2952-SI 100BaseT port  23", "ZXR10 2952-SI 100BaseT port  24", "ZXR10 2952-SI 100BaseT port  25", "ZXR10 2952-SI 100BaseT port  26", "ZXR10 2952-SI 100BaseT port  27", "ZXR10 2952-SI 100BaseT port  28", "ZXR10 2952-SI 100BaseT port  29", "ZXR10 2952-SI 100BaseT port  30", "ZXR10 2952-SI 100BaseT port  31", "ZXR10 2952-SI 100BaseT port  32", "ZXR10 2952-SI 100BaseT port  33", "ZXR10 2952-SI 100BaseT port  34", "ZXR10 2952-SI 100BaseT port  35", "ZXR10 2952-SI 100BaseT port  36", "ZXR10 2952-SI 100BaseT port  37", "ZXR10 2952-SI 100BaseT port  38", "ZXR10 2952-SI 100BaseT port  39", "ZXR10 2952-SI 100BaseT port  40", "ZXR10 2952-SI 100BaseT port  41", "ZXR10 2952-SI 100BaseT port  42", "ZXR10 2952-SI 100BaseT port  43", "ZXR10 2952-SI 100BaseT port  44", "ZXR10 2952-SI 100BaseT port  45", "ZXR10 2952-SI 100BaseT port  46", "ZXR10 2952-SI 100BaseT port  47", "ZXR10 2952-SI 100BaseT port  48", "ZXR10 2952-SI 1000BaseT port  49", "ZXR10 2952-SI 1000BaseT port  50", "ZXR10 2952-SI 1000BaseX port  51", "ZXR10 2952-SI 1000BaseX port  52"]
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.6" then return ["5", "8", "8", "8", "8", "1", "1", "2", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "3"]
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.9" then return ["998", "998", "998", "998", "997", "997", "997", "997", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "22", "1", "22", "1"]
      when "1.3.6.1.4.1.3902.15.2.11.3.4.1.1" then return ["1", "22", "998"]
    end
  end

  def snmp_set_integer(oid, value, host, community)
    case oid
      when "1.3.6.1.2.1.2.2.1.7.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.6.1" then return value
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.9.1" then return value
    end
  end

  def snmp_set_string(oid, value, host, community)
    case oid
      when "1.3.6.1.4.1.3902.15.2.11.2.4.1.3.1" then return value
    end
  end

  def snmp_walk_all_data(oid, host, community)
   case oid
     when "1.3.6.1.2.1.17.7.1.2.2.1.2" then return {:oid=>[["SNMPv2-SMI::mib-2", "17", "7", "1", "2", "2", "1", "2", "1", "0", "21", "99", "190", "88", "141"], ["SNMPv2-SMI::mib-2", "17", "7", "1", "2", "2", "1", "2", "1", "208", "80", "153", "47", "176", "91"], ["SNMPv2-SMI::mib-2", "17", "7", "1", "2", "2", "1", "2", "22", "2", "4", "150", "109", "14", "192"], ["SNMPv2-SMI::mib-2", "17", "7", "1", "2", "2", "1", "2", "22", "2", "4", "150", "109", "14", "195"]], :value=>["50", "50", "50", "50"]}
   end
  end

end