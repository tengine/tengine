module TestCredentialFixture
  module_function

  def test_credential1
    Tengine::Resource::Credential.find_or_create_by(
      :name => "test_credential1",
      :auth_type_key => :ssh_password,
      :auth_values => { :username => "goku", :password => "dragonball"}
      )
  end

end
