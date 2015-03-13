class Zte

	def initialize(host, snmp, model = nil, firmware = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
  end

	def get_firmware(model)
		model.slice(/(?<=Version: ).+/)
	end

	def get_mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMAC")
		result_mib = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id)
		mac = Mib.snmp_get(result_mib.name, @host, @snmp).unpack("H2H2H2H2H2H2").join(":")
	end

	def get_oid(value_oid_name)
  	value_oid = ValueOid.find_by_name(value_oid_name)
		oid = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id).name
  end
	
	def get_ports_count
    oid_ports_count =  get_oid("getPortsCount")
    ports_count = Mib.snmp_get(oid_ports_count, @host, @snmp).to_i
  end

  def get_port_admin_status
  	oid_admin_status = get_oid("walkAdminStatus")
  	admin_status = Mib.snmp_walk(oid_admin_status, @host, @snmp)
  	admin_status.map! do |status| 
  		if status == "1" 
        "up" 
      else 
        "down"  
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
  		if !status.slice("ZXR10 2952-SI 1000Base").blank? 
  			1000 
  		else 
  			100
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
  			when "1" then	"DOWN"
  			when "2" then	"UP" 		
  		end 	
  	end  	
  end

	def get_view_port_types (port_types)
  	speed_duplex = []
  	port_types.each do |port_type| 
  		if port_type == 100
  			speed_duplex << [['auto / auto', '4'], ['auto / Half duplex', '8'], ['auto / Full duplex', '12'], ['10 M / auto', '1'], ['10 M / Half duplex', '5'], ['10 M / Full duplex', '9'], ['100 M / auto ', '2'], ['100 M / Half duplex', '6'], ['100M / Full Duplex', '10']]	
  		elsif port_type == 1000
  			speed_duplex << [['auto / auto', '4'], ['auto / Half duplex', '8'], ['auto / Full duplex', '12'], ['100 M / auto', '2'], ['100 M / Half duplex', '6'], ['100 M / Full duplex', '10'], ['1000 M / auto', '3'], ['1000 M / Full duplex', '11']]
  	 	end
  	end
    speed_duplex
 	end


  def set_port_admin_status(port_num, value)
    oid_admin_status= get_oid("setAdminStatus")
    if value == "up"
      Mib.snmp_set_integer("#{oid_admin_status}.#{port_num}", 1, @host, @snmp)
      p "up"
    else 
       Mib.snmp_set_integer("#{oid_admin_status}.#{port_num}", 2, @host, @snmp)
       p "down"
    end    
  end

  def set_port_name(port_num, value)
    oid_port_name= get_oid("setPortName")
    Mib.snmp_set_string("#{oid_port_name}.#{port_num}", value, @host, @snmp)
  end

  def set_port_speed_duplex(port_num, value)
    oid_port_speed_duplex= get_oid("setPortSpeedDuplex")
    Mib.snmp_set_integer("#{oid_port_speed_duplex}.#{port_num}", value, @host, @snmp)
  end

##################vlan
  def get_vid
    oid_vid = get_oid("walkVlanID")
    vlan_vid = Mib.snmp_walk(oid_vid, @host, @snmp)
  end

  def get_vlan_name(vid)
    oid_vlan_name = get_oid("getVlanName")
    vlan_name = Mib.snmp_get("#{oid_vlan_name}.#{vid}", @host, @snmp).to_s

  end

  def get_port_tag(vid)
    oid_ports_tag = get_oid("getPortsTag")
    vlan_port_tag = Mib.snmp_get("#{oid_ports_tag}.#{vid}", @host, @snmp).to_i
  end

  def get_port_untag(vid)
    oid_ports_untag = get_oid("getPortsUntag")
    vlan_port_untag = Mib.snmp_get("#{oid_ports_untag}.#{vid}", @host, @snmp).to_s.split("")
    decoder_for_tag_untag(vlan_port_untag)
  end

  def get_port_forbid(vid)
  end
 ################################DECODE TAG/UNTAG GET VALUE
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

#################################


  def get_vlan_activate(vid)
    oid_vlan_active = get_oid("getVlanActive")
    vlan_activate = Mib.snmp_get("#{oid_vlan_active}.#{vid}", @host, @snmp).to_i
    if vlan_activate == 1  
      vlan_activate = "yes"
    else 
      vlan_activate = "no"
    end
  end  


end
