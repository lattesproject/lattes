class Candidate < ActiveRecord::Base
	before_save :default_values
	validates :event_id, presence: true
	belongs_to :event




private
	def default_values
    self.livros ||= 0 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end
end



