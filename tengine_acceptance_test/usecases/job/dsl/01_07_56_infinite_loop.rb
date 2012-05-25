# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0756") do
  boot_jobs('rj1')
  ruby_job('rj1', :to => 'rj2'){ STDOUT.puts('rj1 executing...') }
  ruby_job('rj2', :to => 'rj1'){ STDOUT.puts('rj2 executing...') }
end
