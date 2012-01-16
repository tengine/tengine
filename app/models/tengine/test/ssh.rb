class Tengine::Test::Ssh
  include Mongoid::Document
  include Mongoid::Timestamps
  field :host, :type => String, :default => "localhost"
  field :local, :type => Boolean
  field :user, :type => String, :default => "goku"
  field :options, :type => Hash, :default => {:password => "dragonball"}
  map_yaml_accessor :options
  field :timeout, :type => Integer, :default => 300 # seconds
  field :command, :type => String
  field :stdout, :type => String, :default => ""
  field :stderr, :type => String, :default => ""
  field :error_message, :type => String

  validates :command, :presence => true

  before_create :execute_command

  def execute_command
    Timeout.timeout(self.timeout) do
      Net::SSH.start(host, user, options) do |ssh|
        ssh.open_channel do |ch|
          ch.exec(command) do |ch, success|
            unless success
              self.error_message = "could not execute '#{command.inspect}'"
              return
            end
            ch.on_data{|ch, data| self.stdout << data << "\n" }
            ch.on_extended_data{|ch, data| self.stderr << data << "\n" }
          end
        end
      end
    end
  rescue => e
    self.error_message = "[#{e.class}] #{e.message}"
  end
end
