require 'tengine/support/config'

module Tengine::Support::Config::Mongoid

  class Connection
    include Tengine::Support::Config::Definition
    field :host    , 'hostname to connect db.', :default => 'localhost', :type => :string
    field :port    , "port to connect db.", :default => 27017, :type => :integer
    field :username, 'username to connect db.', :type => :string
    field :password, 'password to connect db.', :type => :string
    field :database, 'database name to connect db.', :type => :string
  end

end
