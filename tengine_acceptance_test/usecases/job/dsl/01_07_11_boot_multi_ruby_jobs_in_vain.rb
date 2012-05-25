# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0711") do
  boot_jobs(['rj1', 'rj2'])
  ruby_job('rj1', :to => 'rj3'){ raise RuntimeError }
  ruby_job('rj2', :to => 'rj3'){ STDOUT.puts('rj2 executing...') }
  ruby_job('rj3', :to => 'rj4'){ STDOUT.puts('rj3 executing...') }
  ruby_job('rj4'              ){ STDOUT.puts('rj4 executing...') }
end
