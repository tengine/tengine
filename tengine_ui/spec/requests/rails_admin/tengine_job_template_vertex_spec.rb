# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Tengine::Job::Template::RootJobnets" do

  before(:all) do
    I18n.locale, @original_locale = :ja, I18n.locale
    User.delete_all
    @email = 'tengine@groovenauts.jp'
    @password = "password"
    @admin = User.create!(:email => @email, :password => @password, :password_confirmation => @password)
  end
  after(:all){ I18n.locale = @original_locale }

  describe "GET /admin/tengine~job~template~vertex" do

    before do
      Tengine::Job::Template::Vertex.delete_all
      Tengine::Job::Template::Vertex.count.should == 0
      tengine_job_spec = Gem.loaded_specs["tengine_job"]
      dsl_path = File.join(tengine_job_spec.gem_dir, "examples/0005_retry_two_layer.rb")
      config = {
        action: "load",
        tengined: { load_path: File.join(tengine_job_spec.gem_dir, "examples/0004_retry_one_layer.rb") },
      }
      @bootstrap = Tengine::Core::Bootstrap.new(config)
      @bootstrap.boot
    end

    it "[バグ] 表示するとエラーが発生する。undefined method `eager_load' for Mongoid::Relations::Embedded::In:Class" do
      # ログイン
      visit "/users/sign_in"
      fill_in "Email",    :with => @email
      fill_in "Password", :with => @password
      click_button "Sign in"
      page.should have_content(I18n.t("devise.sessions.signed_in"))

      # Tengine::Job::Template::Vertexの parent/childrenのinverse_ofの設定によって以下のエラーが発生しています
      #   undefined method `eager_load' for Mongoid::Relations::Embedded::In:Class
      visit "/admin/tengine~job~template~vertex"
      page.should have_content(Tengine::Job::Template::Vertex.first.id.to_s)
    end
  end
end
