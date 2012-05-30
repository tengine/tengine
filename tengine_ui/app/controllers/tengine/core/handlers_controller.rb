class Tengine::Core::HandlersController < ApplicationController
  before_filter :prepare_driver

  private
  def prepare_driver
    @driver = Tengine::Core::Driver.find(params[:driver_id])
  end
  def redirect_to(*args)
    obj = args.first
    case obj
    when Tengine::Core::Handler then
      super(tengine_core_driver_handler_url(@driver, args.shift), *args)
    else
      super(*args)
    end
  end

  public

  # GET /tengine/core/handlers
  # GET /tengine/core/handlers.json
  def index
    @handlers = @driver.handlers(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @handlers }
    end
  end

  # GET /tengine/core/handlers/1
  # GET /tengine/core/handlers/1.json
  def show
    @handler = @driver.handlers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @handler }
    end
  end

  # GET /tengine/core/handlers/new
  # GET /tengine/core/handlers/new.json
  def new
    @handler = @driver.handlers.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @handler }
    end
  end

  # GET /tengine/core/handlers/1/edit
  def edit
    @handler = @driver.handlers.find(params[:id])
  end

  # POST /tengine/core/handlers
  # POST /tengine/core/handlers.json
  def create
    @handler = @driver.handlers.new(params[:handler])

    respond_to do |format|
      if @handler.save
        format.html { redirect_to @handler, notice: successfully_created(@handler) }
        format.json { render json: @handler, status: :created, location: @handler }
      else
        format.html { render action: "new" }
        format.json { render json: @handler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/handlers/1
  # PUT /tengine/core/handlers/1.json
  def update
    @handler = @driver.handlers.find(params[:id])

    respond_to do |format|
      if @handler.update_attributes(params[:handler])
        format.html { redirect_to @handler, notice: successfully_updated(@handler) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @handler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/handlers/1
  # DELETE /tengine/core/handlers/1.json
  def destroy
    @handler = @driver.handlers.find(params[:id])
    @handler.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_driver_handlers_url(@driver), notice: successfully_destroyed(@handler) }
      format.json { head :ok }
    end
  end
end
