class Commute< ActiveRecord::Base
    belongs_to :user
    has_many :commute_stops
    has_many :stops, through: :commute_stops
end