class Tengine::Resource::ServersController < ApplicationController
  # GET /tengine/resource/servers
  # GET /tengine/resource/servers.json
  def index
    @servers = Tengine::Resource::Server.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @servers }
    end
  end

  # GET /tengine/resource/servers/1
  # GET /tengine/resource/servers/1.json
  def show
    @server = Tengine::Resource::Server.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @server }
    end
  end

  # GET /tengine/resource/servers/new
  # GET /tengine/resource/servers/new.json
  def new
    @server = Tengine::Resource::Server.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @server }
    end
  end

  # GET /tengine/resource/servers/1/edit
  def edit
    @server = Tengine::Resource::Server.find(params[:id])
  end

  # POST /tengine/resource/servers
  # POST /tengine/resource/servers.json
  def create
    @server = Tengine::Resource::Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: successfully_created(@server) }
        format.json { render json: @server, status: :created, location: @server }
      else
        format.html { render action: "new" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/servers/1
  # PUT /tengine/resource/servers/1.json
  def update
    @server = Tengine::Resource::Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to @server, notice: successfully_updated(@server) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/servers/1
  # DELETE /tengine/resource/servers/1.json
  def destroy
    @server = Tengine::Resource::Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_servers_url, notice: successfully_destroyed(@server) }
      format.json { head :ok }
    end
  end
end
