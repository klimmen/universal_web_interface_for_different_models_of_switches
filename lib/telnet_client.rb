module TelnetClient
  require 'net/telnet'

  def new_connection(host,login, pass, cmd_commands)
    localhost = Net::Telnet::new("Host" => host, 
    		              "Timeout" => 3,
                      "Prompt" => /(\>|\#|\:)/n)
  	#localhost.login(login, pass) { |c| print c }
  	localhost.cmd(login) { |c| print c }
    localhost.cmd(pass) { |c| print c }
    cmd_commands.each do |command|
  		p command
  		localhost.cmd(command) { |c| print c }
  	end
  	localhost.close
  end

end