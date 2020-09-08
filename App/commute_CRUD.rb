module CommuteCRUD
    def user_commutes
        output_commutes_menu
        commute_response=gets.chomp
        commute_menu_response(commute_response)
    end 
    def output_commutes_menu
        puts "\nPlease choose from the following options\n"
        puts "1. See your saved commutes and distances"
        puts "2. Create a new commute"
        puts "3. Update stops for an existing commute"
        puts "4. Delete a saved commute"
        puts "You may also enter 'exit' to exit the application" 
    end
    def commute_menu_response(response)
        system 'clear'
        if response=='exit'
            exit_app
            return
        else 
            case response.to_i
            when 1 #displays commutes
                puts ""
                array=Commute.all.select{|commute| commute.user==@user}
                if  array.length <1
                    puts "You have no saved commutes"
                else 
                    puts "Here are your commutes and their distances\n"
                    distance_array=[]
                    array.each do |commute|
                        label1=UserStop.find_by(stop_id: commute.stops[0].id, user: @user).label
                        label2=UserStop.find_by(stop_id: commute.stops[1].id, user: @user).label
                        distance = distance_calc([commute.stops[0].stop_lat, commute.stops[0].stop_lon], [commute.stops[1].stop_lat, commute.stops[1].stop_lon])
                        distance_array << distance
                        puts "#{commute.name.capitalize} commute from #{label1.capitalize} to #{label2.capitalize} is #{distance.round(2)} miles"
                        end
                    puts "\nYour shortest commute is #{distance_array.min.round(2)} miles"
                    puts "Your longest commute is #{distance_array.max.round(2)} miles"
                end
                puts "\n\n"
            when 2
                puts "Please enter the name of the commute you would like to save"
                name=gets.chomp.downcase
                puts "Please enter the label of the first bus stop"
                stp1=gets.chomp.downcase
                puts "Please enter the label of the second bus stop"
                stp2=gets.chomp.downcase
                stop_id_1=UserStop.find_by(user: @user, label:stp1).stop.id
                stop_id_2=UserStop.find_by(user: @user, label:stp2).stop.id
                commute=Commute.create(user_id: @user.id, name: name)
                CommuteStop.create(stop_id: stop_id_1, commute_id: commute.id)
                CommuteStop.create(stop_id: stop_id_2, commute_id: commute.id)
                puts "\nYour #{name.capitalize} commute has been saved\n\n"
            when 3 
                update_commute
            when 4
                puts "Please enter the name of the commute you would like to delete\n"
                name=gets.chomp.downcase
                @user.commutes.where(name:name).destroy_all
                puts "Commute has been removed from your saved list\n\n"
            else 
                puts  "Error: invalid value, please select from the following menu options\n"
            end
        menu_method
        end
    end 

    def update_commute
        puts "\nPlease enter the name of the commute you would like to update\n"
        name=gets.chomp.downcase
        commute=Commute.find_by(user:@user, name:name)
        if !commute
            puts "\nSorry, #{name.capitalize} is not a saved commute\n"
        else
            puts "\nWould you like to change the start of the commute from #{UserStop.find_by(stop_id: commute.stops[0].id, user: @user).label.capitalize}?"
            puts ""
            res=gets.chomp.downcase
            if res == "yes"
                puts ""
                puts "Please enter the label of the updated first bus stop"
                puts ""
                stp1=gets.chomp.downcase
                stop_id_1=UserStop.find_by(user: @user, label:stp1).stop.id
                commute.commute_stops[0].update(stop_id: stop_id_1)
                puts "\nYour #{name.capitalize} commute has been saved\n"
            else 
                puts "\nWould you like to change the end of the commute from #{UserStop.find_by(stop_id: commute.stops[1].id, user: @user).label.capitalize}?"
                puts ""
                res=gets.chomp.downcase
                if res == "yes"
                    puts "\nPlease enter the label of the updated second bus stop\n"
                    stp2=gets.chomp.downcase
                    stop_id_2=UserStop.find_by(user: @user, label:stp2).stop.id
                    commute.commute_stops[1].update(stop_id: stop_id_2)
                    puts "\nYour #{name.capitalize} commute has been saved\n"
                end
            end
        end 
    end
end