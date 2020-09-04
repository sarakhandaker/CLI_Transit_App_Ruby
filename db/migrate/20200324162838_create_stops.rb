class CreateStops < ActiveRecord::Migration[5.0]
    def change
      create_table :stops do |t|
        t.integer :stop_id_KC
        t.integer :stop_code
        t.string :stop_name
        t.string :stop_desc
        t.float :stop_lat
        t.float :stop_lon
        t.integer :zone_id
        t.string :stop_url
        t.string :location_type
        t.string :parent_station
        t.string :stop_timezone
      end
    end
end
