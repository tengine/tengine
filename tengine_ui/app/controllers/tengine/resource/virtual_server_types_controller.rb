class Tengine::Resource::VirtualServerTypesController < ApplicationController
  # GET /tengine/resource/virtual_server_types
  # GET /tengine/resource/virtual_server_types.json
  def index
    @virtual_server_types = Tengine::Resource::VirtualServerType.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @virtual_server_types }
    end
  end

  # GET /tengine/resource/virtual_server_types/1
  # GET /tengine/resource/virtual_server_types/1.json
  def show
    @virtual_server_type = Tengine::Resource::VirtualServerType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @virtual_server_type }
    end
  end

  # GET /tengine/resource/virtual_server_types/new
  # GET /tengine/resource/virtual_server_types/new.json
  def new
    @virtual_server_type = Tengine::Resource::VirtualServerType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @virtual_server_type }
    end
  end

  # GET /tengine/resource/virtual_server_types/1/edit
  def edit
    @virtual_server_type = Tengine::Resource::VirtualServerType.find(params[:id])
  end

  # POST /tengine/resource/virtual_server_types
  # POST /tengine/resource/virtual_server_types.json
  def create
    @virtual_server_type = Tengine::Resource::VirtualServerType.new(params[:virtual_server_type])

    respond_to do |format|
      if @virtual_server_type.save
        format.html { redirect_to @virtual_server_type, notice: successfully_created(@virtual_server_type) }
        format.json { render json: @virtual_server_type, status: :created, location: @virtual_server_type }
      else
        format.html { render action: "new" }
        format.json { render json: @virtual_server_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/virtual_server_types/1
  # PUT /tengine/resource/virtual_server_types/1.json
  def update
    @virtual_server_type = Tengine::Resource::VirtualServerType.find(params[:id])

    respond_to do |format|
      if @virtual_server_type.update_attributes(params[:virtual_server_type])
        format.html { redirect_to @virtual_server_type, notice: successfully_updated(@virtual_server_type) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @virtual_server_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/virtual_server_types/1
  # DELETE /tengine/resource/virtual_server_types/1.json
  def destroy
    @virtual_server_type = Tengine::Resource::VirtualServerType.find(params[:id])
    @virtual_server_type.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_virtual_server_types_url, notice: successfully_destroyed(@virtual_server_type) }
      format.json { head :ok }
    end
  end
end
