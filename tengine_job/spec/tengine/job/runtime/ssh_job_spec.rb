# -*- coding: utf-8 -*-

require 'spec_helper'

describe Tengine::Job::Runtime::SshJob do

  describe :error_messages do
    context "デフォルト" do
      subject{ Tengine::Job::Runtime::SshJob.new }
      its(:error_messages){ should == nil }
      its(:error_messages_text){ should == "" }
    end

    context "複数音メッセージ" do
      subject{ Tengine::Job::Runtime::SshJob.new(:error_messages => ["foo", "bar"]) }
      its(:error_messages){ should == ["foo", "bar"] }
      its(:error_messages_text){ should == "foo\nbar" }
    end
  end

end
