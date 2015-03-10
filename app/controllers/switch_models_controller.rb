class SwitchModelsController < ApplicationController
 include Finder
  CURRENT_CLASS = SwitchModel

  load_and_authorize_resource

  before_filter(only: [ :edit, :update, :destroy]) {set_curent_class(CURRENT_CLASS)}
  

  # GET /switch_models
  def index
    @subjects = SwitchModel.all
  end


  # GET /switch_models/new
  def new
    @subject = SwitchModel.new
  end

  # GET /switch_models/1/edit
  def edit
  end

  # POST /switch_models
  def create
    @subject = SwitchModel.new(switch_model_params)
    respond_to do |format|
      if @subject.save
        format.html { redirect_to switch_models_url, notice: 'Switch model was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /switch_models/1
  def update
    respond_to do |format|
      if @subject.update(switch_model_params)
        format.html { redirect_to switch_models_url, notice: 'Switch model was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /switch_models/1
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to switch_models_url, notice: 'Switch model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def switch_model_params
      params.require(:switch_model).permit(:name)
    end

end
