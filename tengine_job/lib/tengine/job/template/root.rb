# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ルートジョブネットとして必要な情報に関するモジュール
module Tengine::Job::Template::Root
  extend ActiveSupport::Concern

  included do
    include Tengine::Core::OptimisticLock
    set_locking_field :version

    belongs_to :category, :inverse_of => :root_jobnet_templates, :index => true, :class_name => "Tengine::Job::Category"

    field :version, :type => Integer, :default => 0 # ジョブネット全体を更新する際の楽観的ロックのためのバージョン。更新するたびにインクリメントされます。
  end
end
