require 'ostruct'

class Tengine::Job::RootJobnetTemplatesController < ApplicationController
  # GET /tengine/job/root_jobnet_templates
  # GET /tengine/job/root_jobnet_templates.json
  def index
    conds = {}

    if sort_param = params[:sort]
      order = []
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        k = case k.to_s
            when "id"
              [:id, v]
            when "name"
              [:name, v]
            when "desc"
              [:description, v]
            end
        order.push k
      end
      conds[:sort] = order
    else
      default_sort = {:name => "asc"}
      request.query_parameters[:sort] = default_sort
      conds[:sort] = default_sort.to_a
    end

    if search_param = params[:finder]
      @finder = ::OpenStruct.new search_param
      conds[:conditions] = {}
      [:id, :name, :description].each do |field|
        unless (value = @finder.send(field)).blank?
          value = /#{Regexp.escape(value)}/ unless field == :id
          conds[:conditions][field] = value
        end
      end
    end

    @root_jobnet_templates = \
      Tengine::Job::RootJobnetTemplate.all(conds).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @root_jobnet_templates }
    end
  end

  # GET /tengine/job/root_jobnet_templates/1
  # GET /tengine/job/root_jobnet_templates/1.json
  def show
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @root_jobnet_template }
    end
  end

  # GET /tengine/job/root_jobnet_templates/new
  # GET /tengine/job/root_jobnet_templates/new.json
  def new
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @root_jobnet_template }
    end
  end

  # GET /tengine/job/root_jobnet_templates/1/edit
  def edit
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.find(params[:id])
  end

  # POST /tengine/job/root_jobnet_templates
  # POST /tengine/job/root_jobnet_templates.json
  def create
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.new(params[:root_jobnet_template])

    respond_to do |format|
      if @root_jobnet_template.save
        format.html { redirect_to @root_jobnet_template, notice: successfully_created(@root_jobnet_template) }
        format.json { render json: @root_jobnet_template, status: :created, location: @root_jobnet_template }
      else
        format.html { render action: "new" }
        format.json { render json: @root_jobnet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/root_jobnet_templates/1
  # PUT /tengine/job/root_jobnet_templates/1.json
  def update
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.find(params[:id])

    respond_to do |format|
      if @root_jobnet_template.update_attributes(params[:root_jobnet_template])
        format.html { redirect_to @root_jobnet_template, notice: successfully_updated(@root_jobnet_template) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @root_jobnet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/root_jobnet_templates/1
  # DELETE /tengine/job/root_jobnet_templates/1.json
  def destroy
    @root_jobnet_template = Tengine::Job::RootJobnetTemplate.find(params[:id])
    @root_jobnet_template.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_templates_url, notice: successfully_destroyed(@root_jobnet_template) }
      format.json { head :ok }
    end
  end
end
