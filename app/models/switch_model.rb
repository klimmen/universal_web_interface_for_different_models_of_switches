class SwitchModel < ActiveRecord::Base
  has_many :firmwares, dependent: :destroy

  validates :name, :presence => true
end


  

