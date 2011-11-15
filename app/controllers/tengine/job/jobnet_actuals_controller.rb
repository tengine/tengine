class Tengine::Job::JobnetActualsController < ApplicationController
  # GET /tengine/job/jobnet_actuals
  # GET /tengine/job/jobnet_actuals.json
  def index
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actuals = []
    visitor = Tengine::Job::Vertex::AllVisitor.new do |vertex|
                if vertex.instance_of?(Tengine::Job::JobnetActual)
                  @jobnet_actuals << vertex
                end
              end
    @root_jobnet_actual.accept_visitor(visitor)
    @jobnet_actuals = Kaminari.paginate_array(@jobnet_actuals).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobnet_actuals }
    end
  end

  # GET /tengine/job/jobnet_actuals/1
  # GET /tengine/job/jobnet_actuals/1.json
  def show
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = Tengine::Job::JobnetActual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/new
  # GET /tengine/job/jobnet_actuals/new.json
  def new
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = Tengine::Job::JobnetActual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/1/edit
  def edit
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = @root_jobnet_actual.find_descendant(params[:id])
  end

  # POST /tengine/job/jobnet_actuals
  # POST /tengine/job/jobnet_actuals.json
  def create
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = Tengine::Job::JobnetActual.new(params[:jobnet_actual])

    respond_to do |format|
      if @jobnet_actual.save
        format.html { redirect_to tengine_job_root_jobnet_actual_jobnet_actual_url(@jobnet_actual, :root_jobnet_actual_id => @root_jobnet_actual), notice: successfully_created(@jobnet_actual) }
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
    @root_jobnet_actual = \
      Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = @root_jobnet_actual.find_descendant(params[:id])

    respond_to do |format|
      if @jobnet_actual.update_attributes(params[:jobnet_actual])
        format.html do
          redirect_to tengine_job_root_jobnet_actual_path(@root_jobnet_actual)
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
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:root_jobnet_actual_id])
    @jobnet_actual = @root_jobnet_actual.find_descendant(params[:id])
    stop(@root_jobnet_actual, @jobnet_actual)

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_actual_path(@root_jobnet_actual), notice: successfully_destroyed(@jobnet_actual) }
      format.json { head :ok }
    end
  end

  private

  def stop(root_jobnet, target, options={})
    root_jobnet_id = root_jobnet.id.to_s
    result = Tengine::Job::Execution.create!(
      options.merge(:root_jobnet_id => root_jobnet_id))
    properties = {
      :execution_id => result.id.to_s,
      :root_jobnet_id => root_jobnet_id,
    }

    target_id = target.id.to_s
    if target.children.blank?
      event = :"stop.job.job.tengine"
      properties[:target_job_id] = target_id
      properties[:target_jobnet_id] = target.parent.id.to_s
    else
      event = :"stop.jobnet.job.tengine"
      properties[:target_jobnet_id] = target_id
    end

    sender = Tengine::Event.default_sender
    sender.wait_for_connection do
      sender.fire(event, :source_name => target.name_as_resource,
        :properties => properties)
    end

    return result
  end
end
