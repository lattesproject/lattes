class Candidate < ActiveRecord::Base
	validates :event_id, presence: true
	belongs_to :event

end
