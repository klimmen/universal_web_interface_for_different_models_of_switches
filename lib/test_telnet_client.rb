module TestTelnetClient
  require 'net/telnet'

  def new_connection(host,login, pass, cmd_commands)
  	log = ""
    case cmd_commands
      when "show vlan 1" then return log << "zte(cfg)#show vlan 998 VlanId  : 998   VlanStatus: enabled  VlanName: TEST_VLAN VlanMode: Static  Tagged ports    : 3 Untagged ports  : 5 Forbidden ports : 4"
  	else cmd_commands
    end
    log
  end

end
