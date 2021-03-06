# -*- coding: utf-8 -*-
include Tengine::Core::SafeUpdatable

[
  :'start.jobnet.job.tengine',
  :'success.job.job.tengine',
  :'error.job.job.tengine',
  :'success.jobnet.job.tengine',
  :'error.jobnet.job.tengine',
  :'stop.jobnet.job.tengine',
].each do |i|
  ack_policy :after_all_handler_submit, i
end


# ジョブネット制御ドライバ
driver :jobnet_control_driver do

  on :'start.jobnet.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_jobnet =
      Tengine::Job::Runtime::Jobnet.find(event[:target_jobnet_id]) ||
    Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    signal.with_paths_backup do
      signal.remember(target_jobnet)
      signal.remember(target_jobnet.edges)
      target_jobnet.activate(signal)
    end
    signal.process_callbacks
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'start.jobnet.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = Tengine::Job::Runtime::NamedVertex.find(j) or next
    k.update_with_lock{ k.phase_key = :stuck }
  end

  on :'success.job.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
    signal.with_paths_backup do
      edge = target_job.next_edges.first
      jobnet = edge.owner
      signal.remember(edge)
      signal.remember(jobnet)
      signal.remember(jobnet.edges)
      # signal.cache_list
      jobnet.update_with_lock{ edge.transmit(signal) }
    end
    signal.process_callbacks
    # (*1)
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'success.job.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next

    # 上記(*1)のポイントでtenginedが落ちた時のことを考えると、後続のエッ
    # ジはもうtransmitしているが送信すべきイベントが欠けている状態であ
    # るので、この場合このジョブがおかしくなっているというよりむしろジョ
    # ブネット全体がおかしくなっているというべきである。
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    m = l.parent || l
    m.update_with_lock{ m.phase_key = :stuck }
  end

  on :'error.job.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_job = Tengine::Job::Runtime::NamedVertex.find(event[:target_job_id])
    signal.remember(target_job)
    signal.with_paths_backup do
      edge = target_job.next_edges.first
      signal.remember_all(target_job.root)
      signal.cache_list
      edge.close_followings_and_trasmit(signal)
    end
    signal.process_callbacks
    # target_jobnet = target_job.parent
    # target_jobnet.jobnet_fail(signal)
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'error.job.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next
    k = h["target_job_id"]     or next

    # 同上で、この場合このジョブがおかしくなっているというよりむしろジョ
    # ブネット全体がおかしくなっているというべきである。
    l = Tengine::Job::Runtime::NamedVertex.find(k) or next
    m = l.parent || l
    m.update_with_lock{ m.phase_key = :stuck }
  end

  on :'success.jobnet.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_jobnet = Tengine::Job::Runtime::Jobnet.find(event[:target_jobnet_id])
    signal.with_paths_backup do
      case target_jobnet.jobnet_type_key
      when :finally then
        parent = target_jobnet.parent
        signal.remember_all(parent)
        signal.cache_list
        edge = signal.cache(parent.end_vertex.prev_edges.first)
        (edge.closed? || edge.closing?) ?
          parent.fail(signal) :
          parent.succeed(signal)
      else
        if edge = signal.cache(target_jobnet.next_edges || []).first
          edge.owner.update_with_lock do
            edge.transmit(signal)
          end
        else
          signal.cache(target_jobnet.parent || signal.execution).succeed(signal)
          if target_jobnet.root?
            signal.execution.with(sage: safemode(Tengine::Job::Runtime::Execution.collection)).save!
          end
        end
      end
    end
    signal.process_callbacks
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'success.jobnet.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next

    k = Tengine::Job::Runtime::NamedVertex.find(j) or next
    k.update_with_lock{ k.phase_key = :stuck }
  end

  on :'error.jobnet.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_jobnet =
      Tengine::Job::Runtime::Jobnet.find(event[:target_jobnet_id]) ||
      Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    signal.with_paths_backup do
      case target_jobnet.jobnet_type_key
      when :finally then
        target_jobnet.parent.fail(signal)
      else
        signal.remember_all(target_jobnet.root)
        if edge = (target_jobnet.next_edges || []).first
          edge.close_followings_and_trasmit(signal)
        else
          (target_jobnet.parent || signal.execution).fail(signal)
          if target_jobnet.root?
            signal.execution.with(safe: safemode(Tengine::Job::Runtime::Execution.collection)).save!
          end
        end
      end
    end
    signal.process_callbacks
    # if target_parent = target_jobnet.parent
    #   target_parent.end_vertex.transmit(signal)
    # end
    signal.reservations.each{|r| fire(*r.fire_args)}
    submit
  end

  on :'error.jobnet.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next

    k = Tengine::Job::Runtime::NamedVertex.find(j) or next
    k.update_with_lock{ k.phase_key = :stuck }
  end

  on :'stop.jobnet.job.tengine' do
    signal = Tengine::Job::Runtime::Signal.new(event)
    signal.reset
    target_jobnet =
      Tengine::Job::Runtime::Jobnet.find(event[:target_jobnet_id]) ||
      Tengine::Job::Runtime::RootJobnet.find(event[:root_jobnet_id])
    # signal.remember_all(target_jobnet)
    # signal.cache_list
    target_jobnet.stop(signal)
    signal.process_callbacks
    signal.reservations.each{|r| fire(*r.fire_args) }
    submit
  end

  on :'stop.jobnet.job.tengine.failed.tengined' do
    # このイベントは壊れていたからfailedなのかもしれない。多重送信によ
    # りfailedなのかもしれない。あまりへんな仮定を置かない方が良い。
    e = event
    f = e.properties           or next
    g = f["original_event"]    or next
    h = g["properties"]        or next
    i = h["root_jobnet_id"]    or next
    j = h["target_jobnet_id"]  or next

    k = Tengine::Job::Runtime::NamedVertex.find(j) or next
    k.update_with_lock{ k.phase_key = :stuck }
  end
end
