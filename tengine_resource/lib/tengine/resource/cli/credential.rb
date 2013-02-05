# -*- coding: utf-8 -*-
require 'tengine/resource/cli'

class Tengine::Resource::CLI::Credential < Thor
  include Tengine::Resource::CLI::GlobalOptions
  include Tengine::Resource::CLI::Options

  desc "list", "list credentials"
  method_option :sort, type: :string, aliases: '-s', desc: "sort pattern. name, created_at and updated_at", default: "name"
  def list(*args)
    opts = merge_options(args, options)
    config_mongoid
    require 'text-table'
    res = [%w[name auth_values]]
    sort_options = {(opts[:sort] || "name").to_sym => 1}
    sort_options[:name] = 1 # 同じ時刻などのソートキーが決まらない場合を想定して名前もソートキーに入れる
    Tengine::Resource::Credential.all.order_by(sort_options).each do |credential|
      res << [
        credential.name,
        credential.auth_values.to_json
      ]
    end
    $stdout.puts res.to_table(:first_row_is_head => true)
    res
  end

  desc "add [name]", "add credential"
  method_option :username        , type: :string, aliases: '-u', desc: "username to login" # , required: true
  method_option :password        , type: :string, aliases: '-p', desc: "password"
  method_option :private_key_file, type: :string, aliases: '-k', desc: "private key filepath. ex. ~/.ssh/id_rsa"
  method_option :passphrase      , type: :string, aliases: '-P', desc: "passphrase for private key"
  def add(name, *args)
    opts = merge_options(args, options)
    config_mongoid
    auth_type_key = !opts[:password].blank? ? :ssh_password :
      !opts[:private_key_file].blank? ? :ssh_public_key_file :
      (raise "password or private_key_file is required")
    auth_values = { username: opts[:username] }
    [:password, :private_key_file, :passphrase].each do |k|
      if v = opts[k]
        auth_values[k] = v
      end
    end
    credential = Tengine::Resource::Credential.create!({
        name: name,
        auth_type_key: auth_type_key,
        auth_values: auth_values
      })
    $stdout.puts "credential created successfully!: #{credential.to_json}"
  end

  desc "remove", "remove credential manually by using [name]"
  def remove(name)
    config_mongoid
    if credential = Tengine::Resource::Credential.where({name: name}).first
      credential.destroy
      $stdout.puts "credential was destroyed successfully!: #{name}"
    else
      raise Mongoid::Errors::DocumentNotFound, "credential \"#{name}\" not found"
    end
  end

end
