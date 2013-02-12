# -*- coding: utf-8 -*-
require 'tengine/job'

# ジョブDSLで定義されるジョブネットを表すVertex。
class Tengine::Job::JobnetTemplate < Tengine::Job::Jobnet

  def actual_class
    Tengine::Job::JobnetActual
  end

  def template_block_for(block_name)
    key = Tengine::Job::DslLoader.template_block_store_key(self, block_name)
    Tengine::Job::DslLoader.template_block_store[key]
  end
end
