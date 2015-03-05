class SwitchModelsController < ApplicationController
  load_and_authorize_resource
  before_action :set_switch_model, only: [:edit, :update, :destroy]

  # GET /switch_models
  def index
    @switch_models = SwitchModel.all
  end


  # GET /switch_models/new
  def new
    @switch_model = SwitchModel.new
  end

  # GET /switch_models/1/edit
  def edit
  end

  # POST /switch_models
  def create
    @switch_model = SwitchModel.new(switch_model_params)
    respond_to do |format|
      if @switch_model.save
        format.html { redirect_to switch_models_url, notice: 'Switch model was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /switch_models/1
  def update
    respond_to do |format|
      if @switch_model.update(switch_model_params)
        format.html { redirect_to switch_models_url, notice: 'Switch model was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /switch_models/1
  def destroy
    @switch_model.destroy
    respond_to do |format|
      format.html { redirect_to switch_models_url, notice: 'Switch model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_switch_model
      @switch_model = SwitchModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def switch_model_params
      params.require(:switch_model).permit(:name)
    end

end
