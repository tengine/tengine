class Tengine::Job::Runtime::JobnetsController < ApplicationController
  private

  before_filter :assign_root_jobnet_actual
  def assign_root_jobnet_actual
    @root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.find(params[:root_jobnet_actual_id])
  end

  public

  # GET /tengine/job/jobnet_actuals
  # GET /tengine/job/jobnet_actuals.json
  def index
    @jobnet_actuals = []
    visitor = Tengine::Job::Vertex::AllVisitor.new do |vertex|
                if vertex.instance_of?(Tengine::Job::Runtime::Jobnet)
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
    @jobnet_actual = @root_jobnet_actual.vertex(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/new
  # GET /tengine/job/jobnet_actuals/new.json
  def new
    @jobnet_actual = Tengine::Job::Runtime::Jobnet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jobnet_actual }
    end
  end

  # GET /tengine/job/jobnet_actuals/1/edit
  def edit
    @jobnet_actual = @root_jobnet_actual.vertex(params[:id])
  end

  # POST /tengine/job/jobnet_actuals
  # POST /tengine/job/jobnet_actuals.json
  def create
    @jobnet_actual = Tengine::Job::Runtime::Jobnet.new(params[:jobnet_actual])

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
    @jobnet_actual = @root_jobnet_actual.find_descendant(params[:id])
    stop(@root_jobnet_actual, @jobnet_actual)

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_actual_path(@root_jobnet_actual), notice: successfully_destroyed(@jobnet_actual) }
      format.json { head :ok }
    end
  end

  private

  def stop(root_jobnet, target, options={})
    target.fire_stop_event root_jobnet, options
  end
end
