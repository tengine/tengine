# -*- coding: utf-8 -*-
require 'spec_helper'

include ChangeTime

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Tengine::Job::Runtime::RootJobnetsController do

  # This should return the minimal set of attributes required to create a valid
  # Tengine::Job::Runtime::RootJobnet. As you add validations to Tengine::Job::Runtime::RootJobnet, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :name => "test1",
      :started_at => Time.new(2011, 11, 7, 13, 0)
    }
  end

  describe "GET index" do
    it "assigns all tengine_job_runtime_root_jobnets as @tengine_job_runtime_root_jobnets" do
      change_now(2011, 11, 7, 10, 0) do
        Tengine::Job::Runtime::RootJobnet.delete_all
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        get :index
        root_jobnet_actuals = assigns(:root_jobnet_actuals)
        root_jobnet_actuals.to_a.should eq([root_jobnet_actual])
      end
    end

    it "初期検索条件を持ったTengine::Job::Runtime::RootJobnet::Finderのインスタンスが@finderに設定されていること" do
      expected = Tengine::Job::Runtime::RootJobnet::Finder.new()
      get :index

      assigns(:finder).duration.should == expected.duration
      assigns(:finder).duration_start.should == expected.duration_start
      assigns(:finder).duration_finish.should == expected.duration_finish
      assigns(:finder).phase_ids.should == expected.phase_ids
      assigns(:finder).refresh_interval.should == 15
    end

    it "nilが@categoryに設定されていること" do
      get :index

      assigns(:category).should be_nil
    end

    it "登録されているTengine::Job::Structure::Categoryの内parent属性がnilのものが@root_categoriesに設定されていること" do
      Tengine::Job::Structure::Category.delete_all
      @foo = Tengine::Job::Structure::Category.create!({
        :name => "foo",
        :caption => "ふー",
      })
      Tengine::Job::Structure::Category.create!({
        :name => "bar",
        :caption => "ばー",
        :parent_id => @foo.id
      })

      get:index

      assigns(:root_categories).should == [@foo]
    end

    describe "?sort" do
      before do
        Tengine::Job::Template::RootJobnet.delete_all
        Tengine::Job::Runtime::RootJobnet.delete_all
        stub_template = stub_model(Tengine::Job::Template::RootJobnet, :name => "root_jobnet1")
        @t1 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "a_name",
          :description => "e_Description",
          :phase_cd => 60,
          :started_at => Time.new(2011, 11, 7, 12, 0),
          :finished_at => Time.new(2011, 11, 7, 13, 0),
          :template => stub_template
        })
        @t2 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "b_name",
          :description => "a_Description",
          :phase_cd => 70,
          :started_at => Time.new(2011, 11, 7, 13, 0),
          :finished_at => Time.new(2011, 11, 7, 14, 0),
          :template => stub_template
        })
        @t3 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "c_name",
          :description => "b_Description",
          :phase_cd => 20,
          :started_at => Time.new(2011, 11, 7, 14, 0),
          :finished_at => Time.new(2011, 11, 7, 15, 0),
          :template => stub_template
        })
        @t4 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "d_name",
          :description => "c_Description",
          :phase_cd => 30,
          :started_at => Time.new(2011, 11, 7, 10, 0),
          :finished_at => Time.new(2011, 11, 7, 16, 0),
          :template => stub_template
        })
        @t5 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "e_name",
          :description => "d_Description",
          :phase_cd => 50,
          :started_at => Time.new(2011, 11, 7, 11, 0),
          :finished_at => Time.new(2011, 11, 7, 12, 0),
          :template => stub_template
        })
      end

      it "ソートパラメータを指定しないとき@root_jobnet_actualsがstarted_atの降順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index

          actuals = assigns(:root_jobnet_actuals)
          [@t3, @t2, @t1, @t5, @t4].each_with_index do |expected, i|
            actuals[i].started_at.should == expected.started_at
          end
        end
      end

      it "nameの昇順でソートしたとき@root_jobnet_actualsがnameの昇順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:name => "asc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t1, @t2, @t3, @t4, @t5].each_with_index do |expected, i|
            actuals[i].name.should == expected.name
          end
        end
      end

      it "nameの降順でソートしたとき@root_jobnet_actualsがnameの昇順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:name => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t5, @t4, @t3, @t2, @t1].each_with_index do |expected, i|
            actuals[i].name.should == expected.name
          end
        end
      end

      it "descriptionの昇順でソートしたとき@root_jobnet_actualsがdescriptionの昇順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:description => "asc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t2, @t3, @t4, @t5, @t1].each_with_index do |expected, i|
            actuals[i].description.should == expected.description
          end
        end
      end

      it "descriptionの降順でソートしたとき@root_jobnet_actualsがdescriptionの降順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:description => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t1, @t5, @t4, @t3, @t2].each_with_index do |expected, i|
            actuals[i].description.should == expected.description
          end
        end
      end

      it "phase_cdの昇順でソートしたとき@root_jobnet_actualsがphase_cdの昇順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:phase_cd => "asc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t3, @t4, @t5, @t1, @t2].each_with_index do |expected, i|
            actuals[i].phase_cd.should == expected.phase_cd
          end
        end
      end

      it "phase_cdの降順でソートしたとき@root_jobnet_actualsがphase_cdの降順にソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:phase_cd => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t2, @t1, @t5, @t4, @t3].each_with_index do |expected, i|
            actuals[i].phase_cd.should == expected.phase_cd
          end
        end
      end

      it "started_atの昇順でソートしたとき@root_jobnet_actualsがstarted_atの昇順でソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:started_at => "asc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t4, @t5, @t1, @t2, @t3].each_with_index do |expected, i|
            actuals[i].started_at.should == expected.started_at
          end
        end
      end

      it "started_atの降順でソートしたとき@root_jobnet_actualsがstarted_atの降順でソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:started_at => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t3, @t2, @t1, @t5, @t4].each_with_index do |expected, i|
            actuals[i].started_at.should == expected.started_at
          end
        end
      end

      it "finished_atの昇順でソートしたとき@root_jobnet_actualsがfinished_atの昇順でソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:finished_at => "asc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t5, @t1, @t2, @t3, @t4].each_with_index do |expected, i|
            actuals[i].finished_at.should == expected.finished_at
          end
        end
      end

      it "finished_atの降順でソートしたとき@root_jobnet_actualsがfinished_atの降順でソートされていること" do
        change_now(2011, 11, 7, 16, 0) do
          get :index, :sort => {:finished_at => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t4, @t3, @t2, @t1, @t5].each_with_index do |expected, i|
            actuals[i].finished_at.should == expected.finished_at
          end
        end
      end
    end

    describe "?finder" do
      before do
        Tengine::Job::Template::RootJobnet.delete_all
        Tengine::Job::Runtime::RootJobnet.delete_all
        stub_template = stub_model(Tengine::Job::Template::RootJobnet, :name => "root_jobnet1")
        @t1 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "test_1_foo",
          :phase_cd => 30,
          :started_at => Time.new(2011, 11, 7, 11, 30),
          :finished_at => nil,
          :template => stub_template
        })
        @t2 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "test_2_foo",
          :phase_cd => 40,
          :started_at => Time.new(2011, 11, 7, 13, 30),
          :finished_at => Time.new(2011, 11, 7, 14, 10),
          :template => stub_template
        })
        @t3 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "test_3",
          :phase_cd => 50,
          :started_at => Time.new(2011, 11, 7, 12, 30),
          :finished_at => nil,
          :template => stub_template
        })
        @t4 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "test_4",
          :phase_cd => 50,
          :started_at => Time.new(2011, 11, 7, 12, 30),
          :finished_at => nil,
          :template => stub_template
        })
      end

      it "finderのクエリーパラメータを指定しないとき@root_jobnet_actualsが4件であること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index

          actuals = assigns(:root_jobnet_actuals)
          actuals.count.should == 4
        end
      end

      it "開始時刻が'2011/11/7 11:30'から'12:00'で検索したとき@root_jobnet_actualsにstarted_atが'2011/11/7 11:30'以上'12:00'以下のものが取得できること" do
        started_at = Time.new(2011, 11, 7, 11, 30)
        finished_at = Time.new(2011, 11, 7, 12, 0)

        get :index, :finder => {
          :duration => "started_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.each do |actual|
          actual.started_at.should >= started_at
          actual.started_at.should <= finished_at
        end
      end

      it "開始時刻が'2011/11/7 10:00'から'11:30'で検索したとき@root_jobnet_actualsにstarted_atが'2011/11/7 10:00'以上'11:30'以下のものが取得できること" do
        started_at = Time.new(2011, 11, 7, 10, 0)
        finished_at = Time.new(2011, 11, 7, 11, 30)

        get :index, :finder => {
          :duration => "started_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.each do |actual|
          actual.started_at.should >= started_at
          actual.started_at.should <= finished_at
        end
      end

      it "終了時刻が'2011/11/7 14:10'から'14:30'で検索したとき@root_jobnet_actualsにfinished_atが'2011/11/7 14:10'以上'14:30'以下のものが取得できること" do
        started_at = Time.new(2011, 11, 7, 14, 10)
        finished_at = Time.new(2011, 11, 7, 14, 30)

        get :index, :finder => {
          :duration => "finished_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.each do |actual|
          actual.finished_at.should >= started_at
          actual.finished_at.should <= finished_at
        end
      end

      it "終了時刻が'2011/11/7 14:00'から'14:10'で検索したとき@root_jobnet_actualsにfinished_atが'2011/11/7 14:00'以上'14:10'以下のものが取得できること" do
        started_at = Time.new(2011, 11, 7, 14, 0)
        finished_at = Time.new(2011, 11, 7, 14, 10)

        get :index, :finder => {
          :duration => "finished_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.each do |actual|
          actual.finished_at.should >= started_at
          actual.finished_at.should <= finished_at
        end
      end

      it "IDが@t3.idの値で検索したとき@root_jobnet_actualsが@t3の1件であること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:id => @t3.id}

          actuals = assigns(:root_jobnet_actuals)
          actuals.count.should == 1
          actuals.first.id.should == @t3.id
        end
      end

      it "名称が'test_4'で検索したとき@root_jobnet_actualsに名称に'test_4'を含むものが取得できること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:name => "test_4"}

          actuals = assigns(:root_jobnet_actuals)
          actuals.each do |actual|
            actual.name.should =~ /test_4/
          end
        end
      end

      it "名称が'foo'で検索したとき@root_jobnet_actualsに名称に'foo'を含むものが取得できること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:name => "foo"}

          actuals = assigns(:root_jobnet_actuals)
          actuals.each do |actual|
            actual.name.should =~ /foo/
          end
        end
      end

      it "フェーズが'success'で検索したとき@root_jobnet_actualsにフェーズが'success'のものが取得できること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:phase_ids => ["40"]}

          actuals = assigns(:root_jobnet_actuals)
          actuals.each do |actual|
            actual.phase_cd.to_s.should == "40"
          end
        end
      end

      it "フェーズが'success'と'ready'で検索したとき@root_jobnet_actualsにフェーズが'success'か'ready'のものが取得できること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:phase_ids => ["30", "40"]}

          actuals = assigns(:root_jobnet_actuals)
          actuals.each do |actual|
            actual.phase_cd.to_s.should =~ /30|40/
          end
        end
      end

      it "名称が'test'でフェーズが'starting'で検索したとき@root_jobnet_actualsが@t3,@t4の2件であること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:name => "test", :phase_ids => ["50"]}

          actuals = assigns(:root_jobnet_actuals)
          actuals.each do |actual|
            actual.name.should =~ /test/
            actual.phase_cd.to_s.should == "50"
          end
        end
      end

      it "名称が'test'で終了時刻が'2011/11/7 14:00'から'14:30'で検索したとき@root_jobnet_actualsが@t2の1件であること" do
        started_at = Time.new(2011, 11, 7, 14, 0)
        finished_at = Time.new(2011, 11, 7, 14, 30)

        get :index, :finder => {
          :duration => "finished_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
          :name => "test",
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.count.should == 1
        actuals.each do |actual|
          actual.finished_at.should >= started_at
          actual.finished_at.should <= finished_at
          actual.name.should =~ /test/
        end
      end

      it "開始時刻が'2011/11/7 12:20'から'12:40'で名称が'test_3'で検索したとき@root_jobnet_actualsが@t3の1件であること" do
        started_at = Time.new(2011, 11, 7, 12, 20)
        finished_at = Time.new(2011, 11, 7, 12, 40)

        get :index, :finder => {
          :duration => "started_at",
          "duration_start(1i)" => started_at.year,
          "duration_start(2i)" => started_at.mon,
          "duration_start(3i)" => started_at.day,
          "duration_start(4i)" => started_at.hour,
          "duration_start(5i)" => started_at.min,
          "duration_finish(1i)" => finished_at.year,
          "duration_finish(2i)" => finished_at.mon,
          "duration_finish(3i)" => finished_at.day,
          "duration_finish(4i)" => finished_at.hour,
          "duration_finish(5i)" => finished_at.min,
          :name => "test_3",
        }

        actuals = assigns(:root_jobnet_actuals)
        actuals.count.should == 1
        actuals.each do |actual|
          actual.started_at.should >= started_at
          actual.started_at.should <= finished_at
          actual.name.should =~ /test_3/
        end
      end

      it "名称が'foo'で検索した後に名称で降順にソートしたとき名称に'foo'を含み名称の降順ソートされていること" do
        change_now(2011, 11, 7, 15, 0) do
          get :index, :finder => {:name => "foo"}, :sort => {:name => "desc"}

          actuals = assigns(:root_jobnet_actuals)
          [@t2, @t1].each_with_index do |expected, i|
            actuals[i].name.should =~ /foo/
            actuals[i].id.should == expected.id
          end
        end
      end

      it "デフォルトではrefreshのレイアウトが使用されていること" do
        get :index

        assert_template :layout => "layouts/application"
      end

      it "リフレッシュ間隔が1以上のときrefreshのレイアウトが使用されていること" do
        get :index, :finder => {:refresh_interval => 30}

        assert_template :layout => "layouts/application"
      end

      it "リフレッシュ間隔が0か指定されていないときapplicationのレイアウトが使用されていること" do
        get :index, :finder => {:refresh_interval => 0}

        assert_template :layout => "layouts/application"

        get :index, :finder => {:refresh_interval => ""}

        assert_template :layout => "layouts/application"
      end

    end

    describe "?category" do
      before do
        Tengine::Job::Structure::Category.delete_all
        Tengine::Job::Template::RootJobnet.delete_all
        Tengine::Job::Runtime::RootJobnet.delete_all
        @foo = Tengine::Job::Structure::Category.create!(
          :name => "foo",
          :caption => "ふー"
        )
        @bar = Tengine::Job::Structure::Category.create!(
          :name => "bar",
          :caption => "ばー",
          :parent_id => @foo.id
        )
        @foo.children << @bar
        @foo.save!

        @job1 = Tengine::Job::Template::RootJobnet.create!(
          :name => "foo_job",
          :description => "jobnet_foo_test description",
          :script => "Script",
          :category_id => @foo.id,
          :dsl_filepath => "foo/jobnet_test_1.rb",
          :dsl_lineno => 4,
          :dsl_version => "1"
        )
        @job2 = Tengine::Job::Template::RootJobnet.create!(
          :name => "bar_job",
          :description => "jobnet_bar_test description",
          :script => "Script",
          :category_id => @bar.id,
          :dsl_filepath => "foo/bar/jobnet_test_2.rb",
          :dsl_lineno => 4,
          :dsl_version => "1"
        )
        @t1 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "a_name",
          :description => "c_Description",
          :phase_cd => 20,
          :started_at => Time.new(2011, 11, 7, 12, 0),
          :finished_at => Time.new(2011, 11, 7, 13, 0),
          :template_id => @job1.id,
          :category_id => @foo.id,
          :dsl_version => "1",
        })
        @t2 = Tengine::Job::Runtime::RootJobnet.create!({
          :name => "b_name",
          :description => "b_Description",
          :phase_cd => 30,
          :started_at => Time.new(2011, 11, 7, 12, 0),
          :finished_at => nil,
          :template_id => @job2.id,
          :category_id => @bar.id,
          :dsl_version => "1",
        })
      end

      context "categoryのクエリーパラメータがないとき" do
        it "@categoryがnilであること" do
          get :index

          category = assigns(:category)
          category.should be_nil
        end

        it "@root_jobnet_actualsが2件であること" do
          get :index, :finder => {:duration => ""}

          actuals = assigns(:root_jobnet_actuals)
          actuals.count.should == 2
        end
      end

      context "categoryのクエリーパラメータが@foo.idのとき" do
        it "@categoryが@fooであること" do
          get :index, :category => @foo.id

          category = assigns(:category)
          category.id.should == @foo.id
        end

        it "@root_jobnet_actualsが2件であること" do
          get :index, :category => @foo.id, :finder => {:duration => ""}

          actuals = assigns(:root_jobnet_actuals)
          actuals.count.should == 2
        end

        context "名称の降順でソートしたとき" do
          it "@root_jobnet_actualsが2件で名称の降順でソートされていること" do
            get :index, :category => @foo.id, :finder => {:duration => ""},
              :sort => {:name => "desc"}

            actuals = assigns(:root_jobnet_actuals)
            actuals.count.should == 2
            [@t2, @t1].each_with_index do |expected, i|
              actuals[i].id.should == expected.id
            end
          end
        end

        context "名称が'a_name'で検索したとき" do
          it "@root_jobnet_actualsが1件であること" do
            get :index, :category => @foo.id,
              :finder => {:duration => "", :name => "a_name"}

            actuals = assigns(:root_jobnet_actuals)
            actuals.count.should == 1
            actuals.each do |actual|
              actual.name.should =~ /a_name/
            end
          end
        end
      end

      context "categoryのクエリーパラメータが@bar.idのとき" do
        it "@categoryが@barであること" do
          get :index, :category => @bar.id

          category = assigns(:category)
          category.id.should == @bar.id
        end

        it "@root_jobnet_actualsが1件であること" do
          get :index, :category => @bar.id, :finder => {:duration => ""}

          actuals = assigns(:root_jobnet_actuals)
          actuals.count.should == 1
        end
      end
    end
  end

  describe "GET show" do
    it "assigns the requested root_jobnet_actual as @root_jobnet_actual" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      get :show, :id => root_jobnet_actual.id.to_s
      assigns(:root_jobnet_actual).should eq(root_jobnet_actual)
    end

    it "assigns the submited refresher as @refresher" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      get :show, :id => root_jobnet_actual.id.to_s,
        :refresher => {:refresh_interval => 30}
      assigns(:refresher).refresh_interval.should == 30

      get :show, :id => root_jobnet_actual.id.to_s
      assigns(:refresher).refresh_interval.should == 15
    end

    it "リクエストしたroot_jobnet_actualを元に@finderが設定されていること" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      get :show, :id => root_jobnet_actual.id.to_s
      finder = assigns(:finder)
      finder[:source_name].should == "/" + root_jobnet_actual.id.to_s + "/"
      finder[:occurred_at_start].should == nil # Time.new(2011, 11, 7, 13, 0).strftime("%H:%M")
      finder[:occurred_at_end].should be_nil
    end
  end

  describe "GET new" do
    it "indexにリダイレクトされる" do
      get :new
      response.should redirect_to(:action => 'index')
    end
  end

  describe "GET edit" do
    it "assigns the requested root_jobnet_actual as @root_jobnet_actual" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      get :edit, :id => root_jobnet_actual.id.to_s
      assigns(:root_jobnet_actual).should eq(root_jobnet_actual)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Tengine::Job::Runtime::RootJobnet" do
        expect {
          post :create, :root_jobnet_actual => valid_attributes
        }.to change(Tengine::Job::Runtime::RootJobnet, :count).by(1)
      end

      it "assigns a newly created root_jobnet_actual as @root_jobnet_actual" do
        post :create, :root_jobnet_actual => valid_attributes
        assigns(:root_jobnet_actual).should be_a(Tengine::Job::Runtime::RootJobnet)
        assigns(:root_jobnet_actual).should be_persisted
      end

      it "redirects to the created root_jobnet_actual" do
        post :create, :root_jobnet_actual => valid_attributes
        response.should redirect_to(Tengine::Job::Runtime::RootJobnet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved root_jobnet_actual as @root_jobnet_actual" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tengine::Job::Runtime::RootJobnet.any_instance.stub(:save).and_return(false)
        post :create, :root_jobnet_actual => {}
        assigns(:root_jobnet_actual).should be_a_new(Tengine::Job::Runtime::RootJobnet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tengine::Job::Runtime::RootJobnet.any_instance.stub(:save).and_return(false)
        post :create, :root_jobnet_actual => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested root_jobnet_actual" do
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        # Assuming there are no other tengine_job_runtime_root_jobnets in the database, this
        # specifies that the Tengine::Job::Runtime::RootJobnet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Tengine::Job::Runtime::RootJobnet.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => root_jobnet_actual.id, :root_jobnet_actual => {'these' => 'params'}
      end

      it "assigns the requested root_jobnet_actual as @root_jobnet_actual" do
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        put :update, :id => root_jobnet_actual.id, :root_jobnet_actual => valid_attributes
        assigns(:root_jobnet_actual).should eq(root_jobnet_actual)
      end

      it "redirects to the root_jobnet_actual" do
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        put :update, :id => root_jobnet_actual.id, :root_jobnet_actual => valid_attributes
        response.should redirect_to(root_jobnet_actual)
      end
    end

    describe "with invalid params" do
      it "assigns the root_jobnet_actual as @root_jobnet_actual" do
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Tengine::Job::Runtime::RootJobnet.any_instance.stub(:save).and_return(false)
        put :update, :id => root_jobnet_actual.id.to_s, :root_jobnet_actual => {}
        assigns(:root_jobnet_actual).should eq(root_jobnet_actual)
      end

      it "re-renders the 'edit' template" do
        root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Tengine::Job::Runtime::RootJobnet.any_instance.stub(:save).and_return(false)
        put :update, :id => root_jobnet_actual.id.to_s, :root_jobnet_actual => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested root_jobnet_actual" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      Tengine::Job::Runtime::RootJobnet.any_instance.should_receive(:fire_stop_event)
      delete :destroy, :id => root_jobnet_actual.id.to_s
    end

    it "redirects to the tengine_job_runtime_root_jobnets list" do
      root_jobnet_actual = Tengine::Job::Runtime::RootJobnet.create! valid_attributes
      Tengine::Job::Runtime::RootJobnet.any_instance.should_receive(:fire_stop_event)
      delete :destroy, :id => root_jobnet_actual.id.to_s
      response.should redirect_to(tengine_job_runtime_root_jobnet_path(root_jobnet_actual))
    end
  end

end
