# -*- coding: utf-8 -*-
require 'tengine/resource/cli'
require 'active_support/core_ext/hash/keys'

class Tengine::Resource::CLI::Server < Thor
  include Tengine::Resource::CLI::GlobalOptions
  include Tengine::Resource::CLI::Options

  desc "list", "list servers"
  method_option :sort, type: :string, aliases: '-s', desc: "sort pattern. name, created_at and updated_at", default: "name"
  def list(*args)
    opts = merge_options(args, options)
    config_mongoid
    require 'text-table'
    res = [%w[provider virtual? name addresses]]
    sort_options = {(opts[:sort] || "name").to_sym => 1}
    sort_options[:name] = 1 # 同じ時刻などのソートキーが決まらない場合を想定して名前もソートキーに入れる
    Tengine::Resource::Server.all.order_by(sort_options).each do |server|
      res << [
        server.provider ? server.provider.name : "-",
        server.is_a?(Tengine::Resource::VirtualServer) ? "virtual" : "physical",
        server.name,
        server.addresses.to_json
      ]
    end
    $stdout.puts res.to_table(:first_row_is_head => true)
    res
  end

  desc "add [name]", "add server"
  method_option :addresses , type: :hash, aliases: '-a', desc: "ip addesses and hostnames like 'private_ip_address:192.168.1.10,private_dns_name:i-12345'"
  method_option :properties, type: :hash, aliases: '-p', desc: "any properties"
  # def add(name, options = {})
  def add(name, *args)
    opts = merge_options(args, options)
    config_mongoid
    Tengine::Resource::Provider.manual.tap do |provider|
      server = provider.physical_servers.create!({
          name: name,
          provided_id: name,
          addresses: opts[:addresses],
          properties: opts[:properties]
        })
      $stdout.puts "server created successfully!: #{server.to_json}"
    end
  end

  desc "remove", "remove server manually by using [name]"
  def remove(name)
    config_mongoid
    Tengine::Resource::Provider.manual.tap do |provider|
      if server = provider.physical_servers.where({name: name}).first
        server.destroy
        $stdout.puts "server was destroyed successfully!: #{name}"
      else
        raise "server \"#{name}\" not found under provider \"#{provider.name}\""
      end
    end
  end

end
