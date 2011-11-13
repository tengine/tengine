class Tengine::Job::JobnetActualsController < ApplicationController
  # GET /tengine/job/jobnet_actuals
  # GET /tengine/job/jobnet_actuals.json
  def index
    @jobnet_actuals = Tengine::Job::JobnetActual.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobnet_actuals }
    end
  end

  # GET /tengine/job/jobnet_actuals/1
  # GET /tengine/job/jobnet_actuals/1.json
  def show
    @jobnet_actual = Tengine::Job::JobnetActual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/new
  # GET /tengine/job/jobnet_actuals/new.json
  def new
    @jobnet_actual = Tengine::Job::JobnetActual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/1/edit
  def edit
    @root_jobnet = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_id])
    @jobnet_actual = @root_jobnet.find_descendant(params[:id])
  end

  # POST /tengine/job/jobnet_actuals
  # POST /tengine/job/jobnet_actuals.json
  def create
    @jobnet_actual = Tengine::Job::JobnetActual.new(params[:jobnet_actual])

    respond_to do |format|
      if @jobnet_actual.save
        format.html { redirect_to @jobnet_actual, notice: successfully_created(@jobnet_actual) }
        format.json { render json: @jobnet_actual, status: :created, location: @jobnet_actual }
      else
        format.html { render action: "new" }
        format.json { render json: @jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/jobnet_actuals/1
  # PUT /tengine/job/jobnet_actuals/1.json
  def update
    @root_jobnet = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_id])
    @jobnet_actual = @root_jobnet.find_descendant(params[:id])

    respond_to do |format|
      if @jobnet_actual.update_attributes(params[:jobnet_actual])
        format.html do
          redirect_to tengine_job_root_jobnet_actual_path(@root_jobnet)
        end
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/jobnet_actuals/1
  # DELETE /tengine/job/jobnet_actuals/1.json
  def destroy
    @jobnet_actual = Tengine::Job::JobnetActual.find(params[:id])
    @jobnet_actual.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_jobnet_actuals_url, notice: successfully_destroyed(@jobnet_actual) }
      format.json { head :ok }
    end
  end
end
