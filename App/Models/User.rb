require 'geocoder'
class User < ActiveRecord::Base
    has_many :user_stops
    has_many :stops, through: :user_stops
    has_many :commutes

    def location
        location = Geocoder.search(self.address)
        @array=[location[0].latitude, location[0].longitude]
    end

    def closest_stop
        self.location
        closest_stop=Stop.all.min_by{|stop| distance(stop)}
        d=distance(closest_stop)
        [closest_stop, d.round(2)]
    end

    def distance(stop)
        loc1 =@array
        loc2 = [stop.stop_lat, stop.stop_lon]
         rad_per_deg = Math::PI/180  # PI / 180
         dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
         dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
         lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
         lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
         a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
         c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
         (6371 * 1000 * c)*0.000621371 # Delta in miles from meters
       end
end