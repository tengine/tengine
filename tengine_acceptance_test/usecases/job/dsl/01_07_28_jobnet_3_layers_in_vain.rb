# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0728") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  jobnet("rjn1") do
    ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
    jobnet("rjn11") do
      ruby_job('rj3'){ raise RuntimeError }
    end
    ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
  end
  ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  finally do
    ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
    ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
    ruby_job('frj3'){ STDOUT.puts('frj3 executing...') }
  end
end
