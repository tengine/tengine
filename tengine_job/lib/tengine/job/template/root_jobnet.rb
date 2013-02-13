# -*- coding: utf-8 -*-
require 'tengine/job/template'

# DSLを評価して登録されるルートジョブネットを表すVertex
class Tengine::Job::Template::RootJobnet < Tengine::Job::Template::Jobnet

  field :dsl_filepath, :type => String  # ルートジョブネットを定義した際にロードされたDSLのファイル名(Tengine::Core::Config#dsl_dir_pathからの相対パス)
  field :dsl_lineno  , :type => Integer # ルートジョブネットを定義するjobnetメソッドの呼び出しの、ロードされたDSLのファイルでの行番号
  field :dsl_version , :type => String  # ルートジョブネットを定義した際のDSLのバージョン

  belongs_to :category, :inverse_of => :template_root_jobnets, :index => true, :class_name => "Tengine::Job::Structure::Category"

  def generate(klass = actual_class)
    result = super(klass)
    result.template = self
    result
  end

  def execute(options = {})
    event_sender = options.delete(:sender) || Tengine::Event.default_sender
    actual = generate
    actual.with(safe: safemode(actual.class.collection)).save!
    result = Tengine::Job::Execution.with(
                safe: safemode(Tengine::Job::Execution.collection)
             ).create!(
               (options || {}).update(:root_jobnet_id => actual.id)
             )
    event_sender.fire(:"start.execution.job.tengine", :properties => {
        :execution_id => result.id,
        :root_jobnet_id => actual.id,
        :target_jobnet_id => actual.id
      })
    result
  end

  def find_duplication
    return nil unless self.new_record?
    self.class.find_by_name(name, :version => self.dsl_version)
  end

  class << self
    # Tengine::Core::FindByName で定義しているクラスメソッドfind_by_nameを上書きしています
    def find_by_name(name, options = {})
      version = options[:version] || Tengine::Core::Setting.dsl_version
      where({:name => name, :dsl_version => version}).first
    end
  end
end
