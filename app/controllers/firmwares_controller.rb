class FirmwaresController < ApplicationController
  before_action :set_firmware, only: [:show, :edit, :update, :destroy]

  # GET /firmwares
  # GET /firmwares.json
  def index
    @firmwares = Firmware.all
  end

  # GET /firmwares/1
  # GET /firmwares/1.json
  def show
  end

  # GET /firmwares/new
  def new
    @firmware = Firmware.new
  end

  # GET /firmwares/1/edit
  def edit
  end

  # POST /firmwares
  # POST /firmwares.json
  def create
    @firmware = Firmware.new(firmware_params)

    respond_to do |format|
      if @firmware.save
        format.html { redirect_to @firmware, notice: 'Firmware was successfully created.' }
        format.json { render :show, status: :created, location: @firmware }
      else
        format.html { render :new }
        format.json { render json: @firmware.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /firmwares/1
  # PATCH/PUT /firmwares/1.json
  def update
    respond_to do |format|
      if @firmware.update(firmware_params)
        format.html { redirect_to @firmware, notice: 'Firmware was successfully updated.' }
        format.json { render :show, status: :ok, location: @firmware }
      else
        format.html { render :edit }
        format.json { render json: @firmware.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firmwares/1
  # DELETE /firmwares/1.json
  def destroy
    @firmware.destroy
    respond_to do |format|
      format.html { redirect_to firmwares_url, notice: 'Firmware was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firmware
      @firmware = Firmware.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def firmware_params
      params.require(:firmware).permit(:name, :switch_model_id)
    end
end
