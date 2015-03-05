class MibsController < ApplicationController
  load_and_authorize_resource
  before_action :set_mib, only: [:edit, :update, :destroy]
  before_action :set_vasue_oids, only: [:new, :edit]

  # GET /mibs
  def index
    @mibs = Firmware.find(params[:firmware_id]).mibs
  end


  # GET /mibs/new
  def new
    @mib = Mib.new
  end

  # GET /mibs/1/edit
  def edit
  end

  # POST /mibs
  def create
    @mib = Mib.new(mib_params)
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
      if @mib.update(mib_params)
        format.html { redirect_to switch_model_firmware_mibs_path(params[:switch_model_id], params[:firmware_id], @mib), notice: 'Mib was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /mibs/1
  def destroy
    @mib.destroy
    respond_to do |format|
      format.html { redirect_to switch_model_firmware_mibs_path(params[:switch_model_id], params[:firmware_id], @mib), notice: 'Mib was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mib
      @mib = Mib.find(params[:id])
    end

    def set_vasue_oids
      @value_oids = ValueOid.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mib_params
      params.require(:mib).permit(:name, :value_oid_id)
    end
end
