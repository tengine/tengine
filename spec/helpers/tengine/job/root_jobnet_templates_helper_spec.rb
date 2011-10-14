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
  describe "sort_order" do
    it "sort query_parameter not found" do
      helper.sort_order(@request, :test).should == {:test => "asc"}
    end

    it "sort query_parameter is :asc" do
      @request.query_parameters[:sort] = {:test => :asc}
      helper.sort_order(@request, :test).should == {:test => "desc"}
    end

    it "sort query_parameter is :desc" do
      @request.query_parameters[:sort] = {:test => :desc}
      helper.sort_order(@request, :test).should == {:test => "asc"}
    end
  end
end
