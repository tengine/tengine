# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::Config do

  context "ログの設定なし" do
    {
      true => "デーモン起動の場合",
      false => "非デーモン起動の場合",
    }.each do |daemon_process, context_name|
      context(context_name) do
        before{ @config = Tengine::Core::Config.new(:tengined => {:daemon => daemon_process})}

        context :application_log do
          subject{ @config.log_config(:application_log)}
          it do
            subject.should == {
              :output        => daemon_process ? "./log/application.log" : "STDOUT",
              :rotation      => 3,
              :rotation_size => 1024 * 1024,
              :level         => "info",
            }
          end
        end

        context :process_stdout_log do
          subject{ @config.log_config(:process_stdout_log)}
          it do
            if daemon_process
              subject[:output].should =~ %r{^\./log/.*_stdout\.log}
            else
              subject[:output].should == "STDOUT"
            end
            subject[:rotation] .should == 3
            subject[:rotation_size].should == 1024 * 1024
            subject[:level].should == "info"
          end
        end

        context :process_stderr_log do
          subject{ @config.log_config(:process_stderr_log)}
          it do
            if daemon_process
              subject[:output].should =~ %r{^\./log/.*_stderr\.log}
            else
              subject[:output].should == "STDERR"
            end
            subject[:rotation] .should == 3
            subject[:rotation_size].should == 1024 * 1024
            subject[:level].should == "info"
          end
        end

        context :invalid_log_type_name do
          it "should raise ArgumentError"do
            expect{
              @config.log_config(:invalid_log_type_name)
            }.to raise_error(ArgumentError, "Unsupported log_type_name: :invalid_log_type_name")
          end
        end


      end
    end
  end

  context "共通設定なし各ログの設定あり" do
    {
      true => "デーモン起動の場合",
      false => "非デーモン起動の場合",
    }.each do |daemon_process, context_name|
      context(context_name) do
        before do
          @config = Tengine::Core::Config.new({
              :tengined => {:daemon => daemon_process},
              :application_log => {
                :output        => "/var/log/tengined/application.log",
                :rotation      => "daily",
                :level         => "error",
              },
              :process_stdout_log => {
                :output        => "/var/log/tengined/process_stdout.log",
                :rotation      => "weekly",
                :level         => "info",
              },
              :process_stderr_log => {
                :output        => "/var/log/tengined/process_stderr.log",
                :rotation      => "monthly",
                :level         => "info",
              },
            })
        end

        context :application_log do
          subject{ @config.log_config(:application_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/application.log",
              :rotation      => "daily",
              :level         => "error",
            }
          end
        end

        context :process_stdout_log do
          subject{ @config.log_config(:process_stdout_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/process_stdout.log",
              :rotation      => "weekly",
              :level         => "info",
            }
          end
        end

        context :process_stderr_log do
          subject{ @config.log_config(:process_stderr_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/process_stderr.log",
              :rotation      => "monthly",
              :level         => "info",
            }
          end
        end

      end
    end
  end

  context "共通設定あり各ログの設定あり" do
    {
      true => "デーモン起動の場合",
      false => "非デーモン起動の場合",
    }.each do |daemon_process, context_name|
      context(context_name) do
        before do
          @config = Tengine::Core::Config.new({
              :tengined => {:daemon => daemon_process},
              :log_common => {
                :rotation      => "daily",
                :level         => "info",
              },
              :application_log => {
                :output        => "/var/log/tengined/application.log",
              },
              :process_stdout_log => {
                :output        => "/var/log/tengined/process_stdout.log",
              },
              :process_stderr_log => {
                :output        => "/var/log/tengined/process_stderr.log",
                :rotation      => "monthly",
              },
            })
        end

        context :application_log do
          subject{ @config.log_config(:application_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/application.log",
              :rotation      => "daily",
              :level         => "info",
            }
          end
        end

        context :process_stdout_log do
          subject{ @config.log_config(:process_stdout_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/process_stdout.log",
              :rotation      => "daily",
              :level         => "info",
            }
          end
        end

        context :process_stderr_log do
          subject{ @config.log_config(:process_stderr_log)}
          it do
            subject.should == {
              :output        => "/var/log/tengined/process_stderr.log",
              :rotation      => "monthly",
              :level         => "info",
            }
          end
        end

      end
    end
  end


end
