require 'tengine/resource/provider'

class Tengine::Resource::ProvidersController < ApplicationController
  # GET /tengine/resource/providers
  # GET /tengine/resource/providers.json
  def index
    @providers = Tengine::Resource::Provider.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @providers }
    end
  end

  # GET /tengine/resource/providers/1
  # GET /tengine/resource/providers/1.json
  def show
    @provider = Tengine::Resource::Provider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /tengine/resource/providers/new
  # GET /tengine/resource/providers/new.json
  def new
    @provider = Tengine::Resource::Provider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /tengine/resource/providers/1/edit
  def edit
    @provider = Tengine::Resource::Provider.find(params[:id])
  end

  # POST /tengine/resource/providers
  # POST /tengine/resource/providers.json
  def create
    @provider = Tengine::Resource::Provider.new(params[:provider])

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: successfully_created(@provider) }
        format.json { render json: @provider, status: :created, location: @provider }
      else
        format.html { render action: "new" }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/providers/1
  # PUT /tengine/resource/providers/1.json
  def update
    @provider = Tengine::Resource::Provider.find(params[:id])

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        format.html { redirect_to @provider, notice: successfully_updated(@provider) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/providers/1
  # DELETE /tengine/resource/providers/1.json
  def destroy
    @provider = Tengine::Resource::Provider.find(params[:id])
    @provider.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_providers_url, notice: successfully_destroyed(@provider) }
      format.json { head :ok }
    end
  end
end
