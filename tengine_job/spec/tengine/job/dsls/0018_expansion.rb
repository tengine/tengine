# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet0018_01") do
  boot_jobs("job101", "job102", "job103")
  job("job101", "echo 'success101'")
  job("job102", "echo 'success102'")
  job("job103", "echo 'success103'")
end

jobnet("jobnet0018_02") do
  auto_sequence
  job("job101", "echo 'success101'")
  job("job102", "echo 'success102'")
  job("job103", "echo 'success103'")
end

jobnet("jobnet0018") do
  auto_sequence
  expansion("jobnet0018_01")
  expansion("jobnet0018_02")
end
