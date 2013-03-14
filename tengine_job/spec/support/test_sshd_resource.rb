class TestSshdResource
  class << self
    attr_accessor :instance
  end

  def initialize(test_sshd)
    @test_sshd = test_sshd
  end

  def find_or_create_credential(options = {})
    Tengine::Resource::Credential.find_or_create_by_name!(
      :name => options[:name] || @test_sshd.login,
      :description => "myself",
      :auth_type_cd => :ssh_public_key,
      :auth_values => {
        :username => @test_sshd.login,
        :private_keys => [
          File.binread(Dir[@test_sshd.clientkey].first),
        ],
        :passphrase => "",
      }
      )
  end

  def find_or_create_server(options = {})
    klass = options[:class] || Tengine::Resource::Server
    klass.find_or_create_by_name!(
      :name => options[:name] || "localhost",
      :provided_id => options[:provided_id] || options[:name] || "localhost",
      :description => "localhost",
      :properties => {
        :ssh_port => @test_sshd.port,
      },
      :addressed => {
        :dns_name => "localhost",
        :ip_address => "localhost",
        :private_dns_name => "localhost",
        :private_ip_address => "localhost",
      },
      )
  end
end
