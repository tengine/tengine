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
    @physical_servers = Tengine::Resource::PhysicalServer.all(:sort => [[:name, :asc]])
    @physical_servers_for_select = @physical_servers.collect do |s|
      label = s.name.dup
      label << "(#{s.description})" if s.description
      [label, s.provided_id]
    end
    @selected_physical_server = @physical_servers.first
    provider = @selected_physical_server.provider
    @virtual_server_images_for_select = \
      virtual_server_images_for_select(provider.virtual_server_images)
    types = provider.virtual_server_types.order_by([[:provided_id, :asc]])
    @virtual_server_types_for_select = virtual_server_types_for_select(types)
    physical_server_capacity = \
      provider.capacities[@selected_physical_server.provided_id]
    @starting_number_max = physical_server_capacity[types.first.provided_id]
    @starting_number = 0

    @physical_server_map_provider = @physical_servers.inject({}) do |memo, s|
      memo[s.provided_id] = s.provider.id.to_s
      memo
    end
    @virtual_server_images_by_provider = {}
    @virtual_server_types_by_provider = {}
    @capacities_by_provider = {}
    Tengine::Resource::Provider.all.each do |provider|
      @virtual_server_images_by_provider[provider.id.to_s] = \
        virtual_server_images_for_select(provider.virtual_server_images)
      @virtual_server_types_by_provider[provider.id.to_s] = \
        virtual_server_types_for_select(provider.virtual_server_types)
      @capacities_by_provider[provider.id.to_s] = provider.capacities
    end

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
        format.html { redirect_to tengine_resource_virtual_servers_url, notice: successfully_updated(@virtual_server) }
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

  def virtual_server_images_for_select(virtual_server_images)
    result = \
      virtual_server_images.order_by([[:name, :asc]]).collect do |image|
        label = image.name.dup
        label << "(#{image.description})" if image.description
        [ERB::Util.html_escape(label), image.provided_id]
      end

    return result
  end

  def virtual_server_types_for_select(virtual_server_types)
    result = \
      virtual_server_types.order_by([[:provided_id, :asc]]).collect do |type|
        label = type.provided_id.dup
        # TODO: memory size unit
        msize = type.memory_size / Numeric::MEGABYTE
        label << "("
        label << "#{Tengine::Resource::VirtualServerType.human_attribute_name(:cpu_cores)}:#{type.cpu_cores}"
        label << ", "
        label << "#{Tengine::Resource::VirtualServerType.human_attribute_name(:memory_size)}:#{msize}#{I18n.t("tengine.resource.virtual_servers.new.human.storage_units.mb")})"
        [ERB::Util.html_escape(label), type.provided_id]
      end

    return result
  end
end
