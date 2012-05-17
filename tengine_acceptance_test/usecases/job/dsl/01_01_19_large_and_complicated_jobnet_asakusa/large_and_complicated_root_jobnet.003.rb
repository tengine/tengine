
require 'tengine_job'

# batch - SplyImp
dsl_version("0.9.7")

# configurations
BATCH_ID_QUALIFIER = "large_and_complicated_root_jobnet"
BATCH_ID_MODIFIER = "003"
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
jobnet("#{BATCH_ID_QUALIFIER}.#{BATCH_ID_MODIFIER}", :instance_name => "test_server1", :credential_name => "test_credential1") do 
    auto_sequence
    jobnet("SplyDataFormatCheck") do
      boot_jobs("nacs_ap_batch.sply")
      job("nacs_ap_batch.sply", "$HOME/tengine_job_test.sh 2 job_function_test_001", :instance_name => "test_server1", :credential_name => "test_credential1")
    end
    finally do
      boot_jobs("nacs_ap_batch")
      jobnet("nacs_ap_batch") do
        auto_sequence
        job("nacs_ap_batch.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_002", :instance_name => "test_server1", :credential_name => "test_credential1")
      end
    end
    jobnet("SplyMargeAndSeparate") do
        auto_sequence
        job("SETUP", "$HOME/tengine_job_test.sh 2 job_function_test_003")
        jobnet("IMPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_004", :instance_name => "test_server1", :credential_name => "test_credential1")
                job("bulkloader.nacscommon", "$HOME/tengine_job_test.sh 2 job_function_test_005", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        jobnet("STAGE_GRAPH") do
            boot_jobs("stage0001", "stage0002")
            hadoop_job_run("stage0001", "$HOME/tengine_job_test.sh 2 job_function_test_006", :to => ["stage0003", "stage0004", "stage0006", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0001")
            end
            hadoop_job_run("stage0002", "$HOME/tengine_job_test.sh 2 job_function_test_007", :to => ["stage0003", "stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0002")
            end
            hadoop_job_run("stage0003", "$HOME/tengine_job_test.sh 2 job_function_test_008", :to => ["stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0003")
            end
            hadoop_job_run("stage0004", "$HOME/tengine_job_test.sh 2 job_function_test_009", :to => ["stage0005", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0004")
            end
            hadoop_job_run("stage0007", "$HOME/tengine_job_test.sh 2 job_function_test_010", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0007")
            end
            hadoop_job_run("stage0006", "$HOME/tengine_job_test.sh 2 job_function_test_011", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0006")
            end
            hadoop_job_run("stage0005", "$HOME/tengine_job_test.sh 2 job_function_test_012", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0005")
            end
        end
        jobnet("EPILOGUE") do
            boot_jobs("epilogue.bulkloader")
            hadoop_job_run("epilogue.bulkloader", "$HOME/tengine_job_test.sh 2 job_function_test_013", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.epilogue.bulkloader")
            end
        end
        jobnet("EXPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_013", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        job("CLEANUP", "$HOME/tengine_job_test.sh 2 job_function_test_014")
        finally do
            jobnet("FINALIZE") do
                boot_jobs("bulkloader")
                jobnet("bulkloader") do
                    auto_sequence
                    job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_015", :instance_name => "test_server1", :credential_name => "test_credential1")
                end
            end
        end
    end
    jobnet("SplyMargeAndSeparate2") do
        auto_sequence
        job("SETUP", "$HOME/tengine_job_test.sh 2 job_function_test_003")
        jobnet("IMPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_004", :instance_name => "test_server1", :credential_name => "test_credential1")
                job("bulkloader.nacscommon", "$HOME/tengine_job_test.sh 2 job_function_test_005", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        jobnet("STAGE_GRAPH") do
            boot_jobs("stage0001", "stage0002")
            hadoop_job_run("stage0001", "$HOME/tengine_job_test.sh 2 job_function_test_006", :to => ["stage0003", "stage0004", "stage0006", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0001")
            end
            hadoop_job_run("stage0002", "$HOME/tengine_job_test.sh 2 job_function_test_007", :to => ["stage0003", "stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0002")
            end
            hadoop_job_run("stage0003", "$HOME/tengine_job_test.sh 2 job_function_test_008", :to => ["stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0003")
            end
            hadoop_job_run("stage0004", "$HOME/tengine_job_test.sh 2 job_function_test_009", :to => ["stage0005", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0004")
            end
            hadoop_job_run("stage0007", "$HOME/tengine_job_test.sh 2 job_function_test_010", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0007")
            end
            hadoop_job_run("stage0006", "$HOME/tengine_job_test.sh 2 job_function_test_011", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0006")
            end
            hadoop_job_run("stage0005", "$HOME/tengine_job_test.sh 2 job_function_test_012", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0005")
            end
        end
        jobnet("EPILOGUE") do
            boot_jobs("epilogue.bulkloader")
            hadoop_job_run("epilogue.bulkloader", "$HOME/tengine_job_test.sh 2 job_function_test_013", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.epilogue.bulkloader")
            end
        end
        jobnet("EXPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_013", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        job("CLEANUP", "$HOME/tengine_job_test.sh 2 job_function_test_014")
        finally do
            jobnet("FINALIZE") do
                boot_jobs("bulkloader")
                jobnet("bulkloader") do
                    auto_sequence
                    job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_015", :instance_name => "test_server1", :credential_name => "test_credential1")
                end
            end
        end
    end
    jobnet("SplyMargeAndSeparate3") do
        auto_sequence
        job("SETUP", "$HOME/tengine_job_test.sh 2 job_function_test_003")
        jobnet("IMPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_004", :instance_name => "test_server1", :credential_name => "test_credential1")
                job("bulkloader.nacscommon", "$HOME/tengine_job_test.sh 2 job_function_test_005", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        jobnet("STAGE_GRAPH") do
            boot_jobs("stage0001", "stage0002")
            hadoop_job_run("stage0001", "$HOME/tengine_job_test.sh 2 job_function_test_006", :to => ["stage0003", "stage0004", "stage0006", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0001")
            end
            hadoop_job_run("stage0002", "$HOME/tengine_job_test.sh 2 job_function_test_007", :to => ["stage0003", "stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0002")
            end
            hadoop_job_run("stage0003", "$HOME/tengine_job_test.sh 2 job_function_test_008", :to => ["stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0003")
            end
            hadoop_job_run("stage0004", "$HOME/tengine_job_test.sh 2 job_function_test_009", :to => ["stage0005", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0004")
            end
            hadoop_job_run("stage0007", "$HOME/tengine_job_test.sh 2 job_function_test_010", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0007")
            end
            hadoop_job_run("stage0006", "$HOME/tengine_job_test.sh 2 job_function_test_011", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0006")
            end
            hadoop_job_run("stage0005", "$HOME/tengine_job_test.sh 2 job_function_test_012", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0005")
            end
        end
        jobnet("EPILOGUE") do
            boot_jobs("epilogue.bulkloader")
            hadoop_job_run("epilogue.bulkloader", "$HOME/tengine_job_test.sh 2 job_function_test_013", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.epilogue.bulkloader")
            end
        end
        jobnet("EXPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_013", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        job("CLEANUP", "$HOME/tengine_job_test.sh 2 job_function_test_014")
        finally do
            jobnet("FINALIZE") do
                boot_jobs("bulkloader")
                jobnet("bulkloader") do
                    auto_sequence
                    job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_015", :instance_name => "test_server1", :credential_name => "test_credential1")
                end
            end
        end
    end
    jobnet("SplyMargeAndSeparate4") do
        auto_sequence
        job("SETUP", "$HOME/tengine_job_test.sh 2 job_function_test_003")
        jobnet("IMPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_004", :instance_name => "test_server1", :credential_name => "test_credential1")
                job("bulkloader.nacscommon", "$HOME/tengine_job_test.sh 2 job_function_test_005", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        jobnet("STAGE_GRAPH") do
            boot_jobs("stage0001", "stage0002")
            hadoop_job_run("stage0001", "$HOME/tengine_job_test.sh 2 job_function_test_006", :to => ["stage0003", "stage0004", "stage0006", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0001")
            end
            hadoop_job_run("stage0002", "$HOME/tengine_job_test.sh 2 job_function_test_007", :to => ["stage0003", "stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0002")
            end
            hadoop_job_run("stage0003", "$HOME/tengine_job_test.sh 2 job_function_test_008", :to => ["stage0004"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0003")
            end
            hadoop_job_run("stage0004", "$HOME/tengine_job_test.sh 2 job_function_test_009", :to => ["stage0005", "stage0007"]) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0004")
            end
            hadoop_job_run("stage0007", "$HOME/tengine_job_test.sh 2 job_function_test_010", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0007")
            end
            hadoop_job_run("stage0006", "$HOME/tengine_job_test.sh 2 job_function_test_011", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0006")
            end
            hadoop_job_run("stage0005", "$HOME/tengine_job_test.sh 2 job_function_test_012", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.stage0005")
            end
        end
        jobnet("EPILOGUE") do
            boot_jobs("epilogue.bulkloader")
            hadoop_job_run("epilogue.bulkloader", "$HOME/tengine_job_test.sh 2 job_function_test_013", :to => []) do
                hadoop_job("SplyImp.SplyMargeAndSeparate.epilogue.bulkloader")
            end
        end
        jobnet("EXPORT") do
            boot_jobs("bulkloader")
            jobnet("bulkloader") do
                auto_sequence
                job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_013", :instance_name => "test_server1", :credential_name => "test_credential1")
            end
        end
        job("CLEANUP", "$HOME/tengine_job_test.sh 2 job_function_test_014")
        finally do
            jobnet("FINALIZE") do
                boot_jobs("bulkloader")
                jobnet("bulkloader") do
                    auto_sequence
                    job("bulkloader.nacssply", "$HOME/tengine_job_test.sh 2 job_function_test_015", :instance_name => "test_server1", :credential_name => "test_credential1")
                end
            end
        end
    end
end
