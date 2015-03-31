class ValueOid < ActiveRecord::Base
  has_many :mibs, dependent: :destroy

  validates :name, presence: true
end
