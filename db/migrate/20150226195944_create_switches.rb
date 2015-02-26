class CreateSwitches < ActiveRecord::Migration
  def change
    create_table :switches do |t|
      t.string :name, :null => false
      t.string :ip, :null => false
      t.string :login, :null => false, default: "admin"
      t.string :pass, :null => false, default: "1234" 
      t.string :snmp, :null => false, default: "public"

      t.timestamps null: false
    end
    add_index :switches, :ip
    add_index :switches, :name

  end
end
