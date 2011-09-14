# -*- coding: utf-8 -*-
class Tengine::Core::EventIgnitionsController < ApplicationController

  def new
    @event = Tengine::Event.new
    # 初期値をクリアします
    @event.key = nil
    @event.source_name = nil
    @event.sender_name = nil
    @event.level = nil
    @event.occurred_at = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  def fire
    event = params[:event]
    event_type_name = event[:event_type_name]

    options = ""
    options = options << " key:\"#{event[:key]}\"" unless event[:key].blank?
    options = options << " source_name:\"#{event[:source_name]}\"" unless event[:source_name].blank?
    options = options << " occurred_at:\"#{Time.parse(event[:occurred_at]).utc.to_s}\"" unless event[:occurred_at].blank?
    options = options << " level_key:\"#{Tengine::Core::Event.level_key_by_id(event[:level]).to_s}\"" unless event[:level].blank?
    options = options << " sender_name:\"#{event[:sender_name]}\"" unless event[:sender_name].blank?
    # TODO Hash としてセットできずにエラーになる
    # options = options << " properties:\"#{event[:properties]}\"" unless event[:properties].blank?

    fire_command = "tengine_fire #{event_type_name} #{options}"
    if system(fire_command)
      flash[:notice] = "#{event_type_name}を発火しました"
    else
      flash[:notice] = "#{event_type_name}を発火に失敗しました"
    end

    respond_to do |format|
      format.html { redirect_to action: 'new' }
      format.json { head :ok }
    end

  end

end
