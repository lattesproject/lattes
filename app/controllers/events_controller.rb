class EventsController < ApplicationController 

	def index
		@events = Event.paginate(page: params[:page], per_page: 5)
	end


end