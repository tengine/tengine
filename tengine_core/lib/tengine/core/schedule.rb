# -*- coding: utf-8 -*-
require 'tengine/core'

class Tengine::Core::Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  # statuses
  SCHEDULED = 0
  INVALID   = 1
  FIRED     = 2

  field :event_type_name, :type => String
  field :scheduled_at   , :type => Time   , :default => proc { Time.now }
  field :status         , :type => Integer, :default => SCHEDULED
  field :source_name    , :type => String
  field :properties     , :type => Hash   , :default => proc { Hash.new }

  index scheduled_at: 1, status: 1
  index status: 1
end
