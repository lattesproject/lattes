class EventsController < ApplicationController 
	before_action :set_event, only: [:edit, :update, :show, :destroy]
	before_action :require_user
	before_action :require_same_user, only: [:edit, :update, :destroy]
	before_action :require_admin, only: [:index]
	


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
	end

	def update
		
	end

	def destroy
		@event.destroy
		flash[:danger] = "Event was successfully deleted"
		redirect_to root_path
	end


	private
	def set_event
		@event = Event.find(params[:id])
	end

	def event_params
		params.require(:event).permit(:event_name, :article_qualis_a1, :article_qualis_a2, :article_qualis_b1,
			:article_qualis_b2, :article_qualis_b3, :article_qualis_b4, :article_qualis_b5, :article_qualis_c)
	end
	
	def require_same_user
		if current_user != @event.user and !current_user.admin?
			flash[:danger] = "You can only edit or delete your own events"
			redirect_to root_path
		end
	end

	def require_admin
		if !current_user.admin?
			flash[:danger] = "You have to be an admin to perform this action"
			redirect_to user_path(current_user)
		end
	end
end