require 'tengine/core'

class Tengine::Core::Setting
  include Mongoid::Document
  include Tengine::Core::FindByName

  field :name, :type => String
  field :value

  validates :name, :presence => true, :uniqueness => true

  index({name: 1}, {unique: true})

  class << self
    def dsl_version
      document = where({:name => "dsl_version"}).first
      raise Mongoid::Errors::DocumentNotFound.new(Tengine::Core::Setting, "dsl_version", "dsl_version") unless document
      document.value
    end
  end
end
