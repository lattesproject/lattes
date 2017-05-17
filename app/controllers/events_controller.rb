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
			flash[:success] = "Evento criado com sucesso"
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
		flash[:danger] = "Evento deletado com sucesso"
		redirect_to root_path
	end


	private
	def set_event
		@event = Event.find(params[:id])
	end

	def event_params
		params.require(:event).permit(
			:event_name,
			:artigos_qualis_a1, 
			:artigos_qualis_a2, 
			:artigos_qualis_b1, 
			:artigos_qualis_b2, 
			:artigos_qualis_b3, 
			:artigos_qualis_b4, 
			:artigos_qualis_b5, 
			:artigos_qualis_c, 
			:artigos_qualis_a1_max, 
			:artigos_qualis_a2_max, 
			:artigos_qualis_b1_max, 
			:artigos_qualis_b2_max, 
			:artigos_qualis_b3_max, 
			:artigos_qualis_b4_max, 
			:artigos_qualis_b5_max, 
			:artigos_qualis_c_max, 
			:livros, 
			:livros_max, 
			:capitulos_de_livros, 
			:capitulos_de_livros_max, 
			:projetos_de_pesquisa, 
			:projetos_de_pesquisa_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_a1, 
			:trabalhos_completos_em_anais_de_congresso_qualis_a1_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_a2, 
			:trabalhos_completos_em_anais_de_congresso_qualis_a2_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b1, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b1_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b2, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b2_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b3, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b3_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b4, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b4_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b5, 
			:trabalhos_completos_em_anais_de_congresso_qualis_b5_max, 
			:trabalhos_completos_em_anais_de_congresso_qualis_c, 
			:trabalhos_completos_em_anais_de_congresso_qualis_c_max, 
			:resumos_em_anais_de_congresso_qualis_a1, 
			:resumos_em_anais_de_congresso_qualis_a1_max, 
			:resumos_em_anais_de_congresso_qualis_a2, 
			:resumos_em_anais_de_congresso_qualis_a2_max, 
			:resumos_em_anais_de_congresso_qualis_b1, 
			:resumos_em_anais_de_congresso_qualis_b1_max, 
			:resumos_em_anais_de_congresso_qualis_b2, 
			:resumos_em_anais_de_congresso_qualis_b2_max, 
			:resumos_em_anais_de_congresso_qualis_b3, 
			:resumos_em_anais_de_congresso_qualis_b3_max, 
			:resumos_em_anais_de_congresso_qualis_b4, 
			:resumos_em_anais_de_congresso_qualis_b4_max, 
			:resumos_em_anais_de_congresso_qualis_c, 
			:resumos_em_anais_de_congresso_qualis_c_max, 
			:bancas_graduacao, 
			:bancas_graduacao_max, 
			:bancas_mestrado, 
			:bancas_mestrado_max, 
			:bancas_doutorado, 
			:bancas_doutorado_max, 
			:bancas_especializacao, 
			:bancas_especializacao_max, 
			:orientacoes_mestrado, 
			:orientacoes_mestrado_max, 
			:orientacoes_doutorado, 
			:orientacoes_doutorado_max, 
			:orientacoes_outras, 
			:orientacoes_outras_max)
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