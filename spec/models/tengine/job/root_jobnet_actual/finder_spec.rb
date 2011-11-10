# -*- coding: utf-8 -*-
require 'spec_helper'

include ChangeTime

describe Tengine::Job::RootJobnetActual::Finder do
  before do
    Tengine::Job::RootJobnetTemplate.delete_all
    Tengine::Job::RootJobnetActual.delete_all
    stub_template = stub_model(Tengine::Job::RootJobnetTemplate, :name => "root_jobnet1")
    @t1 = Tengine::Job::RootJobnetActual.create!({
      :name => "test_1_foo",
      :phase_cd => 30,
      :started_at => Time.new(2011, 11, 7, 11, 30),
      :finished_at => nil,
      :template => stub_template
    })
    @t2 = Tengine::Job::RootJobnetActual.create!({
      :name => "test_2_foo",
      :phase_cd => 40,
      :started_at => Time.new(2011, 11, 7, 13, 30),
      :finished_at => Time.new(2011, 11, 7, 14, 10),
      :template => stub_template
    })
    @t3 = Tengine::Job::RootJobnetActual.create!({
      :name => "test_3",
      :phase_cd => 50,
      :started_at => Time.new(2011, 11, 7, 12, 30),
      :finished_at => nil,
      :template => stub_template
    })
    @t4 = Tengine::Job::RootJobnetActual.create!({
      :name => "test_4",
      :phase_cd => 50,
      :started_at => Time.new(2011, 11, 7, 12, 30),
      :finished_at => nil,
      :template => stub_template
    })
  end

  it "validate_datetime" do
    finder = Tengine::Job::RootJobnetActual::Finder.new
    finder.duration_start = Time.now
    finder.duration_finish = Time.now
    finder.valid?.should be_true

    finder.duration_start = Time.now
    finder.duration_finish = Time.now - 1
    finder.valid?.should be_false

    finder.duration_start = Time.now + 10
    finder.duration_finish = Time.now + 10
    finder.valid?.should be_false
  end

  it "assign_attributes" do
    finder = Tengine::Job::RootJobnetActual::Finder.new

    attrs = {
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
    }
    result = finder.assign_attributes(attrs)
    result[:duration_start].should == Time.new(2011, 11, 7, 9 ,30)

    attrs = {
      "duration_start(1i)" => "",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
    }
    result = finder.assign_attributes(attrs)
    result[:duration_start].should be_nil

    attrs = {
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
    }
    result = finder.assign_attributes(attrs)
    result[:duration_start].should == Time.new(2011, nil)

    attrs = {
      "duration_start(1i)" => "0",
      "duration_start(2i)" => "0",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
    }
    result = finder.assign_attributes(attrs)
    result[:duration_start].should be_nil

    attrs = {
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "0",
      "duration_start(5i)" => "0",
    }
    result = finder.assign_attributes(attrs)
    result[:duration_start].should == Time.new(2011, 11, 7, 0, 0)
  end

  it "default attributes" do
    finder = Tengine::Job::RootJobnetActual::Finder.new
    now = Time.now
    finder.duration.should == "started_at"
    finder.duration_start.should == now.beginning_of_day
    finder.duration_finish.should == now.end_of_day
    finder.phase_ids.should == Tengine::Job::RootJobnetActual.phase_ids
  end

  it "属性の値を指定してインスタンスを作成したとき指定した値が設定されていること" do
    attrs = {
      :duration => "finished_at",
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
      "duration_finish(1i)" => "2011",
      "duration_finish(2i)" => "11",
      "duration_finish(3i)" => "7",
      "duration_finish(4i)" => "15",
      "duration_finish(5i)" => "30",
      :id => "45u4w0tu40",
      :name => "test",
      :phase_ids => [20, 30],
      :reflesh_interval => 10,
    }
    finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
    finder.duration.should == attrs[:duration]
    finder.duration_start.should == Time.new(2011, 11, 7, 9, 30)
    finder.duration_finish.should == Time.new(2011, 11, 7, 15, 30)
    finder.id.should == attrs[:id]
    finder.name.should == attrs[:name]
    finder.phase_ids.should == attrs[:phase_ids]
    finder.reflesh_interval.should == attrs[:reflesh_interval]
  end

  it "duration_start(1i)だけ指定されていないときduration_startは初期値のままのこと" do
    attrs = {
      "duration_start(1i)" => "",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "9",
      "duration_start(5i)" => "30",
    }
    finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
    expected = Tengine::Job::RootJobnetActual::Finder.new
    finder.duration_start.should == expected.duration_start
  end

  it "duration_finish(1i)だけ指定されていないときduration_finishは初期値のままのこと" do
    attrs = {
      "duration_finish(1i)" => "",
      "duration_finish(2i)" => "11",
      "duration_finish(3i)" => "7",
      "duration_finish(4i)" => "9",
      "duration_finish(5i)" => "30",
    }
    finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
    expected = Tengine::Job::RootJobnetActual::Finder.new
    finder.duration_finish.should == expected.duration_finish
  end

  it "idに@t1.idを指定してscopeを呼び出したとき@t1のみ取得できること" do
    change_now(2011, 11, 7, 16, 0) do
      attrs = {
        :id => @t1.id.to_s,
      }
      finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
      actuals = finder.scope(Mongoid::Criteria.new(Tengine::Job::RootJobnetActual))
      actuals.count.should == 1
      actuals.first.id.should == @t1.id
    end
  end

  it "nameに'foo'を指定してscopeを呼び出したときnameに'foo'を含んだものが取得できること" do
    change_now(2011, 11, 7, 16, 0) do
      attrs = {
        :name => "foo",
      }
      finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
      actuals = finder.scope(Mongoid::Criteria.new(Tengine::Job::RootJobnetActual))
      actuals.count.should == 2
      actuals.each do |actual|
        actual.name.should =~ /foo/
      end
    end
  end

  it "phase_idsが[30, 40]を指定してscopeを呼び出したときphase_cdが30か40のものが取得できること" do
    change_now(2011, 11, 7, 16, 0) do
      attrs = {
        :phase_ids => [30, 40],
      }
      finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
      actuals = finder.scope(Mongoid::Criteria.new(Tengine::Job::RootJobnetActual))
      actuals.count.should == 2
      actuals.each do |actual|
        [30, 40].should be_include(actual.phase_cd)
      end
    end
  end

  it "開始時刻が'2011/7/12 12:10'から'12:40'を指定してscopeを呼び出したとき開始時刻が'2011/7/12 12:10'から'12:40'のものが取得できること" do
    attrs = {
      :duration => "started_at",
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "12",
      "duration_start(5i)" => "10",
      "duration_finish(1i)" => "2011",
      "duration_finish(2i)" => "11",
      "duration_finish(3i)" => "7",
      "duration_finish(4i)" => "12",
      "duration_finish(5i)" => "40",
    }
    finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
    actuals = finder.scope(Mongoid::Criteria.new(Tengine::Job::RootJobnetActual))
    actuals.count.should == 2
    actuals.each do |actual|
      actual.started_at.should >= Time.new(2011, 11, 7, 12, 10)
      actual.started_at.should <= Time.new(2011, 11, 7, 12, 40)
    end
  end

  it "終了時刻が'2011/7/12 14:00'から'14:30'を指定してscopeを呼び出したとき開始時刻が'2011/7/12 14:00'から'14:30'のものが取得できること" do
    attrs = {
      :duration => "finished_at",
      "duration_start(1i)" => "2011",
      "duration_start(2i)" => "11",
      "duration_start(3i)" => "7",
      "duration_start(4i)" => "14",
      "duration_start(5i)" => "0",
      "duration_finish(1i)" => "2011",
      "duration_finish(2i)" => "11",
      "duration_finish(3i)" => "7",
      "duration_finish(4i)" => "14",
      "duration_finish(5i)" => "30",
    }
    finder = Tengine::Job::RootJobnetActual::Finder.new(attrs)
    actuals = finder.scope(Mongoid::Criteria.new(Tengine::Job::RootJobnetActual))
    actuals.count.should == 1
    actuals.each do |actual|
      actual.finished_at.should >= Time.new(2011, 11, 7, 14, 0)
      actual.finished_at.should <= Time.new(2011, 11, 7, 14, 30)
    end
  end
end
