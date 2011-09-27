class Tengine::Job::ScriptTemplatesController < ApplicationController
  # GET /tengine/job/script_templates
  # GET /tengine/job/script_templates.json
  def index
    @script_templates = Tengine::Job::ScriptTemplate.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @script_templates }
    end
  end

  # GET /tengine/job/script_templates/1
  # GET /tengine/job/script_templates/1.json
  def show
    @script_template = Tengine::Job::ScriptTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @script_template }
    end
  end

  # GET /tengine/job/script_templates/new
  # GET /tengine/job/script_templates/new.json
  def new
    @script_template = Tengine::Job::ScriptTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @script_template }
    end
  end

  # GET /tengine/job/script_templates/1/edit
  def edit
    @script_template = Tengine::Job::ScriptTemplate.find(params[:id])
  end

  # POST /tengine/job/script_templates
  # POST /tengine/job/script_templates.json
  def create
    @script_template = Tengine::Job::ScriptTemplate.new(params[:script_template])

    respond_to do |format|
      if @script_template.save
        format.html { redirect_to @script_template, notice: successfully_created(@script_template) }
        format.json { render json: @script_template, status: :created, location: @script_template }
      else
        format.html { render action: "new" }
        format.json { render json: @script_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/script_templates/1
  # PUT /tengine/job/script_templates/1.json
  def update
    @script_template = Tengine::Job::ScriptTemplate.find(params[:id])

    respond_to do |format|
      if @script_template.update_attributes(params[:script_template])
        format.html { redirect_to @script_template, notice: successfully_updated(@script_template) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @script_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/script_templates/1
  # DELETE /tengine/job/script_templates/1.json
  def destroy
    @script_template = Tengine::Job::ScriptTemplate.find(params[:id])
    @script_template.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_script_templates_url, notice: successfully_destroyed(@script_template) }
      format.json { head :ok }
    end
  end
end
