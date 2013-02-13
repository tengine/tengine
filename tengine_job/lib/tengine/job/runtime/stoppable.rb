# -*- coding: utf-8 -*-
require 'tengine/job'
require 'selectable_attr'

# ジョブ／ジョブネットを実行する際の情報に関するモジュール
# Tengine::Job::JobnetActual, Tengine::Job::JobnetTemplateがこのモジュールをincludeします
module Tengine::Job::Stoppable
  extend ActiveSupport::Concern

  included do
    field :stopped_at , :type => DateTime # 停止時刻。停止を開始した時刻です。
    field :stop_reason, :type => String   # 停止理由。手動以外での停止ならば停止した理由が設定されます。
  end

end
