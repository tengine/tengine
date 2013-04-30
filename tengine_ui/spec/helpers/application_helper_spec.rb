# -*- coding: utf-8 -*-
require 'spec_helper'
require 'ostruct'

describe ApplicationHelper do
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
      helper.sort_class(:test).should == "SortAsc"
    end

    it "testの降順のソートのクエリーパラメータがあるときdesc返ってくること" do
      @request.query_parameters[:sort] = {"test" => "desc"}
      helper.sort_class(:test).should == "SortDesc"
    end

    it "testのクエリーパラメータがascでもdescでもないとき空文字列が返ってくること" do
      @request.query_parameters[:sort] = {"test" => "foo"}
      helper.sort_class(:test).should == ""
    end
  end

  describe "category_tree" do
    context "ルートカテゴリが0のとき" do
      before do
        Tengine::Job::Structure::Category.delete_all
      end

      it "ツリーが生成されないこと" do
        params = {
          :controller => "tengine/job/template/root_jobnets",
          :action => "index",
        }

        helper.category_tree([], "treeview", params).should == ""
      end
    end

    context "ルートカテゴリが1つのとき" do
      before do
        Tengine::Job::Structure::Category.delete_all
        @foo = Tengine::Job::Structure::Category.create!(
          :dsl_verion => 0,
          :name => "foo",
          :caption => "ふー",
        )
        @baz = Tengine::Job::Structure::Category.create!(
          :dsl_verion => 0,
          :name => "baz",
          :caption => "ばず"
        )
        @fizz = Tengine::Job::Structure::Category.create!(
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
          :controller => "tengine/job/template/root_jobnets",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview" class="filetree">
          <li>
            <span class="folder">#{link_to(@all_str, params)}</span>
            <ul>
              <li>
                <span class="folder">#{link_to(@foo.caption, params.merge(:category=>@foo.id))}</span>
                <ul>
                  <li>
                    <span class="folder">#{link_to(@baz.caption, params.merge(:category=>@baz.id))}</span>
                  </li>
                  <li>
                    <span class="folder">#{link_to(@fizz.caption, params.merge(:category=>@fizz.id))}</span>
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
          :controller => "tengine/job/template/root_jobnets",
          :action => "index",
        }
        link_opts = {:class => "foo"}

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview" class="filetree">
          <li>
            <span class="folder">#{link_to(@all_str, params, link_opts)}</span>
            <ul>
              <li>
                <span class="folder">#{link_to(@foo.caption, params.merge(:category=>@foo.id), link_opts)}</span>
                <ul>
                  <li>
                    <span class="folder">#{link_to(@baz.caption, params.merge(:category=>@baz.id), link_opts)}</span>
                  </li>
                  <li>
                    <span class="folder">#{link_to(@fizz.caption, params.merge(:category=>@fizz.id), link_opts)}</span>
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
          :controller => "tengine/job/template/root_jobnets",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview" class="filetree">
          <li>
            <span class="folder">#{ERB::Util.html_escape(link_to(@all_str, params))}</span>
            <ul>
              <li>
                <span class="folder">#{ERB::Util.html_escape(link_to(@foo.caption, params.merge(:category=>@foo.id)))}</span>
                <ul>
                  <li>
                    <span class="folder">#{ERB::Util.html_escape(link_to(@baz.caption, params.merge(:category=>@baz.id)))}</span>
                  </li>
                  <li>
                    <span class="folder">#{ERB::Util.html_escape(link_to(@fizz.caption, params.merge(:category=>@fizz.id)))}</span>
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
        Tengine::Job::Structure::Category.delete_all
        @foo = Tengine::Job::Structure::Category.create!(
          :dsl_verion => 0,
          :name => "foo",
          :caption => "ふー",
        )
        @baz = Tengine::Job::Structure::Category.create!(
          :dsl_verion => 0,
          :name => "baz",
          :caption => "ばず"
        )
        @bar = Tengine::Job::Structure::Category.create!(
          :dsl_verion => 0,
          :name => "bar",
          :caption => "ばー"
        )
        @fizz = Tengine::Job::Structure::Category.create!(
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
          :controller => "tengine/job/template/root_jobnets",
          :action => "index",
        }

        tree_html =<<-_tree_.strip.gsub(/\n?^\s+/, '')
        <ul id="treeview" class="filetree">
          <li>
            <span class="folder">#{link_to(@all_str, params)}</span>
            <ul>
              <li>
                <span class="folder">#{link_to(@foo.caption, params.merge(:category=>@foo.id))}</span>
                <ul>
                  <li>
                    <span class="folder">#{link_to(@baz.caption, params.merge(:category=>@baz.id))}</span>
                  </li>
                  <li>
                    <span class="folder">#{link_to(@fizz.caption, params.merge(:category=>@fizz.id))}</span>
                  </li>
                </ul>
              </li>
              <li>
                <span class="folder">#{link_to(@bar.caption, params.merge(:category=>@bar.id))}</span>
              </li>
            </ul>
          </li>
        </ul>
        _tree_
        helper.category_tree([@foo, @bar], "treeview", params).should == tree_html
      end
    end
  end

  describe "message" do
    it "typeに応じてclassが変わること" do
      helper.message(:warning, "test").should =~ /class="Msg MsgWarning"/
      helper.message(:complete, "test").should =~ /class="Msg MsgComplete"/
      helper.message(:delete, "test").should =~ /class="Msg MsgCompleteDelete"/
      helper.message(nil, "test").should =~ /class="Msg"/
    end

    it "textがpタグとdivタグに囲われていること" do
      expected = %|<div class="Msg MsgComplete"><p>test</p></div>|
      helper.message(:complete, "test").strip.gsub(/\n?^\s+/, '').should == expected
    end

    it "ブロックで渡した内容が含まれていること" do
      helper.message(:complete, "test") { "foo" }.should =~ /foo/
    end

    it "textが空のとき空文字列を返すこと" do
      helper.message(:complete, nil).should == ""
    end
  end

  describe "button_link_to" do
    it "ボタン表示用のspanが作成されること" do
      url = tengine_job_template_root_jobnets_url

      result = helper.button_link_to("test", url)
      result.should == helper.link_to("<span class='BtnNormal'>test</span>".html_safe,
                         url, :class => "BtnWrap")

      result = helper.button_link_to("test", url, :class => "test",
                                     :btn_class => "BtnAdd")
      result.should == helper.link_to("<span class='BtnAdd'>test</span>".html_safe,
                                      url, :class => "test BtnWrap")

      result = helper.button_link_to(url) { "test" }
      result.should == helper.link_to("<span class='BtnNormal'>test</span>".html_safe,
                                      url, :class => "BtnWrap")

      result = helper.button_link_to(url, :class => "test", :btn_class => "BtnAdd") do
        "test"
      end
      result.should == helper.link_to("<span class='BtnAdd'>test</span>".html_safe,
                                      url, :class => "test BtnWrap")
    end
  end

  describe "yaml_view" do
    it "YamlViewが作成されること" do
      result = helper.yaml_view("test summary", "test detail")
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|test summary</span><div class="YamlScript">test detail</div></div>|

      result = helper.yaml_view("test summary") { "test detail" }
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|test summary</span><div class="YamlScript">test detail</div></div>|
    end
  end

  describe "description_format" do
    it "YamlScriptのコンテンツに指定した文字数で<br />が挿入されたYamlViewが作成されること" do
      str = "abcdefghijklmnopqrstuvwxyz"
      summary = str.truncate(10)
      result = helper.description_format(str, 10)
      detail = "abcdefghij\nklmnopqrst\nuvwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|

      str = "abcdefghijklmnopqrstuvwxyz\n"
      summary = str.truncate(10)
      result = helper.description_format(str, 10)
      detail = "abcdefghij\nklmnopqrst\nuvwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|

      str = "abcdefghijkl\nmnopqrstuvwxyz\n"
      summary = str.truncate(10)
      result = helper.description_format(str, 10)
      detail = "abcdefghij\nkl\nmnopqrstuv\nwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|

      str = "abcdefghijklmnopqrstuvwxyz"
      summary = str.truncate(30)
      result = helper.description_format(str, 30)
      detail = "abcdefghijklmnopqrstuvwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|

      str = "abcdefghijklmnopqrstuvwxyz\n"
      summary = str.truncate(30)
      result = helper.description_format(str, 30)
      detail = "abcdefghijklmnopqrstuvwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|

      str = "abcdefghijklmnopqrstuvwxyz"
      summary = str.truncate(26)
      result = helper.description_format(str, 26)
      detail = "abcdefghijklmnopqrstuvwxyz"
      detail = helper.simple_format detail
      result.should == %|<div class="YamlView"><span class="IconYaml">| +
        %|#{summary}</span><div class="YamlScript">#{detail}</div></div>|
    end
  end

  describe "format_map_yml_value" do
    it "objectのmethodの値が空のとき空文字列を返すこと" do
      obj = OpenStruct.new(value:nil)
      result = helper.format_map_yml_value(obj, :value)
      result.should == ""

      obj = OpenStruct.new(value:{})
      result = helper.format_map_yml_value(obj, :value)
      result.should == ""
    end
    it "値がpreタグに囲まれて表示されること" do
      obj = OpenStruct.new(value:{test:10})
      obj.value_yaml = YAML.dump(obj.value)
      result = helper.format_map_yml_value(obj, :value)
      result.should == "<pre>:test: 10\n</pre>"
    end

    it "objectのmethodの値にHTMLタグが含まれるときエスケープされて表示されること" do
      obj = OpenStruct.new(value:{test:"<script>alert('test')</script>"})
      obj.value_yaml = YAML.dump(obj.value)
      result = helper.format_map_yml_value(obj, :value)
      expected = ERB::Util.html_escape(":test: <script>alert('test')</script>\n")
      result.should == "<pre>#{expected}</pre>"
    end
  end
end
