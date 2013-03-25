# -*- coding: utf-8 -*-
require 'tengine/support'

class Tengine::Support::NamedLogger < Logger
  attr_reader :name
  def initialize(name, *args, &block)
    super(*args, &block)
    @name = name
    @mutex = Mutex.new
    @thread_nums ||= {}
    thread_num(Thread.main.object_id) # => 0 のはず
    self.formatter = method(:format_with_color)
  end

  def thread_num(tid = Thread.current.object_id)
    result = @thread_nums[tid]
    return result if result
    @mutex.synchronize do
      num = @thread_nums[tid] = (@thread_nums.length)
      return num
    end
  end

  LOG_FORMAT = "\e[%dm[%s #%5d %s %3d] %5s %s\n\e[0m".freeze

  WHITE = 37

  def format_with_color(severity, datetime, progname, message)
    tn = thread_num
    # http://d.hatena.ne.jp/keyesberry/20101107/p1
    color_no = (tn == 0) ? WHITE : WHITE - 1 - ((tn - 1) % 6) # メインスレッドを白、それ以外を色付きに
    LOG_FORMAT % [color_no, datetime.iso8601(6), Process.pid, @name, tn, severity, message]
  end
end
