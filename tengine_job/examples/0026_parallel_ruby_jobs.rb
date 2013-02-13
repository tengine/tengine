require 'tengine_job'

jobnet("rjn0026", job_method: :ruby_job) do
  names = (1..10).map{|i| "j%03d" % i }

  boot_jobs(*names)

  names.each do |job_name|
    name = job_name
    job(name) do
      open("tmp/ruby_job#{Process.pid}", "a") do |f|
        f.puts("#{Time.now.to_s} #{Process.pid} #{name} start")
        sleep(ENV['SLEEP'] || 10)
        f.puts("#{Time.now.to_s} #{Process.pid} #{name} finish")
      end
    end
  end

end
