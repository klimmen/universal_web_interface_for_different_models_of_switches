class Zte
  if Rails.env.test?
    include TestTelnetClient
    include TestZteSnmpClient
  else
    include TelnetClient
    include SnmpClient
  end

	def initialize(host, snmp, model = nil, firmware = nil, login = nil, pass = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
    @login = login
    @pass = pass
  end

	def get_firmware(model)
		model.slice(/(?<=Version: ).+/)
	end

	def get_mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMAC")
		result_mib = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id)
		mac = snmp_get(result_mib.name, @host, @snmp).unpack("H2H2H2H2H2H2").join(":")
	end

	def get_oid(value_oid_name)
  	value_oid = ValueOid.find_by_name(value_oid_name)
		oid = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id).name
  end

 ################################ get_ports
	
	def get_ports_count
    oid_ports_count =  get_oid("getPortsCount")
    ports_count = snmp_get(oid_ports_count, @host, @snmp).to_i
  end

  def get_port_admin_status
  	oid_admin_status = get_oid("walkAdminStatus")
  	admin_status =snmp_walk(oid_admin_status, @host, @snmp)
  	admin_status.map! do |status| 
      case status
        when "1" then "up"
        when "2" then "down"    
      end   
  	end
	end	
  
  def get_port_name
  	oid_names = get_oid("walkPortName")
  	names =snmp_walk(oid_names, @host, @snmp)
  end
  
  def get_port_type
  	oid_type = get_oid("walkPortType")
  	type = snmp_walk(oid_type, @host, @snmp)
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
  	speed_duplex =snmp_walk(oid_speed_duplex, @host, @snmp)
  end

  def get_link_state
  	oid_link_state= get_oid("walkLinkState")
  	link_state = snmp_walk(oid_link_state, @host, @snmp)
  	link_state.map! do |status| 
  		case status
  			when "2" then	"DOWN"
  			when "1" then	"UP" 		
  		end 	
  	end  	
  end

	def get_view_port_types (port_types)
  	speed_duplex = []
  	port_types.each do |port_type| 
  		case port_type
        when 100 
          speed_duplex << [['auto / auto', '4'], ['auto / Half duplex', '8'], ['auto / Full duplex', '12'], ['10 M / auto', '1'], ['10 M / Half duplex', '5'], ['10 M / Full duplex', '9'], ['100 M / auto ', '2'], ['100 M / Half duplex', '6'], ['100M / Full Duplex', '10']] 
        when 1000 
        speed_duplex << [['auto / auto', '4'], ['auto / Half duplex', '8'], ['auto / Full duplex', '12'], ['100 M / auto', '2'], ['100 M / Half duplex', '6'], ['100 M / Full duplex', '10'], ['1000 M / auto', '3'], ['1000 M / Full duplex', '11']]    
      end
  	end
    speed_duplex
 	end

  def get_pvid
    oid_names = get_oid("walkPVID")
    names = snmp_walk(oid_names, @host, @snmp)
  end

 ################################ set_ports

  def set_port_admin_status(port_num, value)
    oid_admin_status= get_oid("setAdminStatus")
    case value
      when "up" then num = 1
      when "down" then num = 2   
    end 
    snmp_set_integer("#{oid_admin_status}.#{port_num}", num, @host, @snmp)
  end

  def set_port_name(port_num, value)
    oid_port_name= get_oid("setPortName")
    snmp_set_string("#{oid_port_name}.#{port_num}", value, @host, @snmp)
  end

  def set_port_speed_duplex(port_num, value)
    oid_port_speed_duplex= get_oid("setPortSpeedDuplex")
    snmp_set_integer("#{oid_port_speed_duplex}.#{port_num}", value, @host, @snmp)
  end

  def set_port_pvid(pvid, value)
    oid_port_pvid= get_oid("setPVID")
    snmp_set_integer("#{oid_port_pvid}.#{pvid}", value, @host, @snmp)
  end

 ################################ get_vlans
  def get_vid
    oid_vid = get_oid("walkVlanID")
    vlan_vid = snmp_walk(oid_vid, @host, @snmp)
  end

  def get_vlan_name(vid)
    oid_vlan_name = get_oid("getVlanName")
    vlan_name = snmp_get("#{oid_vlan_name}.#{vid}", @host, @snmp).to_s
  end

  def get_port_tag(vid)
    oid_ports_tag = get_oid("getPortsTag")
    vlan_port_tag = snmp_get("#{oid_ports_tag}.#{vid}", @host, @snmp).to_s.split("")
    decoder_for_tag_untag(vlan_port_tag)
  end

  def get_port_untag(vid)
    oid_ports_untag = get_oid("getPortsUntag")
    vlan_port_untag = snmp_get("#{oid_ports_untag}.#{vid}", @host, @snmp).to_s.split("")
    decoder_for_tag_untag(vlan_port_untag)
  end



  def get_vlan_activate(vid)
    oid_vlan_active = get_oid("getVlanActive")
    vlan_activate = snmp_get("#{oid_vlan_active}.#{vid}", @host, @snmp).to_i
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


  def input_format_ports (ports_string)
    ports_arrey =  ports_string.split(",")
    ports = []
    ports_arrey.each do |port_arrey|
      if !port_arrey.slice("-").nil?
        block_ports  = port_arrey.scan(/\d+/)
        (block_ports[0]..block_ports[1]).each { |ii| ports << ii.to_i}
      else
        ports << port_arrey.to_i
      end
    end
    ports
  end
 ################################ walk mac-table
  
  def search_all_mac
    oid_mac_table = get_oid("walkPortMac")
    walk_all_data = snmp_walk_all_data(oid_mac_table, @host, @snmp)
    walk_all_data[:vlan] =[]
    walk_all_data[:mac] = []
    walk_all_data[:oid].each do |walk_data|
      walk_all_data[:vlan] << walk_data[-7].to_i
      walk_all_data[:mac] << walk_data[-6..-1].map! {|mac| mac.to_i.to_s(16)}
    end
    walk_all_data[:mac].map! do |mac|
      mac.map! do |piece_mac|
        if piece_mac.length == 1 
          piece_mac = "0#{piece_mac}" 
        else
          piece_mac
        end
      end
    end
    result = []
    walk_all_data[:value].each_index do |i|
      result << [walk_all_data[:mac][i].join(":"),walk_all_data[:vlan][i], walk_all_data[:value][i]]
    end
    result
  end
 
 def search_mac(mac)
  result = []
  search_all_mac.each do |mac_data|
    result << mac_data if mac_data[0] == mac
  end
  result
 end
 
 def search_mac_for_vid(vid)
  result = []
  search_all_mac.each do |mac_data|
    result << mac_data if mac_data[1] == vid.to_i
  end
  result
 end
 
 def search_mac_for_port(port)
  result = []
  search_all_mac.each do |mac_data|
    result << mac_data if mac_data[2] == port
  end
  result
 end
 ################################ TELNET COMMANDS


  def vlan_port_forbidden(vid)
     commands  = ["en", @pass, "show vlan #{vid}"]
     log = new_connection(@host,@login, @pass, commands)
     result = "#{log.slice(/(?<=Forbidden ports : )[\d,\-]+/)}"
     input_format_ports (result)
  end

  def commands_for_destroy_vlan(id, vlans_info)
        p vlans_info
    commands  = ["en", @pass, "clear vlan #{id} name"]
    vlans_info[:vlan_vid].each_index do |i|
      if vlans_info[:vlan_vid][i] == id
        commands << "set vlan #{id} disable" if !vlans_info[:vlan_activate][i].nil?  
        commands << "set vlan #{id} delete port #{vlans_info[:vlan_port_untag][i]}" if !vlans_info[:vlan_port_untag][i].nil?
        commands << "set vlan #{id} delete port #{vlans_info[:vlan_port_tag][i]}" if !vlans_info[:vlan_port_tag][i].nil?
        commands << "set vlan #{id} permit port #{vlans_info[:vlan_port_untag][i]}" if !vlans_info[:vlan_port_forbidden][i].nil?
      end
    end
    p commands
    commands
  end

  def commands_for_create_update_vlan(param_vlan)
    commands = ["en", @pass, "create vlan #{param_vlan[:vid]} name #{param_vlan[:name]}"]
    commands << "set vlan #{param_vlan[:vid]} enable" if !param_vlan[:active].nil?
    result = { tag: "", untag: "", forbidden: ""}
    (1..get_ports_count).each do |num_port|
      case param_vlan["#{num_port}".to_sym][:port_param]
        when "tag" then result[:tag] << "#{num_port},"
        when "untag" then result[:untag] << "#{num_port},"
        when "forbidden" then result[:forbidden] << "#{num_port},"
      end 
    end
    commands << "set vlan #{param_vlan[:vid]} add port #{result[:tag][0..-2]} tag" if !result[:tag].nil?
    commands << "set vlan #{param_vlan[:vid]} add port #{result[:untag][0..-2]} untag" if !result[:untag].nil?
    commands << "set vlan #{param_vlan[:vid]} forbid port #{result[:forbidden][0..-2]}" if !result[:forbidden].nil?
    commands
  end

 
end
