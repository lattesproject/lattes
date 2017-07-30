class UsersController < ApplicationController
	before_action :require_user, :except => [:new, :create]
	before_action :set_user, only: [:edit, :update, :show]
	before_action :require_same_user_or_admin, only: [:edit, :update, :destroy]
	before_action :require_admin, only: [:destroy]

	def index
		@users = User.All
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
		session[:user_id] = @user.id
		flash[:success] = "Bem vindo ao sistema Avaliação Lattes #{@user.username}"
		redirect_to user_path(current_user)
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update(user_params)
			flash[:success] = "Conta criada com sucesso"
			redirect_to events_path
		else
			render 'edit'
		end
	end

	def show
		@user_events = @user.events
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		flash[:danger] = "Usuário e todos os eventos associados foram deletados"
		redirect_to users_path
	end

	private
	def user_params
		params.require(:user).permit(:username, :email, :password)
	end

	def set_user
		@user = User.find(params[:id])
	end
	
	def require_same_user_or_admin
		if !current_user.admin? && current_user !=@user
			flash[:danger] = "Você só pode editar sua própria conta"
			redirect_to root_path
		end
	end
end