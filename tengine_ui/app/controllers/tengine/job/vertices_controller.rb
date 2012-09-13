class Tengine::Job::VerticesController < ApplicationController
  # GET /tengine/job/vertices
  # GET /tengine/job/vertices.json
  def index
    @vertices = Tengine::Job::Vertex.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vertices }
    end
  end

  # GET /tengine/job/vertices/1
  # GET /tengine/job/vertices/1.json
  def show
    @vertex = Tengine::Job::Vertex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vertex }
    end
  end

  # GET /tengine/job/vertices/new
  # GET /tengine/job/vertices/new.json
  def new
    @vertex = Tengine::Job::Vertex.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vertex }
    end
  end

  # GET /tengine/job/vertices/1/edit
  def edit
    @vertex = Tengine::Job::Vertex.find(params[:id])
  end

  # POST /tengine/job/vertices
  # POST /tengine/job/vertices.json
  def create
    @vertex = Tengine::Job::Vertex.new(params[:vertex])

    respond_to do |format|
      if @vertex.save
        format.html { redirect_to @vertex, notice: successfully_created(@vertex) }
        format.json { render json: @vertex, status: :created, location: @vertex }
      else
        format.html { render action: "new" }
        format.json { render json: @vertex.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/vertices/1
  # PUT /tengine/job/vertices/1.json
  def update
    @vertex = Tengine::Job::Vertex.find(params[:id])

    respond_to do |format|
      if @vertex.update_attributes(params[:vertex])
        format.html { redirect_to @vertex, notice: successfully_updated(@vertex) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vertex.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/vertices/1
  # DELETE /tengine/job/vertices/1.json
  def destroy
    @vertex = Tengine::Job::Vertex.find(params[:id])
    @vertex.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_vertices_url, notice: successfully_destroyed(@vertex) }
      format.json { head :ok }
    end
  end
end
