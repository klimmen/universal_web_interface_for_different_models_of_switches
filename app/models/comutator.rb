class Comutator
	
def initialize(switch)
	@switch_name = switch.name
	@host = switch.ip
	@login = switch.login
	@pass = switch.pass
	@snmp = switch.snmp
end


  def switch_info
		model = Mib.snmp_get("1.3.6.1.2.1.1.1.0", @host,@snmp).to_s
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
		result_ports = {}
  	if data[:model].slice(/ZTE/)
  		switch_class = Zte.new(@host, @snmp, data[:model], data[:firmware])
  	elsif data[:model].slice(/(ES|MES)/)
  		switch_class = Zyxel.new(@host, @snmp, data[:model], data[:firmware])  		
  	end
  		result_ports[:port_admin_status]=switch_class.port_admin_status
  		result_ports[:port_name]=switch_class.port_name
  		result_ports[:port_link_state]=switch_class.link_state
  		result_ports[:port_type]=switch_class.port_type
  		result_ports[:port_speed_duplex]=switch_class.port_speed_duplex
  		result_ports[:port_select_options_speed_duplex] = switch_class.view_port_types(result_ports[:port_type])
  	result_ports
  end

  	
end


