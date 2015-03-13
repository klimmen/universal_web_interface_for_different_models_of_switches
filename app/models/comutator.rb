class Comutator
require 'json'
def initialize(switch, user)
	@switch_name = switch.name
	@host = switch.ip
	@login = switch.login
	@pass = switch.pass
	@snmp = switch.snmp
	@user = user
end

  def check_switch_info
  	file = File.read("public/#{@user}_file_switch_info.json")
    check_switch_model_firmware = JSON.parse(file, {:symbolize_names => true})
		if check_switch_model_firmware[:ip] == @host
    	check_switch_model_firmware
    else
      switch_info
    end
  end

  def switch_info
		model = Mib.snmp_get("1.3.6.1.2.1.1.1.0", @host,@snmp).to_s
		if model.slice(/ZTE/)
			zte = Zte.new(@host, @snmp)
			firmware =  zte.get_firmware(model)
			model = model.slice(/.+(?=,)/)
			mac = zte.get_mac(model, firmware)
		elsif model.slice(/(ES|MES)/) 
			zyxel = Zyxel.new(@host, @snmp)
			firmware = zyxel.get_firmware(model)
			mac = zyxel.get_mac(model, firmware)
	  end
	  result = {name: @switch_name, ip: @host, model: model, firmware: firmware, mac: mac}
	  File.open("public/#{@user}_file_switch_info.json", 'w'){ |file| file.write  result.to_json }
    result
  end
###################### ports
  def ports(data)
		result_ports = {}
  	if data[:model].slice(/ZTE/)
  		switch_class = Zte.new(@host, @snmp, data[:model], data[:firmware])
  	elsif data[:model].slice(/(ES|MES)/)
  		switch_class = Zyxel.new(@host, @snmp, data[:model], data[:firmware])  		
  	end
  	result_ports[:ports_count]=switch_class.get_ports_count
 		result_ports[:port_admin_status]=switch_class.get_port_admin_status
 		result_ports[:port_name]=switch_class.get_port_name
		result_ports[:port_link_state]=switch_class.get_link_state
	 	result_ports[:port_type]=switch_class.get_port_type
 		result_ports[:port_speed_duplex]=switch_class.get_port_speed_duplex
 		result_ports[:port_select_options_speed_duplex] = switch_class.get_view_port_types(result_ports[:port_type])
 		File.open("public/#{@user}_file_ports_info.json", 'w'){ |file| file.write  result_ports.to_json }
  	result_ports
  end


  def update_ports(ports_info_from_view)
  	port_admin_status = []
  	port_name = []
  	port_speed_duplex = []
 		ports_info_from_view.each do |port|
			port_admin_status << port[1]["port_status"]
  		port_name << port[1]["port_name"]
  		port_speed_duplex << port[1]["port_speed_duplex"]
 		end
  	file = File.read("public/#{@user}_file_ports_info.json")
    ports_info_from_file = JSON.parse(file, {:symbolize_names => true})
    
    file = File.read("public/#{@user}_file_switch_info.json")
    switch_info = JSON.parse(file, {:symbolize_names => true})

    if switch_info[:model].slice(/ZTE/)
  		switch_class = Zte.new(@host, @snmp, switch_info[:model], switch_info[:firmware])
  	elsif switch_info[:model].slice(/(ES|MES)/)
  		switch_class = Zyxel.new(@host, @snmp, switch_info[:model], switch_info[:firmware])  		
  	end
    
    port_admin_status.each_index do |i|

    	if port_admin_status[i] != ports_info_from_file[:port_admin_status][i]
    		switch_class.set_port_admin_status(i+1, port_admin_status[i])
    	end

      if port_name[i] != ports_info_from_file[:port_name][i]
        switch_class.set_port_name(i+1, port_name[i])
      end

      if port_speed_duplex[i] != ports_info_from_file[:port_speed_duplex][i]
        switch_class.set_port_speed_duplex(i+1, port_speed_duplex[i])
      end
    end
  end
  	
##################### vlans
  def vlans(data)
    result_vlans = {vlan_name: [], vlan_activate: [], vlan_port_untag: []}
    
    if data[:model].slice(/ZTE/)
      switch_class = Zte.new(@host, @snmp, data[:model], data[:firmware])
    elsif data[:model].slice(/(ES|MES)/)
      switch_class = Zyxel.new(@host, @snmp, data[:model], data[:firmware])     
    end

    result_vlans[:vlan_vid]=switch_class.get_vid
    result_vlans[:vlan_vid].each do |vid|
      result_vlans[:vlan_name] << switch_class.get_vlan_name(vid)
    #  result_vlans[:vlan_port_tag]=switch_class.get_port_tag(vid)
      result_vlans[:vlan_port_untag] << switch_class.get_port_untag(vid)
    # result_vlans[:vlan_port_forbid]=switch_class.get_port_forbid(vid)
       result_vlans[:vlan_activate] << switch_class.get_vlan_activate(vid)
    end
    p result_vlans
  end

end


