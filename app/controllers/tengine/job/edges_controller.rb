class Tengine::Job::EdgesController < ApplicationController
  # GET /tengine/job/edges
  # GET /tengine/job/edges.json
  def index
    @edges = Tengine::Job::Edge.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @edges }
    end
  end

  # GET /tengine/job/edges/1
  # GET /tengine/job/edges/1.json
  def show
    @edge = Tengine::Job::Edge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edge }
    end
  end

  # GET /tengine/job/edges/new
  # GET /tengine/job/edges/new.json
  def new
    @edge = Tengine::Job::Edge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edge }
    end
  end

  # GET /tengine/job/edges/1/edit
  def edit
    @edge = Tengine::Job::Edge.find(params[:id])
  end

  # POST /tengine/job/edges
  # POST /tengine/job/edges.json
  def create
    @edge = Tengine::Job::Edge.new(params[:edge])

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
    @edge = Tengine::Job::Edge.find(params[:id])

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
    @edge = Tengine::Job::Edge.find(params[:id])
    @edge.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_edges_url, notice: successfully_destroyed(@edge) }
      format.json { head :ok }
    end
  end
end
