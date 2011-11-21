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
    ready_to_run

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
    starting_number = params[:virtual_server].delete(:starting_number)
    _starting_number = starting_number.to_i
    starting_number_max = (params[:starting_number_max] || 0).to_i
    @virtual_server = Tengine::Resource::VirtualServer.new(params[:virtual_server])

    respond_to do |format|
      if @virtual_server.valid? &&
        _starting_number > 0 && _starting_number <= starting_number_max

        physical = Tengine::Resource::PhysicalServer.where(
          :provided_id => @virtual_server.host_server_id).first
        image = Tengine::Resource::VirtualServerImage.where(
          :provided_id => @virtual_server.provided_image_id).first
        type = Tengine::Resource::VirtualServerType.where(
          :provided_id => @virtual_server.provided_type_id).first
        provider = physical.provider

        result = provider.create_virtual_servers(
          @virtual_server.name,
          image, type, physical,
          @virtual_server.description,
          _starting_number,
        )
        provided_ids = result.collect{|i| i.provided_id }

        format.html { redirect_to created_tengine_resource_virtual_servers_url(
          :provieded_ids => provided_ids) }
        format.json { render json: @virtual_server, status: :created, location: @virtual_server }
      else
        if _starting_number <= 0
          @virtual_server.errors.add :starting_number,
            I18n.t(:greater_than, :scope => 'activerecord.errors.messages', :count => 0)
        end

        if _starting_number > starting_number_max
          @virtual_server.errors.add :starting_number,
            I18n.t(:less_than_or_equal_to, :scope => 'activerecord.errors.messages',
              :count => starting_number_max)
        end

        ready_to_run(starting_number, starting_number_max)

        format.html { render action: "new" }
        format.json { render json: @virtual_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tengine/resource/virtual_servers/created
  # GET /tengine/resource/virtual_servers/created.json
  def created
    @provided_ids = params[:provided_ids] || []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @provided_ids }
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
        msize = type.memory_size.to_i
        label << "("
        label << "#{Tengine::Resource::VirtualServerType.human_attribute_name(:cpu_cores)}:#{type.cpu_cores}"
        label << ", "
        label << "#{Tengine::Resource::VirtualServerType.human_attribute_name(:memory_size)}:#{msize}#{I18n.t("tengine.resource.virtual_servers.new.human.storage_units.mb")})"
        [ERB::Util.html_escape(label), type.provided_id]
      end

    return result
  end

  def ready_to_run(starting_number=nil, starting_number_max=nil)
    @physical_servers = Tengine::Resource::PhysicalServer.where(:status => "online").
      order_by([[:name, :asc]])
    if @physical_servers.blank?
      @physical_servers_for_select = []
      @virtual_server_images_for_select = []
      @virtual_server_types_for_select = []
      @starting_number = 0
      @starting_number_max = 0
      @physical_server_map_provider = {}
      @virtual_server_images_by_provider = {}
      @virtual_server_types_by_provider = {}
      @capacities_by_provider = {}
      return
    end

    @physical_servers_for_select = @physical_servers.collect do |s|
      label = s.name.dup
      label << "(#{s.description})" if s.description
      [label, s.provided_id]
    end
    selected_physical_server = @physical_servers.first
    provider = selected_physical_server.provider
    @virtual_server_images_for_select = \
      virtual_server_images_for_select(provider.virtual_server_images)
    types = provider.virtual_server_types.order_by([[:provided_id, :asc]])
    selected_type_provided_id = types.first.provided_id
    @virtual_server_types_for_select = virtual_server_types_for_select(types)

    physical_server_capacity = \
      provider.capacities[selected_physical_server.provided_id]
    @starting_number_max = \
      starting_number_max || physical_server_capacity[selected_type_provided_id]
    @starting_number = starting_number || 0

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
  end
end
