# -*- coding: utf-8 -*-

Dir.chdir(File.dirname(__FILE__)) do |dir|
  Dir.glob("enumerable/**/*.rb").each do |f|
    require File.expand_path(f, dir)
  end
end
