class Tengine::Job::ScriptsController < ApplicationController
  # GET /tengine/job/scripts
  # GET /tengine/job/scripts.json
  def index
    @scripts = Tengine::Job::Script.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scripts }
    end
  end

  # GET /tengine/job/scripts/1
  # GET /tengine/job/scripts/1.json
  def show
    @script = Tengine::Job::Script.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @script }
    end
  end

  # GET /tengine/job/scripts/new
  # GET /tengine/job/scripts/new.json
  def new
    @script = Tengine::Job::Script.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @script }
    end
  end

  # GET /tengine/job/scripts/1/edit
  def edit
    @script = Tengine::Job::Script.find(params[:id])
  end

  # POST /tengine/job/scripts
  # POST /tengine/job/scripts.json
  def create
    @script = Tengine::Job::Script.new(params[:script])

    respond_to do |format|
      if @script.save
        format.html { redirect_to @script, notice: successfully_created(@script) }
        format.json { render json: @script, status: :created, location: @script }
      else
        format.html { render action: "new" }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/scripts/1
  # PUT /tengine/job/scripts/1.json
  def update
    @script = Tengine::Job::Script.find(params[:id])

    respond_to do |format|
      if @script.update_attributes(params[:script])
        format.html { redirect_to @script, notice: successfully_updated(@script) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/scripts/1
  # DELETE /tengine/job/scripts/1.json
  def destroy
    @script = Tengine::Job::Script.find(params[:id])
    @script.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_scripts_url, notice: successfully_destroyed(@script) }
      format.json { head :ok }
    end
  end
end
