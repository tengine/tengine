require 'tengine/core'

ack_policy :at_first_submit, :event_at_first_submit
ack_policy :after_all_handlers_submit, :event_after_all

class FileWritingDriver
  include Tengine::Core::Driveable

  on :event_at_first
  def event_at_first
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_at_first called"
    end
    submit
  end

  on :event_at_first_submit
  def event_at_first_submit1
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_at_first_submit1 called"
    end
    submit
  end

  on :event_at_first_submit
  def event_at_first_submit2
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_at_first_submit2 called"
    end
    submit
  end

  on :event_after_all
  def event_after_all1
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_after_all1 called"
    end
    submit
  end

  on :event_after_all
  def event_after_all2
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_after_all2 called"
    end
    submit
  end

  on :event_sleep_and_after_all
  def event_sleep_and_after_all
    open "/tmp/tmp.txt", "ab" do |fp|
      fp.puts "#{Time.now} FileWritingDriver#event_sleep_and_after_all called"
      fp.puts "#{Time.now} I'll sleep for 60 secs."
      sleep 60
      fp.puts "#{Time.now} I woke up."
    end
  end
end

# 
# Local Variables:
# mode: ruby
# coding: utf-8-unix
# indent-tabs-mode: nil
# tab-width: 4
# ruby-indent-level: 2
# fill-column: 79
# default-justification: full
# End:

