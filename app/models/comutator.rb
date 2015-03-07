class Comutator
	
def initialize(switch)
 	@host = switch.ip
 	@community = switch.snmp
 	@login = switch.login
 	@pass = switch.pass
 	@snmp = switch.snmp
end


  def switch_info
		mib = Mib.new
		mib.first_param(@host,@snmp)
		model = mib.snmp_get_test("1.3.6.1.2.1.1.1.0")
		if model.slice(/ZTE/)
			{model: model.slice(/.+(?=,)/), firmware: model.slice(/(?<=Version: ).+/)}
		elsif model.slice(/(ES|MES)/) 
			zyxel = Zyxel.new
			{model: model, firmware: zyxel.def_firmware(model, @host, @snmp)}
	  end
  end


end


