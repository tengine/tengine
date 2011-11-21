require 'ostruct'

class Tengine::Resource::CredentialsController < ApplicationController
  # GET /tengine/resource/credentials
  # GET /tengine/resource/credentials.json
  def index
    @credentials = Tengine::Resource::Credential.all(:sort => [[:_id]]).page(params[:page])
    @check_status = {
      "auth_type_cd_01" => "checked", 
      "auth_type_cd_02" => "checked"
    }


    if sort_param = params[:sort]
      order = []
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        k = case k.to_s
            when "name"
              [:name, v]
            when "description"
              [:description, v]
            when "auth_type_cd"
              [:auth_type_cd, v]
            end
        order.push k
      end
    else
      default_sort = {:name => "asc"}
      request.query_parameters[:sort] = default_sort
      order = default_sort.to_a
    end
    @credentials = @credentials.order_by(order)

    if search_param = params[:finder]
      @finder = ::OpenStruct.new search_param
      finder = {}
      [:name, :description].each do |field|
        next if (value = @finder.send(field)).blank?
        value = /#{Regexp.escape(value)}/
        finder[field] = value
      end
      @credentials = @credentials.where(finder)
      auth_type = {:auth_type_cd_01 => "01", :auth_type_cd_02 => "02"}
      auth_type_finder =[] 
      auth_type.each do |key, id |
        if @finder.send(key) == "1"
          auth_type_finder << {:auth_type_cd => id}
          @check_status[key.to_s] = "checked"
        else
          @check_status[key.to_s] = "unchecked"
        end
      end
      @credentials = @credentials.any_of(auth_type_finder) unless auth_type_finder.empty?
    end

    @credentials = @credentials.page(params[:page])

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
    if params["commit"] == t(:cancel)
        redirect_to :action => "index"
    else
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
  end

  # PUT /tengine/resource/credentials/1
  # PUT /tengine/resource/credentials/1.json
  def update
    if params["commit"] == t(:cancel)
        redirect_to :action => "index"
    else

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
