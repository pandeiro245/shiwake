class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :team_id
      t.string  :options
      t.string :pattern

      t.timestamps null: false
    end
  end
end
