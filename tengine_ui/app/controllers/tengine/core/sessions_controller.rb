class Tengine::Core::SessionsController < ApplicationController
  # GET /tengine/core/sessions
  # GET /tengine/core/sessions.json
  def index
    @sessions = Tengine::Core::Session.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sessions }
    end
  end

  # GET /tengine/core/sessions/1
  # GET /tengine/core/sessions/1.json
  def show
    @session = Tengine::Core::Session.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @session }
    end
  end

  # GET /tengine/core/sessions/new
  # GET /tengine/core/sessions/new.json
  def new
    @session = Tengine::Core::Session.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @session }
    end
  end

  # GET /tengine/core/sessions/1/edit
  def edit
    @session = Tengine::Core::Session.find(params[:id])
  end

  # POST /tengine/core/sessions
  # POST /tengine/core/sessions.json
  def create
    @session = Tengine::Core::Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: successfully_created(@session) }
        format.json { render json: @session, status: :created, location: @session }
      else
        format.html { render action: "new" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/sessions/1
  # PUT /tengine/core/sessions/1.json
  def update
    @session = Tengine::Core::Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to @session, notice: successfully_updated(@session) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/sessions/1
  # DELETE /tengine/core/sessions/1.json
  def destroy
    @session = Tengine::Core::Session.find(params[:id])
    @session.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_sessions_url, notice: successfully_destroyed(@session) }
      format.json { head :ok }
    end
  end
end
