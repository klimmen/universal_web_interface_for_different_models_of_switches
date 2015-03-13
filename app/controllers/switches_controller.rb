class SwitchesController < ApplicationController

include Finder
CURRENT_CLASS = Switch

  load_and_authorize_resource

  before_filter(only: [:show, :edit, :update, :destroy]) {set_curent_class(CURRENT_CLASS)}
  before_action :set_switch_info, only: [:information_about_switch, :ports, :vlans, :update_ports]
  # GET /switches
  # GET /switches.json
  def index
    @subjects = Switch.all
  end

  # GET /switches/1
  # GET /switches/1.json
  def show
   
  end

  # GET /switches/new
  def new
    @subject = Switch.new
  end

  # GET /switches/1/edit
  def edit
  end

  # POST /switches
  # POST /switches.json
  def create
    @subject = Switch.new(switch_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Switch was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /switches/1
  # PATCH/PUT /switches/1.json
  def update
    respond_to do |format|
      if @subject.update(switch_params)
        format.html { redirect_to @subject, notice: 'Switch was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject}
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /switches/1
  # DELETE /switches/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to switches_url, notice: 'Switch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def information_about_switch
    @data = @comutator.check_switch_info
  end

  def ports
    @data = @comutator.check_switch_info
    @ports = @comutator.ports(@data)
  end

  def update_ports
    @comutator.update_ports(params[:ports])
    redirect_to ports_path(@subject.ip)
  end

  def vlans
    @data = @comutator.check_switch_info
    @vlans = @comutator.vlans(@data)
    p @vlans[:vlan_vid]
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_switch_info
      @subject = Switch.find_by_ip(params[:ip])
      @comutator = Comutator.new(@subject, current_user.email)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def switch_params
      params.require(:switch).permit(:name, :ip, :login, :pass, :snmp)
    end
end
