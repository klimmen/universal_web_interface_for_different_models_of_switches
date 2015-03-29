class PortsController < ApplicationController
  rescue_from SNMP::RequestTimeout, with: :snmp_timeout
	#load_and_authorize_resource
	before_action :set_switch_info, only: [ :index, :update_ports]
  
  def index
    begin
      @data = @comutator.check_switch_info
      @ports = @port.ports(@data)
    rescue SNMP::RequestTimeout
      flash[:danger] = "Switch is not available"
      redirect_to switches_url
    end
  end

  def update_ports
    @port.update_ports(params[:ports])
    redirect_to ports_path(@subject.ip)
  end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_switch_info
      @subject = Switch.find_by_ip(params[:ip])
      @comutator = Comutator.new(@subject, current_user.email)
      @port = Port.new(@subject, current_user.email)
    end

    def snmp_timeout
      flash[:danger] = "Switch is not available"
      redirect_to switches_url
    end
end

