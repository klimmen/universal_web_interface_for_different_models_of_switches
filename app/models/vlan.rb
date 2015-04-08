class Vlan

  require 'json'
  if Rails.env.test?
    include TestTelnetClient
  else
    include TelnetClient
  end
	
  def initialize(switch, user, data)
		@host = switch.ip
		@snmp = switch.snmp
    @login = switch.login
    @pass = switch.pass
		@user = user
    @model = data[:model]
    @firmware = data[:firmware]
	end

	def check_model
    if @model.slice(/ZTE/)
      Zte.new(@host, @snmp, @model, @firmware, @login, @pass)
    elsif @model.slice(/(ES|MES)/)
      Zyxel.new(@host, @snmp, @model, @firmware, @login, @pass)     
    end
  end

  def vlans(data)
    result_vlans = {vlan_name: [], vlan_activate: [], vlan_port_untag: [],vlan_port_tag: [], vlan_port_forbidden: []}
    switch_class = check_model
    result_vlans[:vlan_vid]=switch_class.get_vid
    result_vlans[:vlan_vid].each do |vid|
    result_vlans[:vlan_name] << switch_class.get_vlan_name(vid)
    result_vlans[:vlan_port_tag] << output_format_ports(switch_class.get_port_tag(vid))
    result_vlans[:vlan_port_untag] << output_format_ports(switch_class.get_port_untag(vid))
    result_vlans[:vlan_port_forbidden]<<output_format_ports(switch_class.vlan_port_forbidden(vid))
    result_vlans[:vlan_activate] << switch_class.get_vlan_activate(vid)
    end
    File.open("tmp/cache/#{@user}_file_vlans_info.json", 'w'){ |file| file.write result_vlans.to_json }
    result_vlans
  end

  def ports_count
    switch_class = check_model
    switch_class.get_ports_count
  end

  def pvid
    switch_class = check_model
    switch_class.get_pvid
  end

  def create_vlan(param_vlan)
    switch_class = check_model   
    commands = switch_class.commands_for_create_update_vlan(param_vlan)
    new_connection(@host, @login, @pass, commands)
  end

  def edit_vlan(vid)
    switch_class = check_model
    result_vlans = {vid: vid}
    result_vlans[:pvid] = switch_class.get_pvid
    result_vlans[:name] = switch_class.get_vlan_name(vid)
    result_vlans[:tag] = switch_class.get_port_tag(vid)
    result_vlans[:untag] = switch_class.get_port_untag(vid)
    result_vlans[:forbidden] = switch_class.vlan_port_forbidden(vid)
    result_vlans[:activate] = switch_class.get_vlan_activate(vid)
    File.open("tmp/cache/#{@user}_file_vlan_info.json", 'w'){ |file| file.write  result_vlans.to_json }

    result_vlans
  end

  def update_vlan(vid, param_vlan)
    port_pvids = []
    param_vlan.each do |key, value|
       port_pvids << value["pvid"] if !key.slice(/\d+/).nil?
    end
   
    switch_class = check_model
    param_vlan[:vid] = vid
    
    commands = switch_class.commands_for_create_update_vlan(param_vlan)
    new_connection(@host, @login, @pass, commands)
    
    file = File.read("tmp/cache/#{@user}_file_vlan_info.json")
    pvid_info_from_file = JSON.parse(file, {:symbolize_names => true})

    port_pvids.each_index do |i|
      if port_pvids[i] != pvid_info_from_file[:pvid][i]
        switch_class.set_port_pvid(i+1, port_pvids[i])
      end
    end
  end

  def destroy(id)
    switch_class = check_model
    file = File.read("tmp/cache/#{@user}_file_vlans_info.json")
    vlans_info = JSON.parse(file, {:symbolize_names => true})
    commands = switch_class.commands_for_destroy_vlan(id, vlans_info)
    new_connection(@host,@login, @pass, commands)
  end

  def output_format_ports (ports_arrey)
    result_string = ""
    ports_arrey.each_index do |i|
      if ports_arrey[i-1] == ports_arrey[i]-1 && ports_arrey[i+1] == ports_arrey[i]+1 
        result_string.chomp!(",")
        result_string << "-" if result_string[-1] != "-" 
      else
        if ports_arrey.size-1 != i    
          result_string << "#{ports_arrey[i]},"
        else
          result_string << "#{ports_arrey[i]}"
        end
      end
    end
    result_string
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



end