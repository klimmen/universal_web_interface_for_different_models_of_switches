class Zyxel

	def initialize(host, snmp, model = nil, firmware = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
  end

	def def_firmware(model)
		rusult_value_oids = []
		(1..7).each do |i|
		  rusult_value_oids << ValueOid.find_by_name("getFirmwarePart_#{i}")
		end
		
		switch_model = SwitchModel.find_by_name(model)
		rusult_firmware = ""
		firmware = switch_model.firmwares.first

		rusult_value_oids.each do |rusult_value_oid|
		oid = firmware.mibs.find_by_value_oid_id(rusult_value_oid.id).name
			rusult_firmware << Mib.snmp_get(oid, @host, @snmp).to_s
		end
		rusult_firmware	
	end

	def mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMAC")
		oid = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id).name
		mac = Mib.snmp_get(oid, @host, @snmp).to_s.unpack("H2H2H2H2H2H2H2H2H2H2H2").join(":").slice(/(?<=80:00:03:7a:03:).+/)
	end
  
  def get_oid(value_oid_name)
  	value_oid = ValueOid.find_by_name(value_oid_name)
		oid = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id).name
  end
	
	def port_admin_status
			oid_ports_count =  get_oid("getPortsCount")
  		oid_admin_status = get_oid("walkAdminStatus")
  		ports_count = Mib.snmp_get(oid_ports_count, @host, @snmp).to_i
  		admin_status = Mib.snmp_walk(oid_admin_status, @host, @snmp)
  		admin_status = admin_status[0..(ports_count-1)]	
  		admin_status.map! do |status| 
  			if status == "1" 
  				true 
  		  else 
  				false	
  			end
  		end

	end	
  
  def port_name
  	oid_names = get_oid("walkPortName")
  	names = Mib.snmp_walk(oid_names, @host, @snmp)
  	names.map! {|name| name.to_sym}
  end
  
  def port_type
  	oid_type = get_oid("walkPortType")
  	type = Mib.snmp_walk(oid_type, @host, @snmp)
  	type.map! do |status| 
  			if status == "1" 
  				1000 
  		  else 
  				100
  			end
  		end
  end
  
  def port_speed_duplex
  	oid_speed_duplex= get_oid("walkPortSpeedDuplex")
  	speed_duplex = Mib.snmp_walk(oid_speed_duplex, @host, @snmp)
  end

  def link_state
  	oid_link_state= get_oid("walkLinkState")
  	link_state = Mib.snmp_walk(oid_link_state, @host, @snmp)
  	link_state.map! do |status| 
  		case status
  			when "0" then "DOWN"
  			when "1" then	"UP(copper)"
  			when "2" then	"UP(fiber)" 		
  		end 	
  	end
  	p link_state
  end


end


