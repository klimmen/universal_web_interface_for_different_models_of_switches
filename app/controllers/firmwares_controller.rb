class FirmwaresController < ApplicationController
include Finder
  CURRENT_CLASS = Firmware

  load_and_authorize_resource

  before_filter(only: [ :edit, :update, :destroy]) {set_curent_class(CURRENT_CLASS)}
  before_action :set_firmware, only: [ :edit, :update, :destroy]


  # GET /firmwares/new
  def new
    @subject = Firmware.new
  end

  # GET /firmwares/1/edit
  def edit
  end

  # POST /firmwares
  def create
    @subject = Firmware.new(firmware_params)
    respond_to do |format|
      if @subject.save
        format.html { redirect_to switch_models_url, notice: 'Firmware was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /firmwares/1
  def update
    respond_to do |format|
      if @subject.update(firmware_params)
        format.html { redirect_to switch_models_url, notice: 'Firmware was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /firmwares/1
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to switch_models_url, notice: 'Firmware was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firmware
      @switch_model = SwitchModel.find(params[:switch_model_id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def firmware_params
      params.permit().tap do |whitelisted|
        whitelisted[:name] = params[:firmware][:name]
        whitelisted[:switch_model_id] = params[:switch_model_id]
      end  
    end

end
