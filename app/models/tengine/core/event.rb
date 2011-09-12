# -*- coding: utf-8 -*-
class Tengine::Core::Event
  include Mongoid::Document
  field :event_type_name, :type => String
  field :key, :type => String
  field :source_name, :type => String
  field :occurred_at, :type => Time
  field :level, :type => Integer
  field :confirmed, :type => Boolean
  field :sender_name, :type => String
  field :properties, :type => Hash
  map_yaml_accessor :properties

  # 複数の経路から同じ意味のイベントが複数個送られる場合に、これらを重複して登録しないようにユニーク制約を設定
  index :key, unique: true

end
