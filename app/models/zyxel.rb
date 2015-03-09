class Zyxel

	def initialize(host, snmp, model = nil, firmware = nil)
		@host = host
		@snmp = snmp
		@model = model
		@firmware = firmware
  end

	def def_firmware(model)
		rusult_value_oids = []
		(1..7).each do |i|
		  rusult_value_oids << ValueOid.find_by_name("getFirmwarePart_#{i}")
		end
		
		mib = Mib.new
		mib.first_param(@host,@snmp)
		switch_model = SwitchModel.find_by_name(model)
		rusult_firmware = ""
		firmware = switch_model.firmwares.first
		rusult_value_oids.each do |rusult_value_oid|
			rusult_firmware << mib.snmp_get_test(firmware.mibs.find_by_value_oid_id(rusult_value_oid.id).name)
		end
		rusult_firmware	
	end

	def mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMac")
		mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id)
		mac = mib.snmp_get_test(result_mib.name)
	end

	def port_admin_status
		value_oid = ValueOid.find_by_name("walkPortAdminStatus")
		mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id)
		admin_status = mib.test_snmp_walk(result_mib.name)

		admin_status.map! do |status|
  		if status == 1
  			true 
  		elsif status == 2
  			false
  		end  			
  	end
	end	
  
  def port_name
  	value_oid = ValueOid.find_by_name("walkPortName")
  	mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id)
		names = mib.test_snmp_walk(result_mib.name)
  	names.map! {|name| name.to_sym}
  end
  
  def port_type
  	value_oid = ValueOid.find_by_name("walkPortType")
  	mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id)
		mib.test_snmp_walk(result_mib.name)
  end
  
  def port_speed_duplex
  	value_oid = ValueOid.find_by_name("walkPortSpeedDuplex")
  	mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(@model).firmwares.find_by_name(@firmware).mibs.find_by_value_oid_id(value_oid.id)
		mib.test_snmp_walk(result_mib.name)
  end

end


