# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ジョブDSLで定義されるジョブネットを表すVertex。
class Tengine::Job::Template::JobnetTemplate < Tengine::Job::Jobnet

  def actual_class
    Tengine::Job::JobnetActual
  end
end
