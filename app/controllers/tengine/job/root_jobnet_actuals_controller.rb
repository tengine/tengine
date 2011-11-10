class Tengine::Job::RootJobnetActualsController < ApplicationController
  # GET /tengine/job/root_jobnet_actuals
  # GET /tengine/job/root_jobnet_actuals.json
  def index
    @root_jobnet_actuals = Mongoid::Criteria.new(Tengine::Job::RootJobnetActual)

    if sort_param = params[:sort]
      order = []
      sort_param.each do |k, v|
        v = (v.to_s == "desc") ? :desc : :asc
        k = case k.to_s
            when "id"
              [:_id, v]
            when "name", "description", "phase_cd", "started_at", "finished_at"
              [k, v]
            end
        order.push k
      end
    else
      default_sort = {:name => "asc"}
      request.query_parameters[:sort] = default_sort
      order = default_sort.to_a
    end
    @root_jobnet_actuals = @root_jobnet_actuals.order_by(order)

    @finder = Tengine::Job::RootJobnetActual::Finder.new(params[:finder])
    if @finder.valid?
      @root_jobnet_actuals = @finder.scope(@root_jobnet_actuals)
    end

    @category = nil
    if category_id = params[:category]
      @category = Tengine::Job::Category.first(:conditions => {:id => category_id})
      categories = category_childrens(@category).collect(&:id)
      unless categories.blank?
        @root_jobnet_actuals = \
          @root_jobnet_actuals.any_in({:category_id => categories})
      end
    end

    @root_jobnet_actuals = @root_jobnet_actuals.page(params[:page])
    @root_categories = Tengine::Job::Category.all(:conditions => {:parent_id => nil})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @root_jobnet_actuals }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/1
  # GET /tengine/job/root_jobnet_actuals/1.json
  def show
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @root_jobnet_actual }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/new
  # GET /tengine/job/root_jobnet_actuals/new.json
  def new
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @root_jobnet_actual }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/1/edit
  def edit
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])
  end

  # POST /tengine/job/root_jobnet_actuals
  # POST /tengine/job/root_jobnet_actuals.json
  def create
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.new(params[:root_jobnet_actual])

    respond_to do |format|
      if @root_jobnet_actual.save
        format.html { redirect_to @root_jobnet_actual, notice: successfully_created(@root_jobnet_actual) }
        format.json { render json: @root_jobnet_actual, status: :created, location: @root_jobnet_actual }
      else
        format.html { render action: "new" }
        format.json { render json: @root_jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/root_jobnet_actuals/1
  # PUT /tengine/job/root_jobnet_actuals/1.json
  def update
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])

    respond_to do |format|
      if @root_jobnet_actual.update_attributes(params[:root_jobnet_actual])
        format.html { redirect_to @root_jobnet_actual, notice: successfully_updated(@root_jobnet_actual) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @root_jobnet_actual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/root_jobnet_actuals/1
  # DELETE /tengine/job/root_jobnet_actuals/1.json
  def destroy
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])
    @root_jobnet_actual.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_actuals_url, notice: successfully_destroyed(@root_jobnet_actual) }
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
