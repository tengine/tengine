# -*- coding: utf-8 -*-
require 'tengine/resource/cli'

class Tengine::Resource::CLI:: Server < Thor
  include Tengine::Resource::CLI::GlobalOptions

  desc "list", "list servers"
  def list
    config_mongoid
    require 'text-table'
    res = [%w[provider virtual? name addresses]]
    Tengine::Resource::Server.all.each do |server|
      res << [
        server.provider.name,
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
  def add(name)
    config_mongoid
    Tengine::Resource::Provider.manual.tap do |provider|
      server = provider.physical_servers.create!({
          name: name,
          provided_id: name,
          addresses: options[:addresses],
          properties: options[:properties]
        })
      $stdout.puts "server created successfully!: #{server.to_json}"
    end
  end

  desc "remove", "remove server manually by using [name]"
  def remove(name)
    config_mongoid
    Tengine::Resource::Provider.manual.tap do |provider|
      if server = provider.physical_servers.where({name: name})
        server.destroy
        $stdout.puts "server was destroyed successfully!: #{name}"
      else
        raise "server not found under provider \"#{provider.name}\""
      end
    end
  end

end
