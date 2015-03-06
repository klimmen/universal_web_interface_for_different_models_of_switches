class Zyxel
	def def_firmware(host,snmp)
		id_value_oids = {}
		value_oids = ValueOid.all
		value_oids.each do |value_oid|
			firmwape_part_num =  value_oid.name.slice(/(?<=getFirmwarePart_)\d/)
			id_value_oids[firmwape_part_num.to_i] = value_oid.id if !firmwape_part_num.nil?
		end
		mib = Mib.new
		mib.first_param(host,snmp)
		firmwares = Firmware.all
		firmware_results = []
		firmwares.each do |firmware|
			i = 0
			(1..7).each do |i|
				mib_name = firmware.mibs.find_by_value_oid_id(id_value_oids[i])
				if !mib_name.nil?
					i+=1
					firmware_results << mib.snmp_get_test(mib_name.name)
				end
  		end
  		break if i == 7
		end  
	  firmwares.each do |firmware|
	    i = 0
			firmware_results.each do |firmware_result|
   			i +=1 if !firmware.name.slice(/#{firmware_result}/).nil?
			end
			if i == 7
				p firmware.name
			  return firmware 
		  end
		end 
	end
end
