class Mib < ActiveRecord::Base
    belongs_to :value_oid
    has_many :firmware_mibs
    has_many :firmwares, through: :firmware_mibs


 def self.snmp_get(oid, host, community)
  
   	get_value = ''
    SNMP::Manager.open(:host => host, :community => community ) do |manager|
    response = manager.get(oid)
    response.each_varbind do |vb|
      get_value = vb.value
    end
   end
   get_value
   
 end

  def self.snmp_walk(oid, host, community)
  	walk_values = []
		SNMP::Manager.open(:host => host, :community => community) do |manager|
  	manager.walk(oid) do |vb| 
  	walk_values<<vb.value.to_s
  		end
		end
    walk_values
  end

  def self.snmp_set_integer(oid, value, host, community)    
    manager = SNMP::Manager.new(:host => host, :community => community)
    varbind = SNMP::VarBind.new(oid, SNMP::Integer32.new(value))
    manager.set(varbind)
    manager.close
  end

  def self.snmp_set_string(oid, value, host, community)  
      p"----------------------"
    p oid
    p value  
    manager =  SNMP::Manager.new(:host => host, :community => community)
    varbind =  SNMP::VarBind.new(oid, SNMP::OctetString.new(value))
    manager.set(varbind)
    manager.close
  end
  
  def snmp_get_test(oid)
    case oid
      #when "1.3.6.1.2.1.1.1.0"              then return  "ZTE Ethernet Switch ZXR10 2952-SI, Version: V2.0.12.W"
      when "1.3.6.1.2.1.1.1.0"             then return "ES3500-8PD" 
      when "1.3.6.1.4.1.890.1.5.8.72.1.1.0" then return "4"
      when "1.3.6.1.4.1.890.1.5.8.72.1.2.0" then return "0"
      when "1.3.6.1.4.1.890.1.5.8.72.1.3.0" then return "AADF"
      when "1.3.6.1.4.1.890.1.5.8.72.1.4.0" then return "0"
      when "1.3.6.1.4.1.890.1.5.8.72.1.5.0" then return "19"
      when "1.3.6.1.4.1.890.1.5.8.72.1.6.0" then return "6"
      when "1.3.6.1.4.1.890.1.5.8.72.1.7.0" then return "2012"
      when "1.3.6.1.2.1.2.2.1.6.1"          then return "00-22-93-55-C9-41" # zte
      when "1.3.6.1.6.3.10.2.1.1.0"          then return "0x80 00 03 7A 03 40 4A 03 0B 01 24" # zyxel 3528
    end
  end        

  def test_snmp_walk(oid)
    case oid
      when "1.3.6.1.2.1.2.2.1.7"                then return [1, 2, 2, 1, 2, 1, 1, 1] 
      when "1.3.6.1.4.1.890.1.5.8.51.24.1.1.3"  then return ["port1", "port2", "port3", "port4", "port5", "port6", "port7", "port8"]
      when "1.3.6.1.4.1.890.1.5.8.51.24.1.1.4"  then return [100, 100, 100, 100, 100, 100, 1000, 1000]
      when "1.3.6.1.4.1.890.1.5.8.51.24.1.1.5"  then return ["auto", "auto", '100M / Half Duplex', "auto", "auto", "auto", "auto", '100M / Full Duplex']
    end
  end


end
