class MacTablesController < ApplicationController
  rescue_from SNMP::RequestTimeout, with: :snmp_timeout
	before_action :set_switch_info
  
  def index
  end

  def search
  	@mac_tables = @mac_table.search_mac(params[:search_param])
  	respond_to do |format|
      format.js   {}
      format.json { render json: @mac_tables , status: :ok, location: mac_tables_path(@subject.ip) }
  	end
  end

  private
    def set_switch_info
      @subject = Switch.find_by_ip(params[:ip])
      @comutator = Comutator.new(@subject, current_user.email)
      @data = @comutator.check_switch_info
      @mac_table = MacTable.new(@subject, @data)
    end

    def snmp_timeout
      flash[:danger] = "Switch is not available"
      redirect_to switches_url
    end
end
