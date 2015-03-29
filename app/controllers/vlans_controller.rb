class VlansController < ApplicationController
  rescue_from SNMP::RequestTimeout, with: :snmp_timeout
  #load_and_authorize_resource
	before_action :set_switch_info

	def index
    @vlans = @vlan.vlans(@data)
  end

  def new
    @pvid = @vlan.pvid
    @ports_count = @vlan.ports_count
  end

  def edit
    @ports_count = @vlan.ports_count
    @edit_vlan= @vlan.edit_vlan(params[:id])
  end

  def create
    @vlan.create_vlan(params[:new_vlan])
    redirect_to vlans_path(@subject.ip)
  end

  def update
    @vlan.update_vlan(params[:id], params[:edit_vlan])
    redirect_to vlans_path(@subject.ip)
  end

  def destroy
    @vlan.destroy(params[:id])
    redirect_to vlans_path(@subject.ip)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_switch_info
      @subject = Switch.find_by_ip(params[:ip])
      @comutator = Comutator.new(@subject, current_user.email)
      @data = @comutator.check_switch_info
      @vlan = Vlan.new(@subject, current_user.email, @data)
    end

    def snmp_timeout
      flash[:danger] = "Switch is not available"
      redirect_to switches_url
    end
end
