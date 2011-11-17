require "ostruct"

class Tengine::Resource::VirtualServersController < ApplicationController
  # GET /tengine/resource/virtual_servers
  # GET /tengine/resource/virtual_servers.json
  def index
    default_refresher = {:refresh_interval => 15}
    default_refresher.update(params[:refresher]) if params[:refresher]
    @refresher = OpenStruct.new(default_refresher)
    @refresh_interval = @refresher.refresh_interval
    @auto_refresh = false
    @auto_refresh = true unless @refresh_interval.to_i.zero?

    @finder = Tengine::Resource::VirtualServer::Finder.new(params)

    @physical_servers = Tengine::Resource::PhysicalServer.order_by([[:name, :asc]])
    if name = @finder.physical_server_name
      @physical_servers = @physical_servers.where(:name => /^#{name}/)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @virtual_servers }
    end
  end

  # GET /tengine/resource/virtual_servers/1
  # GET /tengine/resource/virtual_servers/1.json
  def show
    @virtual_server = Tengine::Resource::VirtualServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @virtual_server }
    end
  end

  # GET /tengine/resource/virtual_servers/new
  # GET /tengine/resource/virtual_servers/new.json
  def new
    @virtual_server = Tengine::Resource::VirtualServer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @virtual_server }
    end
  end

  # GET /tengine/resource/virtual_servers/1/edit
  def edit
    @virtual_server = Tengine::Resource::VirtualServer.find(params[:id])
  end

  # POST /tengine/resource/virtual_servers
  # POST /tengine/resource/virtual_servers.json
  def create
    @virtual_server = Tengine::Resource::VirtualServer.new(params[:virtual_server])

    respond_to do |format|
      if @virtual_server.save
        format.html { redirect_to @virtual_server, notice: successfully_created(@virtual_server) }
        format.json { render json: @virtual_server, status: :created, location: @virtual_server }
      else
        format.html { render action: "new" }
        format.json { render json: @virtual_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/virtual_servers/1
  # PUT /tengine/resource/virtual_servers/1.json
  def update
    @virtual_server = Tengine::Resource::VirtualServer.find(params[:id])

    respond_to do |format|
      if @virtual_server.update_attributes(params[:virtual_server])
        format.html { redirect_to @virtual_server, notice: successfully_updated(@virtual_server) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @virtual_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/virtual_servers/1
  # DELETE /tengine/resource/virtual_servers/1.json
  def destroy
    @virtual_server = Tengine::Resource::VirtualServer.find(params[:id])
    @virtual_server.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_virtual_servers_url, notice: successfully_destroyed(@virtual_server) }
      format.json { head :ok }
    end
  end

  # DELETE /tengine/resource/virtual_servers
  # DELETE /tengine/resource/virtual_servers.json
  def destroy_all
    unless (target_server_ids = params[:target_server_ids]).blank?
      @virtual_servers = \
        Tengine::Resource::VirtualServer.any_in(:_id => target_server_ids)
      @virtual_servers.each do |server|
        server.provider.terminate_virtual_servers([server])
      end
    end

    respond_to do |format|
      query_params = {}.with_indifferent_access
      query_params[:finder] = params[:finder] if params[:finder]
      query_params[:refresher] = params[:refresher] if params[:refresher]

      format.html do
        redirect_to(tengine_resource_virtual_servers_url(query_params), notice: successfully_destroyed_all(Tengine::Resource::VirtualServer))
      end
      format.json { head :ok }
    end
  end

  private

  def successfully_destroyed_all(model_class)
    I18n.t(:successfully_destroyed, :scope => [:views, :notice],:model => model_class.human_name)
  end
end
