require 'selectable_attr'

class Tengine::Test::Script
  include Mongoid::Document
  include Mongoid::Timestamps

  include ::SelectableAttr::Base

  field :kind, :type => String, :default => '01'
  field :code, :type => String
  field :options, :type => Hash, :default => {}
  map_yaml_accessor :options
  field :timeout, :type => Integer, :default => 300 # seconds
  field :messages, :type => Hash, :default => {}
  map_yaml_accessor :messages

  selectable_attr :kind do
    entry '01', :eval, 'eval' do
      def execute(script)
        script.messages[:result] = eval(script.code)
      end
    end

    entry '02', :ssh, 'SSH' do
      def validate(script)
        opts = (script.options || {}).symbolize_keys
        script.errors.add(:options, ":host can't be blank") if opts[:host].blank?
        script.errors.add(:options, ":user can't be blank") if opts[:user].blank?
      end

      def execute(script)
        opts = script.options.symbolize_keys
        host = opts.delete(:host)
        user = opts.delete(:user)
        Net::SSH.start(host, user, opts) do |ssh|
          ssh.open_channel do |ch|
            ch.exec(script.code) do |ch, success|
              script.messages[:success] = success
              return unless success
              ch.on_data{|ch, data| script.messages[:stdout] ||= []; script.messages[:stdout].concat data.lines.map{|i| i.chomp }.to_a }
              ch.on_extended_data{|ch, data| script.messages[:stderr] ||= []; script.messages[:stderr] << data }
            end
          end
        end
        script.messages[:stdout] and script.messages[:stdout].each {|i| i.chomp!}
        script.messages[:stderr] and script.messages[:stderr].each {|i| i.chomp!}
      end
    end

    entry '03', :spawn, 'spawn' do
      def execute(script)
        script.messages[:pid] = spawn(script.code, (script.options || {}).symbolize_keys)
      end
    end

    entry '04', :system, 'system' do
      def execute(script)
        result = system(script.code, (script.options || {}).symbolize_keys)
        script.messages[:result] = result
        script.messages[:exitstatus] = $?.exitstatus.inspect
        script.messages[:status] = $?.inspect
      end
    end

    entry '05', :backquote, 'backquote' do
      def execute(script)
        script.messages[:result] = `#{script.code}`
        script.messages[:exitstatus] = $?.exitstatus.inspect
        script.messages[:status] = $?.inspect
      end
    end

  end

  validates :code, :presence => true
  validates :kind, :format => Regexp.new(kind_ids.map{|k| "^#{k}$"}.join('|'))

  validate do |script|
    script.kind_entry.tap do |entry|
      entry.validate(script) if entry.respond_to?(:validate)
    end
  end

  before_validation do |script|
    script.code.gsub! "\r\n", "\n"
  end

  before_create :execute

  def execute
    Timeout.timeout(self.timeout) do
      kind_entry.execute(self)
    end
  rescue => e
    self.messages[:error] = "[#{e.class}] #{e.message}"
  end

  before_create :auto_increment

  class Counter
    include Mongoid::Document
    field :key, type: String
    field :sequence, type: Integer
  end

  def auto_increment
    self._id = Counter.collection.find_and_modify(
      query: { "key" => self.class.name },
      update: { "$inc" => { "sequence" => 1 } },
      new: true, upsert: true
    )["sequence"]
  end
end
