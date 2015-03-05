class SwitchesController < ApplicationController

  load_and_authorize_resource
  #skip_load_resource :only => :create
  before_action :set_switch, only: [:show, :edit, :update, :destroy]
  before_action :set_ip_switch, only: [:information_about_switch, :ports, :vlans]
  # GET /switches
  # GET /switches.json
  def index
    @switches = Switch.all
  end

  # GET /switches/1
  # GET /switches/1.json
  def show
  end

  # GET /switches/new
  def new
    @switch = Switch.new
  end

  # GET /switches/1/edit
  def edit
  end

  # POST /switches
  # POST /switches.json
  def create
    @switch = Switch.new(switch_params)

    respond_to do |format|
      if @switch.save
        format.html { redirect_to @switch, notice: 'Switch was successfully created.' }
        format.json { render :show, status: :created, location: @switch }
      else
        format.html { render :new }
        format.json { render json: @switch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /switches/1
  # PATCH/PUT /switches/1.json
  def update
    respond_to do |format|
      if @switch.update(switch_params)
        format.html { redirect_to @switch, notice: 'Switch was successfully updated.' }
        format.json { render :show, status: :ok, location: @switch }
      else
        format.html { render :edit }
        format.json { render json: @switch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /switches/1
  # DELETE /switches/1.json
  def destroy
    @switch.destroy
    respond_to do |format|
      format.html { redirect_to switches_url, notice: 'Switch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def information_about_switch

  end

  def ports

  end

  def vlans

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_switch
       @switch = Switch.find(params[:id])
    end

    def set_ip_switch
      @switch = Switch.find_by_ip(params[:ip])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def switch_params
      params.require(:switch).permit(:name, :ip, :login, :pass, :snmp)
    end
end
