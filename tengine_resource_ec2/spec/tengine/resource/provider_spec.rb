# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider do
  before do
    @original_locale, I18n.locale = I18n.locale, :en
  end
  after do
    I18n.locale = @original_locale
  end

  valid_attributes1 = {
    :name => "provider1"
  }.freeze

  context "nameで検索" do
    before do
      Tengine::Resource::Provider.delete_all
      @fixture = GokuAtEc2ApNortheast.new
      @provider1 = @fixture.provider
    end

    context "見つかる場合" do
      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name(@provider1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @provider1.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name!(@provider1.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @provider1.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::Provider.find_by_name("unexist_name").should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::Provider.find_by_name!("unexist_name")
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end
  end

end
