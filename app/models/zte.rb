class Zte

	def initialize(host, snmp)
		@host = host
		@snmp = snmp
  end

	def def_firmware(model)
		model.slice(/(?<=Version: ).+/)
	end

	def mac(model, firmware)
		value_oid = ValueOid.find_by_name("getSwitchMAC")
		mib = Mib.new
		p model.class
		p firmware
		p value_oid
		mib.first_param(@host, @snmp)
p  SwitchModel.find_by_name(model.to_s)
		result_mib = SwitchModel.find_by_name(model).firmwares.find_by_name(firmware).mibs.find_by_value_oid_id(value_oid.id)
		p result_mib
		mac = mib.snmp_get(result_mib.name).unpack("H2H2H2H2H2H2").join(":")
	end


	def ports
	end

end