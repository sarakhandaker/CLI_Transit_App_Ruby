require 'geocoder'
class User < ActiveRecord::Base
    has_many :user_stops
    has_many :stops, through: :user_stops
    has_many :commutes

    def location
        location = Geocoder.search(self.address)
        location[0].latitude
        location[0].longitude
        @array=[location[0].latitude, location[0].longitude]
    end

    def closest_stop
        d=100000
        closest_stop=nil
        stop_array=Stop.all
        self.location
        stop_array.each do|stop|
            if distance(stop)<d
                closest_stop=stop
                d=distance(stop)
            end
        end
        array=[closest_stop, d.round(2)]
    end

    def distance (stop)
        loc1 =@array
        loc2 = [stop.stop_lat, stop.stop_lon]
  
         rad_per_deg = Math::PI/180  # PI / 180
         rkm = 6371                  # Earth radius in kilometers
         rm = rkm * 1000             # Radius in meters
       
         dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
         dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
       
         lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
         lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
       
         a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
         c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
       
         (rm * c)*0.000621371 # Delta in miles from meters
       end
end