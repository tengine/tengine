# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0709") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  ruby_job('rj2'){ raise RuntimeError }
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end
