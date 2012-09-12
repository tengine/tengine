class Tengine::Resource::PhysicalServer < Tengine::Resource::Server
  field :cpu_cores, :type => Integer
  field :memory_size, :type => Integer

  belongs_to :provider, :index => true, :inverse_of => :physical_servers,
    :class_name => "Tengine::Resource::Provider"

  class << self
    def by_provided_id(provided_id)
      return nil if provided_id.blank?
      where({:provided_id => provided_id}).first
    end

  end
end
