class CreateFilterLogics < ActiveRecord::Migration
  def change
    create_table :filter_logics do |t|
      t.integer :user_id, :null => false
      t.string :keyword
      t.timestamps null: false
    end
  end
end
