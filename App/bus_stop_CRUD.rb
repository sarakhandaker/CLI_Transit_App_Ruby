module BusStopCRUD
    def output_stops_menu
        puts ""
        puts "Please choose from the following options"
        puts ""
        puts "1. See your saved bus stops"
        puts "2. Look up and save a new bus stop"
        puts "3. Update location of saved bus stop"
        puts "4. Delete a saved bus stop"
        puts "5. See the most saved bus stop"
        puts "You may also enter 'exit' to exit the application" 
        puts ""
    end
    def stop_menu_response(response)
        if response == "exit"
            exit_app
            return
        else 
            case response.to_i
            when 1 #read user's stops
                array=@user.user_stops
                puts ""
                if  array.length <1
                    puts "You have no saved bus stops"
                else 
                    puts "Here are your saved bus stops:"
                    puts ""
                    array.each {|stop| puts "#{stop.label.capitalize}: #{stop.stop.stop_name}"}
                end
                puts ""
                puts ""
                menu_method
            when 2 #create user's stops
                puts "Please enter an address to find the closest bus stop"
                puts "Enter the address in the format: #### Street, City, State"
                puts ""
                address=gets.chomp
                location = Geocoder.search(address)
                if location== nil
                    puts""
                    puts "Sorry, that is not a valid address"
                    puts ""
                    menu_method
                else 
                    loc_array=[location[0].latitude, location[0].longitude]
                    array=closest_stop(loc_array)
                    puts""
                    puts "Would you like to save #{array[0].stop_name} that is #{array[1]} miles away from the address? (Yes/No)"
                    puts ""
                    res=gets.chomp.downcase
                    if res =="yes"
                        puts "What would you like to label this bus stop?"
                        puts ""
                        stop_label=gets.chomp.downcase
                        UserStop.create(user_id: @user.id, stop_id: array[0].id, label: stop_label)
                        puts "Bus stop #{array[0].stop_name} has been saved as #{stop_label.capitalize}"
                        puts ""
                        puts ""
                        menu_method
                    else 
                        menu_method
                    end
                end
            when 3
                puts ""
                puts "Please enter the label of the bus stop you would like to update"
                puts ""
                label=gets.chomp.downcase
                user_stop=UserStop.find_by(user: @user,label: label)
                if user_stop== nil
                    puts""
                    puts "Sorry, #{label.capitalize} is not a saved bus stop"
                    puts ""
                    menu_method
                else
                    puts "Please enter the new address to find the closest bus stop"
                    puts "Enter the address in the format: #### Street, City, State"
                    puts ""
                    address=gets.chomp
                    location = Geocoder.search(address)
                    if location== nil
                        puts""
                        puts "Sorry, that is not a valid address"
                        puts ""
                        menu_method
                    else 
                        loc_array=[location[0].latitude, location[0].longitude]
                        array=closest_stop(loc_array)
                        puts""
                        puts "Would you like to save #{array[0].stop_name} that is #{array[1]} miles away from the address as #{label.capitalize}? (Yes/No)"
                        puts ""
                        res=gets.chomp.downcase
                        if res =="yes"
                            user_stop.update(stop_id: array[0].id)
                            puts "Bus stop #{array[0].stop_name} has been saved as #{label.capitalize}"
                            puts ""
                            puts ""
                            menu_method
                        else 
                            menu_method
                        end
                    end
                end
            when 4 #delete saved stops
                puts ""
                puts "Please enter the label of the bus stop you would like to delete"
                puts ""
                label=gets.chomp.downcase
                stop_id=UserStop.find_by(label: label, user: @user).stop_id
                @user.commutes.map do|commute|
                    if commute.stops[0].id==stop_id || commute.stops[1].id==stop_id
                        Commute.destroy(commute.id)
                    end
                end
                @user.user_stops.map do|user_stop|
                    if user_stop.label==label
                        UserStop.destroy(user_stop.id)
                    end
                end
                puts "Bus stop has been removed from your saved list"
                puts ""
                puts ""
                menu_method
            when 5
                puts ""
                puts "Bus stop that is saved the most frequently is: #{UserStop.most_saved.stop_name}"
                puts ""
                puts ""
                menu_method
            else #error message
                puts  "Error: invalid value, please select from the following menu options"
                puts ""
                output_stops_menu
                response= gets.chomp
                stop_menu_response(response)
            end
        end
    end

end