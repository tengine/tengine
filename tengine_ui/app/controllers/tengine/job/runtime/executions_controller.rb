class Tengine::Job::Runtime::ExecutionsController < ApplicationController
  # GET /tengine/job/runtime/executions
  # GET /tengine/job/runtime/executions.json
  def index
    @executions = Tengine::Job::Runtime::Execution.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @executions }
    end
  end

  # GET /tengine/job/runtime/executions/1
  # GET /tengine/job/runtime/executions/1.json
  def show
    @execution = Tengine::Job::Runtime::Execution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @execution }
    end
  end

  # GET /tengine/job/runtime/executions/new
  # GET /tengine/job/runtime/executions/new.json
  def new
    root_jobnet_id = params[:root_jobnet_id]

    @retry = false
    if params[:retry].to_s == "true"
      unless root_jobnet_id
        redirect_to tengine_job_runtime_root_jobnets_path
        return
      end

      @retry = true

      @root_jobnet = Tengine::Job::Runtime::RootJobnet.find(root_jobnet_id)

      @select_root_jobnet = false
      @target_actual_ids = [params[:target_actual_ids]].flatten.compact.uniq
      if @target_actual_ids.empty?
        @target_actual_ids = [@root_jobnet.id.to_s]
        @select_root_jobnet = true
      elsif @target_actual_ids.size == 1 &&
        @target_actual_ids.first == @root_jobnet.id.to_s

        @select_root_jobnet = true
      end
    else
      unless root_jobnet_id
        redirect_to tengine_job_template_root_jobnets_path
        return
      end

      dsl_version = Tengine::Core::Setting.dsl_version
      @root_jobnet = Tengine::Job::Template::RootJobnet.where(
        :dsl_version => dsl_version).find(root_jobnet_id)
    end

    @execution = Tengine::Job::Runtime::Execution.new(
      :actual_base_timeout_alert => 0,
      :actual_base_timeout_termination => 0,
      :root_jobnet_id => root_jobnet_id,
      :retry => @retry,
    )
    @execution.target_actual_ids = @target_actual_ids if @retry

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @execution }
    end
  end

  # GET /tengine/job/runtime/executions/1/edit
  def edit
    @execution = Tengine::Job::Runtime::Execution.find(params[:id])
  end

  # POST /tengine/job/runtime/executions
  # POST /tengine/job/runtime/executions.json
  def create
    execute_param = params[:execution]
    @execution = Tengine::Job::Runtime::Execution.new(execute_param)

    respond_to do |format|
      @retry = @execution.retry
      klass = Tengine::Job::Template::RootJobnet
      klass = Tengine::Job::Runtime::RootJobnet if @retry
      @root_jobnet = klass.find(@execution.root_jobnet_id)

      runtime_root_jobnet = @retry ? @root_jobnet : @root_jobnet.generate

      executed = nil
      EM.run do
        operation = @retry ? :rerun : :execute
        executed = runtime_root_jobnet.send(operation, execute_param)
      end

      format.html do
        redirect_to tengine_job_runtime_root_jobnet_path(executed.root_jobnet.id)
      end
      format.json { render json: @execution, status: :created, location: @execution }
    end
  end

  # PUT /tengine/job/runtime/executions/1
  # PUT /tengine/job/runtime/executions/1.json
  def update
    @execution = Tengine::Job::Runtime::Execution.find(params[:id])

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

  # DELETE /tengine/job/runtime/executions/1
  # DELETE /tengine/job/runtime/executions/1.json
  def destroy
    @execution = Tengine::Job::Runtime::Execution.find(params[:id])
    @execution.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_runtime_executions_url, notice: successfully_destroyed(@execution) }
      format.json { head :ok }
    end
  end
end
