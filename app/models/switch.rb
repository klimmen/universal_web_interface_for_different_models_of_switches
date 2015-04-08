class Switch < ActiveRecord::Base
	
  require 'resolv'
  validates :name, :presence => true,length: 2..20
  validates :ip, :presence => true, :uniqueness => true,
  :format => { :with => Resolv::IPv4::Regex }
  validates :login, :presence => true
  validates :pass, :presence => true
  validates :snmp, :presence => true


  def self.search(search)

    if search =~ /^\d+\.\d+/
      where('ip LIKE ?', "%#{search}%")
    elsif  search
      where('name LIKE ?', "%#{search}%")
     else
      all
    end
  end



end
