# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::VirtualServerImage do
  valid_attributes1 = {
    :name => "provider1"
  }.freeze

  context "nameは必須" do
    it "正常系" do
      Tengine::Resource::VirtualServerImage.delete_all
      credential1 = Tengine::Resource::VirtualServerImage.new(valid_attributes1)
      credential1.valid?.should == true
    end

    [:name].each do |key|
      it "#{key}なし" do
        attrs = valid_attributes1.dup
        attrs.delete(key)
        credential1 = Tengine::Resource::VirtualServerImage.new(attrs)
        credential1.valid?.should == false
      end
    end

  end

  context "nameはユニーク" do
    before do
      Tengine::Resource::VirtualServerImage.delete_all
      @credential1 = Tengine::Resource::VirtualServerImage.create!(valid_attributes1)
    end

    it "同じ名前で登録されているものが存在する場合エラー" do
      expect{
        @credential1 = Tengine::Resource::VirtualServerImage.create!(valid_attributes1)
      }.to raise_error(Mongoid::Errors::Validations, "Validation failed - Name is already taken.")
    end
  end

  context "nameはベース名として定義される文字列です" do
    it "スラッシュ'/’はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::VirtualServerImage.new(:name => "foo/bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end

    it "コロン':'はリソース識別子で使われるのでnameには使用できません" do
      server1 = Tengine::Resource::VirtualServerImage.new(:name => "foo:bar")
      server1.valid?.should == false
      server1.errors[:name].should == [Tengine::Core::Validation::BASE_NAME.message]
    end
  end

  context "nameで検索" do
    before do
      Tengine::Resource::VirtualServerImage.delete_all
      @fixture = GokuAtEc2ApNortheast.new
      @hadoop_image = @fixture.hadoop_image
    end

    context "見つかる場合" do
      it "find_by_name" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::VirtualServerImage.find_by_name(@hadoop_image.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @hadoop_image.id
      end

      it "find_by_name!" do
        found_credential = nil
        lambda{
          found_credential = Tengine::Resource::VirtualServerImage.find_by_name!(@hadoop_image.name)
        }.should_not raise_error
        found_credential.should_not be_nil
        found_credential.id.should == @hadoop_image.id
      end
    end

    context "見つからない場合" do
      it "find_by_name" do
        found_credential = Tengine::Resource::VirtualServerImage.find_by_name("unexist_name").should == nil
      end

      it "find_by_name!" do
        lambda{
          found_credential = Tengine::Resource::VirtualServerImage.find_by_name!("unexist_name")
        }.should raise_error(Tengine::Core::FindByName::Error)
      end
    end
  end

end
