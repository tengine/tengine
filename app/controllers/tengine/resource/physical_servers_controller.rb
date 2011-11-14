class Tengine::Resource::PhysicalServersController < ApplicationController
  # GET /tengine/resource/physical_servers
  # GET /tengine/resource/physical_servers.json
  def index
    @physical_servers = Tengine::Resource::PhysicalServer.all(:sort => [[:_id]]).page(params[:page])

    if sort_param = params[:sort]
      order = []
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        k = case k.to_s
            when "name"
              [:name, v]
            when "description"
              [:description, v]
            when "provided_id"
              [:provided_id, v]
            end
        order.push k
      end
    else
      default_sort = {:name => "asc"}
      request.query_parameters[:sort] = default_sort
      order = default_sort.to_a
    end
    @physical_servers = @physical_servers.order_by(order)

    if search_param = params[:finder]
      @finder = ::OpenStruct.new search_param
      finder = {}
      [:name, :description, :provided_id].each do |field|
        next if (value = @finder.send(field)).blank?
        value = /#{Regexp.escape(value)}/
        finder[field] = value
      end
      @physical_servers = @physical_servers.where(finder)
      status = {:online => "01", :registering => "02"}
      status_finder =[] 
      status.each do |key, id |
         status_finder << {:status => id}  if @finder.send(key) == "1"
      end
      @physical_servers = @physical_servers.any_of(status_finder) unless status_finder.empty?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @physical_servers }
    end
  end

  # GET /tengine/resource/physical_servers/1
  # GET /tengine/resource/physical_servers/1.json
 # def show
 #   @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])

 #   respond_to do |format|
 #     format.html # show.html.erb
 #     format.json { render json: @physical_server }
 #   end
 # end

  # GET /tengine/resource/physical_servers/new
  # GET /tengine/resource/physical_servers/new.json
 # def new
 #   @physical_server = Tengine::Resource::PhysicalServer.new

 #   respond_to do |format|
 #     format.html # new.html.erb
 #     format.json { render json: @physical_server }
 #   end
 # end

  # GET /tengine/resource/physical_servers/1/edit
  def edit
    @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])
  end

  # POST /tengine/resource/physical_servers
  # POST /tengine/resource/physical_servers.json
  def create
    @physical_server = Tengine::Resource::PhysicalServer.new(params[:physical_server])

    respond_to do |format|
      if @physical_server.save
        format.html { redirect_to @physical_server, notice: successfully_created(@physical_server) }
        format.json { render json: @physical_server, status: :created, location: @physical_server }
      else
        format.html { render action: "new" }
        format.json { render json: @physical_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/physical_servers/1
  # PUT /tengine/resource/physical_servers/1.json
  def update
    @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])

    respond_to do |format|
      if @physical_server.update_attributes(params[:physical_server])
        format.html { redirect_to @physical_server, notice: successfully_updated(@physical_server) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @physical_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/physical_servers/1
  # DELETE /tengine/resource/physical_servers/1.json
  def destroy
    @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])
    @physical_server.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_physical_servers_url, notice: successfully_destroyed(@physical_server) }
      format.json { head :ok }
    end
  end
end
