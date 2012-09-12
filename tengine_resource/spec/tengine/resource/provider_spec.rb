# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::Provider do

  describe :find_virtual_server_on_duplicaion_error do
    subject do
      Tengine::Resource::Provider.delete_all
      Tengine::Resource::VirtualServer.delete_all
      provider = Tengine::Resource::Provider.create!(:name => "provider1")
      @virtual_server_provided_id = "virtual_server1"
      @virtual_server = provider.virtual_servers.create!(:name => @virtual_server_provided_id, :provided_id => @virtual_server_provided_id)
      provider
    end

    it "例外がで起きなければブロックの戻り値をそのまま返します" do
      result = subject.find_virtual_server_on_duplicaion_error(:foo) do
        :bar
      end
      result.should == :bar
    end

    it "普通の例外はそのままraiseされます" do
      expect{
        subject.find_virtual_server_on_duplicaion_error(:foo){ raise "bar" }
      }.to raise_error(RuntimeError, "bar")
    end

    it "重複でないMongo::OperationFailureはそのままraiseされます" do
      expect{
        subject.find_virtual_server_on_duplicaion_error(:foo){ raise Moped::Errors::OperationFailure.new('', 'err' => "bar") }
      }.to raise_error(Moped::Errors::OperationFailure, /bar/)
    end

    it "重複でないMongoid::Errors::Validationsはそのままraiseされます" do
      dup = subject.virtual_servers.new(:name => "", :provided_id => "")
      dup.valid?
      begin
        subject.find_virtual_server_on_duplicaion_error(:foo){ raise Mongoid::Errors::Validations, dup }
      rescue Mongoid::Errors::Validations => e
        e.document.should == dup
      end
    end

    context "重複エラー" do

      context "データが見つかる場合" do
        it "重複のMongo::OperationFailureの場合、引数からvirtual_serversを検索します" do
          result = subject.find_virtual_server_on_duplicaion_error(@virtual_server_provided_id){ raise Moped::Errors::OperationFailure.new('', 'err' => "E11000 duplicate key error") }
          result.id.should == @virtual_server.id
        end

        it "重複のMongoid::Errors::Validationsの場合、引数からvirtual_serversを検索します" do
          dup = subject.virtual_servers.new(:name => @virtual_server_provided_id,
            :provided_id => @virtual_server_provided_id)
          result = subject.find_virtual_server_on_duplicaion_error(@virtual_server_provided_id){ dup.save! }
          result.id.should == @virtual_server.id
        end
      end

      context "データが見つからない場合" do
        it "重複のMongo::OperationFailureの場合、引数からvirtual_serversを検索します" do
          expect{
            subject.find_virtual_server_on_duplicaion_error("invalid_id"){ raise Moped::Errors::OperationFailure.new('', 'err' => "E11000 duplicate key error") }
          }.to raise_error
        end

        it "重複のMongoid::Errors::Validationsの場合、引数からvirtual_serversを検索します" do
          dup = subject.virtual_servers.new(:name => @virtual_server_provided_id,
            :provided_id => @virtual_server_provided_id)
          expect{
            subject.find_virtual_server_on_duplicaion_error("invalid_id"){ dup.save! }
          }.to raise_error
        end
      end

    end


  end
end
