# -*- coding: utf-8 -*-
require 'tengine_job'
require "socket" 

jobnet("rjn1054", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "$HOME/preparation.sh", :to => "j2", :preparation => proc{ "export IP_MESSAGE=#{IPSocket::getaddress(Socket::gethostname)}_j1"})
  job("j2", "$HOME/preparation.sh", :to => "j3")
  job("j3", "$HOME/preparation.sh", :to => "j4", :preparation => proc{ "export IP_MESSAGE=#{IPSocket::getaddress(Socket::gethostname)}_j3"})
  job("j4", "$HOME/preparation.sh")
end

