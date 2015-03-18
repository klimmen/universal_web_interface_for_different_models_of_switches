module TelnetClient
  require 'net/telnet'

  def new_connection(host,login, pass, cmd_commands)
    localhost = Net::Telnet::new("Host" => host, 
    		              "Timeout" => 3,
                      "Prompt" => /(\>|\#|\word:|ESC)/n)
  	#localhost.login(login, pass) { |c| print c }
  	log = ""
    localhost.cmd(login) { |c| print c }
    localhost.cmd(pass) { |c| print c }
    cmd_commands.each do |command|
  		localhost.cmd(command) { |c| print c; log << c }
  	end
  	localhost.close
    log
  end

end