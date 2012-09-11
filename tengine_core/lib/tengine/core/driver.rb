# -*- coding: utf-8 -*-
require 'tengine/core'

# イベントドライバ
#
# イベントに対する処理はイベントハンドラによって実行されますが、イベントドライバはそのイベントハンドラの上位の概念です。
# イベントハンドラは必ずイベントドライバの中に定義されます。
#
# またイベントドライバは有効化／無効化を設定する単位であり、起動時の設定あるいはユーザーの指定によって変更することができます。
#
class Tengine::Core::Driver
  autoload :Finder, 'tengine/core/driver/finder'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::Validation
  include Tengine::Core::FindByName

  # @attribute 名前
  field :name, :type => String

  # @attribute バージョン。デプロイされた際に設定されます。
  field :version, :type => String

  # @attribute 有効／無効
  field :enabled, :type => Boolean

  # @attribute 実行時有効／無効
  field :enabled_on_activation, :type => Boolean, :default => true

  # @attribute 対象クラス名
  field :target_class_name, :type => String

  index _id: 1, enabled: 1, version: 1
  index({name: 1, version: 1}, {unique: true})
  index version: 1, enabled_on_activation: 1
  index version: 1
  index _id: 1, name: 1

  validates(:name, :presence => true,
    :uniqueness => {:scope => :version, :message => "is already taken in same version"},
    :format => BASE_NAME.options
    )
  validates :version, :presence => true

  embeds_many :handlers, :class_name => "Tengine::Core::Handler"

  belongs_to :session, :index => true, :class_name => "Tengine::Core::Session"
  has_many :handler_paths, :class_name => "Tengine::Core::HandlerPath"

  before_create :create_session # has_oneによって追加されるメソッドcreate_sessionのように振る舞うメソッドです
  after_create :update_handler_path

  after_destroy :delete_handler_paths

  def create_session
    self.session ||= Tengine::Core::Session.create
  end

  def update_handler_path
    handlers.each(&:update_handler_path)
  end

  def delete_handler_paths
    return if new_record?
    Tengine::Core::HandlerPath.where(:driver_id => self.id).delete_all
  end

  class << self
    # Tengine::Core::FindByName で定義しているクラスメソッドfind_by_nameを上書きしています
    def find_by_name(name, options = {})
      version = options[:version] || Tengine::Core::Setting.dsl_version
      where({:name => name, :version => version}).first
    end

    def delete_all_with_handler_paths(dsl_version)
      drivers = Tengine::Core::Driver.where(:version => dsl_version)
      Tengine::Core::HandlerPath.where(:driver_id.in => drivers.map(&:id)).delete_all
      drivers.delete_all
    end
  end
end
