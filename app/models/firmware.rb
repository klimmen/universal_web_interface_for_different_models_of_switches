class Firmware < ActiveRecord::Base
  belongs_to :switch_model
  has_many :firmware_mibs
  has_many :mibs, through: :firmware_mibs

  validates :name, presence: true
end
