# -*- coding: utf-8 -*-
class Tengine::Core::EventsController < ApplicationController

  # GET /tengine/core/events
  # GET /tengine/core/events.json
  def index

    # 検索ボタン押下の遷移でない且つ、セッション上に検索フォームの情報がある場合は、セッション情報を利用する
    if params[:commit].blank? && session[:events_finder]
      @finder = Tengine::Core::Event::Finder.new(session[:events_finder])
    else
      @finder = Tengine::Core::Event::Finder.new(params[:finder])
      session[:events_finder]  = @finder.attributes
    end

    @events = @finder.paginate(params[:page])

    respond_to do |format|
      format.html {
        if reflesh?
          # app/views/layouts/refresh.html.erb で更新間隔として参照しています。
          @reflesh_interval = reflesh_interval
          render layout: "refresh"
        else
          render
        end
      } # index.html.erb
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
        format.html { redirect_to @event, notice: successfully_created(@event) }
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
        format.html { redirect_to @event, notice: successfully_updated(@event) }
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
      format.html { redirect_to tengine_core_events_url, notice: successfully_destroyed(@event) }
      format.json { head :ok }
    end
  end

  # indexアクション且つ、更新間隔が0以外の場合リフレッシュします。
  def reflesh?
    action_name == 'index' && reflesh_interval != 0
  end

  # パラメータから更新間隔を取り出し数値でかえします。
  # 有効な値がない場合は0を返します。
  def reflesh_interval
    result = 0
    result = params[:finder][:reflesh_interval].to_i if params[:finder]
    return result
  end

end
