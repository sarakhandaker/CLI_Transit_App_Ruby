class UserStop< ActiveRecord::Base
    belongs_to :user
    belongs_to :stop
    def self.most_saved
        array=UserStop.all.map{|userstop| userstop.stop}
        array.max_by{|stop| array.count(stop) }
    end
end