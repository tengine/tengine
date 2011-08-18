class Tengine::Core::DriversController < ApplicationController
  # GET /tengine/core/drivers
  # GET /tengine/core/drivers.json
  def index
    @tengine_core_drivers = Tengine::Core::Driver.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tengine_core_drivers }
    end
  end

  # GET /tengine/core/drivers/1
  # GET /tengine/core/drivers/1.json
  def show
    @tengine_core_driver = Tengine::Core::Driver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tengine_core_driver }
    end
  end

  # GET /tengine/core/drivers/new
  # GET /tengine/core/drivers/new.json
  def new
    @tengine_core_driver = Tengine::Core::Driver.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tengine_core_driver }
    end
  end

  # GET /tengine/core/drivers/1/edit
  def edit
    @tengine_core_driver = Tengine::Core::Driver.find(params[:id])
  end

  # POST /tengine/core/drivers
  # POST /tengine/core/drivers.json
  def create
    @tengine_core_driver = Tengine::Core::Driver.new(params[:tengine_core_driver])

    respond_to do |format|
      if @tengine_core_driver.save
        format.html { redirect_to @tengine_core_driver, notice: 'Driver was successfully created.' }
        format.json { render json: @tengine_core_driver, status: :created, location: @tengine_core_driver }
      else
        format.html { render action: "new" }
        format.json { render json: @tengine_core_driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/drivers/1
  # PUT /tengine/core/drivers/1.json
  def update
    @tengine_core_driver = Tengine::Core::Driver.find(params[:id])

    respond_to do |format|
      if @tengine_core_driver.update_attributes(params[:tengine_core_driver])
        format.html { redirect_to @tengine_core_driver, notice: 'Driver was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tengine_core_driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/drivers/1
  # DELETE /tengine/core/drivers/1.json
  def destroy
    @tengine_core_driver = Tengine::Core::Driver.find(params[:id])
    @tengine_core_driver.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_drivers_url }
      format.json { head :ok }
    end
  end
end
