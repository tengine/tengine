# batch - SplyImp
dsl_version("0.9.7")

# configurations
BATCH_ID_QUALIFIER = "expand_root_jobnet"
BATCH_CONTEXT_PARAM_MAP = {
    # TODO Configure BatchContext like as "key" => "value", ...
    "COMPANY_CODE" => "00189004",
    "DEPARTMENT_CODE" => "760",
}

# prepare configurations
BATCH_ARGUMENTS = "__workflow_engine__=monkeymagic,"
BATCH_CONTEXT_PARAM_MAP.each {|k, v|
    BATCH_ARGUMENTS += k.gsub(/[\$=,]/n) { "\\" + $& }
    BATCH_ARGUMENTS += "="
    BATCH_ARGUMENTS += v.gsub(/[\$=,]/n) { "\\" + $& }
    BATCH_ARGUMENTS += ","
}
# workflow
jobnet("#{BATCH_ID_QUALIFIER}.001", :instance_name => "i-centos", :credential_name => "nstore") do 
    auto_sequence
    jobnet("STAGE_GRAPH") do
        boot_jobs("stage0001", "stage0002")
        hadoop_job_run("stage0001", "~/mm_server/spec/models/job/mm_job.sh 2 job_function_test_006", :to => "large_and_complicated_root_jobnet.001") do
            hadoop_job("SplyImp.SplyMargeAndSeparate.stage0001")
        end
        hadoop_job_run("stage0002", "~/mm_server/spec/models/job/mm_job.sh 2 job_function_test_007", :to => "large_and_complicated_root_jobnet.001") do
            hadoop_job("SplyImp.SplyMargeAndSeparate.stage0002")
        end
        expansion("large_and_complicated_root_jobnet.001", :to => ["large_and_complicated_root_jobnet.002", "large_and_complicated_root_jobnet.003"])
        expansion("large_and_complicated_root_jobnet.002", :to => "large_and_complicated_root_jobnet.004")
        expansion("large_and_complicated_root_jobnet.003", :to => "large_and_complicated_root_jobnet.004")
        expansion("large_and_complicated_root_jobnet.004", :to => "large_and_complicated_root_jobnet.005")
        expansion("large_and_complicated_root_jobnet.005")
    end
end
