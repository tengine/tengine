class Tengine::Core::SettingsController < ApplicationController
  # GET /tengine/core/settings
  # GET /tengine/core/settings.json
  def index
    @settings = Tengine::Core::Setting.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @settings }
    end
  end

  # GET /tengine/core/settings/1
  # GET /tengine/core/settings/1.json
  def show
    @setting = Tengine::Core::Setting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @setting }
    end
  end

  # GET /tengine/core/settings/new
  # GET /tengine/core/settings/new.json
  def new
    @setting = Tengine::Core::Setting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @setting }
    end
  end

  # GET /tengine/core/settings/1/edit
  def edit
    @setting = Tengine::Core::Setting.find(params[:id])
  end

  # POST /tengine/core/settings
  # POST /tengine/core/settings.json
  def create
    @setting = Tengine::Core::Setting.new(params[:setting])

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: successfully_created(@setting) }
        format.json { render json: @setting, status: :created, location: @setting }
      else
        format.html { render action: "new" }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/settings/1
  # PUT /tengine/core/settings/1.json
  def update
    @setting = Tengine::Core::Setting.find(params[:id])

    respond_to do |format|
      if @setting.update_attributes(params[:setting])
        format.html { redirect_to @setting, notice: successfully_updated(@setting) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/settings/1
  # DELETE /tengine/core/settings/1.json
  def destroy
    @setting = Tengine::Core::Setting.find(params[:id])
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_settings_url, notice: successfully_destroyed(@setting) }
      format.json { head :ok }
    end
  end
end
