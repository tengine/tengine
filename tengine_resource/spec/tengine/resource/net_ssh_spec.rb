# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'
require 'tengine/resource/net_ssh'

describe Net::SSH do
  describe :start do

    private_key_content = <<END_OF_PK
-----BEGIN RSA PRIVATE KEY-----
MIIEoAIBAAKCAQEAvdBvdpWxMumGZsyWpnsPetEW0da5/5sIfSgP8pAVgibp492O
l++LQlITsSf3Lt/WOQNEfOrfU7HFZuRk3b7dPTJFneG+AIXS8PdrxDO8e9DSG1D4
xDAgSrG4inuSQju1EPaPhIz7r0eg1tupP6UM8GVUu90zO7OCnvjYOPjNRvibW5ao
dzo4T5cOLBZuUm3RqclQLehLAQpG6p+d6DbADTVVNpvgk+VfPpKI9E+q944ivJIM
0KLNWyfEbxjoXuYnZYn1em6MHcaXsR1I5rlzuhfOaukerqFulG3MkU6A2t/CfbXM
PiOtwPSse7ZuoBtdFhnxUpGRmlPoSvezfSz23wIBIwKCAQA7p+iEWu6MWAWrR50P
wEaxkiu+Ssy+DCc9Rxr0dm0o56iYEm6kx6DLs2VGTmOhBIUn3HScSdEo7rpiKoYZ
zkWIQv/vyprM9tvlVRM9qdwm6duiL2QgZuWT0XSDS2h7N1Yp5xcpqKbfUQap7UPS
LI8JuXJm7b+lDIgjVYXIwzkzj2qEkoF+p8hHWD7X3v6db6Gz7+HMQx/rc6yMrZ0H
RF/CKHOWvriY/41CxsYvpAK0ksXTXupxzEJdItvHYIJsQW6gxBGtxWo7Y55si8w/
VBgmkiQ/wPVZsQ5omo3lwrLohW0k7xO8ZX2sAweb/NUKhZi0KcrwTHFT5MbwxrHi
GGcbAoGBAPvjaPtg9171h+xu/MlpOBivhfApdhrEoRfn5Np8OmSRtOC5hK/UyQtk
Ot4G10KQziK98xkSQ3OphR/kQA8oiq+TfZvPKJ69GYqLpWkBdM2rNXph5BCahri+
qO04wqgpZkG7obCMrKXPNQj1MWhCAy5mRNYcuWSEeIXZZ66TT1SZAoGBAMDpoVbg
W4qlmUKCme8i0ofsSB00s+HyJ6zmBriDaJ8o/77jQ/ypwKmox+6Ebo5WvnNGzgnI
puOgkNH5MWjGoowvnH6CXWzSQYlvAOGnZ58IhbIm5OolRHC3fASUw0JZRVQGvlFC
v73ltf+td9TfhmAVfqzE5PMK7C9E6UNJBFo3AoGAVlyZBbrYeFQumjSucPDgCHax
lCt48zwZ+ZFVx0CJDIm6W61SEGY2TQxr9Fod6u/RpYL0Qxw0Yit+GZAV9pGOopj3
3aYcjjI0pIembSUSGqEZpk1yw901gSttHiIW2pHZ6qa7F/W3iU5bU4dEI77chO/d
FjW75/Lnflkq3MTKvesCgYALBgk4KhPcCXZ41ENPflUsVqUI+7KB8JSNiXy6FiM8
S3xUDPySGFQm87OnOsR9KYc5yYgd0POX+ovuvchPIUsd9BeSM1XLtD5CXh1OuRvd
M6/eS12JuPyYugcWNGLt2TcpX3iW7d8SKmIr3gbY9tR6hOKqyWwrJTIRVGUZyah6
LwKBgA+Fdse5WibNPG1smoS/JzmPdrdD46x2D7HoLtbcNF4rPlduVI8yS3dRSqi4
Gh5L65ukAbWSC8yuQpKtq3EfpNcf83a+Xc5XXANbTgN/+sJjgd+ycmPzLv5Zcsg9
8xlb43zLCiEf5TyrlbmqfM97hxuPbrgifyU7jMaTdmHHGsDx
-----END RSA PRIVATE KEY-----
END_OF_PK

    after do
      Tengine::Resource::Credential.delete_all(:name => "ssh1")
    end

    def setup_net_ssh_mocks(options, result = true)
      options = {:user => "goku", :logger => an_instance_of(Logger)}.update(options)
      mock_transport = mock(:transport, :logger => true, :socket => nil)
      mock_auth = mock(:auth)
      Net::SSH::Transport::Session.should_receive(:new).with("localhost", options).and_return(mock_transport)
      Net::SSH::Authentication::Session.should_receive(:new).with(mock_transport, options).and_return(mock_auth)
      mock_auth.should_receive(:authenticate).with("ssh-connection", "goku", options[:password]). and_return(result)
    end


    describe "``Net::SSH.start(hostname, credential) {|ctx| ... }''" do
      describe "auth_type_key: :ssh_password" do
        it "starts" do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => 'goku', :password => "password1"})
          setup_net_ssh_mocks(:password => "password1")
          Net::SSH.start("localhost", c)
        end
      end

      describe "auth_type_key: :ssh_public_key" do
        it "starts" do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_public_key,
            :auth_values => {:username => 'goku', :private_keys => private_key_content, :passphrase => ""})

          base_tmp_dir = File.expand_path("../../../../tmp", __FILE__)
          tmp_dir = File.expand_path("test", base_tmp_dir)
          FileUtils.mkdir_p(tmp_dir)
          Dir.stub(:mktmpdir).with(nil, base_tmp_dir).and_yield(tmp_dir)
          tmpfile = Tempfile.new("pk", tmp_dir)
          Tempfile.should_receive(:new).with("pk", tmp_dir).and_return(tmpfile)

          setup_net_ssh_mocks(:passphrase => "", :keys => [tmpfile.path])
          Net::SSH.start("localhost", c)
        end
      end
    end

    describe "``Net::SSH.start(hostname, user, credential) {|ctx| ... }''" do
      describe "normal path" do
        it "starts" do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_password,
            :auth_values => {:password => "password1"})
          setup_net_ssh_mocks(:password => "password1")
          Net::SSH.start("localhost", "goku", c)
        end
      end

      describe "conflicted username" do
        subject do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => "goku", :password => "password1"})
          expect{ Net::SSH.start("localhost", "goku", c) }
        end
        it { should raise_error(ArgumentError) }
      end
    end

    describe "``Net::SSH.start(hostname, credential, other_opts) {|ctx| ... }''" do
      describe "normal path" do
        it "starts" do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => "goku"})
          setup_net_ssh_mocks(:password => "password1")
          Net::SSH.start("localhost", c, :password => "password1")
        end
      end

      describe "conflicted option" do
        subject do
          c = Tengine::Resource::Credential.new(
            :name => "ssh1",
            :auth_type_key => :ssh_password,
            :auth_values => {:username => "goku", :password => "password1"})
          # setup_net_ssh_mocks(:password => "password1")
          expect{ Net::SSH.start("localhost", c, :password => "password1") }
        end
        it { should raise_error(ArgumentError) }
      end
    end

    describe "``Net::SSH.start(hostname, user, other_opts) {|ctx| ... }''" do
      describe "normal path" do
        it "starts" do
          setup_net_ssh_mocks(:password => "password1")
          Net::SSH.start("localhost", "goku", :password => "password1")
        end
      end

      describe "unknown key" do
        subject do
          expect{ Net::SSH.start("localhost", "goku", :foo => "bar") }
        end
        it { should raise_error(ArgumentError) }
      end
    end

    describe "``Net::SSH.start(hostname, other_opts) {|ctx| ... }''" do
      describe "normal path" do
        it "starts" do
          setup_net_ssh_mocks(:password => "password1")
          Net::SSH.start("localhost", :username => "goku", :password => "password1")
        end
      end

      describe "missing username" do
        subject do
          expect{ Net::SSH.start("localhost", :password => "password1") }
        end
        it { should raise_error(ArgumentError) }
      end
    end
  end
end
