class Tengine::Resource::VirtualServerImagesController < ApplicationController
  # GET /tengine/resource/virtual_server_images
  # GET /tengine/resource/virtual_server_images.json
  def index
    @virtual_server_images = Tengine::Resource::VirtualServerImage.all(:sort => [[:_id]]).page(params[:page])

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
    @virtual_server_image = Tengine::Resource::VirtualServerImage.find(params[:id])

    respond_to do |format|
      if @virtual_server_image.update_attributes(params[:virtual_server_image])
        format.html { redirect_to @virtual_server_image, notice: successfully_updated(@virtual_server_image) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @virtual_server_image.errors, status: :unprocessable_entity }
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
