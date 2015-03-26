class MacTable

	def initialize(switch,data)
		@host = switch.ip
		@snmp = switch.snmp
    @login = switch.login
    @pass = switch.pass
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

	def search_mac(search_param)
		switch_class = check_model
		case search_param[:search_type]
			when "all" then switch_class.search_all_mac
			when "mac" then switch_class.search_mac(search_param[:search_value])
			when "vid" then switch_class.search_mac_for_vid(search_param[:search_value])
			when "port" then switch_class.search_mac_for_port(search_param[:search_value])
		end						
	end
end