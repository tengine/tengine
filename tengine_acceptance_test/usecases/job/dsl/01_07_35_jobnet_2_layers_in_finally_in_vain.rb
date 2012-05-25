# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0735") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  finally do
    jobnet("rfjn1") do
      ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
      jobnet("rfjn11") do
        ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
        ruby_job('rj4'){ raise RuntimeError }
        ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
      end
      ruby_job('rj6'){ STDOUT.puts('rj6 executing...') }
    end
  end
end
