# -*- coding: utf-8 -*-
require 'tengine_resource_ec2'

module Tengine::ResourceEc2
  autoload :Provider       , 'tengine/resource_ec2/provider'
  autoload :DummyConnection, 'tengine/resource_ec2/dummy_connection'
  autoload :LaunchOptions  , 'tengine/resource_ec2/launch_options'
end
