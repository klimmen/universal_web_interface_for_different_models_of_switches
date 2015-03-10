class Switch < ActiveRecord::Base
	
  require 'resolv'
  validates :name, :presence => true,length: 2..20
  validates :ip, :presence => true, :uniqueness => true,
  :format => { :with => Resolv::IPv4::Regex }
  validates :login, :presence => true
  validates :pass, :presence => true
  validates :snmp, :presence => true
  


 # def check_mac
 # 	.unpack("H2H2H2H2H2H2").join(":")
 # end

end
