# ./usecases/job/dsl/03_03_stop_ruby_job_1.rb
# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0303_01") do
  ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 complete') }
  ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 complete') }
  ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 complete') }
  ruby_job('rj4'                       ){ STDOUT.puts('rj4 complete') }
end
