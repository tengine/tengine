class Tengine::Job::ExecutionsController < ApplicationController
  # GET /tengine/job/executions
  # GET /tengine/job/executions.json
  def index
    @executions = Tengine::Job::Execution.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @executions }
    end
  end

  # GET /tengine/job/executions/1
  # GET /tengine/job/executions/1.json
  def show
    @execution = Tengine::Job::Execution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @execution }
    end
  end

  # GET /tengine/job/executions/new
  # GET /tengine/job/executions/new.json
  def new
    @retry = false
    if params[:retry].to_s == "true"
      @retry = true
      @root_jobnet = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_id])
      @spot = (params[:spot].to_s == "true") ? true : false
      @target_actuals = [@target_actuals].flatten.compact
      if @target_actuals.empty?
        @target_actuals = [@root_jobnet.id]
        @spot = false
      end
    else
      dsl_version = Tengine::Core::Setting.dsl_version
      @root_jobnet = Tengine::Job::RootJobnetTemplate.where(
        :dsl_version => dsl_version).find(params[:root_jobnet_id])
    end

    @execution = Tengine::Job::Execution.new(
      :actual_base_timeout_alert => 0,
      :actual_base_timeout_termination => 0,
    )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @execution }
    end
  end

  # GET /tengine/job/executions/1/edit
  def edit
    @execution = Tengine::Job::Execution.find(params[:id])
  end

  # POST /tengine/job/executions
  # POST /tengine/job/executions.json
  def create
    @execution = Tengine::Job::Execution.new(params[:execution])

    respond_to do |format|
      if @execution.save
        format.html { redirect_to @execution, notice: successfully_created(@execution) }
        format.json { render json: @execution, status: :created, location: @execution }
      else
        format.html { render action: "new" }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/executions/1
  # PUT /tengine/job/executions/1.json
  def update
    @execution = Tengine::Job::Execution.find(params[:id])

    respond_to do |format|
      if @execution.update_attributes(params[:execution])
        format.html { redirect_to @execution, notice: successfully_updated(@execution) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/executions/1
  # DELETE /tengine/job/executions/1.json
  def destroy
    @execution = Tengine::Job::Execution.find(params[:id])
    @execution.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_executions_url, notice: successfully_destroyed(@execution) }
      format.json { head :ok }
    end
  end
end
