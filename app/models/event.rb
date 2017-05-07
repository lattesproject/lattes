class Event < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	validates :event_name, presence: true,
	uniqueness: { case_sensitive: false },
	length: { minimum: 3, maximum: 25 }
end