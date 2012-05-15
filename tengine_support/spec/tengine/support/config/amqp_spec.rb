# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'Tengine::Support::Config::Amqp' do

  context "static" do
    describe Tengine::Support::Config::Amqp::Connection.host do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :host }
      its(:description){ should == 'hostname to connect queue.'}
      its(:default){ should == 'localhost'}
    end

    describe Tengine::Support::Config::Amqp::Connection.port do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :integer }
      its(:__name__){ should == :port }
      its(:description){ should == 'port to connect queue.'}
      its(:default){ should == 5672}
    end

    describe Tengine::Support::Config::Amqp::Connection.heartbeat_interval do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :integer }
      its(:__name__){ should == :heartbeat_interval }
      its(:description){ should == 'heartbeat interval client uses, in seconds.'}
      its(:default){ should == 0}
    end
  end

end
