class Tengine::Job::ExpansionsController < ApplicationController
  # GET /tengine/job/expansions
  # GET /tengine/job/expansions.json
  def index
    @expansions = Tengine::Job::Expansion.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expansions }
    end
  end

  # GET /tengine/job/expansions/1
  # GET /tengine/job/expansions/1.json
  def show
    @expansion = Tengine::Job::Expansion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expansion }
    end
  end

  # GET /tengine/job/expansions/new
  # GET /tengine/job/expansions/new.json
  def new
    @expansion = Tengine::Job::Expansion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expansion }
    end
  end

  # GET /tengine/job/expansions/1/edit
  def edit
    @expansion = Tengine::Job::Expansion.find(params[:id])
  end

  # POST /tengine/job/expansions
  # POST /tengine/job/expansions.json
  def create
    @expansion = Tengine::Job::Expansion.new(params[:expansion])

    respond_to do |format|
      if @expansion.save
        format.html { redirect_to @expansion, notice: successfully_created(@expansion) }
        format.json { render json: @expansion, status: :created, location: @expansion }
      else
        format.html { render action: "new" }
        format.json { render json: @expansion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/expansions/1
  # PUT /tengine/job/expansions/1.json
  def update
    @expansion = Tengine::Job::Expansion.find(params[:id])

    respond_to do |format|
      if @expansion.update_attributes(params[:expansion])
        format.html { redirect_to @expansion, notice: successfully_updated(@expansion) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @expansion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/expansions/1
  # DELETE /tengine/job/expansions/1.json
  def destroy
    @expansion = Tengine::Job::Expansion.find(params[:id])
    @expansion.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_expansions_url, notice: successfully_destroyed(@expansion) }
      format.json { head :ok }
    end
  end
end
