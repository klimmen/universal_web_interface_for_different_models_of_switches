class CreateValueOids < ActiveRecord::Migration
  def change
    create_table :value_oids do |t|
      t.string :name, :null => false

      t.timestamps null: false
    end
  end
end
