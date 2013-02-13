# -*- coding: utf-8 -*-
require 'tengine/job/template'

# 終了対象となりうるVertexで使用するモジュール
module Tengine::Job::Template::Killing
  extend ActiveSupport::Concern

  included do
    require 'tengine/core'
    include Tengine::Core::CollectionAccessible

    field :killing_signals, :type => Array # 強制停止時にプロセスに送るシグナルの配列
    array_text_accessor :killing_signals

    field :killing_signal_interval, :type => Integer # 強制停止時にkilling_signalsで定義されるシグナルを順次送信する間隔。
  end

  DEFAULT_KILLING_SIGNAL_INTERVAL = 5

  def actual_killing_signals
    killing_signals ? killing_signals :
      (parent ? parent.actual_killing_signals : ['KILL'])
  end

  def actual_killing_signal_interval
    killing_signals ? killing_signal_interval :
      (parent ? parent.actual_killing_signal_interval : DEFAULT_KILLING_SIGNAL_INTERVAL)
  end

end
