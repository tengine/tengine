require File.expand_path('../../../../spec_helper', File.dirname(__FILE__))
require "tengine/support/core_ext/enumerable/deep_freeze"

describe Enumerable do
  describe "#deep_freeze" do
    subject { { "q" => { "w" => { "e" => { "r" => { "t" => { "y" => "u" } } } } } }.deep_freeze }
    it "recursive destructive freezing of the subject" do
      subject["q"].frozen?.should be_true
      subject["q"]["w"].frozen?.should be_true
      subject["q"]["w"]["e"].frozen?.should be_true
      subject["q"]["w"]["e"]["r"].frozen?.should be_true
      subject["q"]["w"]["e"]["r"]["t"].frozen?.should be_true
      subject["q"]["w"]["e"]["r"]["t"]["y"].frozen?.should be_true
    end
  end
end
