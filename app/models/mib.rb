class Mib < ActiveRecord::Base
    belongs_to :value_oid
    has_many :firmware_mibs
    has_many :firmwares, through: :firmware_mibs
end
