class Candidate < ActiveRecord::Base
	validates :user_id, presence: true
	belongs_to :event
end