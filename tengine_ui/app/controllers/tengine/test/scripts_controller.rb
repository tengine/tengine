class Tengine::Test::ScriptsController < ApplicationController
  # GET /tengine/test/scripts
  # GET /tengine/test/scripts.json
  def index
    @script = Tengine::Test::Script.new

    @scripts = Tengine::Test::Script.all(:sort => [[:_id, :desc]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scripts }
    end
  end

  # GET /tengine/test/scripts/1
  # GET /tengine/test/scripts/1.json
  def show
    @script = Tengine::Test::Script.find(params[:id].to_i)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @script }
    end
  end

  # GET /tengine/test/scripts/new
  # GET /tengine/test/scripts/new.json
  def new
    @script = Tengine::Test::Script.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @script }
    end
  end

  # GET /tengine/test/scripts/1/edit
  def edit
    @script = Tengine::Test::Script.find(params[:id].to_i)
  end

  # POST /tengine/test/scripts
  # POST /tengine/test/scripts.json
  def create
    @script = Tengine::Test::Script.new(params[:script])

    respond_to do |format|
      if @script.save
        if params[:from_index]
          format.html { redirect_to tengine_test_scripts_url, notice: successfully_created(@script) }
        else
          format.html { redirect_to @script, notice: successfully_created(@script) }
        end
        format.json { render json: @script, status: :created, location: @script }
      else
        format.html { render action: "new" }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/test/scripts/1
  # PUT /tengine/test/scripts/1.json
  def update
    @script = Tengine::Test::Script.find(params[:id].to_i)

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

  # DELETE /tengine/test/scripts/1
  # DELETE /tengine/test/scripts/1.json
  def destroy
    @script = Tengine::Test::Script.find(params[:id].to_i)
    @script.destroy

    respond_to do |format|
      format.html { redirect_to tengine_test_scripts_url, notice: successfully_destroyed(@script) }
      format.json { head :ok }
    end
  end
end
