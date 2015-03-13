class Zyxel


	def initialize(host, snmp, model = nil, firmware = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
  end

	def get_firmware(model)
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

	def get_mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMAC")
		oid = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id).name
		mac = Mib.snmp_get(oid, @host, @snmp).to_s.unpack("H2H2H2H2H2H2H2H2H2H2H2").join(":").slice(/(?<=80:00:03:7a:03:).+/)
	end
  
  def get_oid(value_oid_name)
  	value_oid = ValueOid.find_by_name(value_oid_name)
		oid = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id).name
  end
	
 ################################ get_ports

  def get_ports_count
    oid_ports_count =  get_oid("getPortsCount")
    ports_count = Mib.snmp_get(oid_ports_count, @host, @snmp).to_i
  end

	def get_port_admin_status
  	oid_admin_status = get_oid("walkAdminStatus")
  	ports_count = get_ports_count
  	admin_status = Mib.snmp_walk(oid_admin_status, @host, @snmp)
  	admin_status = admin_status[0..(ports_count-1)]	
  	admin_status.map! do |status|
      case status
        when "1" then "up"
        when "2" then "down"  
      end    
  	end
	end	
  
  def get_port_name
  	oid_names = get_oid("walkPortName")
  	names = Mib.snmp_walk(oid_names, @host, @snmp)
  	names.map! {|name| name.to_sym}
  end
  
  def get_port_type
  	oid_type = get_oid("walkPortType")
  	type = Mib.snmp_walk(oid_type, @host, @snmp)
  	type.map! do |status| 
      case status
        when "1" then 1000
        when "2" then 100  
      end
  	end
  end
  
  def get_port_speed_duplex
  	oid_speed_duplex= get_oid("walkPortSpeedDuplex")
  	speed_duplex = Mib.snmp_walk(oid_speed_duplex, @host, @snmp)
  end

  def get_link_state
  	oid_link_state= get_oid("walkLinkState")
  	link_state = Mib.snmp_walk(oid_link_state, @host, @snmp)
  	link_state.map! do |status| 
  		case status
  			when "0" then "DOWN"
  			when "1" then	"UP(copper)"
  			when "2" then	"UP(fiber)" 		
  		end 	
  	end
  	link_state
  end

  def get_view_port_types (port_types)
    speed_duplex = []
    port_types.each do |port_type|
      case port_type
        when 100
          speed_duplex << [['auto', '0'], ['10M / Full Duplex', '2'], ['10M / Half Duplex', '1'], ['100M / Full Duplex', '4'], ['100M / Half Duplex', '3'] ]  
        when 1000
          speed_duplex << [['auto', '0'], ['100M / Full Duplex', '2'], ['100M / Half Duplex', '3'], ['1000M / Full Duplex', '5']] 
      end
    end
    speed_duplex  
  end

 ################################ set_ports

  def set_port_admin_status(port_num, value)
    oid_admin_status= get_oid("setAdminStatus")
    case value
      when "up" then num = 1
      when "down" then num = 2    
    end 
    Mib.snmp_set_integer("#{oid_admin_status}.#{port_num}", num, @host, @snmp)  
  end

  def set_port_name(port_num, value)
    oid_port_name= get_oid("setPortName")
    Mib.snmp_set_string("#{oid_port_name}.#{port_num}", value, @host, @snmp)
  end

  def set_port_speed_duplex(port_num, value)
    oid_port_speed_duplex= get_oid("setPortSpeedDuplex")
    Mib.snmp_set_integer("#{oid_port_speed_duplex}.#{port_num}", value, @host, @snmp)
  end

 ################################ get_vlans
 
 ################################ get_vlan
 
 ################################ set_vlan

end


