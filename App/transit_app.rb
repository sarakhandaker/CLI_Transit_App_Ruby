require 'geocoder'
require_relative "./commute_CRUD.rb"
require_relative "./bus_stop_CRUD.rb"

class TransitApp 
    include CommuteCRUD
    include BusStopCRUD
    attr_reader :user
    def run
        system 'clear'
        welcome 
        log_in_and_sign_up
        menu_method
    end 
    def menu_method
        output_menu
        response= gets.chomp
        system 'clear'
        menu_response(response)
    end
    def welcome
        print "Welcome to King County Metro Transit App \nThis CLI app allows you to look up the nearest KC Metro Stop to any address!\nFrom there you can save and label your stops and organize your commutes"
        puts " _________________________ "  
        puts "|   |     |     |    | |  | " 
        puts "|___|_____|_____|____|_|__ \\ "
        puts "|KING COUNTY METRO   | |   | "
        puts "`--(o)(o)--------------(o)-- " 
        puts "```````````````````````````````````"
    end 
    def output_menu
        puts "\nPlease choose from the following options\n"
        puts "1. View, save and update your saved bus stops"
        puts "2. View, save and update your commutes"
        puts "3. Update user address"
        puts "4. Delete user"
        puts "5. Exit transit app \n"
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
                puts  "Error: invalid value, please select from the following menu options\n"
            menu_method
            end
    end
    def log_in_and_sign_up
        puts "What's your username\n"
        name = gets.chomp.downcase
        @user = User.find_or_create_by(username:name)
        puts "Welcome #{@user.username.capitalize}"
        system 'clear'
        if !@user.address
            puts "Please enter your address\n"
            address = gets.chomp 
            @user.update(address: address)
            set_home_stop
        end
    end 
    def set_home_stop
        array=@user.closest_stop
        puts "\nWould you like to set #{array[0].stop_name} that is #{array[1]} miles away as your 'Home' bus stop? (Yes/No)"
        res=gets.chomp.downcase
        if res=="yes"
            UserStop.create(user_id: @user.id, stop_id: array[0].id, label: "home")
            puts "Bus stop #{array[0].stop_name} has been saved as Home\n\n"
        end
    end
    def user_stops
        output_stops_menu
        stop_response=gets.chomp
        stop_menu_response(stop_response)
    end 
    def update_address
        puts "Please enter your new address\n"
        address = gets.chomp 
        @user.update(address: address)
        set_home_stop
        menu_method
    end
    def delete_user
        @user.destroy
        puts "\nYour account has been deleted!\n\n"
        exit_app
    end
    def exit_app
        puts "\nSafe Travels!"
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
    close_stop=Stop.all.min_by{|stop| distance_calc([stop.stop_lat, stop.stop_lon],loc_array)}
    d=distance_calc([close_stop.stop_lat, close_stop.stop_lon],loc_array)
    [close_stop, d.round(2)]
end

def distance_calc(loc1, loc2)
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