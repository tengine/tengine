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
      @target_actual_class = Tengine::Job::RootJobnetActual
    else
      @target_actual_class = Tengine::Job::RootJobnetTemplate
    end

    @target_actuals = []
    if ids = params[:target_actual_ids]
      @target_actuals = @target_actual_class.any_in(:_id => [ids].flatten)
      if @target_actuals.empty?
        ex = Mongoid::Errors::DocumentNotFound.new(
          @target_actual_class, ids)
        raise ex
      end
    end
    @execution = Tengine::Job::Execution.new

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
