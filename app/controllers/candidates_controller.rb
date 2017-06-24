class CandidatesController < ApplicationController
	before_action :require_user
	before_action :require_same_user, only: [:edit, :update, :destroy]
	before_action :require_admin, only: [:index]
	before_action :set_candidate, only: [:show]


	def index
		
	end

	def new
		ActionController::Parameters.permit_all_parameters = true
		uploaded_xml_cv = File.read(params[:datafile].tempfile)
		@event = Event.find(params[:events][:event_id])
		@cv_handler = CvHandler.new(uploaded_xml_cv,@event)
		@candidate = Candidate.new

	end

	def create
		puts params[:articles_total]

		@candidate = Candidate.new(candidate_params)
		
		if @candidate.save
			flash[:success] = "Candidato criado com sucesso"
			redirect_to candidate_path(@candidate)
		else
			render 'Fuck that shit'
		end
	end
	
	def show
	end

	private
	def set_candidate
		@candidate = Candidate.find(params[:id])
	end

	def candidate_params
		params.require(:candidate).permit(
		:article_qualis_a1_total,
		:article_qualis_a2_total, 
		:article_qualis_b1_total, 
		:article_qualis_b2_total, 
		:article_qualis_b3_total, 
		:article_qualis_b4_total, 
		:article_qualis_b5_total, 
		:article_qualis_c_total, 
		:articles_total, 
		:livros_total, 
		:capitulos_de_livros_total, 
		:projetos_de_pesquisa_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_a1_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_a2_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_b1_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_b2_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_b3_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_b4_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_b5_total, 
		:trabalhos_completos_em_anais_de_congresso_qualis_c_total, 
		:trabalhos_completos_em_anais_de_congresso_total, 
		:resumos_em_anais_de_congresso_qualis_a1_total, 
		:resumos_em_anais_de_congresso_qualis_a2_total, 
		:resumos_em_anais_de_congresso_qualis_b1_total, 
		:resumos_em_anais_de_congresso_qualis_b2_total, 
		:resumos_em_anais_de_congresso_qualis_b3_total, 
		:resumos_em_anais_de_congresso_qualis_b4_total, 
		:resumos_em_anais_de_congresso_qualis_c_total, 
		:resumos_em_anais_de_congresso_total, 
		:bancas_graduacao_total, 
		:bancas_mestrado_total, 
		:bancas_doutorado_total, 
		:bancas_especializacao_total, 
		:bancas_total, 
		:orientacoes_mestrado_total, 
		:orientacoes_doutorado_total, 
		:orientacoes_outras_total, 
		:orientacoes_total, 
		:event_id,
		:nome,
		:total_geral)
	end

	def require_same_user
		if current_user != @event.user and !current_user.admin?
			flash[:danger] = "Você só pode editar ou deletar seus próprio eventos"
			redirect_to root_path
		end
	end

	def require_admin
		if !current_user.admin?
			flash[:danger] = "Você precisa de permissão de administrador para executar essa ação"
			redirect_to user_path(current_user)
		end
	end
	
end