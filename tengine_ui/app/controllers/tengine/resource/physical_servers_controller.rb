require 'ostruct'
require 'selectable_attr'
class Tengine::Resource::PhysicalServersController < ApplicationController
  # GET /tengine/resource/physical_servers
  # GET /tengine/resource/physical_servers.json
  def index
    @physical_servers = Mongoid::Criteria.new(Tengine::Resource::PhysicalServer)

    @check_status = {}
    Tengine::Resource::Provider::Wakame::PHYSICAL_SERVER_STATES.each do | s |
      @check_status["st_#{s}"] = ["unchecked", s]
    end 

    order = []
    if sort_param = params[:sort]
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        if %w(name provided_id description cpu_cores
              memory_size status).include?(k.to_s)
          order.push [k, v]
        else
          request.query_parameters[:sort].delete(k)
        end
      end
    end
    if order.blank?
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
        if  field == :provided_id 
          value = value
        else
          value = /#{Regexp.escape(value)}/
        end
        finder[field] = value
      end
      @physical_servers = @physical_servers.where(finder)
      status_finder =[] 
      @check_status.each do |key, id |
        if @finder.send(key) == "1"
           status_finder << {:status => id[1]}
           @check_status[key][0] = "checked"
        else
           @check_status[key][0] = "unchecked"
        end
      end
      @physical_servers = @physical_servers.any_of(status_finder) unless status_finder.empty?
    end

    @physical_servers = @physical_servers.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @physical_servers }
    end
  end

  # GET /tengine/resource/physical_servers/1
  # GET /tengine/resource/physical_servers/1.json
  def show
    redirect_to :action => "index"
    # @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @physical_server }
    # end
  end

  # GET /tengine/resource/physical_servers/new
  # GET /tengine/resource/physical_servers/new.json
  def new
    redirect_to :action => "index"
  #   @physical_server = Tengine::Resource::PhysicalServer.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @physical_server }
  #   end
  end

  # GET /tengine/resource/physical_servers/1/edit
  def edit
    @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])
  end

  def create
    if params["commit"] == t(:cancel)
        redirect_to :action => "index"
    else

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
  end

  # PUT /tengine/resource/physical_servers/1
  # PUT /tengine/resource/physical_servers/1.json
  def update
    if params["commit"] == t(:cancel)
        redirect_to :action => "index"
    else

      @physical_server = Tengine::Resource::PhysicalServer.find(params[:id])
  
      respond_to do |format|
        if @physical_server.update_attributes(params[:physical_server])
          format.html { redirect_to tengine_resource_physical_servers_url, notice: successfully_updated(@physical_server) }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @physical_server.errors, status: :unprocessable_entity }
        end
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
