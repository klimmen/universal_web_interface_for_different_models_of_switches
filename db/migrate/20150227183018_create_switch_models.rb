class CreateSwitchModels < ActiveRecord::Migration
  def change
    create_table :switch_models do |t|
      t.string :name, :null => false

      t.timestamps null: false
    end
  end
end
