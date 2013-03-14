class TestSshdResource
  def initialize(test_sshd)
    @test_sshd
  end

  def find_or_create_credential
    Tengine::Resource::Credential.find_or_create_by_name!(
      :name => @test_sshd.login,
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

  def find_or_create_server
    Tengine::Resource::Server.find_or_create_by_name!(
      :name => "localhost",
      :description => "localhost",
      :provided_id => "localhost",
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
