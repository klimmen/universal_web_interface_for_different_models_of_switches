class Vlan

  require 'json'
  
	def initialize(switch, user)
		@host = switch.ip
		@snmp = switch.snmp
		@user = user
	end

	def vlans(data)
    result_vlans = {vlan_name: [], vlan_activate: [], vlan_port_untag: [],vlan_port_tag: []}
    
    if data[:model].slice(/ZTE/)
      switch_class = Zte.new(@host, @snmp, data[:model], data[:firmware])
    elsif data[:model].slice(/(ES|MES)/)
      switch_class = Zyxel.new(@host, @snmp, data[:model], data[:firmware])     
    end

    result_vlans[:vlan_vid]=switch_class.get_vid
    result_vlans[:vlan_vid].each do |vid|
      result_vlans[:vlan_name] << switch_class.get_vlan_name(vid)
      result_vlans[:vlan_port_tag] << switch_class.get_port_tag(vid)
      result_vlans[:vlan_port_untag] << switch_class.get_port_untag(vid)
    # result_vlans[:vlan_port_forbid]=switch_class.get_port_forbid(vid)
      result_vlans[:vlan_activate] << switch_class.get_vlan_activate(vid)
    end
    result_vlans
  end

end