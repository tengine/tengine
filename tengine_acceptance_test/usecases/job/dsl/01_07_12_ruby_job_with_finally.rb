# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0712") do
  ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  finally do
    ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
  end
end
