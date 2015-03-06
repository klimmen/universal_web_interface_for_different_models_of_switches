class Comutator
	
def initialize(ip,snmp,pass)
 	@host = ip
 	@community = snmp
 	@pass = pass
 end


  def switch_info
		snmp_do = Mib.new(ip,snmp)
		model = snmp_do.snmp_get("1.3.6.1.2.1.1.1.0")
		case model
			when model.slice(/Zyxel/)
			 sw_model = Zyxel.new
			when model.slice(/ZTE/)
			 sw_model = Zte.new
		end
  end


end