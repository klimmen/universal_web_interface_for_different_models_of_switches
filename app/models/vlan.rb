class Vlan

  require 'json'
  include TelnetClient
	
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
      Zte.new(@host, @snmp, @model, @firmware)
    elsif @model.slice(/(ES|MES)/)
      Zyxel.new(@host, @snmp, @model, @firmware)     
    end
  end

  def vlans(data)
    result_vlans = {vlan_name: [], vlan_activate: [], vlan_port_untag: [],vlan_port_tag: [], vlan_port_forbidden: []}
    switch_class = check_model
    result_vlans[:vlan_vid]=switch_class.get_vid
    result_vlans[:vlan_vid].each do |vid|
    result_vlans[:vlan_name] << switch_class.get_vlan_name(vid)
    result_vlans[:vlan_port_tag] << switch_class.get_port_tag(vid)
    result_vlans[:vlan_port_untag] << switch_class.get_port_untag(vid)
    result_vlans[:vlan_port_forbidden]<<switch_class.vlan_port_forbidden(vid)
    result_vlans[:vlan_activate] << switch_class.get_vlan_activate(vid)
    end
    File.open("public/#{@user}_file_vlans_info.json", 'w'){ |file| file.write  result_vlans.to_json }
    result_vlans
  end

  def ports_count
    switch_class = check_model
    switch_class.get_ports_count
  end

  def create_vlan(param_vlan)
    switch_class = check_model
    commands = switch_class.commands_for_create_vlan(@pass, param_vlan)
    new_connection(@host, @login, @pass, commands)
  end

  def destroy(id)
    switch_class = check_model
    file = File.read("public/#{@user}_file_vlans_info.json")
    vlans_info = JSON.parse(file, {:symbolize_names => true})
    commands = switch_class.commands_for_destroy_vlan(@pass, id, vlans_info)
    new_connection(@host,@login, @pass, commands)
  end

end