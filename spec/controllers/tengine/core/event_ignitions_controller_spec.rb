require 'spec_helper'

describe Tengine::Core::EventIgnitionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'firegit'" do
    it "should be successful" do
      get 'firegit'
      response.should be_success
    end
  end

  describe "GET 'add'" do
    it "should be successful" do
      get 'add'
      response.should be_success
    end
  end

end
