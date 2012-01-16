class Tengine::Test::Script
  include Mongoid::Document
  include Mongoid::Timestamps
  field :code, :type => String
  field :result, :type => String
  field :message, :type => String
end
