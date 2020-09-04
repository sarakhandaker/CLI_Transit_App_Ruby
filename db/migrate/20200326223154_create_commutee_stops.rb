class CreateCommuteeStops < ActiveRecord::Migration[5.0]
  def change
    create_table :commute_stops do |t|
      t.integer :commute_id
      t.integer :stop_id
      t.string :label
    end
  end
end