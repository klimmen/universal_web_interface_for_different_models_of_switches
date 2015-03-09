class Comutator
	
def initialize(switch)
	@switch_name = switch.name
	@host = switch.ip
	@login = switch.login
	@pass = switch.pass
	@snmp = switch.snmp
end


  def switch_info
		mib = Mib.new
		mib.first_param(@host,@snmp)
		model = mib.snmp_get_test("1.3.6.1.2.1.1.1.0")
		if model.slice(/ZTE/)
			zte = Zte.new(@host, @snmp)
			firmware =  zte.def_firmware(model)
			model = model.slice(/.+(?=,)/)
			mac = zte.mac(model, firmware)
		elsif model.slice(/(ES|MES)/) 
			zyxel = Zyxel.new(@host, @snmp)
			firmware = zyxel.def_firmware(model)
			mac = zyxel.mac(model, firmware)
	  end
	 {name: @switch_name, ip: @host, model: model, firmware: firmware, mac: mac}
  end

  def ports(data)
		mib = Mib.new
		mib.first_param(@host,@snmp)
		result_ports = {}
  	if data[:model].slice(/ZTE/)

  	elsif data[:model].slice(/(ES|MES)/)
  		zyxel = Zyxel.new(@host, @snmp, data[:model], data[:firmware])
  		result_ports[:port_admin_status]=zyxel.port_admin_status
  		result_ports[:port_name]=zyxel.port_name
  		result_ports[:port_type]=zyxel.port_type
  		result_ports[:port_speed_duplex]=zyxel.port_speed_duplex
  	end
  	result_ports
  end

end


