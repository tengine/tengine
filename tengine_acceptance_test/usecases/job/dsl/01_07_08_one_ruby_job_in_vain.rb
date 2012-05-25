# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0708") do
  ruby_job('rj1'){ raise RuntimeError }
end
