require 'tengine/support/config'

module Tengine::Support::Config::Amqp
  class Connection
    include Tengine::Support::Config::Definition
    field :host , 'hostname to connect queue.', :default => 'localhost', :type => :string
    field :port , "port to connect queue.", :default => 5672, :type => :integer
    field :vhost, "vhost to connect queue.", :type => :string
    field :user , "username to connect queue.", :type => :string
    field :pass , "password to connect queue.", :type => :string
    field :heartbeat_interval , "heartbeat interval client uses, in seconds.", :default => 0, :type => :integer
  end

  class Exchange
    include Tengine::Support::Config::Definition
    field :name   , "exchange name.", :type => :string
    field :type   , "exchange type.", :type => :string, :default => 'direct'
    field :durable, "exchange durable.", :type => :boolean, :default => true
  end

  class Queue
    include Tengine::Support::Config::Definition
    field :name   , "queue name.", :type => :string
    field :durable, "queue durable.", :type => :boolean, :default => true
  end

end
