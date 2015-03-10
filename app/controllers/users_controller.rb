class UsersController < ApplicationController
  include Finder
  CURRENT_CLASS = User

  load_and_authorize_resource

  before_filter(only: [:show, :destroy]) {set_curent_class(CURRENT_CLASS)}
	skip_authorize_resource :only => :show

#	before_action :set_user, only: [:show, :destroy]

	def index
		@subjects = User.all
		@roles = Role.all
	end


	def show		
  		
	end

	def update
		@subject = User.find(user_params[:id])
		@subject.remove_role @subject.roles.first.name if !@subject.roles.blank? 
		@subject.add_role user_params[:name]
		flash[:notice] = "Successfully ."
		redirect_to users_path
	end
	
	def destroy
    	if @subject.destroy
     	 flash[:notice] = "Successfully deleted User."
     	 redirect_to users_path
   	 end
  end


  private

  #	 def set_user
  #    @user = User.find(params[:id])
  #  end

    def user_params
      params.permit().tap do |whitelisted|
        whitelisted[:name] = params[:role][:user_role]
        whitelisted[:id] = params[:id]
      end
    end

end
