class Tengine::Job::Edge
  include Mongoid::Document
  field :status_cd, :type => Integer
  field :origin_id, :type => String
  field :destination_id, :type => String
end
