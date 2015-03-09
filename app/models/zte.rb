class Zte

	def initialize(host, snmp)
		@host = host
		@snmp = snmp
  end

	def def_firmware(model)
		model.slice(/(?<=Version: ).+/)
	end

	def mac(model, firmware, host, snmp)
		value_oid = ValueOid.find_by_name("getSwitchMac")
		mib = Mib.new
		mib.first_param(@host, @snmp)
		result_mib = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id)
		mac = mib.snmp_get_test(result_mib.name)
	end


	def ports
	end

end