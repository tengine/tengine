# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Template::Jobnet do

  context "基本機能" do
    before do
      @j1000 = Tengine::Job::Template::Jobnet.new(:name => "j1000").with_start
      @j1000.children << @j1100 = Tengine::Job::Template::Jobnet.new(:name => "j1100").with_start
      @j1100.children << @j1110 = Tengine::Job::Template::Jobnet.new(:name => "j1110", :script => "j1110.sh")
      @j1100.children << @j1120 = Tengine::Job::Template::Jobnet.new(:name => "j1120", :script => "j1120.sh")
      @j1000.children << @j1200 = Tengine::Job::Template::Jobnet.new(:name => "j1200").with_start
      @j1200.children << @j1210 = Tengine::Job::Template::Jobnet.new(:name => "j1210").with_start
      @j1210.children << @j1211 = Tengine::Job::Template::Jobnet.new(:name => "j1211", :script => "j1211.sh")
      @j1210.children << @j1212 = Tengine::Job::Template::Jobnet.new(:name => "j1212", :script => "j1212.sh")
      @j1200.children << @j1220 = Tengine::Job::Template::Jobnet.new(:name => "j1220").with_start
      @j1220.children << @j1221 = Tengine::Job::Template::Jobnet.new(:name => "j1221", :script => "j1221.sh")
      @j1220.children << @j1222 = Tengine::Job::Template::Jobnet.new(:name => "j1222", :script => "j1222.sh")
      @j1000.prepare_end
      @j1100.prepare_end
      @j1200.prepare_end
      @j1210.prepare_end
      @j1220.prepare_end
      @j1000.build_sequencial_edges
      @j1100.build_sequencial_edges
      @j1200.build_sequencial_edges
      @j1210.build_sequencial_edges
      @j1220.build_sequencial_edges
      @j1000.save!
    end

    name_to_name_path = {
      'j1000' => '/j1000',
      'j1100' => '/j1000/j1100',
      'j1110' => '/j1000/j1100/j1110',
      'j1120' => '/j1000/j1100/j1120',
      'j1200' => '/j1000/j1200',
      'j1210' => '/j1000/j1200/j1210',
      'j1211' => '/j1000/j1200/j1210/j1211',
      'j1212' => '/j1000/j1200/j1210/j1212',
      'j1220' => '/j1000/j1200/j1220',
      'j1221' => '/j1000/j1200/j1220/j1221',
      'j1222' => '/j1000/j1200/j1220/j1222',
    }

    describe :name_path do
      name_to_name_path.each do |node_name, name_path|
        context "#{node_name}'s name_path" do
          subject{ instance_variable_get(:"@#{node_name}") }
          its(:name_path){ should == name_path}
        end
      end
    end

    describe 'find_descendant系' do
      all_node_names = %w[j1000 j1100 j1110 j1120 j1200 j1210 j1211 j1212 j1220 j1221 j1222]

      context "find_descendant*メソッドではルートはルート自身を見つけることができない" do
        it :find_desendant do
          root = @j1000
          root.find_descendant(root.id).should be_nil
        end

        it :find_desendant_by_name_path do
          root = @j1000
          root.find_descendant_by_name_path('/j1000').should be_nil
        end
      end

      context "vertex*メソッドではルートはルート自身を見つけることができる" do
        it :vertex do
          root = @j1000
          root.vertex(root.id).should == root
        end

        it :vertex_by_name_path do
          root = @j1000
          root.vertex_by_name_path('/j1000').should == root
        end
      end

      [:find_descendant, :vertex].each do |method_name|
        by_name_path_method_name = :"#{method_name}_by_name_path"

        (all_node_names -%w[j1000]).each do |node_name|
          context "ルートから#{node_name}を見つけることができる" do
            context method_name do
              it "BSON::ObjectId" do
                root = @j1000
                node = instance_variable_get(:"@#{node_name}")
                actual = root.send(method_name, node.id)
                actual.id.should == node.id
                actual.name.should == node.name
              end

              it "String" do
                root = @j1000
                node = instance_variable_get(:"@#{node_name}")
                actual = root.send(method_name, node.id.to_s)
                actual.id.should == node.id
                actual.name.should == node.name
              end
            end

            it by_name_path_method_name do
              root = @j1000
              node = instance_variable_get(:"@#{node_name}")
              actual = root.send(by_name_path_method_name, name_to_name_path[node_name])
              actual.id.should == node.id
              actual.name.should == node.name
            end
          end
        end

        (all_node_names -%w[j1000 j1100 j1110 j1120 j1200]).each do |node_name|
          context "j1200から#{node_name}を見つけることができる" do
            it :find_descendant do
              base = @j1200
              node = instance_variable_get(:"@#{node_name}")
              actual = base.send(method_name, node.id)
              actual.id.should == node.id
              actual.name.should == node.name
            end

            it :find_descendant_by_name_path do
              base = @j1200
              node = instance_variable_get(:"@#{node_name}")
              actual = base.send(by_name_path_method_name, name_to_name_path[node_name])
              actual.id.should == node.id
              actual.name.should == node.name
            end

          end
        end

        %w[j1000 j1100 j1110 j1120].each do |node_name|
          context "j1200から#{node_name}をidで見つけることはできない" do
            it :find_descendant do
              base = @j1200
              node = instance_variable_get(:"@#{node_name}")
              base.send(method_name, node.id).should == nil
            end
          end

          context "j1200から#{node_name}を#{name_to_name_path[node_name].inspect}で見つけることができる" do
            it :find_descendant_by_name_path do
              base = @j1200
              node = instance_variable_get(:"@#{node_name}")
              base.send(by_name_path_method_name, name_to_name_path[node_name]).id.should == node.id
            end
          end
        end
      end

      context "j1200からj1200を見つけることはできない" do
        it :find_descendant do
          @j1200.find_descendant(@j1200.id).should == nil
        end

        it :find_descendant_by_name_path do
          @j1200.find_descendant_by_name_path(@j1200.name_path).should == nil
        end

        it :vertex do
          @j1200.vertex(@j1200.id).should == @j1200
        end

        it :vertex_by_name_path do
          @j1200.vertex_by_name_path(@j1200.name_path).should == @j1200
        end
      end
    end

    describe :find_descendant_edge do
      before do
        @j1000_start = @j1000.edges[0] # to j1100
        @j1100_next  = @j1000.edges[1] # to j1200
        @j1200_next  = @j1000.edges[2] # to j1000's end

        @j1100_start = @j1100.edges[0] # to j1110
        @j1110_next  = @j1100.edges[1] # to j1120
        @j1120_next  = @j1100.edges[2] # to j1100's end

        @j1200_start = @j1200.edges[0] # to j1210
        @j1210_next  = @j1200.edges[1] # to j1220
        @j1220_next  = @j1200.edges[2] # to j1200's end

        @j1210_start = @j1210.edges[0] # to j1211
        @j1211_next  = @j1210.edges[1] # to j1212
        @j1212_next  = @j1210.edges[2] # to j1210's end

        @j1220_start = @j1220.edges[0] # to j1221
        @j1221_next  = @j1220.edges[1] # to j1222
        @j1222_next  = @j1220.edges[2] # to j1220's end
      end

      edge_names = %w[
        j1000_start j1100_next j1200_next
        j1100_start j1110_next j1120_next
        j1200_start j1210_next j1220_next
        j1210_start j1211_next j1212_next
        j1220_start j1221_next j1222_next
      ]

      edge_names.each do |edge_name|
        context "edge_name check" do
          case edge_name
          when /_start$/ then

            it "should be the edge from start to other" do
              owner_name = edge_name.sub(/_start$/, '')
              owner = instance_variable_get(:"@#{owner_name}")
              start = owner.children.first
              edge = instance_variable_get(:"@#{edge_name}")
              edge.origin_id.should == start.id
            end

          when /_next$/ then

            it "should be the edge from vertex to other" do
              origin_name = edge_name.sub(/_next$/, '')
              origin = instance_variable_get(:"@#{origin_name}")
              edge = instance_variable_get(:"@#{edge_name}")
              edge.origin_id.should == origin.id
              owner = origin.parent
              edge.owner.id.should == owner.id
            end

          end
        end
      end

      edge_names.each do |edge_name|
        it "ルートからエッジ#{edge_name}を参照できます" do
          edge = instance_variable_get(:"@#{edge_name}")
          found = @j1000.find_descendant_edge(edge.id)
          found.id.should == edge.id
        end
      end

    end

    describe "vertex_by_name_path" do
      {
        :@j1000 => {
          :@j1000 => ['/j1000', '.'],
          :@j1100 => ['/j1000', '..'],
          :@j1110 => ['/j1000', '../..'],
          :@j1200 => ['/j1000', '..'],
        },
        :@j1100 => {
          :@j1000 => ['/j1000/j1100', 'j1100'],
          :@j1100 => ['/j1000/j1100', '.'],
          :@j1110 => ['/j1000/j1100', '..'],
          :@j1200 => ['/j1000/j1100', '../j1100'],
          :@j1210 => ['/j1000/j1100', '../../j1100'],
        },
        :@j1110 => {
          :@j1000 => ['/j1000/j1100/j1110', 'j1100/j1110'],
          :@j1100 => ['/j1000/j1100/j1110', 'j1110'],
          :@j1110 => ['/j1000/j1100/j1110', '.'],
          :@j1200 => ['/j1000/j1100/j1110', '../j1100/j1110'],
          :@j1210 => ['/j1000/j1100/j1110', '../../j1100/j1110'],
        },
      }.each do |target, hash|
        hash.each do |origin, name_paths|
          name_paths.each do |name_path|
            it "#{target.inspect}を#{origin.inspect}から#{name_path}として参照する" do
              job = instance_variable_get(origin)
              job.vertex_by_name_path(name_path).should == instance_variable_get(target)
            end
          end
        end
      end
    end

    context "vertex_by_name_path for finally" do
      before do
        Tengine::Job::Template::Vertex.delete_all
        builder = Rjn0012NestedAndFinallyBuilder.new
        @root = builder.create_template
        @ctx = builder.context
      end

      it "finallyも検索可能" do
        @root.vertex_by_name_path("/rjn0012/j1000/finally").should == @ctx[:j1f00]
        @root.vertex_by_name_path("/rjn0012/j1000/finally/finally").should == @ctx[:j1ff0]
        @root.vertex_by_name_path("/rjn0012/finally").should == @ctx[:jf000]
        @root.vertex_by_name_path("/rjn0012/j1000/finally/start").should == @ctx[:S5]
        @root.vertex_by_name_path("/rjn0012/j1000/finally/finally/start").should == @ctx[:S7]
        @root.vertex_by_name_path("/rjn0012/finally/start").should == @ctx[:S9]
      end

      [
        "/rjn0012/j1000/finally",
        "/rjn0012/j1000/finally/finally",
        "/rjn0012/finally",
        "/rjn0012/j1000/finally/start",
        "/rjn0012/j1000/finally/finally/start",
        "/rjn0012/finally/start",
      ].each do |name_path|
        it name_path do
          @root.vertex_by_name_path(name_path).name_path.should == name_path
        end
      end

      it "endをchild_by_nameで参照できる" do
        @root.child_by_name('end').tap do |_end1|
          _end1.should_not == nil
          _end1.should == @root.end_vertex
        end
      end
    end


    context "child_by_name" do
      before do
        Tengine::Job::Template::Vertex.delete_all
        builder = Rjn0009TreeSequentialJobnetBuilder.new
        @root = builder.create_template
        @ctx = builder.context
      end

      it "endを検索できる" do
        @root.child_by_name("end").should == @ctx[:E1]
        @root.vertex_by_name_path("end").should == @ctx[:E1]
        @root.vertex_by_name_path("/rjn0009/end").should == @ctx[:E1]
      end
    end
  end


  context "バリデーションエラーでraiseされる例外から原因を判断できるように" do
    before do
      @j1000 = Tengine::Job::Template::Jobnet.new(:name => "j1000").with_start
      @j1000.children << @j1100 = Tengine::Job::Template::Jobnet.new(:name => "j1100").with_start
      @j1100.children << @j1110 = Tengine::Job::Template::Jobnet.new(:name => "j1110", :script => "j1110.sh")
      @j1100.children << @j1120 = Tengine::Job::Template::Jobnet.new(:name => "j1120", :script => "j1120.sh")
      @j1000.prepare_end
      @j1100.prepare_end
      @j1000.build_sequencial_edges
      # @j1100.build_sequencial_edges
      @j1000.edges << @e1 = Tengine::Job::Template::Edge.new(:origin_id => @j1000.start_vertex.id, :destination_id => @j1100.id)
      @j1000.edges << @e2 = Tengine::Job::Template::Edge.new(:origin_id => @j1110.id, :destination_id => @j1000.end_vertex.id)
      @j1100.edges << @e3 = Tengine::Job::Template::Edge.new(:origin_id => @j1100.start_vertex.id, :destination_id => @j1110.id)
      @j1100.edges << @e4 = Tengine::Job::Template::Edge.new(:origin_id => @j1110.id, :destination_id => @j1120.id)
      @j1100.edges << @e5 = Tengine::Job::Template::Edge.new(:origin_id => @j1120.id, :destination_id => @j1100.end_vertex.id)
    end

    it "save!" do
      @e3.origin_id = nil # バリデーションエラーにする
      begin
        @j1000.save!
        fail
      rescue Mongoid::Errors::Validations => e
        msg = "Origin can't be blank"
        # e.message.should =~ %r<edge\([0-9a-f]+\) from no origin to /j1000/j1100/j1110 #{msg}>
        e.document.errors.full_messages.join(".").should =~ %r<edge\([0-9a-f]+\) from no origin to /j1000/j1100/j1110 #{msg}>
      end
    end

    it "update_attributes!" do
      @j1000.save!
      begin
        @e3.origin_id = nil # バリデーションエラーにする
        @j1000.update_attributes!(:description => "test description")
        fail
      rescue Mongoid::Errors::Validations => e
        msg = "Origin can't be blank"
        # e.message.should =~ %r<edge\([0-9a-f]+\) from no origin to /j1000/j1100/j1110 #{msg}>
        e.document.errors.full_messages.join(", ").should =~ %r<edge\([0-9a-f]+\) from no origin to /j1000/j1100/j1110 #{msg}>
      end
    end

    it "create!" do
      begin
        Tengine::Job::Template::RootJobnet.create!(:name => nil)
        fail
      rescue Mongoid::Errors::Validations => e
        msg = "Name can't be blank"
        # e.message.should =~ %r</ #{msg}>
        e.document.errors.full_messages.join(", ").should =~ %r<#{msg}>
      end
    end

  end

  describe :error_messages do
    context "デフォルト" do
      subject{ Tengine::Job::Runtime::Jobnet.new }
      its(:error_messages){ should == nil }
      its(:error_messages_text){ should == "" }
    end

    context "複数音メッセージ" do
      subject{ Tengine::Job::Runtime::Jobnet.new(:error_messages => ["foo", "bar"]) }
      its(:error_messages){ should == ["foo", "bar"] }
      its(:error_messages_text){ should == "foo\nbar" }
    end
  end

end
