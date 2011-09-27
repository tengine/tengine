module Tengine::Job::Stoppable
  extend ActiveSupport::Concern

  included do
    field :killing_signals, :type => Array
    array_text_accessor :killing_signals
    field :killing_signal_interval, :type => Integer
  end
end
