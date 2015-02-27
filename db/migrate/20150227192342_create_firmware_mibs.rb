class CreateFirmwareMibs < ActiveRecord::Migration
  def change
    create_table :firmware_mibs do |t|
      t.belongs_to :firmware, index: true, :null => false
      t.belongs_to :mib, index: true, :null => false

      t.timestamps null: false
    end
  end
end
