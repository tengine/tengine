require 'eventmachine'

module Enumerable

  # ``You are not expected to understand this. ... The real problem is
  #   that we didn't understand what was going on either.''
  #                                                      Dennis Ritcie
  def each_next_tick
    raise ArgumentError, "no block given" unless block_given?
    nop = lambda do end
    self.reverse_each.inject nop do |block, obj|
      lambda do
        EM.next_tick do
          yield obj
          block.call
        end
      end
    end.call
  end
end

