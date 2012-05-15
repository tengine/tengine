# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'Tengine::Support::Config::Mongoid' do

  context "static" do
    describe Tengine::Support::Config::Mongoid::Connection.host do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :host }
      its(:description){ should == 'hostname to connect db.'}
      its(:default){ should == 'localhost'}
    end

    describe Tengine::Support::Config::Mongoid::Connection.port do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :integer }
      its(:__name__){ should == :port }
      its(:description){ should == 'port to connect db.'}
      its(:default){ should == 27017}
    end
  end

end
