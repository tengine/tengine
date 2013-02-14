# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Vertex do
  describe :ancestors do
    context "templateの場合" do
      before do
        builder = Rjn0009TreeSequentialJobnetBuilder.new
        builder.create_template
        @ctx = builder.context
      end

      context "ルートを先頭に親までの配列を返します" do
        it "深さ3のジョブ・ジョブネットなら２つの要素を返します" do
          @ctx[:j1120].ancestors.should == [@ctx[:root], @ctx[:j1100]]
        end

        it "深さ4のジョブ・ジョブネットなら3つの要素を返します" do
          @ctx[:j1611].ancestors.should == [@ctx[:root], @ctx[:j1600], @ctx[:j1610]]
        end
      end
    end
  end

end
