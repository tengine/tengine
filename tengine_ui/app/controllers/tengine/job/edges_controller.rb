class Tengine::Job::EdgesController < ApplicationController
  before_filter :prepare_jobnet

  private
  def prepare_jobnet
    @jobnet = Tengine::Job::Jobnet.find(params[:jobnet_id])
  end
  def redirect_to(*args)
    obj = args.first
    case obj
    when Tengine::Job::Edge then
      super(tengine_job_jobnet_edge_url(@jobnet, args.shift), *args)
    else
      super(*args)
    end
  end

  public

  # GET /tengine/job/edges
  # GET /tengine/job/edges.json
  def index
    @edges = @jobnet.edges(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @edges }
    end
  end

  # GET /tengine/job/edges/1
  # GET /tengine/job/edges/1.json
  def show
    @edge = @jobnet.edges.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edge }
    end
  end

  # GET /tengine/job/edges/new
  # GET /tengine/job/edges/new.json
  def new
    @edge = @jobnet.edges.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edge }
    end
  end

  # GET /tengine/job/edges/1/edit
  def edit
    @edge = @jobnet.edges.find(params[:id])
  end

  # POST /tengine/job/edges
  # POST /tengine/job/edges.json
  def create
    @edge = @jobnet.edges.new(params[:edge])

    respond_to do |format|
      if @edge.save
        format.html { redirect_to @edge, notice: successfully_created(@edge) }
        format.json { render json: @edge, status: :created, location: @edge }
      else
        format.html { render action: "new" }
        format.json { render json: @edge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/edges/1
  # PUT /tengine/job/edges/1.json
  def update
    @edge = @jobnet.edges.find(params[:id])

    respond_to do |format|
      if @edge.update_attributes(params[:edge])
        format.html { redirect_to @edge, notice: successfully_updated(@edge) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @edge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/edges/1
  # DELETE /tengine/job/edges/1.json
  def destroy
    @edge = @jobnet.edges.find(params[:id])
    @edge.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_edges_url, notice: successfully_destroyed(@edge) }
      format.json { head :ok }
    end
  end
end
