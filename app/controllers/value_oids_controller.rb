class ValueOidsController < ApplicationController
  load_and_authorize_resource
  before_action :set_value_oid, only: [:edit, :update, :destroy]

  # GET /value_oids
  def index
    @value_oids = ValueOid.all
  end


  # GET /value_oids/new
  def new
    @value_oid = ValueOid.new
  end

  # GET /value_oids/1/edit
  def edit
  end

  # POST /value_oids
  def create
    @value_oid = ValueOid.new(value_oid_params)

    respond_to do |format|
      if @value_oid.save
        format.html { redirect_to value_oids_url, notice: 'Value oid was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /value_oids/1
  def update
    respond_to do |format|
      if @value_oid.update(value_oid_params)
        format.html { redirect_to value_oids_url, notice: 'Value oid was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /value_oids/1
  def destroy
    @value_oid.destroy
    respond_to do |format|
      format.html { redirect_to value_oids_url, notice: 'Value oid was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_value_oid
      @value_oid = ValueOid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def value_oid_params
      params.require(:value_oid).permit(:name)
    end
end
