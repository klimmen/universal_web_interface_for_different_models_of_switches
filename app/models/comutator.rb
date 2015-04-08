class Comutator

  if Rails.env.test?
    include TestZyxelSnmpClient
  else
    include SnmpClient
  end

  require 'json'
  def initialize(switch, user)
	 @switch_name = switch.name
	 @host = switch.ip
	 @snmp = switch.snmp
	 @user = user
  end

  def check_switch_info
  	if File.file?("tmp/cache/#{@user}_file_switch_info.json")
  		file = File.read("tmp/cache/#{@user}_file_switch_info.json")
    	check_switch_model_firmware = JSON.parse(file, {:symbolize_names => true})
    	if check_switch_model_firmware[:ip] == @host
    		check_switch_model_firmware
    	else
      	switch_info
    	end
		else
			switch_info
		end

		if check_switch_model_firmware[:ip] == @host
    	check_switch_model_firmware
    else
      switch_info
    end
  end

  def switch_info
		model =snmp_get("1.3.6.1.2.1.1.1.0", @host,@snmp).to_s
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
	  File.open("tmp/cache/#{@user}_file_switch_info.json", 'w'){ |file| file.write  result.to_json }
    result
  end
end


