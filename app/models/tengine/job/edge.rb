class Tengine::Job::Edge
  include Mongoid::Document
  # embedded_in :owner, :class_name => "Tengine::Job::Jobnet", :inverse_of => :edges

  field :status_cd, :type => Integer
  field :origin_id, :type => BSON::ObjectId
  field :destination_id, :type => BSON::ObjectId

  def origin
    owner.children.detect{|c| c.id == origin_id}
  end

  def destination
    owner.children.detect{|c| c.id == destination_id}
  end
end
