class VlansController < ApplicationController
  
  load_and_authorize_resource
	before_action :set_switch_info

	def index
    @data = @comutator.check_switch_info
    @vlans = @vlan.vlans(@data)
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_switch_info
      @subject = Switch.find_by_ip(params[:ip])
      @comutator = Comutator.new(@subject, current_user.email)
      @vlan = Vlan.new(@subject, current_user.email)
    end

end
