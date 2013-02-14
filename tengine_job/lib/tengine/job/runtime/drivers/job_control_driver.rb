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
    # activate
    root_jobnet = Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = Tengine::Job::Runtime::Vertex.find(event[:target_jobnet_id]) || root_jobnet
      target_job = Tengine::Job::Runtime::Vertex.find(event[:target_job_id])
      signal.with_paths_backup do
        target_job.activate(signal) # transmitは既にされているはず。
      end
    end
    root_jobnet.reload
    if signal.callback
      block = signal.callback
      signal.callback = nil
      block.call
    end
    if signal.callback
      root_jobnet.update_with_lock(&signal.callback)
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
    l = Tengine::Job::Runtime::RootJobnet.find(i) or next

    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      n.phase_key = :stuck
    end
  end

  on :'stop.job.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    root_jobnet = Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = root_jobnet.find_descendant(event[:target_jobnet_id]) || root_jobnet
      target_job = target_jobnet.find_descendant(event[:target_job_id])
      signal.with_paths_backup do
        target_job.stop(signal)
      end
    end
    root_jobnet.reload
    if signal.callback
      signal.callback.call
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
    l = Tengine::Job::Runtime::RootJobnet.find(i) or next

    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      n.phase_key = :stuck
    end
  end

  on :'finished.process.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    root_jobnet = Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    # finish
    root_jobnet.update_with_lock do
      signal.reset
      job = root_jobnet.find_descendant(event[:target_job_id])
      job.finish(signal) unless job.phase_key == :stuck
    end
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
    l = Tengine::Job::Runtime::RootJobnet.find(i) or next

    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      n.phase_key = :stuck
    end
  end

  on :'expired.job.heartbeat.tengine' do
    event.tap do |e|
      Tengine::Job::Runtime::RootJobnet.find(e[:root_jobnet_id]).tap do |r|
        r.update_with_lock do
          r.find_descendant(e[:target_job_id]).phase_key = :stuck
        end
      end
    end
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
    l = Tengine::Job::Runtime::RootJobnet.find(i) or next

    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      n.phase_key = :stuck
    end
  end

  on :'restart.job.job.tengine' do
    begin
      signal = Tengine::Job::Runtime::Signal.new(event)
      root_jobnet = Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
      root_jobnet.update_with_lock do
        signal.reset
        job = root_jobnet.find_descendant(event[:target_job_id])
        job.reset(signal)
        job.transmit(signal)
      end
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
    l = Tengine::Job::Runtime::RootJobnet.find(i) or next

    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      n.phase_key = :stuck
    end
  end
end
