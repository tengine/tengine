class Tengine::Job::ScriptActualsController < ApplicationController
  # GET /tengine/job/script_actuals
  # GET /tengine/job/script_actuals.json
  def index
    @script_actuals = Tengine::Job::ScriptActual.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @script_actuals }
    end
  end

  # GET /tengine/job/script_actuals/1
  # GET /tengine/job/script_actuals/1.json
  def show
    @script_actual = Tengine::Job::ScriptActual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @script_actual }
    end
  end

  # GET /tengine/job/script_actuals/new
  # GET /tengine/job/script_actuals/new.json
  def new
    @script_actual = Tengine::Job::ScriptActual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @script_actual }
    end
  end

  # GET /tengine/job/script_actuals/1/edit
  def edit
    @script_actual = Tengine::Job::ScriptActual.find(params[:id])
  end

  # POST /tengine/job/script_actuals
  # POST /tengine/job/script_actuals.json
  def create
    @script_actual = Tengine::Job::ScriptActual.new(params[:script_actual])

    respond_to do |format|
      if @script_actual.save
        format.html { redirect_to @script_actual, notice: successfully_created(@script_actual) }
        format.json { render json: @script_actual, status: :created, location: @script_actual }
      else
        format.html { render action: "new" }
        format.json { render json: @script_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/script_actuals/1
  # PUT /tengine/job/script_actuals/1.json
  def update
    @script_actual = Tengine::Job::ScriptActual.find(params[:id])

    respond_to do |format|
      if @script_actual.update_attributes(params[:script_actual])
        format.html { redirect_to @script_actual, notice: successfully_updated(@script_actual) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @script_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/script_actuals/1
  # DELETE /tengine/job/script_actuals/1.json
  def destroy
    @script_actual = Tengine::Job::ScriptActual.find(params[:id])
    @script_actual.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_script_actuals_url, notice: successfully_destroyed(@script_actual) }
      format.json { head :ok }
    end
  end
end
