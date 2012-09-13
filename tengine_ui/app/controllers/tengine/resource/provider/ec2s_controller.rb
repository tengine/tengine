require 'tengine/resource_ec2'

class Tengine::Resource::Provider::Ec2sController < ApplicationController
  # GET /tengine/resource/provider/ec2s
  # GET /tengine/resource/provider/ec2s.json
  def index
    @ec2s = Tengine::ResourceEc2::Provider.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ec2s }
    end
  end

  # GET /tengine/resource/provider/ec2s/1
  # GET /tengine/resource/provider/ec2s/1.json
  def show
    @ec2 = Tengine::ResourceEc2::Provider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ec2 }
    end
  end

  # GET /tengine/resource/provider/ec2s/new
  # GET /tengine/resource/provider/ec2s/new.json
  def new
    @ec2 = Tengine::ResourceEc2::Provider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ec2 }
    end
  end

  # GET /tengine/resource/provider/ec2s/1/edit
  def edit
    @ec2 = Tengine::ResourceEc2::Provider.find(params[:id])
  end

  # POST /tengine/resource/provider/ec2s
  # POST /tengine/resource/provider/ec2s.json
  def create
    @ec2 = Tengine::ResourceEc2::Provider.new(params[:ec2])

    respond_to do |format|
      if @ec2.save
        format.html { redirect_to tengine_resource_provider_ec2_url(@ec2), notice: successfully_created(@ec2) }
        format.json { render json: @ec2, status: :created, location: @ec2 }
      else
        format.html { render action: "new" }
        format.json { render json: @ec2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/provider/ec2s/1
  # PUT /tengine/resource/provider/ec2s/1.json
  def update
    @ec2 = Tengine::ResourceEc2::Provider.find(params[:id])

    respond_to do |format|
      if @ec2.update_attributes(params[:ec2])
        format.html { redirect_to tengine_resource_provider_ec2_url(@ec2), notice: successfully_updated(@ec2) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ec2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/provider/ec2s/1
  # DELETE /tengine/resource/provider/ec2s/1.json
  def destroy
    @ec2 = Tengine::ResourceEc2::Provider.find(params[:id])
    @ec2.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_provider_ec2s_url, notice: successfully_destroyed(@ec2) }
      format.json { head :ok }
    end
  end
end
