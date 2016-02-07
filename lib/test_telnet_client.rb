module TestTelnetClient
  require 'net/telnet'

  def new_connection(host,login, pass, cmd_commands)
  	log = ""
    cmd_commands.each do |command|
      case command
        when /show vlan/
          log = json_parse(command) || ''
        when /create vlan/
          vlan_id = command.sub('create vlan ', '').sub(' name test', '').to_i
          vlan_name = command.slice(/(?<= name ).+/)
          file = IO.read('172_24_18_195.json')
          json = JSON.parse(file)
          json['1.3.6.1.4.1.3902.15.2.11.3.4.1.1'] = (json['1.3.6.1.4.1.3902.15.2.11.3.4.1.1'].push vlan_id.to_s).sort_by { |i| i.to_i }.uniq
          json["1.3.6.1.2.1.17.7.1.4.3.1.1.#{vlan_id}"] = vlan_name
          json["1.3.6.1.4.1.3902.15.2.11.3.3.1.6.#{vlan_id}"] = cmd_commands.include?("set vlan #{vlan_id} enable")? "1" : "2"
          File.open('172_24_18_195.json',"w") do |f|
            f.write(JSON.pretty_generate(json))
          end
        when /forbid/
          vlan_id = command.slice(/(?<=set vlan )\d+/)
          ports =  command.sub("set vlan #{vlan_id} forbid port ",'')
          file = IO.read('172_24_18_195.json')
          json = JSON.parse(file)
          json["show vlan #{vlan_id}"] = "Forbidden ports : #{ports}"
          File.open('172_24_18_195.json',"w") do |f|
            f.write(JSON.pretty_generate(json))
          end
        when /untag/
          if command.include?('set vlan')
            vlan_id = command.slice(/(?<=set vlan )\d+/)
            ports =  command.sub("set vlan #{vlan_id} add port ",'').sub(' untag', '')
            file = IO.read('172_24_18_195.json')
            json = JSON.parse(file)
            json["1.3.6.1.2.1.17.7.1.4.2.1.5.#{vlan_id}"] = coder(ports)
            File.open('172_24_18_195.json',"w") do |f|
              f.write(JSON.pretty_generate(json))
            end
          end
        when /tag/
          if !(command.include?('untag')) && command.include?('set vlan')
            vlan_id = command.slice(/(?<=set vlan )\d+/)
            ports =  command.sub("set vlan #{vlan_id} add port ",'').sub(' tag', '')
            file = IO.read('172_24_18_195.json')
            json = JSON.parse(file)
            json["tag #{vlan_id}"] = coder(ports)
            json["1.3.6.1.4.1.3902.15.2.11.3.3.1.4.#{vlan_id}"] = coder(ports)
            File.open('172_24_18_195.json',"w") do |f|
              f.write(JSON.pretty_generate(json))
            end
          end
          #"clear vlan 8 name"
        when /clear vlan/
          vlan_id =command.sub('clear vlan ', '').sub(' name', '')
          file = IO.read('172_24_18_195.json')
          json = JSON.parse(file)
          json.delete("1.3.6.1.2.1.17.7.1.4.3.1.1.#{vlan_id}")
          json.delete("1.3.6.1.4.1.3902.15.2.11.3.3.1.6.#{vlan_id}")
          json.delete("1.3.6.1.4.1.3902.15.2.11.3.3.1.4.#{vlan_id}")
          json.delete("1.3.6.1.2.1.17.7.1.4.2.1.5.#{vlan_id}")
          json.delete("show vlan #{vlan_id}")
          json["1.3.6.1.4.1.3902.15.2.11.3.4.1.1"].delete(vlan_id)
          File.open('172_24_18_195.json',"w") do |f|
            f.write(JSON.pretty_generate(json))
          end
      end
    end
    log
  end

  def json_parse(oid)
    file = IO.read('172_24_18_195.json')
    my_hash = JSON.parse(file)
    my_hash[oid]
  end

  def update_value(oid_set, port, value)
    file = IO.read('172_24_18_195.json')
    json = JSON.parse(file)
    json[oid_set][port -1] = value.to_s
    File.open('172_24_18_195.json',"w") do |f|
      f.write(JSON.pretty_generate(json))
    end
  end


  def coder(ports_str)
    ports = ports_str.split(",").map {|port| port.to_i }
    all_ports = (1..13).collect{|port| [(port-1)*4+1,(port-1)*4+2,(port-1)*4+3, (port-1)*4+4 ]}
    rezult1 = all_ports.map {|port| port & ports}
    rezult = []
    rezult1.each_index do |i|
      if rezult1[i].present?
        rezult << coder_port(i, rezult1[i])
      else
        rezult << 0
      end
    end
    (rezult + [0]).join("")
  end

  def coder_port(i, ports)
    sum = 0
    ports.each do |port|
      port = port - i*4
      case port
        when 1 then sum += 8
        when 2 then sum += 4
        when 3 then sum += 2
        when 4 then sum += 1
      end
    end
    sum.to_s(16)
  end

end

