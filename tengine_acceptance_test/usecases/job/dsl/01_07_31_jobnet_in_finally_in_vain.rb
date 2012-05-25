# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0731") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  finally do
    jobnet("rfjn1") do
      ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
      ruby_job('rj3'){ raise RuntimeError }
      ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
    end
  end
end
