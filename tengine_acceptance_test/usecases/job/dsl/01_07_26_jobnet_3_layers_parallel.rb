# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0726") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  jobnet("rjn1") do
    ruby_job('rj2', :to => ['rjn11', 'rj4']){ STDOUT.puts('rj2 executing...') }
    jobnet("rjn11", :to => 'rj5') do
      ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
    end
    ruby_job('rj4', :to => 'rj5'){ STDOUT.puts('rj4 executiong...') }
    ruby_job('rj5'              ){ STDOUT.puts('rj5 executiong...') }
  end
  ruby_job('rj6'){ STDOUT.puts('rj6 executing...') }
end
