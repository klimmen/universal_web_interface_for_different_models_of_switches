class CreateFirmwares < ActiveRecord::Migration
  def change
    create_table :firmwares do |t|
      t.string :name, :null => false
      t.belongs_to :switch_model, index: true, :null => false

      t.timestamps null: false
    end
  end
end
