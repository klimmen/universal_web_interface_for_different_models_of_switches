class ValueOid < ActiveRecord::Base
  has_many :mibs, dependent: :destroy
end
