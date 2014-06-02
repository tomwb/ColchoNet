class UsersController < ApplicationController

	 def index
	    @users = User.all
	 end

	def show
    	@user = User.find(params[:id])
  	end

	def new
		@user = User.new
		# O controle com- partilha todas as variáveis de instância com o template, ou seja, toda variável com @ estará disponível no template renderizado pela ação.
	end

	def create
		# metodo chamado ao enviar o formulario para salvar
	    @user = User.new(user_params)
	    # mude de params[:user] para user_params.
	    # O método params retorna um hash com todos os parâmetros enviados pelo usuário
	    if @user.save
	      redirect_to @user,
	                  notice: 'Cadastro criado com sucesso!'
		else
	      render action: :new
	    end
	end

	 def edit
	    @user = User.find(params[:id])
	end

	def update
	    @user = User.find(params[:id])
	    if @user.update(user_params)
	      redirect_to @user,
	        notice: 'Cadastro atualizado com sucesso!'
	else
	      render action: :edit
	    end
	end

	private

	def user_params
	    # Os "pontos" no final da linha não são opcionais!
	    params.
	      require(:user).
	      permit(:email, :full_name, :location, :password,
	             :password_confirmation, :bio)
	end
	
end
