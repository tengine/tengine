# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0701") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
end
