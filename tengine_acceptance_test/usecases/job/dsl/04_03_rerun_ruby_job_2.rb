# ./usecases/job/dsl/04_03_stop_ruby_job_2.rb
# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0403_02") do
  jobnet('rjn1', :to => ['rjn2', 'rjn3']) { ruby_job('rj1'){ STDOUT.puts('rj1 complete') } }
  jobnet('rjn2', :to => 'rjn4') do
    ruby_job('rj2', :to => ['rj3', 'rj4']){ STDOUT.puts('rj2 complete') }
    ruby_job('rj3', :to => 'rj5'         ){ STDOUT.puts('rj3 complete') }
    ruby_job('rj4', :to => 'rj5'         ){ STDOUT.puts('rj4 complete') }
    ruby_job('rj5'                       ){ STDOUT.puts('rj5 complete') }
    finally do
      ruby_job('rj6') { STDOUT.puts('rj6 complete') }
    end
  end
  jobnet('rjn3', :to => 'rjn4') { ruby_job('rj7'){ STDOUT.puts('rj7 complete') } }
  jobnet('rjn4'               ) { ruby_job('rj8'){ STDOUT.puts('rj8 complete') } }
  finally do
    ruby_job('rj9'){ STDOUT.puts('rj9 complete') }
    jobnet('rjn5') do
      ruby_job('rj10'){ STDOUT.puts('rj10 complete') }
      finally do
        ruby_job('rj11'){ STDOUT.puts('rj11 complete') }
      end
    end
  end
end
