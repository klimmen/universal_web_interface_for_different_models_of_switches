class CreateMibs < ActiveRecord::Migration
  def change
    create_table :mibs do |t|
      t.string :name, :null => false
      t.belongs_to :value_oid, index: true, :null => false

      t.timestamps null: false
    end
  end
end
