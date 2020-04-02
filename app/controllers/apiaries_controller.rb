class ApiariesController < ApplicationController
  before_action :set_apiary, only: [:show, :edit, :update, :destroy]

  # GET /apiaries
  # GET /apiaries.json
  def index
    @apiaries = Apiary.all
  end

  # GET /apiaries/1
  # GET /apiaries/1.json
  def show
  end

  # GET /apiaries/new
  def new
    @apiary = Apiary.new
  end

  # GET /apiaries/1/edit
  def edit
  end

  # POST /apiaries
  # POST /apiaries.json
  def create
    @apiary = Apiary.new(apiary_params)

    respond_to do |format|
      if @apiary.save
        format.html { redirect_to @apiary, notice: 'Apiary was successfully created.' }
        format.json { render :show, status: :created, location: @apiary }
      else
        format.html { render :new }
        format.json { render json: @apiary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apiaries/1
  # PATCH/PUT /apiaries/1.json
  def update
    respond_to do |format|
      if @apiary.update(apiary_params)
        format.html { redirect_to @apiary, notice: 'Apiary was successfully updated.' }
        format.json { render :show, status: :ok, location: @apiary }
      else
        format.html { render :edit }
        format.json { render json: @apiary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apiaries/1
  # DELETE /apiaries/1.json
  def destroy
    @apiary.destroy
    respond_to do |format|
      format.html { redirect_to apiaries_url, notice: 'Apiary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apiary
      @apiary = Apiary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apiary_params
      params.require(:apiary).permit(:uuid, :description)
    end
end
