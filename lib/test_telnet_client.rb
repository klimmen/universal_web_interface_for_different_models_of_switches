module TestTelnetClient
  require 'net/telnet'

  def new_connection(host,login, pass, cmd_commands)

  	log = ""
    case cmd_commands
      when "show vlan 1" then return log << "Forbidden ports : 4"

  	end

    log
  end

end

