class UserStop< ActiveRecord::Base
    belongs_to :user
    belongs_to :stop
    def self.most_saved
        stops=UserStop.all.map(&:stop)
        stops.max_by{|stop| stops.count(stop) }
    end
end