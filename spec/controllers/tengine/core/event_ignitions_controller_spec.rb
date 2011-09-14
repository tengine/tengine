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

end
