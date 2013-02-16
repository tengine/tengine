# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# 処理を意味するVertex。実際に実行を行うTengine::Job::Scriptやジョブネットである
# Tengine::Job::Runtime::Jobnetの継承元である。
class Tengine::Job::Runtime::NamedVertex < Tengine::Job::Runtime::Vertex
  field :name, :type => String # ジョブの名称。

  validates :name, :presence => true

  # 楽観的ロックのためのバージョン。更新するたびにインクリメントされます。
  # これはジョブネットや末端のSshJob毎にロックをかけられるようにしています。
  include Tengine::Core::OptimisticLock
  set_locking_field :version
  field :version, :type => Integer, :default => 0

  # リソース識別子を返します
  def name_as_resource
    @name_as_resource ||= "job:#{Tengine::Event.host_name}/#{Process.pid.to_s}/#{root.id.to_s}/#{id.to_s}"
  end

  def short_inspect
    "#<%%%-30s id: %s name: %s>" % [self.class.name, self.id.to_s, name]
  end

  # 末端のジョブあるいはジョブネット単位で実行・停止します。
  include Tengine::Job::Runtime::Executable
  include Tengine::Job::Runtime::Stoppable

  def root_or_expansion
    p = parent
    p.nil? ? self : p.was_expansion ? p : p.root_or_expansion
  end

  def update_with_lock(*args)
    if @in_update_with_lock
      Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} before yield in nested update_with_lock")
      yield if block_given?
      Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} after yield in nested update_with_lock")
      return
    end
    @in_update_with_lock = true
    begin
      Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} before update_with_lock")
      super(*args) do
        Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} before yield in update_with_lock")
        yield if block_given?
        Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} after yield in update_with_lock")
      end
      Tengine::Job.test_harness_hook("[#{self.class.name}] #{name_path} after update_with_lock")
    ensure
      @in_update_with_lock = false
    end
  end

end
