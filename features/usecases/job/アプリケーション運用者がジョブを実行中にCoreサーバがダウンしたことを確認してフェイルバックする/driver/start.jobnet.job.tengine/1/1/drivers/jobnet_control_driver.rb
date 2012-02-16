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
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = root_jobnet.find_descendant(event[:target_jobnet_id]) || root_jobnet
      signal.with_paths_backup do
        target_jobnet.activate(signal)
      end
    end
    `echo start.jobnet.job.tengine_1_1  >> /tmp/core_server_down_txt`
    `echo please poweroff this server >> /tmp/core_server_down_txt`
    sleep 300
    signal.execution.safely(safemode(Tengine::Job::Execution.collection)).save! if event[:root_jobnet_id] == event[:target_jobnet_id]
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
    k = Tengine::Job::RootJobnetActual.find(i) or next

    k.update_with_lock do
      l = k.find_descendant(j) || k
      l.phase_key = :stuck
    end
  end

  on :'success.job.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_job = root_jobnet.find_descendant(event[:target_job_id])
      signal.with_paths_backup do
        edge = target_job.next_edges.first
        edge.transmit(signal)
      end
    end
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
    l = Tengine::Job::RootJobnetActual.find(i) or next

    # 上記(*1)のポイントでtenginedが落ちた時のことを考えると、後続のエッ
    # ジはもうtransmitしているが送信すべきイベントが欠けている状態であ
    # るので、この場合このジョブがおかしくなっているというよりむしろジョ
    # ブネット全体がおかしくなっているというべきである。
    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      o = n.parent || n
      o.phase_key = :stuck
    end
  end

  on :'error.job.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_job = root_jobnet.vertex(event[:target_job_id])
      signal.with_paths_backup do
        edge = target_job.next_edges.first
        edge.close_followings
        edge.transmit(signal)
      end
      # target_jobnet = target_job.parent
      # target_jobnet.jobnet_fail(signal)
    end
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
    l = Tengine::Job::RootJobnetActual.find(i) or next

    # 同上で、この場合このジョブがおかしくなっているというよりむしろジョ
    # ブネット全体がおかしくなっているというべきである。
    l.update_with_lock do
      m = l.find_descendant(j)  || l
      n = m.find_descendant(k)
      o = n.parent || n
      o.phase_key = :stuck
    end
  end

  on :'success.jobnet.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = root_jobnet.vertex(event[:target_jobnet_id])
      signal.with_paths_backup do
        case target_jobnet.jobnet_type_key
        when :finally then
          parent = target_jobnet.parent
          edge = parent.end_vertex.prev_edges.first
          (edge.closed? || edge.closing?) ?
            parent.fail(signal) :
            parent.succeed(signal)
        else
          if edge = (target_jobnet.next_edges || []).first
            edge.transmit(signal)
          else
            (target_jobnet.parent || signal.execution).succeed(signal)
          end
        end
      end
    end
    signal.execution.safely(safemode(Tengine::Job::Execution.collection)).save! if event[:root_jobnet_id] == event[:target_jobnet_id]
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
    k = Tengine::Job::RootJobnetActual.find(i) or next

    k.update_with_lock do
      l = k.find_descendant(j) || k
      l.phase_key = :stuck
    end
  end

  on :'error.jobnet.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = root_jobnet.find_descendant(event[:target_jobnet_id]) || root_jobnet
      signal.with_paths_backup do
        case target_jobnet.jobnet_type_key
        when :finally then
          target_jobnet.parent.fail(signal)
        else
          if edge = (target_jobnet.next_edges || []).first
            edge.close_followings
            edge.transmit(signal)
          else
            (target_jobnet.parent || signal.execution).fail(signal)
          end
        end
      end
      # if target_parent = target_jobnet.parent
      #   target_parent.end_vertex.transmit(signal)
      # end
    end
    signal.execution.safely(safemode(Tengine::Job::Execution.collection)).save! if event[:root_jobnet_id] == event[:target_jobnet_id]
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
    k = Tengine::Job::RootJobnetActual.find(i) or next

    k.update_with_lock do
      l = k.find_descendant(j) || k
      l.phase_key = :stuck
    end
  end

  on :'stop.jobnet.job.tengine' do
    signal = Tengine::Job::Signal.new(event)
    root_jobnet = Tengine::Job::RootJobnetActual.find(event[:root_jobnet_id])
    root_jobnet.update_with_lock do
      signal.reset
      target_jobnet = root_jobnet.find_descendant(event[:target_jobnet_id]) || root_jobnet
      target_jobnet.stop(signal)
    end
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
    k = Tengine::Job::RootJobnetActual.find(i) or next

    k.update_with_lock do
      l = k.find_descendant(j) || k
      l.phase_key = :stuck
    end
  end
end
