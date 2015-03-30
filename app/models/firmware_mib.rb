class FirmwareMib < ActiveRecord::Base
  belongs_to :firmware
  belongs_to :mib

  validates :name, presence: true
end
