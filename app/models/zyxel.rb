class Zyxel

	def def_firmware(model, host, snmp)
		value_oid = ValueOid.find_by_name("getFirmwarePart_3")
		mib = Mib.new
		mib.first_param(host,snmp)
		switch_models = SwitchModel.all
		switch_models.each do |switch_model|
			if switch_model.name == model 
				switch_model.firmwares.each do |firmware|
					mibb = firmware.mibs.find_by_value_oid_id(value_oid.id)
					if !mib.snmp_get_test(mibb.name).nil?
						return firmware.name
					end				
				end
			end	
		end

	end

end


