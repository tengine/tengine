# -*- coding: utf-8 -*-
require 'mongoid'
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'tengine/support/mongoid'

class TestModel1
  include Mongoid::Document
end

describe Mongoid::Document do
  describe :human_name do
    before do
      I18n.backend = I18n::Backend::Simple.new
      I18n.backend.store_translations :ja, :mongoid => {:models => {
          :test_model1 => "テストモデル1"
        } }
    end

    context "リソースが登録されていない場合" do
      before{ I18n.locale = :en }
      subject{ TestModel1 }
      it{ TestModel1.human_name.should == 'TestModel1' }
      its(:i18n_scope){ should == :mongoid }
    end

    context "リソースが登録されている場合" do
      before{ I18n.locale = :ja }
      subject{ TestModel1 }
      it{ TestModel1.human_name.should == 'テストモデル1' }
      it{ TestModel1.name.should == "TestModel1" }
      it{ TestModel1.name.underscore.should == "test_model1" }
      it{ I18n.t(:test_model1, :scope => [:mongoid, :models]).should == "テストモデル1" }
    end

  end
end
