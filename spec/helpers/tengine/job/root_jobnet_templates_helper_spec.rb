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
    it "ソートのクエリーパラメータがないときtestの昇順のクエリーパラメータが返ってくること" do
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end

    it "testのソートのクエリーパラメータがないときtestの昇順のクエリーパラメータが返ってくること" do
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end

    it "testの昇順のソートのクエリーパラメータがあるときtestの降順のクエリーパラメータが返ってくること" do
      @request.query_parameters[:sort] = {"test" => "asc"}
      helper.sort_param(:test).should == {"sort" => {"test" => "desc"}}
    end

    it "testの降順のソートのクエリーパラメータがあるときtestの昇順のクエリーパラメータが返ってくること" do
      @request.query_parameters[:sort] = {"test" => "desc"}
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end

    it "testのクエリーパラメータがascでもdescでもないときtestの昇順のクエリーパラメータが返ってくること" do
      @request.query_parameters[:sort] = {"test" => "foo"}
      helper.sort_param(:test).should == {"sort" => {"test" => "asc"}}
    end
  end

  describe "sort_class" do
    it "ソートのクエリーパラメータがないとき空文字列が返ってくること" do
      helper.sort_class(:test).should == ""
    end

    it "testのソートのクエリーパラメータがないとき空文字列が返ってくること" do
      helper.sort_class(:test).should == ""
    end

    it "testの昇順のソートのクエリーパラメータがあるときascが返ってくること" do
      @request.query_parameters[:sort] = {"test" => "asc"}
      helper.sort_class(:test).should == "asc"
    end

    it "testの降順のソートのクエリーパラメータがあるときdesc返ってくること" do
      @request.query_parameters[:sort] = {"test" => "desc"}
      helper.sort_class(:test).should == "desc"
    end

    it "testのクエリーパラメータがascでもdescでもないとき空文字列が返ってくること" do
      @request.query_parameters[:sort] = {"test" => "foo"}
      helper.sort_class(:test).should == ""
    end
  end

  describe "category_tree" do
    context "ルートカテゴリが0のとき" do
      before do
        Tengine::Job::Category.delete_all
      end

      it "ツリーが生成されないこと" do
        params = {
          :controller => "tengine/job/root_jobnet_templates",
          :action => "index",
        }

        helper.category_tree([], "treeview", params).should == ""
      end
    end

    context "ルートカテゴリが1つのとき" do
      before do
        Tengine::Job::Category.delete_all
        @foo = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "foo",
          :caption => "ふー",
        )
        @baz = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "baz",
          :caption => "ばず"
        )
        @fizz = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "fizz",
          :caption => "ふぃず"
        )
        @foo.parent_id = nil
        @baz.parent_id = @foo.id
        @fizz.parent_id = @foo.id
        @foo.save!
        @baz.save!
        @fizz.save!

        @all_str = I18n.t("all", :scope => [:views, :category_tree])
      end
  
      it "ツリーが作成されること" do
        params = {
          :controller => "tengine/job/root_jobnet_templates",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview">
          <li>
            #{link_to(@all_str, params)}
            <ul>
              <li>
                #{link_to(@foo.caption, params.merge(:category=>@foo.id))}
                <ul>
                  <li>
                    #{link_to(@baz.caption, params.merge(:category=>@baz.id))}
                  </li>
                  <li>
                    #{link_to(@fizz.caption, params.merge(:category=>@fizz.id))}
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
        _tree_
        helper.category_tree(@foo, "treeview", params).should == tree_html
      end
  
      it "指定したリンクのオプションがリンクに設定されていること" do
        params = {
          :controller => "tengine/job/root_jobnet_templates",
          :action => "index",
        }
        link_opts = {:class => "foo"}

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview">
          <li>
            #{link_to(@all_str, params, link_opts)}
            <ul>
              <li>
                #{link_to(@foo.caption, params.merge(:category=>@foo.id), link_opts)}
                <ul>
                  <li>
                    #{link_to(@baz.caption, params.merge(:category=>@baz.id), link_opts)}
                  </li>
                  <li>
                    #{link_to(@fizz.caption, params.merge(:category=>@fizz.id), link_opts)}
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
        _tree_
        result = helper.category_tree(@foo, "treeview", params, link_opts)
        result.should == tree_html
      end

      it "カテゴリのcaptionにHTMLタグが含まれている場合captionに含まれるHTMLタグが文字列として表示されること" do
        @foo.caption = "<span>test</span>"
        @foo.save!
        params = {
          :controller => "tengine/job/root_jobnet_templates",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview">
          <li>
            #{ERB::Util.html_escape(link_to(@all_str, params))}
            <ul>
              <li>
                #{ERB::Util.html_escape(link_to(@foo.caption, params.merge(:category=>@foo.id)))}
                <ul>
                  <li>
                    #{ERB::Util.html_escape(link_to(@baz.caption, params.merge(:category=>@baz.id)))}
                  </li>
                  <li>
                    #{ERB::Util.html_escape(link_to(@fizz.caption, params.merge(:category=>@fizz.id)))}
                  </li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>
        _tree_
        helper.category_tree(@foo, "treeview", params).should == tree_html
      end
    end

    context "ルートカテゴリが2つのとき" do
      before do
        Tengine::Job::Category.delete_all
        @foo = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "foo",
          :caption => "ふー",
        )
        @baz = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "baz",
          :caption => "ばず"
        )
        @bar = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "bar",
          :caption => "ばー"
        )
        @fizz = Tengine::Job::Category.create!(
          :dsl_verion => 0,
          :name => "fizz",
          :caption => "ふぃず"
        )
        @foo.parent_id = nil
        @baz.parent_id = @foo.id
        @bar.parent_id = nil
        @fizz.parent_id = @foo.id
        @foo.save!
        @baz.save!
        @bar.save!
        @fizz.save!

        @all_str = I18n.t("all", :scope => [:views, :category_tree])
      end
  
      it "ツリーが作成されること" do
        params = {
          :controller => "tengine/job/root_jobnet_templates",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview">
          <li>
            #{link_to(@all_str, params)}
            <ul>
              <li>
                #{link_to(@foo.caption, params.merge(:category=>@foo.id))}
                <ul>
                  <li>
                    #{link_to(@baz.caption, params.merge(:category=>@baz.id))}
                  </li>
                  <li>
                    #{link_to(@fizz.caption, params.merge(:category=>@fizz.id))}
                  </li>
                </ul>
              </li>
              <li>
                #{link_to(@bar.caption, params.merge(:category=>@bar.id))}
              </li>
            </ul>
          </li>
        </ul>
        _tree_
        helper.category_tree([@foo, @bar], "treeview", params).should == tree_html
      end
    end
  end
end
