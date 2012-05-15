require 'mongoid'

class Tengine::Resource::VirtualServerImage
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::Validation
  include Tengine::Core::FindByName

  field :name, :type => String
  field :description, :type => String
  field :provided_id, :type => String
  field :provided_description, :type => String

  belongs_to :provider, :inverse_of => :virtual_server_images, :index => true,
    :class_name => "Tengine::Resource::Provider"

  validates :name, :presence => true, :uniqueness => true, :format => BASE_NAME.options
  index :name, :unique => true

  index([ [:description, Mongo::ASCENDING], ])
  index([ [:description, Mongo::DESCENDING], ])
  index([ [:provided_description, Mongo::ASCENDING], ])
  index([ [:provided_description, Mongo::DESCENDING], ])
  index([ [:provided_id, Mongo::ASCENDING], ])
  index([ [:provided_id, Mongo::DESCENDING], ])

  class << self
    def find_or_create_by_name!(attrs = {}, &block)
      result = self.first(:conditions => {:name => attrs[:name]})
      result ||= self.create!(attrs)
      result
    end
  end
end
