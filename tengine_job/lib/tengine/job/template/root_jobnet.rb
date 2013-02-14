# -*- coding: utf-8 -*-
require 'tengine/job/template'

# DSLを評価して登録されるルートジョブネットを表すVertex
class Tengine::Job::Template::RootJobnet < Tengine::Job::Template::Jobnet
  include Tengine::Core::FindByName

  field :dsl_filepath, :type => String  # ルートジョブネットを定義した際にロードされたDSLのファイル名(Tengine::Core::Config#dsl_dir_pathからの相対パス)
  field :dsl_lineno  , :type => Integer # ルートジョブネットを定義するjobnetメソッドの呼び出しの、ロードされたDSLのファイルでの行番号
  field :dsl_version , :type => String  # ルートジョブネットを定義した際のDSLのバージョン

  belongs_to :category, inverse_of: nil, index: true, class_name: "Tengine::Job::Structure::Category"

  def generate(klass = actual_class)
    super(klass) do |r|
      r.template = self
    end
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

  Tengine::Job::Template::Jobnet::VERTEX_CLASSES.keys.each do |key|
    instance_eval("def #{key}_class; Tengine::Job::Template::Jobnet.#{key}_class; end", __FILE__, __LINE__)
  end

end
