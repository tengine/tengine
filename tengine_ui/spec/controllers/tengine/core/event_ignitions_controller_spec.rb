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
    context "valid" do
      it "種別名とイベントキーが指定されている場合" do
        event = {
          "event_type_name" => "event_ignitions_controller_test",
          "key" => "test_key-#{Time.now.iso8601}",
        }
        post 'fire', event: event
        assigns[:core_event].errors.should be_empty
        response.should redirect_to(tengine_core_event_ignitions_new_url)
      end

      it "種別名が指定されているが、イベントキーは指定されていない場合" do
        event = {
          "event_type_name" => "event_ignitions_controller_test",
          "key" => "",
        }
        post 'fire', event: event
        assigns[:core_event].errors.should be_empty
        response.should redirect_to(tengine_core_event_ignitions_new_url)
      end
    end

    context "invalid" do
      it "種別名とイベントキーのどちらも指定されていない場合" do
        event = {
          "event_type_name" => "",
          "key" => "",
        }
        post 'fire', event: event
        assigns[:core_event].errors.should_not be_empty
        response.should be_success
      end


      it "イベントキーは指定されているが、種別名が指定されていない場合" do
        event = {
          "event_type_name" => "",
          "key" => "test_key-#{Time.now.iso8601}",
        }
        post 'fire', event: event
        assigns[:core_event].errors.should_not be_empty
        response.should be_success
      end
    end

  end
end
