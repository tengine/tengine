# -*- coding: utf-8 -*-
require 'tengine/job/runtime'
require 'selectable_attr'

# ジョブ／ジョブネットを実行する際の情報に関するモジュール
# Tengine::Job::Runtime::Jobne, Tengine::Job::Runtime::JobBase、Tengine::Job::Runtime::Executionがこのモジュールをincludeします
module Tengine::Job::Runtime::Executable
  extend ActiveSupport::Concern

  class PhaseError < StandardError
  end

  included do
    field :phase_cd   , :type => Integer, :default => 20 # 進行状況。とりうる値は以下を参照してください。詳しくは「tengine_jobパッケージ設計書」の「ジョブ／ジョブネット状態遷移」を参照してください
    field :started_at , :type => Time     # 開始時刻。以前はDateTimeでしたが、実績ベースの予定終了時刻の計算のためにTimeにしました
    field :finished_at, :type => Time     # 終了時刻。強制終了時にも設定されます。

    include Tengine::Core::SelectableAttr
    selectable_attr :phase_cd do
      entry 20, :initialized, 'initialized'
      entry 30, :ready      , "ready"
      entry 50, :starting   , "starting"
      entry 60, :running    , "running"
      entry 70, :dying      , "dying"
      entry 40, :success    , "success"
      entry 80, :error      , "error"
      entry 90, :stuck      , "stuck"
    end

    def phase_key=(phase_key)
      element_type =
        case self.class
        when Tengine::Job::Runtime::Execution  then "execution"
        when Tengine::Job::Runtime::RootJobnet then "root_jobnet"
        when Tengine::Job::Runtime::Jobnet     then self.jobnet_type_key == :normal ?  "jobnet" : self.jobnet_type_name
        when Tengine::Job::Runtime::SshJob     then "job"
        end
      Tengine.logger.debug("#{element_type} phase changed. <#{ self.id.to_s}> #{self.phase_name} -> #{ self.class.phase_name_by_key(phase_key)}")
      self.write_attribute(:phase_cd, self.class.phase_id_by_key(phase_key))
    end

    after_save :update_children_phase_modified, if: :phase_cd_changed?

    def update_children_phase_modified
      return unless respond_to?(:children)
      children.each do |child|
        if child.respond_to?(:chained_box?) && child.chained_box?
          child.phase_key = phase_key
          child.save!
        end
      end
    end

    def update_phase!(phase_key)
      self.phase_key = phase_key
      self.save!
    end

    unless defined?(HUMAN_PHASE_KEYS_HASH)
      HUMAN_PHASE_KEYS_HASH = {
        'user_stop' => { :dying => :stopping_by_user, :error => :stopped_by_user }.freeze,
        'timeout' => { :dying => :stopping_by_timeout, :error => :stopped_by_timeout }.freeze,
      }.freeze

      HUMAN_PHASE_KEYS_ADDITIONAL = HUMAN_PHASE_KEYS_HASH.values.map{|hash| hash.values}.flatten.freeze
      # HUMAN_PHASE_KEYS = (phase_keys + HUMAN_PHASE_KEYS_ADDITIONAL).freeze
    end

    # 可読可能なphase_keyを返します。
    # 具体的にはphase_keyが:dying、:errorの場合は、stop_reasonを考慮した値を返します。
    def human_phase_key
      case phase_key
      when :dying, :error then
        hash = HUMAN_PHASE_KEYS_HASH[self.stop_reason]
        hash ? hash[phase_key] : phase_key
      else phase_key
      end
    end

    # human_phase_keyの表示用の文字列を返します。
    def human_phase_name
      I18n.t(human_phase_key, :scope => "selectable_attrs.tengine/job/jobnet_actual.human_phase_name")
    end

  end

end
