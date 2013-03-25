require 'tengine/mq/suite'
require 'tengine/support/core_ext/enumerable/deep_freeze'

class Tengine::Mq::Suite
  DEFAULT_CONFIG = {
      :sender                 => {
        :keep_connection      => false,
        :retry_interval       => 1,  # in seconds
        :retry_count          => 30,
      },
      :connection             => {
        :user                 => 'guest',
        :pass                 => 'guest',
        :vhost                => '/',
        :logging              => false,
        :insist               => false,
        :host                 => 'localhost',
        :port                 => 5672,
        :auto_reconnect_delay => 1, # in seconds
      },
      :channel                => {
        :prefetch             => 1,
        :auto_recovery        => true,
      },
      :exchange               => {
        :name                 => 'tengine_event_exchange',
        :type                 => :direct,
        :passive              => false,
        :durable              => true,
        :auto_delete          => false,
        :internal             => false,
        :nowait               => false,
        :publish              => {
          :content_type       => "application/json", # RFC4627
          :persistent         => true,
        },
      },
      :queue                  => {
        :name                 => 'tengine_event_queue',
        :passive              => false,
        :durable              => true,
        :auto_delete          => false,
        :exclusive            => false,
        :nowait               => false,
        :subscribe            => {
          :ack                => true,
          :nowait             => false,
          :confirm            => nil,
        },
      },
    }.deep_freeze
end
