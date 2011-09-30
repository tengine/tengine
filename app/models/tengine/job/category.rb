class Tengine::Job::Category
  include Mongoid::Document
  field :name, :type => String
  field :caption, :type => String
  referenced_in :parent, :inverse_of => :categories, :index => true
end
