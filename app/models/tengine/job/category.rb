class Tengine::Job::Category
  include Mongoid::Document
  field :name, :type => String
  field :caption, :type => String
  with_options(:class_name => "Tengine::Job::Category") do |c|
    c.belongs_to :parent, :inverse_of => :children, :index => true
    c.has_many   :children, :inverse_of => :parent
  end
end
