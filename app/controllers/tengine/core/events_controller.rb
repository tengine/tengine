class Tengine::Core::EventsController < ApplicationController
  # GET /tengine/core/events
  # GET /tengine/core/events.json
  def index
    @events = Tengine::Core::Event.all(:sort => [[:_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /tengine/core/events/1
  # GET /tengine/core/events/1.json
  def show
    @event = Tengine::Core::Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /tengine/core/events/new
  # GET /tengine/core/events/new.json
  def new
    @event = Tengine::Core::Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /tengine/core/events/1/edit
  def edit
    @event = Tengine::Core::Event.find(params[:id])
  end

  # POST /tengine/core/events
  # POST /tengine/core/events.json
  def create
    @event = Tengine::Core::Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tengine/core/events/1
  # PUT /tengine/core/events/1.json
  def update
    @event = Tengine::Core::Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tengine/core/events/1
  # DELETE /tengine/core/events/1.json
  def destroy
    @event = Tengine::Core::Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to tengine_core_events_url }
      format.json { head :ok }
    end
  end
end
