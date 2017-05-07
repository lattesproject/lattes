class EventsController < ApplicationController 

	def index
		@events = Event.paginate(page: params[:page], per_page: 5)
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(event_params)
		@event.user = current_user
		if @event.save
			flash[:success] = "Event was successfully created"
			redirect_to event_path(@event)
		else
			render 'new'
		end
	end

	def show
		@event = Event.find(params[:id])
	end

	def destroy
		@event = Event.find(params[:id])
		@event.destroy
		flash[:danger] = "Article was successfully deleted"
		redirect_to events_path
	end

	def event_params
		params.require(:event).permit(:event_name, :article_qualis_a1, :article_qualis_a2, :article_qualis_b1,
			:article_qualis_b2, :article_qualis_b3, :article_qualis_b4, :article_qualis_b5, :article_qualis_c)
	end
	
end