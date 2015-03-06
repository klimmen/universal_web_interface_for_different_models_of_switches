class Comutator
	
def initialize(switch)
 	@host = switch.ip
 	@community = switch.snmp
 	@login = switch.login
 	@pass = switch.pass
 	@snmp = switch.snmp
end


  def switch_info
		snmp_do = Mib.new(@host,@snmp)
		p model = snmp_do.snmp_get("1.3.6.1.2.1.1.1.0")
		if model.slice(/ZTE/)
			zte= Zte.new
			return zte.firmware(@host,@snmp)
		else 
			zyxel = Zyxel.new
			return zyxel.firmware(@host,@snmp)
	  end
  end


end