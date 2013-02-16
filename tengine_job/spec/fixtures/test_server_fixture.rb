module TestServerFixture
  module_function

  public

  def test_server1
    Tengine::Resource::PhysicalServer.find_or_create_by(
      :name => "test_server1",
      :provided_id => "test_server1",
      :properties => {},
      :addresses => {
        :private_dns_name => "localhost",
        # :private_ip_address => "127.0.0.1"
      }
      )
  end

  def test_server2
    Tengine::Resource::PhysicalServer.find_or_create_by(
      :name => "test_server2",
      :provided_id => "test_server2",
      :properties => {},
      :addresses => {
        :private_dns_name => "test_server2",
        :private_ip_address => "192.168.1.2"
      }
      )
  end

end
