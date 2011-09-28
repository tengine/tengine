# -*- coding: utf-8 -*-
jobnet("jobnet0006_01") do
  boot_jobs("job101", "job102", "job103")
  job("job101", "echo 'success101'")
  job("job102", "echo 'success102'")
  job("job103", "echo 'success103'")
end

jobnet("jobnet0006_02") do
  auto_sequence
  job("job101", "echo 'success101'")
  job("job102", "echo 'success102'")
  job("job103", "echo 'success103'")
end

jobnet("jobnet0006") do
  auto_sequence
  expansion("jobnet0006_01")
  expansion("jobnet0006_02")
end
