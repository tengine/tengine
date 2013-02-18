require 'tengine_job'

jobnet("rjn0027", job_method: :ssh_job, server_name: "localhost", credential_name: "ssh_pk") do
  names = (1..20).map{|i| "j%03d" % i }

  boot_jobs(*names)

  filepath = __FILE__.sub(/jobs\.rb/, 'job')

  names.each do |name|
    job(name, "#{filepath} #{Process.pid} #{name}")
  end

end
