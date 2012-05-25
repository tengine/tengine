# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0733") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  finally do
    jobnet("rfjn1") do
      ruby_job('rj2', :to => ['rfjn11', 'rj4']){ STDOUT.puts('rj2 executing...') }
      jobnet("rfjn11", :to => 'rj5') do
        ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
      end
      ruby_job('rj4', :to => 'rj5'){ STDOUT.puts('rj4 executing...') }
      ruby_job('rj5'              ){ STDOUT.puts('rj5 executing...') }
    end
  end
end
