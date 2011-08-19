class Tengine::Core::Driver
  include Mongoid::Document
  field :name, :type => String
  field :version, :type => String
  field :enabled, :type => Boolean

  validates :name, :presence => true
  validates :version, :presence => true
end
