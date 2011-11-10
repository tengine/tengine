# -*- coding: utf-8 -*-

module ChangeTime
  def change_now(y, m, d, h, min, &block)
    Time.class_eval(<<-__end_of_statement__)
      class << self
        def now_dest
          return Time.new(#{y}, #{m}, #{d}, #{h}, #{min})
        end
        alias now_src now
        alias now now_dest
      end
    __end_of_statement__
    yield
    Time.class_eval do
      class << self
        alias now now_src
      end
    end
  end
end
