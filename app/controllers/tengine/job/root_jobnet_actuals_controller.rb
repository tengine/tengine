class Tengine::Job::RootJobnetActualsController < ApplicationController
  # GET /tengine/job/root_jobnet_actuals
  # GET /tengine/job/root_jobnet_actuals.json
  def index
    @finder = Tengine::Job::RootJobnetActual::Finder.new(params[:finder])
    @category = nil
    @root_jobnet_actuals = Tengine::Job::RootJobnetActual.all(:sort => [[:_id]]).page(params[:page]).per(1)
    @root_categories = Tengine::Job::Category.all(:conditions => {:parent_id => nil})


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @root_jobnet_actuals }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/1
  # GET /tengine/job/root_jobnet_actuals/1.json
  def show
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @root_jobnet_actual }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/new
  # GET /tengine/job/root_jobnet_actuals/new.json
  def new
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @root_jobnet_actual }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/1/edit
  def edit
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])
  end

  # POST /tengine/job/root_jobnet_actuals
  # POST /tengine/job/root_jobnet_actuals.json
  def create
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.new(params[:root_jobnet_actual])

    respond_to do |format|
      if @root_jobnet_actual.save
        format.html { redirect_to @root_jobnet_actual, notice: successfully_created(@root_jobnet_actual) }
        format.json { render json: @root_jobnet_actual, status: :created, location: @root_jobnet_actual }
      else
        format.html { render action: "new" }
        format.json { render json: @root_jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/root_jobnet_actuals/1
  # PUT /tengine/job/root_jobnet_actuals/1.json
  def update
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])

    respond_to do |format|
      if @root_jobnet_actual.update_attributes(params[:root_jobnet_actual])
        format.html { redirect_to @root_jobnet_actual, notice: successfully_updated(@root_jobnet_actual) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @root_jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/root_jobnet_actuals/1
  # DELETE /tengine/job/root_jobnet_actuals/1.json
  def destroy
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])
    @root_jobnet_actual.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_actuals_url, notice: successfully_destroyed(@root_jobnet_actual) }
      format.json { head :ok }
    end
  end
end
