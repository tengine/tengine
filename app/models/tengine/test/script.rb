class Tengine::Test::Script
  include Mongoid::Document
  include Mongoid::Timestamps
  field :code, :type => String
  field :result, :type => String
  field :message, :type => String

  validates :code, :presence => true

  before_create :eval_code

  def eval_code
    self.result = eval(code)
  rescue => e
    self.message = "[#{e.class.name}] #{e.message}"
  end

end
