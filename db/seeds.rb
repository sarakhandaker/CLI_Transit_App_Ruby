require 'pry'
Stop.destroy_all

data_arr = []
File.open("/Users/sarakhandaker/Flatiron/code/ruby-project-guidelines-seattle-web-030920/google_daily_transit/stops.txt").each do
    |line| data_arr<< line 
end
data_arr.shift
data_arr.each do |each_stop|
    each_stop=each_stop.split(",")
    each_stop[2]=each_stop[2][1...-1]
    Stop.create(
        stop_id_KC:   each_stop[0].to_i, 
        stop_code: each_stop[1].to_i, 
        stop_name: each_stop[2], 
        stop_desc: each_stop[3], 
        stop_lat: each_stop[4].to_f, 
        stop_lon: each_stop[5].to_f, 
        zone_id: each_stop[6].to_i, 
        stop_url: each_stop[7], 
        location_type: each_stop[8], 
        parent_station: each_stop[9], 
        stop_timezone: each_stop[10].chomp
    )
end