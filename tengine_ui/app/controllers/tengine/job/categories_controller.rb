class Tengine::Job::CategoriesController < ApplicationController
  # GET /tengine/job/categories
  # GET /tengine/job/categories.json
  def index
    @categories = Tengine::Job::Category.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /tengine/job/categories/1
  # GET /tengine/job/categories/1.json
  def show
    @category = Tengine::Job::Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /tengine/job/categories/new
  # GET /tengine/job/categories/new.json
  def new
    @category = Tengine::Job::Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /tengine/job/categories/1/edit
  def edit
    @category = Tengine::Job::Category.find(params[:id])
  end

  # POST /tengine/job/categories
  # POST /tengine/job/categories.json
  def create
    @category = Tengine::Job::Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: successfully_created(@category) }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/job/categories/1
  # PUT /tengine/job/categories/1.json
  def update
    @category = Tengine::Job::Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: successfully_updated(@category) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/job/categories/1
  # DELETE /tengine/job/categories/1.json
  def destroy
    @category = Tengine::Job::Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to tengine_job_categories_url, notice: successfully_destroyed(@category) }
      format.json { head :ok }
    end
  end
end
