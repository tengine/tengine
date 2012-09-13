class Tengine::Job::JobnetTemplatesController < ApplicationController
  # GET /tengine/job/jobnet_templates
  # GET /tengine/job/jobnet_templates.json
  def index
    @jobnet_templates = Tengine::Job::JobnetTemplate.asc(:_id).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobnet_templates }
    end
  end

  # GET /tengine/job/jobnet_templates/1
  # GET /tengine/job/jobnet_templates/1.json
  def show
    @jobnet_template = Tengine::Job::JobnetTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jobnet_template }
    end
  end

  # GET /tengine/job/jobnet_templates/new
  # GET /tengine/job/jobnet_templates/new.json
  def new
    @jobnet_template = Tengine::Job::JobnetTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jobnet_template }
    end
  end

  # GET /tengine/job/jobnet_templates/1/edit
  def edit
    @jobnet_template = Tengine::Job::JobnetTemplate.find(params[:id])
  end

  # POST /tengine/job/jobnet_templates
  # POST /tengine/job/jobnet_templates.json
  def create
    @jobnet_template = Tengine::Job::JobnetTemplate.new(params[:jobnet_template])

    respond_to do |format|
      if @jobnet_template.save
        format.html { redirect_to @jobnet_template, notice: successfully_created(@jobnet_template) }
        format.json { render json: @jobnet_template, status: :created, location: @jobnet_template }
      else
        format.html { render action: "new" }
        format.json { render json: @jobnet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/jobnet_templates/1
  # PUT /tengine/job/jobnet_templates/1.json
  def update
    @jobnet_template = Tengine::Job::JobnetTemplate.find(params[:id])

    respond_to do |format|
      if @jobnet_template.update_attributes(params[:jobnet_template])
        format.html { redirect_to @jobnet_template, notice: successfully_updated(@jobnet_template) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @jobnet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/jobnet_templates/1
  # DELETE /tengine/job/jobnet_templates/1.json
  def destroy
    @jobnet_template = Tengine::Job::JobnetTemplate.find(params[:id])
    @jobnet_template.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_jobnet_templates_url, notice: successfully_destroyed(@jobnet_template) }
      format.json { head :ok }
    end
  end
end
