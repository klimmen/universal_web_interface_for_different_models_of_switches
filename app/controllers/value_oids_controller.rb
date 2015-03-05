class ValueOidsController < ApplicationController
  load_and_authorize_resource
  before_action :set_value_oid, only: [:show, :edit, :update, :destroy]

  # GET /value_oids
  # GET /value_oids.json
  def index
    @value_oids = ValueOid.all
  end

  # GET /value_oids/1
  # GET /value_oids/1.json
  def show
  end

  # GET /value_oids/new
  def new
    @value_oid = ValueOid.new
  end

  # GET /value_oids/1/edit
  def edit
  end

  # POST /value_oids
  # POST /value_oids.json
  def create
    @value_oid = ValueOid.new(value_oid_params)

    respond_to do |format|
      if @value_oid.save
        format.html { redirect_to @value_oid, notice: 'Value oid was successfully created.' }
        format.json { render :show, status: :created, location: @value_oid }
      else
        format.html { render :new }
        format.json { render json: @value_oid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /value_oids/1
  # PATCH/PUT /value_oids/1.json
  def update
    respond_to do |format|
      if @value_oid.update(value_oid_params)
        format.html { redirect_to @value_oid, notice: 'Value oid was successfully updated.' }
        format.json { render :show, status: :ok, location: @value_oid }
      else
        format.html { render :edit }
        format.json { render json: @value_oid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_oids/1
  # DELETE /value_oids/1.json
  def destroy
    @value_oid.destroy
    respond_to do |format|
      format.html { redirect_to value_oids_url, notice: 'Value oid was successfully destroyed.' }
      format.json { head :no_content }
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
