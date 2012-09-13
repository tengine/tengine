class Tengine::Core::HandlerPathsController < ApplicationController
  # GET /tengine/core/handler_paths
  # GET /tengine/core/handler_paths.json
  def index
    @handler_paths = Tengine::Core::HandlerPath.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @handler_paths }
    end
  end

  # GET /tengine/core/handler_paths/1
  # GET /tengine/core/handler_paths/1.json
  def show
    @handler_path = Tengine::Core::HandlerPath.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @handler_path }
    end
  end

  # GET /tengine/core/handler_paths/new
  # GET /tengine/core/handler_paths/new.json
  def new
    @handler_path = Tengine::Core::HandlerPath.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @handler_path }
    end
  end

  # GET /tengine/core/handler_paths/1/edit
  def edit
    @handler_path = Tengine::Core::HandlerPath.find(params[:id])
  end

  # POST /tengine/core/handler_paths
  # POST /tengine/core/handler_paths.json
  def create
    @handler_path = Tengine::Core::HandlerPath.new(params[:handler_path])

    respond_to do |format|
      if @handler_path.save
        format.html { redirect_to @handler_path, notice: successfully_created(@handler_path) }
        format.json { render json: @handler_path, status: :created, location: @handler_path }
      else
        format.html { render action: "new" }
        format.json { render json: @handler_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/handler_paths/1
  # PUT /tengine/core/handler_paths/1.json
  def update
    @handler_path = Tengine::Core::HandlerPath.find(params[:id])

    respond_to do |format|
      if @handler_path.update_attributes(params[:handler_path])
        format.html { redirect_to @handler_path, notice: successfully_updated(@handler_path) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @handler_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/handler_paths/1
  # DELETE /tengine/core/handler_paths/1.json
  def destroy
    @handler_path = Tengine::Core::HandlerPath.find(params[:id])
    @handler_path.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_handler_paths_url, notice: successfully_destroyed(@handler_path) }
      format.json { head :ok }
    end
  end
end
