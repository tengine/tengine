class Tengine::Resource::VirtualServerImagesController < ApplicationController
  # GET /tengine/resource/virtual_server_images
  # GET /tengine/resource/virtual_server_images.json
  def index
    @virtual_server_images = Mongoid::Criteria.new(Tengine::Resource::VirtualServerImage)

    order = []
    if sort_param = params[:sort]
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        if %w(name provided_id description provided_description).include?(k.to_s)
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
    @virtual_server_images = @virtual_server_images.order_by(order)

    if search_param = params[:finder]
      @finder = ::OpenStruct.new search_param
      finder = {}
      [:name, :description, :provided_id].each do |field|
        next if (value = @finder.send(field)).blank?
        unless field.to_s == "provided_id"
          value = /#{Regexp.escape(value)}/
        end
        finder[field] = value
      end
      @virtual_server_images = @virtual_server_images.where(finder)
    end

    @virtual_server_images = @virtual_server_images.page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @virtual_server_images }
    end
  end

  # GET /tengine/resource/virtual_server_images/1
  # GET /tengine/resource/virtual_server_images/1.json
  def show
    redirect_to :action =>'index'
    # @virtual_server_image = Tengine::Resource::VirtualServerImage.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @virtual_server_image }
    # end
  end

  # GET /tengine/resource/virtual_server_images/new
  # GET /tengine/resource/virtual_server_images/new.json
  # def new
  #   @virtual_server_image = Tengine::Resource::VirtualServerImage.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @virtual_server_image }
  #   end
  # end

  # GET /tengine/resource/virtual_server_images/1/edit
  def edit
    @virtual_server_image = Tengine::Resource::VirtualServerImage.find(params[:id])
  end

  # POST /tengine/resource/virtual_server_images
  # POST /tengine/resource/virtual_server_images.json
  def create
    @virtual_server_image = Tengine::Resource::VirtualServerImage.new(params[:virtual_server_image])

    respond_to do |format|
      if @virtual_server_image.save
        format.html { redirect_to @virtual_server_image, notice: successfully_created(@virtual_server_image) }
        format.json { render json: @virtual_server_image, status: :created, location: @virtual_server_image }
      else
        format.html { render action: "new" }
        format.json { render json: @virtual_server_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/virtual_server_images/1
  # PUT /tengine/resource/virtual_server_images/1.json
  def update
    if params["commit"] == t(:cancel)
      redirect_to :action => "index"
    else
      @virtual_server_image = Tengine::Resource::VirtualServerImage.find(params[:id])
  
      respond_to do |format|
        if @virtual_server_image.update_attributes(params[:virtual_server_image])
          format.html { redirect_to tengine_resource_virtual_server_images_url,
            notice: successfully_updated(@virtual_server_image) }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @virtual_server_image.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tengine/resource/virtual_server_images/1
  # DELETE /tengine/resource/virtual_server_images/1.json
  def destroy
    @virtual_server_image = Tengine::Resource::VirtualServerImage.find(params[:id])
    @virtual_server_image.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_virtual_server_images_url, notice: successfully_destroyed(@virtual_server_image) }
      format.json { head :ok }
    end
  end
end
