# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::EventIgnitionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

   # コントローラの中で外部コマンドとして tengine_fire を実行しおり、
   # RabbitMQが起動していないとエラーメッセージを標準出力にはいていたのでコメントにします。
#  describe "POST 'fire'" do
#    it "should be successful" do
#      Kernel.stub!(:system)
#      post :fire, :event => {event_type_name: "event01"}
#      response.should redirect_to(tengine_core_event_ignitions_new_path)
#    end
#  end

  describe :validation do
    it "should be valid" do
      event = {
        "event_type_name" => "ssss",
        "key" => "fff",
      }
      post 'fire', event: event
      assigns[:core_event].errors.should be_empty
      response.should redirect_to(tengine_core_event_ignitions_new_url)
    end
    it "should not be valid" do
      event = {
        "event_type_name" => "",
        "key" => "",
      }
      post 'fire', event: event
      assigns[:core_event].errors.should_not be_empty
      response.should be_success
    end
  end
end
