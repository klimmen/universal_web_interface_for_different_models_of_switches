class Mib < ActiveRecord::Base
    belongs_to :value_oid
    has_many :firmware_mibs
    has_many :firmwares, through: :firmware_mibs


#include SNMP


def initialize(ip,snmp)
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




end
