class Tengine::Core::Setting
  include Mongoid::Document

  field :name, :type => String
  field :value

  validates :name, :presence => true, :uniqueness => true

  index :name, :unique => true
end
