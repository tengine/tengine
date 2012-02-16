# -*- coding: utf-8 -*-
include Tengine::Core::SafeUpdatable

# スケジュール管理ドライバ
driver :schedule_driver do

  on :'start.execution.job.tengine' do
    exec = Tengine::Job::Signal.new(event).execution
    name = exec.name_as_resource
    status = Tengine::Core::Schedule::SCHEDULED
    if exec.actual_base_timeout_alert && !exec.actual_base_timeout_alert.zero?
      t1 = Time.now + (exec.actual_base_timeout_alert * 60.0)
      Tengine::Core::Schedule.safely(
        safemode(Tengine::Core::Schedule.collection)
      ).create(
        event_type_name: "alert.execution.job.tengine", scheduled_at: t1, source_name: name, status: status , properties: event.properties
      )
    end
    if exec.actual_base_timeout_termination && !exec.actual_base_timeout_termination.zero?
      t2 = Time.now + (exec.actual_base_timeout_termination * 60.0)
      Tengine::Core::Schedule.safely(
        safemode(Tengine::Core::Schedule.collection)
      ).create(
        event_type_name: "stop.execution.job.tengine", scheduled_at: t2, source_name: name, status: status, properties: event.properties.merge(stop_reason: 'timeout')
      )
    end
    submit
  end

  on :'start.execution.job.tengine.failed.tengined' do
    e = event
    f = e.properties                     or next
    g = f["original_event"]              or next
    h = g["properties"]                  or next
    i = h["execution_id"]                or next

    orig = Tengine::Core::EventWrapper.new(Tengine::Core::Event.new(g)) # this object shall noe be persisted
    exec = Tengine::Job::Signal.new(orig).execution
    name = exec.name_as_resource
    status = Tengine::Core::Schedule::SCHEDULED
    if exec.actual_base_timeout_alert && !exec.actual_base_timeout_alert.zero? && Tengine::Core::Schedule.where(event_type_name: "alert.execution.job.tengine", source_name: name).count.zero?
      t1 = Time.now + (exec.actual_base_timeout_alert * 60.0)
      Tengine::Core::Schedule.safely(
        safemode(Tengine::Core::Schedule.collection)
      ).create(
        event_type_name: "alert.execution.job.tengine", scheduled_at: t1, source_name: name, status: status , properties: orig.properties
      )
    end
    if exec.actual_base_timeout_termination && !exec.actual_base_timeout_termination.zero? && Tengine::Core::Schedule.where(event_type_name: "stop.execution.job.tengine", source_name: name).count.zero?
      t2 = Time.now + (exec.actual_base_timeout_termination * 60.0)
      Tengine::Core::Schedule.safely(
        safemode(Tengine::Core::Schedule.collection)
      ).create(
        event_type_name: "stop.execution.job.tengine", scheduled_at: t2, source_name: name, status: status, properties: orig.properties.merge(stop_reason: 'timeout')
      )
    end
    submit
  end

  on :'success.execution.job.tengine' do
    name = Tengine::Job::Signal.new(event).execution.name_as_resource
    Tengine::Core::Schedule.safely(
      safemode(Tengine::Core::Schedule.collection)
    ).where(
      source_name: name, status: Tengine::Core::Schedule::SCHEDULED
    ).update_all(status: Tengine::Core::Schedule::INVALID)
    submit
  end

  on :'error.execution.job.tengine' do
    name = Tengine::Job::Signal.new(event).execution.name_as_resource
    Tengine::Core::Schedule.safely(
      safemode(Tengine::Core::Schedule.collection)
    ).where(
      source_name: name, status: Tengine::Core::Schedule::SCHEDULED
    ).update_all(status: Tengine::Core::Schedule::INVALID)
    submit
  end

end
