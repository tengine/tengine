class Tengine::Core::DriversController < ApplicationController
  # GET /tengine/core/drivers
  # GET /tengine/core/drivers.json
  def index
    @drivers = Tengine::Core::Driver.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drivers }
    end
  end

  # GET /tengine/core/drivers/1
  # GET /tengine/core/drivers/1.json
  def show
    @driver = Tengine::Core::Driver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @driver }
    end
  end

  # GET /tengine/core/drivers/new
  # GET /tengine/core/drivers/new.json
  def new
    @driver = Tengine::Core::Driver.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @driver }
    end
  end

  # GET /tengine/core/drivers/1/edit
  def edit
    @driver = Tengine::Core::Driver.find(params[:id])
  end

  # POST /tengine/core/drivers
  # POST /tengine/core/drivers.json
  def create
    @driver = Tengine::Core::Driver.new(params[:driver])

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render json: @driver, status: :created, location: @driver }
      else
        format.html { render action: "new" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/drivers/1
  # PUT /tengine/core/drivers/1.json
  def update
    @driver = Tengine::Core::Driver.find(params[:id])

    respond_to do |format|
      if @driver.update_attributes(params[:driver])
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/drivers/1
  # DELETE /tengine/core/drivers/1.json
  def destroy
    @driver = Tengine::Core::Driver.find(params[:id])
    @driver.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_drivers_url }
      format.json { head :ok }
    end
  end
end
