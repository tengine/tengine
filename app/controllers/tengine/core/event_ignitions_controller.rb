# -*- coding: utf-8 -*-

# TODO ここではなくて、Tengine::Eventの定義で以下の記述を行う
Tengine::Event.class_eval do
  unless instance_methods.include?(:properties_yaml)
    include Tengine::Core::CollectionAccessible
    map_yaml_accessor :properties
  end
end

class Tengine::Core::EventIgnitionsController < ApplicationController

  def new
    @event = Tengine::Event.new
    # 初期値をクリアします
    @event.key = nil
    @event.source_name = nil
    @event.sender_name = nil
    @event.level = nil
    @event.occurred_at = nil

    @core_event = Tengine::Core::Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  def fire
    @core_event = Tengine::Core::Event.new(params[:event])
    if @core_event.valid?
      begin
        event = params[:event]
        event_type_name = event[:event_type_name]
        options = [:key, :source_name, :occurred_at, :level, :sender_name].inject({}) do |d, name|
          val = event[name]
          d[name] = val unless val.blank?
          d
        end
        yaml = event[:properties_yaml]
        unless yaml.blank?
          options[:properties] = YAML.load(yaml)
        end
        EM.run{ Tengine::Event.fire(event_type_name, options) }
        flash[:notice] = "#{event_type_name}を発火しました"
      rescue Exception => e
        flash[:notice] = "#{event_type_name}の発火に失敗しました: [#{e.class.name}] #{e.message}"
      end
    end

    respond_to do |format|
      if !@core_event.errors
        format.html { redirect_to action: 'new'}
        format.json { head :ok }
      else
        @event = Tengine::Event.new(params[:event])
        format.html { render action: 'new'}
        format.json { head :ok }
      end
    end

  end

end
