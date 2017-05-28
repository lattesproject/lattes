class CandidatesController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:index, :process_cv]

	def index
		
	end

	def new
		
	end

	def create
		
	end
	
	def show
		
	end

	def process_cv
		ActionController::Parameters.permit_all_parameters = true
		uploaded_xml_cv = File.read(params[:datafile].tempfile)
		
		#@event = Event.find(params[:id])

		#@json_qualis =  File.read('C:\periodico.json')
		#render json: @json_qualis
		#puts  @json_qualis.class.name + "HHHHHHHHHHHHIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"

		@event = Event.find(params[:events][:event_id])
		@cv_handler = CvHandler.new(uploaded_xml_cv,@event)
		@candidate = Candidate.new
		#@cv_handler.calculate_total_book_points
	end
end