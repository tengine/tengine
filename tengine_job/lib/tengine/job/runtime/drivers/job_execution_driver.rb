# -*- coding: utf-8 -*-
include Tengine::Core::SafeUpdatable

ack_policy :after_all_handler_submit, :'start.execution.job.tengine'
ack_policy :after_all_handler_submit, :'stop.execution.job.tengine'

# ジョブ起動ドライバ
driver :job_execution_driver do

  on :'start.execution.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    execution = signal.execution
    root_jobnet = execution.root_jobnet
    root_jobnet.update_with_lock do
      signal.reset
      execution.transmit(signal)
    end
    execution.with(safe: safemode(Tengine::Job::Runtime::Execution.collection)).save!
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'start.execution.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties                     or next
    g = f["original_event"]              or next
    h = g["properties"]                  or next
    i = h["execution_id"]                or next
    j = Tengine::Job::Runtime::Execution.find(i)  or next

    j.update_attributes :phase_key => :stuck
  end

  on :'stop.execution.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    execution = signal.execution
    root_jobnet = execution.root_jobnet
    root_jobnet.update_with_lock do
      signal.reset
      execution.stop(signal)
    end
    execution.with(safe: safemode(Tengine::Job::Runtime::Execution.collection)).save!
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'stop.execution.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties                     or next
    g = f["original_event"]              or next
    h = g["properties"]                  or next
    i = h["execution_id"]                or next
    j = Tengine::Job::Runtime::Execution.find(i)  or next

    j.update_attributes :phase_key => :stuck
  end
end
