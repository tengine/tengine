# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0725") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  jobnet("rjn1") do
    ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
    jobnet("rjn11") do
      ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
    end
  end
  ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
end
