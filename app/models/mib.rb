class Mib < ActiveRecord::Base
    belongs_to :value_oid
    has_many :firmware_mibs
    has_many :firmwares, through: :firmware_mibs


def first_param(ip,snmp)
 	@host = ip
 	@community = snmp
 end

 def snmp_get(oid)
   	get_value = ''
    SNMP::Manager.open(:host => @host, :community => @community ) do |manager|
    response = manager.get(oid)
    response.each_varbind do |vb|
      get_value = vb.value
    end
   end
   get_value
   
 end

  def snmp_walk(oid)
  	walk_values = []
		SNMP::Manager.new(:host => @host, :community => @community) do |manager|
  	manager.walk(oid) do |vb| 
  	walk_values<<vb.value 
  		end
		end
		walk_values
  end
  
  def snmp_get_test(oid)
    case oid
      when "1.3.6.1.4.1.890.1.5.8.72.1.1.0" then return "4"
      when "1.3.6.1.4.1.890.1.5.8.72.1.2.0" then return "0"
      when "1.3.6.1.4.1.890.1.5.8.72.1.3.0" then return "AADF"
      when "1.3.6.1.4.1.890.1.5.8.72.1.4.0" then return "2"
      when "1.3.6.1.4.1.890.1.5.8.72.1.5.0" then return "23"
      when "1.3.6.1.4.1.890.1.5.8.72.1.6.0" then return "12"
      when "1.3.6.1.4.1.890.1.5.8.72.1.7.0" then return "2013"
    end
  end



end
