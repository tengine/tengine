class Tengine::Resource::CredentialsController < ApplicationController
  # GET /tengine/resource/credentials
  # GET /tengine/resource/credentials.json
  def index
    @credentials = Tengine::Resource::Credential.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credentials }
    end
  end

  # GET /tengine/resource/credentials/1
  # GET /tengine/resource/credentials/1.json
  def show
    @credential = Tengine::Resource::Credential.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credential }
    end
  end

  # GET /tengine/resource/credentials/new
  # GET /tengine/resource/credentials/new.json
  def new
    @credential = Tengine::Resource::Credential.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credential }
    end
  end

  # GET /tengine/resource/credentials/1/edit
  def edit
    @credential = Tengine::Resource::Credential.find(params[:id])
  end

  # POST /tengine/resource/credentials
  # POST /tengine/resource/credentials.json
  def create
    @credential = Tengine::Resource::Credential.new(params[:credential])

    respond_to do |format|
      if @credential.save
        format.html { redirect_to @credential, notice: successfully_created(@credential) }
        format.json { render json: @credential, status: :created, location: @credential }
      else
        format.html { render action: "new" }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/resource/credentials/1
  # PUT /tengine/resource/credentials/1.json
  def update
    @credential = Tengine::Resource::Credential.find(params[:id])

    respond_to do |format|
      if @credential.update_attributes(params[:credential])
        format.html { redirect_to @credential, notice: successfully_updated(@credential) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/resource/credentials/1
  # DELETE /tengine/resource/credentials/1.json
  def destroy
    @credential = Tengine::Resource::Credential.find(params[:id])
    @credential.destroy

    respond_to do |format|
      format.html { redirect_to tengine_resource_credentials_url, notice: successfully_destroyed(@credential) }
      format.json { head :ok }
    end
  end
end
