require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'yaml'
require 'tengine/support/yaml_with_erb'

describe "yaml_with_erb" do

  EXPECTATION = {
    'foo' => 259200
  }.freeze

  describe :load_file do
    describe 'yaml_with_erb_spec/test1.yml.erb' do
      it "should load by using ERB + YAML" do
        actual = YAML.load_file(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == EXPECTATION
      end
    end

    describe 'yaml_with_erb_spec/test2_with_erb.yml' do
      it "should raise Error when loading by YAML" do
        actual = YAML.load_file(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == {"foo"=>"<%= 3 * 24 * 60 * 60 %>"}
      end
    end

    describe 'yaml_with_erb_spec/test3_without_erb.yml' do
      it "should load by using YAML" do
        actual = YAML.load_file(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == EXPECTATION
      end
    end

    describe 'yaml_with_erb_spec/test4_with_invalid_erb.yml' do
      it "should raise Error when loading by YAML" do
        actual = YAML.load_file(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == {"foo"=>"<%= 3 * :foo %>"}
      end
    end
  end

  describe :load_file_with_erb do
    describe 'yaml_with_erb_spec/test1.yml.erb' do
      it "should load by using ERB + YAML" do
        actual = YAML.load_file_with_erb(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == EXPECTATION
      end
    end

    describe 'yaml_with_erb_spec/test2_with_erb.yml' do
      it "should load by using ERB + YAML" do
        actual = YAML.load_file_with_erb(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == EXPECTATION
      end
    end

    describe 'yaml_with_erb_spec/test3_without_erb.yml' do
      it "should load by using ERB + YAML" do
        actual = YAML.load_file_with_erb(File.expand_path(subject, File.dirname(__FILE__)))
        actual.should == EXPECTATION
      end
    end

    describe 'yaml_with_erb_spec/test4_with_invalid_erb.yml' do
      it "should raise Error which has backtrace with filename" do
        filepath = File.expand_path(subject, File.dirname(__FILE__))
        begin
          YAML.load_file_with_erb(filepath)
        rescue TypeError => e
          e.backtrace.any?{|line| line.include?(filepath)}.should == true
        end
      end
    end
  end

end
