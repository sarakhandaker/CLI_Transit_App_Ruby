require 'pry'
require 'geocoder'
require_relative "./commute_CRUD.rb"
require_relative "./bus_stop_CRUD.rb"

class TransitApp 
    include CommuteCRUD
    include BusStopCRUD
    attr_reader :user
    def run
        welcome 
        log_in_and_sign_up
        menu_method
    end 
    def menu_method
        output_menu
        response= gets.chomp
        menu_response(response)
    end
    def welcome
        puts "Welcome to King County Metro Transit App"
        puts "This CLI app will allow you to look up the nearest KC Metro Stop to any address!"
        puts "From there you can save and label your stops and organize your commutes."
        puts "Enjoy!"
        puts " _________________________ "  
        puts "|   |     |     |    | |  | " 
        puts "|___|_____|_____|____|_|__ \\ "
        puts "|KING COUNTY METRO   | |   | "
        puts "`--(o)(o)--------------(o)-- " 
        puts "```````````````````````````````````"
    end 
    def output_menu
        puts ""
        puts "Please choose from the following options"
        puts ""
        puts "1. View, save and update your saved bus stops"
        puts "2. View, save and update your commutes"
        puts "3. Update user address"
        puts "4. Delete user"
        puts "5. Exit transit app"
        puts ""
    end 
    def menu_response(response)
            case response.to_i
            when 1 #CRUD for user's saved stops 
                user_stops
            when 2 #CRUD for user's saved commutes
                user_commutes
            when 3
                update_address
            when 4 
                delete_user
            when 5 #exiting app
                exit_app
            else #error message
                puts  "Error: invalid value, please select from the following menu options"
                puts ""
            menu_method
            end
    end
    def log_in_and_sign_up
        puts "What's your username"
        puts ""
        name = gets.chomp.downcase
        @user = User.find_or_create_by(username:name)
        puts "Welcome #{@user.username.capitalize}"
        if @user.address
        else 
            puts "Please enter your address"
            puts ""
            address = gets.chomp 
            @user.update(address: address)
            set_home_stop
        end
    end 
    def set_home_stop
        array=@user.closest_stop
        puts""
        puts "Would you like to set #{array[0].stop_name} that is #{array[1]} miles away as your 'Home' bus stop? (Yes/No)"
        res=gets.chomp.downcase
        if res=="yes"
            bus_stop_id=array[0].id
            UserStop.create(user_id: @user.id, stop_id: bus_stop_id, label: "home")
            puts "Bus stop #{array[0].stop_name} has been saved as Home"
            puts ""
            puts ""
        else 
        end
    end
    def user_stops
        output_stops_menu
        stop_response=gets.chomp
        stop_menu_response(stop_response)
    end 
    def update_address
        puts "Please enter your new address"
        puts ""
        address = gets.chomp 
        @user.update(address: address)
        set_home_stop
        menu_method
    end
    def delete_user
        @user.destroy
        puts ""
        puts "Your account has been deleted!"
        puts ""
        exit_app
    end
    def exit_app
        puts ""
        puts "Safe Travels!"
        puts " _________________________ "  
        puts "|   |     |     |    | |  | " 
        puts "|___|_____|_____|____|_|__ \\ "
        puts "|KING COUNTY METRO   | |   | "
        puts "`--(o)(o)--------------(o)-- " 
        puts "```````````````````````````````````"
        return
    end 
end 

def closest_stop(loc_array)
    d=100000
    closest_stop=nil
    stop_array=Stop.all
    stop_array.each do|stop|
        if distance_calc(stop,loc_array)<d
            closest_stop=stop
            d=distance_calc(stop, loc_array)
        end
    end
    array=[closest_stop, d.round(2)]
end

def distance_calc(stop, loc_array)
    loc1 =loc_array
    loc2 = [stop.stop_lat, stop.stop_lon]
     rad_per_deg = Math::PI/180  # PI / 180
     rm = 6371  * 1000             # Earth radius in kilometers to meters
     dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
     dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
     lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
     lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
     a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
     c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
     (rm * c)*0.000621371 # Delta in miles from meters
end

def distance_calc_stops(stop1, stop2)
    loc1 =[stop1.stop_lat, stop1.stop_lon]
    loc2 = [stop2.stop_lat, stop2.stop_lon]
     rad_per_deg = Math::PI/180  # PI / 180
     rm = 6371  * 1000             # Earth radius in kilometers to meters
     dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
     dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
     lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
     lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
     a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
     c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
     (rm * c)*0.000621371 # Delta in miles from meters
end