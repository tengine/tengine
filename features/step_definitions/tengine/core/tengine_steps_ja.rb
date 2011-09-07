# -*- coding: utf-8 -*-
require 'timeout'

# インストール、セットアップ関係は優先度を下げるため後ほど実装する
前提 /^"([^"]*)パッケージ"のインストールおよびセットアップが完了している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"が起動している$/ do |name|
  if name == "DBプロセス"
    unless system('ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"')
      raise "MongoDBの起動に失敗しました" unless system('mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet')
    end
  elsif name == "キュープロセス"
    unless system('ps aux | grep -v grep | grep -e rabbitmq')
      raise "RabbitMQの起動に失敗しました" unless system('rabbitmq-server -detached')
    end
  end
end

前提 /^"([^"]*)"が停止している$/ do |name|
  if name == "DBプロセス"
    if system('ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"')
     raise "MongoDBの停止に失敗しました"  unless system("mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js")
    end
  elsif name == "キュープロセス"
    if system('ps aux | grep -v grep | grep -e rabbitmq')
     raise "RabbitMQの停止に失敗しました" unless system('rabbitmqctl stop')
    end
  elsif name == "Tengineコアプロセス"
    # Tengineコアのpidファイル => tmp/tengine_pids/tengine.[0からの連番].[pid]
    # 例：tmp/tengine_pids/tengine.0.3948
    # ファイルの中はpidが記述されている
    pids = IO.popen("cat tmp/tengine_pids/tengine.*").to_a
    pids.each do |pid|
      if system('ps -eo pid #{pid}}')
         raise "Tengineコアの停止に失敗しました" unless system("kill -KILL #{pid}")
      end
    end
  elsif name == "Tengineコンソールプロセス"
    if system('ps -eo pid | grep `cat tmp/pids/server.pid`')
      raise "Tengineコアの停止に失敗しました" unless system('kill -KILL `cat tmp/pids/server.pid`')
    end
  end
end

もし /^"([^"]*)"を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  io = IO.popen(command)
  @h = {} 
  @h[name] = {:io => io, :stdout => []}
end

もし /^"([^"]*)"の起動を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  io = IO.popen(command)
  @h = {} 
  @h[name] = {:io => io, :stdout => []}
end

ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/ do |name, word|

  # 既に表示されていないか
  match = nil
  @h[name][:stdout].each do |line|
    puts "既に:#{line}"
    match = line.match(word)
    break if match
  end

  unless match
    time_out(10) do
      while line = @h[name][:io].gets
        puts line
        @h[name][:stdout] << line
        if line.match(word) then
          # puts "match:#{word}"
          break
        end
      end
    end
  end

end

ならば /^"([^"]*)"の標準出力からPIDを確認することができること$/ do |name|
  # TODO Tengineコアをフォアグラウンド起動した際に標準出力が決まっていないので、PIDの取得部分は暫定的に正規表現で数値を引っこ抜いている
  if name == "Tengineコアプロセス"
    pid_regexp = /PID:(\d+)/
  elsif name == "Tengineコンソールプロセス"
    pid_regexp = /pid=(\d+)/
  end 

  time_out(5) { 
    while line = @h[name][:io].gets
      @h[name][:stdout] << line
      if line.match(pid_regexp) then
        pid = line.match(pid_regexp)[1]
        @h[name][:pid] = pid
        break
      end
    end
  }

end

ならば /^"([^"]*)"が起動していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  puts "start confirm command: #{exec_command}"
  time_out(5) do
    while true
      break if system(exec_command) 
      sleep 1
    end
  end
end

ならば /^"([^"]*)"が停止していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  puts "stop confirm command: #{exec_command}"
  time_out(5) do
    while true
      break unless system(exec_command) 
      sleep 1
    end
  end
end

もし /^"([^"]*)"を Ctrl\+c で停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill -INT #{pid} > /dev/null"
  #exec_command = "kill -KILL #{pid} > /dev/null"
  puts "kill commando: #{exec_command}"
  system(exec_command)

end

もし /^"([^"]*)"を強制停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill KILL #{pid} > /dev/null"
  system(exec_command)
end

もし /^"([^"]*)"が起動していることを"([^"]*)"で確認できる$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

もし /^"([^"]*)"に"([^"]*)"を入力する$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

ならば /^"([^"]*)"に以下の行が表示されること$/ do |arg1, table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

前提 /.*ファイル"([^"]*)"が存在すること$/ do |file_path|
  FileTest.exists?(file_path).should be_true
end

前提 /.*ファイル"([^"]*)"が存在しないこと$/ do |file_path|
  FileTest.exists?(file_path).should be_false
end

前提 /.*ファイル"([^"]*)"が存在しない$/ do |file_path|
  if FileTest.exists?(file_path)
    FileUtils.rm(file_path)
  end
end

もし /^Tengineコアの設定ファイル"([^"]*)"を作成する$/ do |config_file_path|
  FileUtils.cp("./features/usecases/コア/config/tengine.yml", config_file_path)
end

もし /^Tengineコアの設定ファイル"([^"]*)"を修正する$/ do |config_file_path|
  FileUtils.cp("./features/usecases/コア/config/tengine.yml", config_file_path)
end

前提 /^yamlファイルとして不正なTengineコアの設定ファイルinvalid_tengine.ymlが存在する$/ do
  FileUtils.cp("./features/usecases/コア/config/invalid_tengine.yml", "./tmp/invalid_tengine.yml")
end

前提 /.*イベントハンドラ定義"([^"]*)"が登録されている$/ do |event_handler_def|
  reise "#{event_handler_def} のloadに失敗しました。" unless system("tengined -k load -f tengine.yml -T #{event_handler_def}")
end

もし /^"([^"]*)"へ問い合わせる$/ do
end

もし /^イベントタイプ名"([^"]*)"のイベントを発火する$/ do |event_type_name|
  raise "イベントタイプ名#{event_type_name}のイベント発火に失敗しました" unless system('tengine_fire #{event_type_name}')
end

もし /^"([^"]*)"を"([^"]*)"にコピーする$/ do |src, dest|
  FileUtils.copy(src,dest)
end

もし /^"([^"]*)"を削除する$/ do |src|
  FileUtils.rm(src)
end

もし /^DBを"([^"]*)"に物理バックアップする$/ do |backup_path|
  # MongoDBのDBファイルを退避させる
  # TODO:バックアップ対象のファイル名の指定
  FileUtils.copy("/data/mongo/master",backup_path)
end

もし /^DBを"([^"]*)"から物理リストアする$/ do |backup_path|
  # MongoDBのDBファイルを上書きする
  # TODO:バックアップ対象のファイル名の指定
  FileUtils.copy(backup_path,"/data/mongo/master")
end

前提 /^"([^"]*)"にDBの物理バックアップファイルが存在する$/ do
  # MongoDBのDBファイルを事前にバックアップしておく
  # TODO:バックアップ対象のファイル名の指定
  FileUtils.copy("/data/mongo/master",backup_path)
end


def time_out(time, &block)
  begin
    timeout(time){
      yield
    }
  rescue Timeout::Error
    puts "Timeout!"
    true.should be_false
  end
end
