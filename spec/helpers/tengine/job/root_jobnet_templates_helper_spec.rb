# -*- coding: utf-8 -*-
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Tengine::Job::RootJobnetTemplatesHelper. For example:
#
# describe Tengine::Job::RootJobnetTemplatesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Tengine::Job::RootJobnetTemplatesHelper do
  describe "sort_param" do
    it "ソートのクエリーパラメータがないときtestの降順のクエリーパラメータが付加されること" do
      helper.sort_param(:test).should == {"sort" => {"test" => "desc"}}
    end

    it "testのソートのクエリーパラメータがないときtestの降順のクエリーパラメータが付加されること" do
      helper.sort_param(:test).should == {"sort" => {"test" => "desc"}}
    end

    it "testの昇順のソートのクエリーパラメータがあるときtestの降順のクエリーパラメータが付加されること" do
      @request.query_parameters[:sort] = {"test" => "asc"}
      helper.sort_param(:test).should == {"sort" => {"test" => "desc"}}
    end

    it "testの降順のソートのクエリーパラメータがあるときtestの昇順のクエリーパラメータが付加されること" do
      @request.query_parameters[:sort] = {"test" => "desc"}
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end

    it "testのクエリーパラメータがascでもdescでもないときtestの昇順のクエリーパラメータが付加されること" do
      @request.query_parameters[:sort] = {"test" => "foo"}
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end
  end

  describe "sort_class" do
    it "ソートのクエリーパラメータがないときascが返ってくること" do
      helper.sort_class(:test).should == "asc"
    end

    it "testのソートのクエリーパラメータがないときascが返ってくること" do
      helper.sort_class(:test).should == "asc"
    end

    it "testの昇順のソートのクエリーパラメータがあるときascが返ってくること" do
      @request.query_parameters[:sort] = {"test" => "asc"}
      helper.sort_class(:test).should == "asc"
    end

    it "testの降順のソートのクエリーパラメータがあるときdesc返ってくること" do
      @request.query_parameters[:sort] = {"test" => "desc"}
      helper.sort_class(:test).should == "desc"
    end

    it "testのクエリーパラメータがascでもdescでもないときasc返ってくること" do
      @request.query_parameters[:sort] = {"test" => "foo"}
      helper.sort_class(:test).should == "asc"
    end
  end
end
