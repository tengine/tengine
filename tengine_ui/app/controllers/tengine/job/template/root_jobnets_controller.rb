require 'ostruct'

class Tengine::Job::Template::RootJobnetsController < ApplicationController
  # GET /tengine/job/template/root_jobnet_templates
  # GET /tengine/job/template/root_jobnet_templates.json
  def index
    dsl_version = Tengine::Core::Setting.dsl_version rescue nil
    flash["notice"] = "NO dsl_version given. Maybe no tengined started." unless dsl_version
    @root_jobnet_templates = Tengine::Job::Template::RootJobnet.where(:dsl_version => dsl_version)

    if sort_param = params[:sort]
      order = []
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        k = case k.to_s
            when "id"
              [:_id, v]
            when "name"
              [:name, v]
            when "desc"
              [:description, v]
            end
        order.push k
      end
    else
      default_sort = {:name => "asc"}
      request.query_parameters[:sort] = default_sort
      order = default_sort.to_a
    end
    order.each do |n, v|
      @root_jobnet_templates = @root_jobnet_templates.send(v, n)
    end

    if search_param = params[:finder]
      @finder = ::OpenStruct.new search_param
      finder = {}
      [:id, :name, :description].each do |field|
        next if (value = @finder.send(field)).blank?
        if field.to_s == "id"
          finder[:_id] = Moped::BSON::ObjectId(value)
        else
          value = /#{Regexp.escape(value)}/
          finder[field] = value
        end
      end
      @root_jobnet_templates = @root_jobnet_templates.where(finder)
    end

    @category = nil
    if category_id = params[:category]
      @category = Tengine::Job::Structure::Category.where({:id => category_id}).first
      categories = category_childrens(@category).collect(&:id)
      unless categories.blank?
        @root_jobnet_templates = \
          @root_jobnet_templates.any_in({:category_id => categories})
      end
    end

    @root_jobnet_templates = @root_jobnet_templates.page(params[:page])
    @root_categories = Tengine::Job::Structure::Category.where({:parent_id => nil})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @root_jobnet_templates }
    end
  end

  # GET /tengine/job/template/root_jobnet_templates/1
  # GET /tengine/job/template/root_jobnet_templates/1.json
  def show
    dsl_version = Tengine::Core::Setting.dsl_version
    @root_jobnet_template = \
      Tengine::Job::Template::RootJobnet.where(:dsl_version => dsl_version).find(params[:id])
    @jobnet_templates = []
    visitor = Tengine::Job::Structure::Visitor::All.new do |vertex|
      if vertex.instance_of?(Tengine::Job::Template::Jobnet) or vertex.instance_of?(Tengine::Job::Template::Expansion)
        @jobnet_templates << [vertex, (vertex.ancestors.size - 1)]
      end
    end
    @root_jobnet_template.accept_visitor(visitor)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @root_jobnet_template }
    end
  end

  # GET /tengine/job/template/root_jobnet_templates/new
  # GET /tengine/job/template/root_jobnet_templates/new.json
  def new
    @root_jobnet_template = Tengine::Job::Template::RootJobnet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @root_jobnet_template }
    end
  end

  # GET /tengine/job/template/root_jobnet_templates/1/edit
  def edit
    @root_jobnet_template = Tengine::Job::Template::RootJobnet.find(params[:id])
  end

  # POST /tengine/job/template/root_jobnet_templates
  # POST /tengine/job/template/root_jobnet_templates.json
  def create
    @root_jobnet_template = Tengine::Job::Template::RootJobnet.new(params[:root_jobnet_template])

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

  # PUT /tengine/job/template/root_jobnet_templates/1
  # PUT /tengine/job/template/root_jobnet_templates/1.json
  def update
    @root_jobnet_template = Tengine::Job::Template::RootJobnet.find(params[:id])

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

  # DELETE /tengine/job/template/root_jobnet_templates/1
  # DELETE /tengine/job/template/root_jobnet_templates/1.json
  def destroy
    @root_jobnet_template = Tengine::Job::Template::RootJobnet.find(params[:id])
    @root_jobnet_template.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_templates_url, notice: successfully_destroyed(@root_jobnet_template) }
      format.json { head :ok }
    end
  end

  private

  def category_childrens(category)
    result = []
    return result unless category
    _category_childrens(result, category)
    return result
  end

  def _category_childrens(result, category)
    return unless category
    result << category
    category.children.each do |i|
      _category_childrens(result, i)
    end
  end
end
