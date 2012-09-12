# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Tengine::Job::Category do

  describe :update_for do

    context "RootJobnetTemplateのdsl_filepathからCategoryを登録します" do

      before do
        Tengine::Job::Vertex.delete_all
        Tengine::Job::Category.delete_all
        @root1 = Tengine::Job::RootJobnetTemplate.create!({
            :name => "root_jobnet_template01",
            :dsl_filepath => "foo/bar1/jobnet01.rb",
            :dsl_lineno => 4,
            :dsl_version => "1"
          })
        @root2 = Tengine::Job::RootJobnetTemplate.create!({
            :name => "root_jobnet_template01",
            :dsl_filepath => "foo/bar2/jobnet01.rb",
            :dsl_lineno => 4,
            :dsl_version => "2"
          })
        @root3 = Tengine::Job::RootJobnetTemplate.create!({
            :name => "root_jobnet_template01",
            :dsl_filepath => "foo/bar3/jobnet2.rb",
            :dsl_lineno => 4,
            :dsl_version => "2"
          })
        @root4 = Tengine::Job::RootJobnetTemplate.create!({
            :name => "root_jobnet_template04",
            :dsl_filepath => "jobnet4.rb",
            :dsl_lineno => 4,
            :dsl_version => "2"
          })
        @tmp_dir = Dir.tmpdir
        @base_dir = File.expand_path("root", @tmp_dir)
        FileUtils.mkdir_p(File.expand_path("foo/bar2", @base_dir))
        FileUtils.mkdir_p(File.expand_path("foo/bar3", @base_dir))
        File.open(File.expand_path("dictionary.yml", @tmp_dir), "w"){|f| YAML.dump({"root" => "ルート"}, f)}
        File.open(File.expand_path("dictionary.yml", @base_dir), "w"){|f| YAML.dump({"foo" => "ほげ"}, f)}
        File.open(File.expand_path("foo/dictionary.yml", @base_dir), "w"){|f|
          YAML.dump({"bar1" => "ばー1", "bar2" => "ばー2"}, f)}
      end

      context "指定されたバージョンのRootJobneTTemplateからカテゴリを生成します" do
        it "全ドキュメントを対象にしています・・・" do
          expect{
            Tengine::Job::Category.update_for(@base_dir)
          }.to change(Tengine::Job::Category, :count).by(5)
          root = Tengine::Job::Category.where({:parent_id => nil}).first
          root.name.should == "root"
          root.caption.should == "ルート"
          root.children.count.should == 1
          foo = root.children[0]
          foo.name.should == "foo"
          foo.caption.should == "ほげ"
          foo.children.count.should == 3
          foo.children[0].tap do |c|
            c.name.should == "bar1"
            c.caption.should == "ばー1"
            c.parent_id.should == foo.id
            @root1.reload
            @root1.category_id.should == c.id
          end
          foo.children[1].tap do |c|
            c.name.should == "bar2"
            c.caption.should == "ばー2"
            c.parent_id.should == foo.id
            @root2.reload
            @root2.category_id.should == c.id
          end
          foo.children[2].tap do |c|
            c.name.should == "bar3"
            c.caption.should == "bar3"
            c.parent_id.should == foo.id
            @root3.reload
            @root3.category_id.should == c.id
          end
        end
      end

      it "後から追加された場合" do
        expect{
          Tengine::Job::Category.update_for(@base_dir)
        }.to change(Tengine::Job::Category, :count).by(5)
        @root4 = Tengine::Job::RootJobnetTemplate.create!({
            :name => "root_jobnet_template01",
            :dsl_filepath => "foo/bar3/baz1/jobnet2.rb",
            :dsl_lineno => 4,
            :dsl_version => "3"
          })
        expect{
          Tengine::Job::Category.update_for(@base_dir)
        }.to change(Tengine::Job::Category, :count).by(1)
        root = Tengine::Job::Category.where({:parent_id => nil}).first
        foo = root.children[0]
        foo.children[2].tap do |bar3|
          bar3.name.should == "bar3"
          bar3.caption.should == "bar3"
          bar3.parent_id.should == foo.id
          bar3.children.first.tap do |baz1|
           baz1.name.should == "baz1"
           baz1.caption.should == "baz1"
           baz1.parent_id.should == bar3.id
            @root4.reload
            @root4.category_id.should == baz1.id
          end
        end
      end

      it "Tengine::Job.notifyでジョブDSLのロード終了を通知された場合" do
        mock_config = mock(:config)
        mock_config.should_receive(:dsl_dir_path).and_return(@base_dir)
        mock_sender = mock(:sender)
        mock_sender.should_receive(:respond_to?).with(:config).and_return(true)
        mock_sender.should_receive(:config).and_return(mock_config)
        expect{
          Tengine::Job.notify(mock_sender, :after_load_dsl)
        }.to change(Tengine::Job::Category, :count).by(5)
        root = Tengine::Job::Category.where({:parent_id => nil}).first
        root.name.should == "root"
        root.caption.should == "ルート"
        root.children.count.should == 1
        foo = root.children[0]
        foo.name.should == "foo"
        foo.caption.should == "ほげ"
        foo.should_not be_nil
        foo.children.count.should == 3
        foo.children[0].tap do |c|
          c.name.should == "bar1"
          c.caption.should == "ばー1"
          c.parent_id.should == foo.id
          @root1.reload
          @root1.category_id.should == c.id
        end
        foo.children[1].tap do |c|
          c.name.should == "bar2"
          c.caption.should == "ばー2"
          c.parent_id.should == foo.id
          @root2.reload
          @root2.category_id.should == c.id
        end
        foo.children[2].tap do |c|
          c.name.should == "bar3"
          c.caption.should == "bar3"
          c.parent_id.should == foo.id
          @root3.reload
          @root3.category_id.should == c.id
        end
      end

    end

  end


  describe "名前で検索" do
    before do
      Tengine::Job::Category.delete_all
      Tengine::Job::Category.create!(:name => "category1", :caption => "ONE")
      Tengine::Job::Category.create!(:name => "category2", :caption => "TWO")
    end

    [:find_by_name, :find_by_name!].each do |method_name|
      it "存在する場合はそれを返す" do
        driver = Tengine::Job::Category.send(method_name, "category1")
        driver.should be_a(Tengine::Job::Category)
        driver.name.should == "category1"
        driver.caption.should == "ONE"
      end
    end

    it ":find_by_nameは見つからなかった場合はnilを返す" do
      Tengine::Job::Category.find_by_name("unexist_category").should == nil
    end

    it ":find_by_name!は見つからなかった場合はTengine::Core::FindByName::Errorをraiseする" do
      begin
          Tengine::Job::Category.find_by_name!("unexist_category")
      rescue Tengine::Errors::NotFound => e
        e.message.should == "Tengine::Job::Category named \"unexist_category\" not found"
      end
    end

  end



end
