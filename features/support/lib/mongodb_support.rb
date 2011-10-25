# -*- coding: utf-8 -*-
class MongodbSupport
  
  ＠＠NODES = nil

  class << self

    def nodes(nodes)
      nodes.each do |node|
        puts node
      end
      @@NODES = nodes
    end

    def shutdown
      @@NODES.each do |node|
        command = "mongo localhost:#{node['port']}/admin features/step_definitions/mongodb/shutdown"
        puts "command:#{command}"
        raise "MongoDBの停止に失敗しました" unless system(command)
      end
    end

    def kill
      @@NODES.each do |node|
        command = "ps -e |grep -e \"mongod.*--port.*#{node['port']}\" | grep -v grep|awk '{print $1}' | xargs kill -9"
        puts "command:#{command}"
        system(command)
      end
    end

    def rm_mongo_lock
      @@NODES.each do |node|
        command = "rm -rf #{node['dbpath']}/mongod.lock"
        puts "command:#{command}"
        system(command)
      end
    end

    def running?
      # 一つ目のnodeのプロセスがあるかで判断
      command = "ps aux|grep -v \"grep\" | grep -e \"mongod.*--port.*#{@@NODES.first['port']}\""
      puts "command:#{command}"
      system(command)
    end

    def start_mongodb(h, name)
      @@NODES.each do |node|
puts "node:#{node}"
        command = "mongod --replSet tengine_e2e_rs --port #{node['port']} --dbpath #{node['dbpath']} --logpath #{node['logpath']}/tengine.log --fork --logappend --rest --journal"
        # name が重複しないように、ノードの識別子(host + port)をつける
        node_name = "name_#{node['host']}_#{node['port']}"
        start_process(h, node_name, command)
        sleep 2
        pid = get_mongodb_pid(node['port'])
        pid ? (h[node_name][:pid] = pid) : (raise "MongoDBの起動に失敗しました")
      end
    end

    def get_mongodb_pid(port)
      pid = `ps -e |grep -e \"mongod.*--port.*#{port}\" |grep -v grep|awk '{print $1}'`.chomp
      puts "mongodb_pid:#{pid}"
      pid.empty? ? nil : pid
    end


    def start_process(h, name, command)
      h[name] = {:stdout => [], :command => command}
      puts "command:#{command}"
      output, input, p = PTY.spawn(command)
      Thread.start {
        while line = begin
                   output.gets          # FreeBSD returns nil.
                 rescue Errno::EIO # GNU/Linux raises EIO.
                   nil
                 end
#      puts line 
          h[name][:stdout] << line
        end
      }
    end

  def add_user
    # primaryノードに対して実行する必要があるので修正しないといけない。TODO
    command = "mongo localhost:#{@@NODES.first['port']}/tengine_production features/step_definitions/mongodb/add_e2e_user"
    puts "command:#{command}"
    raise "DBへのユーザ追加に失敗しました。"  unless system(command)
  end

  end

end
