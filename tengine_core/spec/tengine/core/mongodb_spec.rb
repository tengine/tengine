# -*- coding: utf-8 -*-
require 'spec_helper'

describe "MongoDB" do

  context "server version must be >= 2.0.x" do
    subject do
      info = Moped::Database.new(Mongoid.default_session, "admin").command buildinfo: 1
      info["version"]
    end
    its(:to_s){ should =~ /^2\.\d+\./ }
  end

end
