class Zyxel
include TelnetClient

	def initialize(host, snmp, model = nil, firmware = nil, login = nil, pass = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
    @login = login
    @pass = pass
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
        when "0" then 100  
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

  def get_pvid
    oid_names = get_oid("walkPVID")
    names = Mib.snmp_walk(oid_names, @host, @snmp)
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

  def set_port_pvid(pvid, value)
    oid_port_pvid= get_oid("setPVID")
    Mib.snmp_set_integer("#{oid_port_pvid}.#{pvid}", value, @host, @snmp)
  end

################################ get_vlans

  def get_vid
    oid_vid = get_oid("walkVlanID")
    vlan_vid = Mib.snmp_walk(oid_vid, @host, @snmp)
  end

  def get_vlan_name(vid)
    oid_vlan_name = get_oid("getVlanName")
    vlan_name = Mib.snmp_get("#{oid_vlan_name}.#{vid}", @host, @snmp).to_s
  end

  def get_port_tag(vid)
    oid_ports_untag = get_oid("getPortsUntag")
    vlan_port_untag = Mib.snmp_get("#{oid_ports_untag}.#{vid}", @host, @snmp)
    result = vlan_port_untag.unpack("H2H2H2H2H2H2H2H2").join.split("")
    ports = decoder_for_tag_untag(result)
    all_ports = (1..get_ports_count).collect {|i| i}
    ports = vlan_port_fixed(vid) - ports
  end

  def get_port_untag(vid)
    oid_ports_untag = get_oid("getPortsUntag")
    vlan_port_untag = Mib.snmp_get("#{oid_ports_untag}.#{vid}", @host, @snmp)
    result = vlan_port_untag.unpack("H2H2H2H2H2H2H2H2").join.split("")
    ports = decoder_for_tag_untag(result)
    ports = vlan_port_fixed(vid) & ports
  end

  def vlan_port_fixed(vid)
    oid_vlan_ports_fixed = get_oid("getVlanPortsFixed")
    vlan_ports_fixed = Mib.snmp_get("#{oid_vlan_ports_fixed}.#{vid}", @host, @snmp)
    result = vlan_ports_fixed.unpack("H2H2H2H2H2H2H2H2").join.split("")
    ports = decoder_for_tag_untag(result)
  end

  def vlan_port_forbidden(vid)
    oid_vlan_ports_forbidden = get_oid("getVlanPortsForbidden")
    vlan_ports_forbidden = Mib.snmp_get("#{oid_vlan_ports_forbidden}.#{vid}", @host, @snmp)
    result = vlan_ports_forbidden.unpack("H2H2H2H2H2H2H2H2").join.split("")
    ports = decoder_for_tag_untag(result)
  end


  def get_vlan_activate(vid)
    oid_vlan_active = get_oid("getVlanActive")
    vlan_activate = Mib.snmp_get("#{oid_vlan_active}.#{vid}", @host, @snmp).to_i
    case vlan_activate
      when 1 then vlan_activate = "yes"
      when 2 then vlan_activate = "no"    
    end 
  end  

  ################################ DECODE TAG/UNTAG GET VALUE

  def get_index_ports(value)
    decoder_keys = [8,4,2,1]
    index_ports = []
    decoder_keys.each do |decoder_key|
      while value >= decoder_key do
      value=value-decoder_key
      index_ports << decoder_key
      end
    end
    index_ports
  end

  def decoder_for_tag_untag(oid_value)
    oid_value.map! {|value| value.to_i(16)}
    result = []
    oid_value.each do |value|
      if !value.nil?
        result << get_index_ports(value)
      else 
        result << [0]
      end
    end 
    ports = []
    result.each_index do |i|
      result[i].map! do |port|
        case port 
          when 8 then port = 1
          when 4 then port = 2
          when 2 then port = 3
          when 1 then port = 4
        end
        ports << i * 4 + port
      end 
    end
    ports
  end

  def commands_for_destroy_vlan(pass, id, vlans_info)
    ["configure", "no vlan #{id}"]
  end
  
  def commands_for_create_update_vlan(pass, param_vlan)
    commands =["configure", "vlan #{param_vlan[:pvid]}", "name #{param_vlan[:name]}"]
    commands << "inactive" if param_vlan[:active].nil?
    result = { tag: "", untag: "", forbidden: ""}
    (1..get_ports_count).each do |num_port|
      case param_vlan["#{num_port}".to_sym][:port_param]
        when "tag" then result[:tag] << "#{num_port},"
        when "untag" then result[:untag] << "#{num_port},"
        when "forbidden" then result[:forbidden] << "#{num_port},"
      end 
    end
    commands << "forbidden #{result[:forbidden][0..-2]}" if !result[:forbidden].nil?
    commands << "fixed #{result[:untag][0..-2]}" if !result[:untag].nil?
    commands << "untagged #{result[:untag][0..-2]}" if !result[:untag].nil?
    commands << "fixed #{result[:tag][0..-2]}" if !result[:tag].nil?
    commands << "no untagged #{result[:tag][0..-2]}" if !result[:tag].nil?
    commands
  end

  def commands_for_update_vlan(pass, pvid, param_vlan)
    commands =["configure", "vlan #{pvid}", "name #{param_vlan[:name]}"]
    commands << "inactive" if param_vlan[:active].nil?
    result = { tag: "", untag: "", forbidden: ""}
    (1..get_ports_count).each do |num_port|
      case param_vlan["#{num_port}".to_sym][:port_param]
        when "tag" then result[:tag] << "#{num_port},"
        when "untag" then result[:untag] << "#{num_port},"
        when "forbidden" then result[:forbidden] << "#{num_port},"
      end 
    end
    commands << "forbidden #{result[:forbidden][0..-2]}" if !result[:forbidden].nil?
    commands << "fixed #{result[:untag][0..-2]}" if !result[:untag].nil?
    commands << "untagged #{result[:untag][0..-2]}" if !result[:untag].nil?
    commands << "fixed #{result[:tag][0..-2]}" if !result[:tag].nil?
    commands << "no untagged #{result[:tag][0..-2]}" if !result[:tag].nil?
    commands
  end

 ################################ set_vlan

end


