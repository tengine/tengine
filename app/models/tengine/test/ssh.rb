class Tengine::Test::Ssh
  include Mongoid::Document
  include Mongoid::Timestamps
  field :host, :type => String, :default => "localhost"
  field :exec_type, :type => String, :default => "ssh"
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
      case exec_type
      when 'ssh' then execute_by_ssh
      when 'spawn' then execute_by_spawn
      when 'system' then execute_by_system
      when 'backquote' then execute_by_backquote
      end
    end
  rescue => e
    self.error_message = "[#{e.class}] #{e.message}"
  end

  def execute_by_ssh
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

  def execute_by_spawn
    pid = spawn(command, options || {})
    self.error_message = "PID: #{pid}"
  end

  def execute_by_system
    result = system(command, options || {})
    self.error_message = "system(...) returns #{result.inspect}\nstatus:#{$?.inspect}"
  end

  def execute_by_backquote
    self.stdout = `#{command}`
    self.error_message = "status:#{$?.inspect}"
  end

end
