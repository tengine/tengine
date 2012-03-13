# -*- coding: utf-8 -*-
require "ostruct"

class Tengine::Job::RootJobnetActualsController < ApplicationController
  # GET /tengine/job/root_jobnet_actuals
  # GET /tengine/job/root_jobnet_actuals.json
  def index
    @root_jobnet_actuals = Mongoid::Criteria.new(Tengine::Job::RootJobnetActual)

    if sort_param = params[:sort]
      order = sort_order(sort_param)
    else
      default_sort = {:started_at => "desc"}
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
      format.html { # index.html.erb
        if @auto_refresh = @finder.reflesh_interval.to_i != 0
          @reflesh_interval = @finder.reflesh_interval
        end
        render
      }
      format.json { render json: @root_jobnet_actuals }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/1
  # GET /tengine/job/root_jobnet_actuals/1.json
  def show
    @root_jobnet_actual = Tengine::Job::RootJobnetActual.find(params[:id])
    @jobnet_actuals = []
    visitor = Tengine::Job::Vertex::AllVisitor.new do |vertex|
                if vertex.instance_of?(Tengine::Job::JobnetActual)
                  @jobnet_actuals << [vertex, (vertex.ancestors.size - 1)]
                end
              end
    @root_jobnet_actual.accept_visitor(visitor)

    @refresher = OpenStruct.new
    @refresher.refresh_interval = 15
    if params[:refresher]
      @refresher.refresh_interval = params[:refresher][:refresh_interval].to_i
      if @refresher.refresh_interval < 0
        @refresher.refresh_interval = 0
      end
    end
    @refresh_interval = @refresher.refresh_interval

     @finder = { :source_name => "/#{@root_jobnet_actual.id.to_s}/" }
#     @finder = { :source_name => @root_jobnet_actual.name_as_resource, }
#     if s = @root_jobnet_actual.started_at
#       @finder[:occurred_at_start] = s.strftime("%H:%M")
#     end
#     if e = @root_jobnet_actual.finished_at
#       @finder[:occurred_at_end] = e.strftime("%H:%M")
#     end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @root_jobnet_actual }
    end
  end

  # GET /tengine/job/root_jobnet_actuals/new
  # GET /tengine/job/root_jobnet_actuals/new.json
  def new
    redirect_to :action => 'index'
    # @root_jobnet_actual = Tengine::Job::RootJobnetActual.new

    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @root_jobnet_actual }
    # end
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
        format.html do
          redirect_to tengine_job_root_jobnet_actual_path
        end
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
    stop(@root_jobnet_actual)

    respond_to do |format|
      format.html { redirect_to tengine_job_root_jobnet_actual_path(@root_jobnet_actual), notice: successfully_destroyed(@root_jobnet_actual) }
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

  def stop(root_jobnet, options={})
    root_jobnet_id = root_jobnet.id.to_s
    result = Tengine::Job::Execution.create!(
      options.merge(:root_jobnet_id => root_jobnet_id))

    EM.run do
      Tengine::Event.fire(:"stop.jobnet.job.tengine",
        :source_name => root_jobnet.name_as_resource,
        :properties => {
          :execution_id => result.id.to_s,
          :root_jobnet_id => root_jobnet_id,
          :target_jobnet_id => root_jobnet_id.to_s,
          :stop_reason => "user_stop",
        })
    end

    return result
  end
end
