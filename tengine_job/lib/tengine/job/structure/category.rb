# -*- coding: utf-8 -*-
require 'tengine/job/template'

require 'yaml'
require 'tengine/support/yaml_with_erb'

class Tengine::Job::Structure::Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::FindByName

  field :name       , :type => String # カテゴリ名。ディレクトリ名を元に設定されるので、"/"などは使用不可。
  field :caption    , :type => String # カテゴリの表示名。各ディレクトリ名に対応する表示名。通常dictionary.ymlに定義する。

  with_options(:class_name => self.name) do |c|
    c.belongs_to :parent, :inverse_of => :children, :index => true
    c.has_many   :children, :inverse_of => :parent, :order => [:name, :asc]
  end

  # embeddedなDocumentをその外部のドキュメントから参照することはできないので、これはNG
  # has_many :template_root_jobnets, class_name: "Tengine::Job::Template::RootJobnet", inverse_of: :category
  has_many :runtime_root_jobnets , class_name: "Tengine::Job::Runtime::RootJobnet" , inverse_of: :category

  class << self
    def update_for(base_dir)
      root_dir = File.basename(base_dir)
      dic_dir_base = File.dirname(base_dir)
      root_jobnets = Tengine::Job::Template::RootJobnet.all
      root_jobnets.each do |root_jobnet|
        dirs = File.dirname(root_jobnet.dsl_filepath || "").split('/') - ['.', '..']
        dirs.unshift(root_dir)
        last_category = nil
        dic_dir = dic_dir_base
        dirs.each do |dir|
          caption = nil
          dic_path = File.expand_path("dictionary.yml", dic_dir)
          if File.exist?(dic_path)
            # TODO dictionary.yml が不正な形の場合の処理が必要
            hash = YAML.load_file(dic_path)
            caption = hash[dir]
          end
          category = self.find_or_create_by(
            :name => dir,
            :caption => caption || dir,
            :parent_id => last_category ? last_category.id : nil)
          dic_dir = File.join(dic_dir, dir)
          last_category = category
        end
        if last_category
          root_jobnet.category_id = last_category.id
          root_jobnet.save!
        end
      end

    end
  end

end
