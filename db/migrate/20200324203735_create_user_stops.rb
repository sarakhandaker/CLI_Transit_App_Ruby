class CreateUserStops < ActiveRecord::Migration[5.0]
  def change
    create_table :user_stops do |t|
      t.integer :user_id
      t.integer :stop_id
      t.string :label
    end
  end
end
