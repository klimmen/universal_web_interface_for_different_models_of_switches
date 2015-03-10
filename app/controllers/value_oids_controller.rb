class ValueOidsController < ApplicationController
  include Finder
  CURRENT_CLASS = ValueOid

  load_and_authorize_resource

  before_filter(only: [ :edit, :update, :destroy]) {set_curent_class(CURRENT_CLASS)}

  # GET /value_oids
  def index
    @subjects = ValueOid.all
  end


  # GET /value_oids/new
  def new
    @subject = ValueOid.new
  end

  # GET /value_oids/1/edit
  def edit
  end

  # POST /value_oids
  def create
    @subject = ValueOid.new(value_oid_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to value_oids_url, notice: 'Value oid was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /value_oids/1
  def update
    respond_to do |format|
      if @subject.update(value_oid_params)
        format.html { redirect_to value_oids_url, notice: 'Value oid was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /value_oids/1
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to value_oids_url, notice: 'Value oid was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def value_oid_params
      params.require(:value_oid).permit(:name)
    end
end
