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
		processing_xml = CvHandler.new
		@json_cv = processing_xml.convert_xml_json(uploaded_xml_cv)
		
		#render json: @json_cv

		puts @json_cv['CURRICULO_VITAE']['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_MESTRADO']


		render json: @json_cv['CURRICULO_VITAE']['OUTRA_PRODUCAO']['ORIENTACOES_CONCLUIDAS']['ORIENTACOES_CONCLUIDAS_PARA_MESTRADO']
		
		

		#json["Continents"].each do |continent|
 		 # do something
		#end
	end
end