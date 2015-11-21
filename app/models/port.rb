class Port

  require 'json'
  
	def initialize(switch, user)
		@host = switch.ip
		@snmp = switch.snmp
		@user = user
	end

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
    result_ports[:port_pvid]=switch_class.get_pvid
 		File.open("tmp/cache/#{@user}_file_ports_info.json", 'w'){ |file| file.write  result_ports.to_json }
  	result_ports
  end


  def update_ports(ports_info_from_view)
  	port_admin_status = []
  	port_name = []
  	port_speed_duplex = []
    port_pvid = []
 		ports_info_from_view.each do |key, value|
			port_admin_status << value["port_status"]
  		port_name << value["port_name"]
  		port_speed_duplex << value["port_speed_duplex"]
      port_pvid << value["port_pvid"]
 		end
  	file = File.read("tmp/cache/#{@user}_file_ports_info.json")
    ports_info_from_file = JSON.parse(file, {:symbolize_names => true})
    
    file = File.read("tmp/cache/#{@user}_file_switch_info.json")
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

      if port_pvid[i] != ports_info_from_file[:port_pvid][i]
        switch_class.set_port_pvid(i+1, port_pvid[i])
      end

    end
  end
end