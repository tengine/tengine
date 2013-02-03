# -*- coding: utf-8 -*-
require 'tengine/resource/cli'

class Tengine::Resource::CLI::Credential < Thor
  include Tengine::Resource::CLI::GlobalOptions

  desc "list", "list credentials"
  def list
    puts "list credentials"
  end

  desc "add", "add credential manually"
  def add
    puts "add credential"
  end

  desc "remove", "remove credential manually"
  def remove
    puts "remove credential"
  end

end
