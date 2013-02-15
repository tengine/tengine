# -*- coding: utf-8 -*-

[
 :'start.job.job.tengine',
 :'stop.job.job.tengine',
 :'finished.process.job.tengine',
 :'expired.job.heartbeat.tengine',
 :'restart.job.job.tengine',
].each do |i|
  ack_policy :after_all_handler_submit, i
end


# ジョブ制御ドライバ
driver :job_control_driver do

  on :'start.job.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
      signal.reset
      target_job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
      signal.with_paths_backup do
        target_job.activate(signal) # transmitは既にされているはず。
      end
    if signal.callback
      block, signal.callback = signal.callback, nil
      block.call
    end
    if signal.callback
      target_job.update_with_lock(&signal.callback)
    end
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'start.job.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    l.update_with_lock{ l.phase_key = :stuck }
  end

  on :'stop.job.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
      signal.reset
      target_job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
      signal.with_paths_backup do
        target_job.stop(signal)
      end
    if signal.callback
      block, signal.callback = signal.callback, nil
      block.call
    end
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'stop.job.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    l.update_with_lock{ l.phase_key = :stuck }
  end

  on :'finished.process.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    # finish
      signal.reset
      job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
      job.finish(signal) unless job.phase_key == :stuck
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'finished.process.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    l.update_with_lock{ l.phase_key = :stuck }
  end

  on :'expired.job.heartbeat.tengine' do
    job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
    job.update_with_lock{ job.phase_key = :stuck }
    submit
  end

  on :'expired.job.heartbeat.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    l.update_with_lock{ l.phase_key = :stuck }
  end

  on :'restart.job.job.tengine' do
    begin
      signal = Tengine::Job::Runtime::Signal.new(event)
        signal.reset
        job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
        job.reset(signal)
        job.transmit(signal)
      signal.reservations.each{|r| fire(*r.fire_args)}
    ensure
      submit
    end
  end

  on :'restart.job.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    l.update_with_lock{ l.phase_key = :stuck }
  end
end
