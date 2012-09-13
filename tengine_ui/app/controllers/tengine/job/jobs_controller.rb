class Tengine::Job::JobsController < ApplicationController
  # GET /tengine/job/jobs
  # GET /tengine/job/jobs.json
  def index
    @jobs = Tengine::Job::Job.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /tengine/job/jobs/1
  # GET /tengine/job/jobs/1.json
  def show
    @job = Tengine::Job::Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /tengine/job/jobs/new
  # GET /tengine/job/jobs/new.json
  def new
    @job = Tengine::Job::Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # GET /tengine/job/jobs/1/edit
  def edit
    @job = Tengine::Job::Job.find(params[:id])
  end

  # POST /tengine/job/jobs
  # POST /tengine/job/jobs.json
  def create
    @job = Tengine::Job::Job.new(params[:job])

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: successfully_created(@job) }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/jobs/1
  # PUT /tengine/job/jobs/1.json
  def update
    @job = Tengine::Job::Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: successfully_updated(@job) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/jobs/1
  # DELETE /tengine/job/jobs/1.json
  def destroy
    @job = Tengine::Job::Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_jobs_url, notice: successfully_destroyed(@job) }
      format.json { head :ok }
    end
  end
end
