# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tmpdir'

describe "tengine/job/root_jobnet_templates/show.html.erb" do
  before(:all) do
    Tengine.plugins.add(Tengine::Job)
  end

  def load_dsl(dir, filename)
    @bootstrap = Tengine::Core::Bootstrap.new({
      :action => "load",
      :tengined => { :load_path => File.expand_path(filename, dir), :cache_drivers => true },
    })
    @bootstrap.boot
  end

  describe "構成ジョブがないとき" do
    before(:each) do

      @root_jobnet_template = assign(:root_jobnet_template,
        stub_model(Tengine::Job::Template::RootJobnet,
        :id => Moped::BSON::ObjectId("4e955633c3406b3a9f000001"),
        :name => "Name",
        :server_name => "Server Name",
        :credential_name => "Credential Name",
        :killing_signals => ["abc", "123"],
        :killing_signal_interval => 1,
        :description => "Description",
        :script => "Script",
        :jobnet_type_cd => 1,
        :category => nil,
        :lock_version => 1,
        :dsl_filepath => "Dsl Filepath",
        :dsl_lineno => 1,
        :dsl_version => "Dsl Version"
      ))
    end

    it "ページタイトルが表示されていること" do
      render

      title = page_title(Tengine::Job::Template::RootJobnet, :show)
      rendered.should have_xpath("//h1", :text => title)
    end

    it "情報が表示されていること" do
      render

      rendered.should have_xpath("//td", :text => @root_jobnet_template.name)
      rendered.should have_xpath("//td", :text => "#{@root_jobnet_template.id}")
      rendered.should have_xpath("//td", :text => @root_jobnet_template.name)
      rendered.should have_xpath("//td", :text => @root_jobnet_template.description)
    end

    it "実行設定画面へのリンクが表示されていること" do
      render

      name = I18n.t(:run, :scope => [:views, :links])
      rendered.should have_link(name, :href =>
        new_tengine_job_execution_path(:root_jobnet_id => @root_jobnet_template))
    end

    it "一覧画面へのリンクが表示されていること" do
      render

      name = I18n.t(:back_list, :scope => [:views, :links])
      rendered.should have_link(name, :href => tengine_job_root_jobnet_templates_path)
    end
  end

  describe "構成ジョブがあるとき" do
    before do
      Tengine::Job::Template::RootJobnet.delete_all
      @dsl_dir = Dir.tmpdir
      File.open(File.expand_path("VERSION", @dsl_dir), "w"){|f| f.write("1") }
      fname = "jn1_jobnet"
      File.open(File.expand_path(fname, @dsl_dir), "w") do |f|
        f.write(<<-__end_of_dsl__)
# -*- coding: utf-8 -*-
require 'tengine_job'
# [jn1]
#               
# [S1]-->[j1]-->[j2]-->[E1]
#               
jobnet("jn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "echo 'j1'", :to => "j2")
  job("j2", "echo 'j2'")
  finally do
    job("jn1_f", "echo 'jn1_f'")
  end
end
__end_of_dsl__
      end
      load_dsl(@dsl_dir, fname)
      @root_jobnet_template = assign(:root_jobnet_template,
        Tengine::Job::Template::RootJobnet.first())
      @jobnet_templates = []
      visitor = \
        Tengine::Job::Vertex::AllVisitor.new do |vertex|
          if vertex.instance_of?(Tengine::Job::JobnetTemplate) or vertex.instance_of?(Tengine::Job::Expansion)
            @jobnet_templates << [vertex, (vertex.ancestors.size - 1)]
          end
        end
      @root_jobnet_template.accept_visitor(visitor)
    end

    it "構成ジョブが表示されていること" do
      render

      @jobnet_templates.each do |item|
        jobnet_template = item.first
        level = item.second
        next if (edges = jobnet_template.next_edges).blank?
        destination = edges.first.destination
        next unless destination.instance_of?(Tengine::Job::JobnetTemplate)

        space = Nokogiri::HTML('&nbsp;').text
        indent = space * level
        rendered.should have_xpath("//td", :text => "#{jobnet_template.id}")
        rendered.should have_xpath("//td", :text => "#{indent}#{jobnet_template.name}")
        rendered.should have_xpath("//td", :text => jobnet_template.script)
        rendered.should have_xpath("//td", :text => jobnet_template.description)
        rendered.should have_xpath("//td", :text => destination.name)
      end
    end

    it "finallyジョブが表示されていること" do
      render

      rendered.should have_xpath("//td", :text => "finally")
    end
  end

  describe "構成ジョブにジョブネットが含まれているとき" do
    before do
      Tengine::Job::Template::RootJobnet.delete_all
      @dsl_dir = Dir.tmpdir
      File.open(File.expand_path("VERSION", @dsl_dir), "w"){|f| f.write("1") }
      fname = "jn1_jobnet"
      File.open(File.expand_path(fname, @dsl_dir), "w") do |f|
        f.write(<<-__end_of_dsl__)
# -*- coding: utf-8 -*-
require 'tengine_job'
# [jn1]
#               
#          __________[jn2]___________
#        {                           }
#        {                           }
# [S1]-->{    [S2]-->[j21]-->[E2]    }-->[E1]
#        {  _________finally________ }
#        { { [S3]-->[jn2_f]-->[E3] } }
#        { __________________________}
#               
jobnet("jn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jn2")
  jobnet("jn2") do
    boot_jobs("j21")
    job("j21", "echo 'job21'", "j21_display")
    finally do
      job("jn2_f", "echo 'jn2_f'")
    end
  end
  finally do
    job("jn1_f", "echo 'jn1_f'")
  end
end
__end_of_dsl__
      end
      load_dsl(@dsl_dir, fname)
      @root_jobnet_template = assign(:root_jobnet_template,
        Tengine::Job::Template::RootJobnet.first())
      @jobnet_templates = []
      visitor = \
        Tengine::Job::Vertex::AllVisitor.new do |vertex|
          if vertex.instance_of?(Tengine::Job::JobnetTemplate) or vertex.instance_of?(Tengine::Job::Expansion)
            @jobnet_templates << [vertex, (vertex.ancestors.size - 1)]
          end
        end
      @root_jobnet_template.accept_visitor(visitor)
    end

    it "ジョブネット中のジョブが表示されていること" do
      render

      space = Nokogiri::HTML('&nbsp;').text
      indent = space * 2
      rendered.should have_xpath("//td", :text => "#{indent}j21")
      rendered.should have_xpath("//td", :text => "echo 'job21'")
      rendered.should have_xpath("//td", :text => "j21_display")
    end
  end

  describe "ジョブネットにforkが含まれているとき" do
    before do
      Tengine::Job::Template::RootJobnet.delete_all
      @dsl_dir = Dir.tmpdir
      File.open(File.expand_path("VERSION", @dsl_dir), "w"){|f| f.write("1") }
      fname = "jn1_jobnet"
      File.open(File.expand_path(fname, @dsl_dir), "w") do |f|
        f.write(<<-__end_of_dsl__)
# -*- coding: utf-8 -*-
require 'tengine_job'
# [jn1]
#               |-[j2]-|
# [S1]-->[j1]-->        -->[j4]-->[E1]
#               |-[j3]-|
jobnet("jn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "echo 'job1'", "j1_display", :to => ["j2", "j3"])
  job("j2", "echo 'job2'", "j2_display", :to => "j4")
  job("j3", "echo 'job3'", "j3_display", :to => "j4")
  job("j4", "echo 'job4'", "j4_display")
  finally do
    job("jn1_f", "echo 'jn1_f'")
  end
end
__end_of_dsl__
      end
      load_dsl(@dsl_dir, fname)
      @root_jobnet_template = assign(:root_jobnet_template,
        Tengine::Job::Template::RootJobnet.first())
      @jobnet_templates = []
      visitor = \
        Tengine::Job::Vertex::AllVisitor.new do |vertex|
          if vertex.instance_of?(Tengine::Job::JobnetTemplate) or vertex.instance_of?(Tengine::Job::Expansion)
            @jobnet_templates << [vertex, (vertex.ancestors.size - 1)]
          end
        end
      @root_jobnet_template.accept_visitor(visitor)
    end

    it "次に実行するジョブが複数のジョブである場合次のジョブに複数のジョブの識別子が表示されていること" do
      render

      rendered.should have_xpath("//td", :text => "j1")
      rendered.should have_xpath("//td", :text => "echo 'job1'")
      rendered.should have_xpath("//td", :text => "j1_display")
      rendered.should have_xpath("//td", :text => "j2, j3")
    end
  end

  describe "ジョブネットにexpansionが含まれているとき" do
    before do
      Tengine::Job::Template::RootJobnet.delete_all
      @dsl_dir = Dir.tmpdir
      File.open(File.expand_path("VERSION", @dsl_dir), "w"){|f| f.write("1") }
      expansion_jobnets = {
        :jn11_jobnet => "jn11",
        :jn12_jobnet => "jn12",
        :jn13_jobnet => "jn13",
        :jn14_jobnet => "jn14",
        :jn16_jobnet => "jn16",
      }
      expansion_jobnets.each do |k, v|
        fname = k.to_s
        File.open(File.expand_path(fname, @dsl_dir), "w") do |f|
          f.write(<<-__end_of_dsl__)
# -*- coding: utf-8 -*-
require 'tengine_job'
jobnet("#{v}", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("j1")
  job("j1", "echo 'j1'")
end
__end_of_dsl__
        end
        load_dsl(@dsl_dir, fname)
      end

      fname = "jn1_jobnet"
      File.open(File.expand_path(fname, @dsl_dir), "w") do |f|
        f.write(<<-__end_of_dsl__)
# -*- coding: utf-8 -*-
require 'tengine_job'
jobnet("jn1", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs("jn11")
  expansion("jn11", :to => ["jn12", "jn13"])
  expansion("jn12", :to => "jn14")
  expansion("jn13", :to => "jn14")
  expansion("jn14")
  job("j15", "echo 'j15'")
  finally do
    expansion("jn16")
  end
end
__end_of_dsl__
      end
      load_dsl(@dsl_dir, fname)
      @root_jobnet_template = assign(:root_jobnet_template,
        Tengine::Job::Template::RootJobnet.find_by_name("jn1"))
      @jobnet_templates = []

      visitor = \
        Tengine::Job::Vertex::AllVisitor.new do |vertex|
          if vertex.instance_of?(Tengine::Job::JobnetTemplate) or vertex.instance_of?(Tengine::Job::Expansion)
            @jobnet_templates << [vertex, (vertex.ancestors.size - 1)]
          end
        end
      @root_jobnet_template.accept_visitor(visitor)
    end

    it "expansionを含むジョブネットの場合、expansionのジョブが表示されること" do
      render

      rendered.should have_xpath("//td", :text => "jn11")
      rendered.should have_xpath("//td", :text => "jn12, jn13")
      rendered.should have_xpath("//td", :text => "jn12")
      rendered.should have_xpath("//td", :text => "jn13")
      rendered.should have_xpath("//td", :text => "jn14")
      rendered.should have_xpath("//td", :text => "j15")
      rendered.should have_xpath("//td", :text => "finally")
      rendered.should have_xpath("//td", :text => "jn16")
    end
  end
end
