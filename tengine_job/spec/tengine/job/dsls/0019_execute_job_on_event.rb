# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("jobnet0019") do
  auto_sequence
  job("j11", "tengine_job_test 5 j11'")
  job("j12", "tengine_job_test 5 j12'")
  job("j13", "tengine_job_test 5 j13'")
end

driver :driver_for_jobnet_0019 do
  on :foo do
    jobnet("jobnet0019").execute(:sender => self)
  end
end
