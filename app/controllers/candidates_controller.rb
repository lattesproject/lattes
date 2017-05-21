class CandidatesController < ApplicationController

	def index
		
	end

	def new
		
	end

	def show
		
	end

	def process_cv
		cv = CvHandler.new
		@json_file = cv.convert_xml_json()
		render json: @json_file
	end
end