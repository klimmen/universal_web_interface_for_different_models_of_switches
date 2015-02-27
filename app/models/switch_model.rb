class SwitchModel < ActiveRecord::Base
  has_many :firmwares, dependent: :destroy
end


  

