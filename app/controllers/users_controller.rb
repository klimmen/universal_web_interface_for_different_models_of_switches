class UsersController < ApplicationController

	load_and_authorize_resource
	skip_authorize_resource :only => :show

	before_action :set_user, only: [:show, :destroy]

	def index
		@users = User.all
		@roles = Role.all
	end


	def show		
  		
	end

	def update
		@user = User.find(user_params[:id])
		@user.remove_role @user.roles.first.name if !@user.roles.blank? 
		@user.add_role user_params[:name]
		flash[:notice] = "Successfully ."
		redirect_to users_path
	end
	
	def destroy
    	if @user.destroy
     	 flash[:notice] = "Successfully deleted User."
     	 redirect_to users_path
   	 end
  end


  private

  	 def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit().tap do |whitelisted|
        whitelisted[:name] = params[:role][:user_role]
        whitelisted[:id] = params[:id]
      end
    end

end
