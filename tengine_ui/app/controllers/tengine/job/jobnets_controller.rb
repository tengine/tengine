class Tengine::Job::JobnetsController < ApplicationController
  # GET /tengine/job/jobnets
  # GET /tengine/job/jobnets.json
  def index
    @jobnets = Tengine::Job::Jobnet.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobnets }
    end
  end

  # GET /tengine/job/jobnets/1
  # GET /tengine/job/jobnets/1.json
  def show
    @jobnet = Tengine::Job::Jobnet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jobnet }
    end
  end

  # GET /tengine/job/jobnets/new
  # GET /tengine/job/jobnets/new.json
  def new
    @jobnet = Tengine::Job::Jobnet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jobnet }
    end
  end

  # GET /tengine/job/jobnets/1/edit
  def edit
    @jobnet = Tengine::Job::Jobnet.find(params[:id])
  end

  # POST /tengine/job/jobnets
  # POST /tengine/job/jobnets.json
  def create
    @jobnet = Tengine::Job::Jobnet.new(params[:jobnet])

    respond_to do |format|
      if @jobnet.save
        format.html { redirect_to @jobnet, notice: successfully_created(@jobnet) }
        format.json { render json: @jobnet, status: :created, location: @jobnet }
      else
        format.html { render action: "new" }
        format.json { render json: @jobnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/jobnets/1
  # PUT /tengine/job/jobnets/1.json
  def update
    @jobnet = Tengine::Job::Jobnet.find(params[:id])

    respond_to do |format|
      if @jobnet.update_attributes(params[:jobnet])
        format.html { redirect_to @jobnet, notice: successfully_updated(@jobnet) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @jobnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/jobnets/1
  # DELETE /tengine/job/jobnets/1.json
  def destroy
    @jobnet = Tengine::Job::Jobnet.find(params[:id])
    @jobnet.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_jobnets_url, notice: successfully_destroyed(@jobnet) }
      format.json { head :ok }
    end
  end
end
