class MibsController < ApplicationController
  include Finder
  CURRENT_CLASS = Mib

  load_and_authorize_resource

  before_filter(only: [ :edit, :update, :destroy]) {set_curent_class(CURRENT_CLASS)}
  before_action :set_value_oids, only: [:new, :edit]

  # GET /mibs
  def index
    @subjects = Firmware.find(params[:firmware_id]).mibs
  end


  # GET /mibs/new
  def new
    @subject = Mib.new
  end

  # GET /mibs/1/edit
  def edit
  end

  # POST /mibs
  def create
    @subject = Mib.new(mib_params)
    @firmware = Firmware.find(params[:firmware_id])
    @firmware.mibs << @mib
    respond_to do |format|
     if @firmware.save
        format.html { redirect_to switch_model_firmware_mibs_path(params[:switch_model_id], params[:firmware_id], @mib), notice: 'Mib was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /mibs/1
  def update
    respond_to do |format|
      if @subject.update(mib_params)
        format.html { redirect_to switch_model_firmware_mibs_path(params[:switch_model_id], params[:firmware_id], @mib), notice: 'Mib was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /mibs/1
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to switch_model_firmware_mibs_path(params[:switch_model_id], params[:firmware_id], @mib), notice: 'Mib was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  
    def set_value_oids
      @value_oids = ValueOid.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mib_params
      params.require(:mib).permit(:name, :value_oid_id)
    end
end
