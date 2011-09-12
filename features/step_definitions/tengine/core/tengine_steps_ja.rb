# -*- coding: utf-8 -*-
require 'timeout'
require 'amqp'

tengine_yaml = YAML::load(IO.read('./features/support/config/tengine.yml'))
@mq_server = tengine_yaml["event_queue"]["conn"]
@tengine_event_queue_opts = tengine_yaml["event_queue"]["queue"]
@tengine_event_queue_name = @tengine_event_queue_opts.delete("name")
@tengine_event_exchange_opts = tengine_yaml["event_queue"]["exchange"]
@tengine_event_exchange_name = @tengine_event_exchange_opts.delete("name")
@tengine_event_exchange_type = @tengine_event_exchange_opts.delete("type")

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
  @h ||= {}
  @h[name] = {:io => io, :stdout => []}
end

もし /^"([^"]*)"の起動を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  io = IO.popen(command)
  @h ||= {}
  @h[name] = {:io => io, :stdout => []}
end

もし /^"([^"]*)"の停止を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  `#{command}`
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

ならば /^"([^"]*)"の標準出力からPIDを確認できること$/ do |name|
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

ならば /^"([^"]*)"のPIDファイル"([^"]*)"からPIDを確認できること$/ do |name, file_path|
  @h[name][:pid] = `cat #{file_path}`.chomp
  @h[name][:pid].should_not be_empty
end

ならば /^"([^"]*)"が起動していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  # cucumberからのテストでforkしたプロセスは、killされた場合にゾンビプロセスが残ってしまうので
  # statusがZのプロセスは省く処理を入れます。
  # よって、指定するps コマンドには"-o stat"というオプションが必須になります。
  exec_command = "#{command.gsub(/PID/, pid)} | grep -v Z > /dev/null"
  puts "start confirm command: #{exec_command}"
  time_out(5) do
    while true
      break if system(exec_command)
      sleep 1
    end
  end
end

ならば /^"([^"]*)"が起動していること$/ do |name|
  result = ""
  if name == "DBプロセス"
    result = `ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"`.chomp
  elsif name == "キュープロセス"
    result = `ps aux | grep -v grep | grep -e rabbitmq`.chomp
  elsif name == "Tengineコアプロセス"
    # Tengineコアのpidファイル => tmp/tengine_pids/tengine.[0からの連番].[pid]
    # 例：tmp/tengine_pids/tengine.0.3948
    # ファイルの中はpidが記述されている
    pids = IO.popen("cat tmp/tengine_pids/tengine.*").to_a
    pids.each do |pid|
      result = `ps -eo pid #{pid}}`.chomp
    end
  elsif name == "Tengineコンソールプロセス"
    result = `ps -eo pid | grep \`cat tmp/pids/server.pid\``.chomp
  end
  # systemメソッドの戻り値が空でないことで起動を判断する
  result.should_not be_empty
end

ならば /^"([^"]*)"が停止していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  # cucumberからのテストでforkしたプロセスは、killされた場合にゾンビプロセスが残ってしまうので
  # statusがZのプロセスは省く処理を入れます。
  # よって、指定するps コマンドには"-o stat"というオプションが必須になります。
  exec_command = "#{command.gsub(/PID/, pid)} | grep -v Z > /dev/null"
  puts "stop confirm command: #{exec_command}"
  time_out(5) do
    while true
      break unless system(exec_command)
      sleep 1
    end
  end
end

ならば /^"([^"]*)"が停止していること$/ do |name|
  result = ""
  if name == "DBプロセス"
    result = `ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"`.chomp
  elsif name == "キュープロセス"
    result = `ps aux | grep -v grep | grep -e rabbitmq`.chomp
  elsif name == "Tengineコアプロセス"
    # Tengineコアのpidファイル => tmp/tengine_pids/tengine.[0からの連番].[pid]
    # 例：tmp/tengine_pids/tengine.0.3948
    # ファイルの中はpidが記述されている
    pids = IO.popen("cat tmp/tengine_pids/tengine.*").to_a
    pids.each do |pid|
      result = `ps -eo pid #{pid}}`.chomp
    end
  elsif name == "Tengineコンソールプロセス"
    result = `ps -eo pid | grep \`cat tmp/pids/server.pid\``.chomp
  end
  # systemメソッドの戻り値が空であることで停止を判断する
  result.should be_empty
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

前提 /^GR Heartbeatの発火間隔が(.*)と設定されている$/ do |tengined_heartbeat_period|
  @tengined_heartbeat_period = tengined_heartbeat_period
end

もし /^発火間隔だけ待機する$/ do
  sleep @tengined_heartbeat_period
end

#############
# キュー関連
#############

もし /^イベントキューを削除する$/ do
  delete_queue(@tengine_event_queue_name, @tengine_event_queue_opts)
end

もし /^イベントエクスチェンジを削除する$/ do
  delete_exchange(@tengine_event_exchange_name, @tengine_event_exchange_type, @tengine_event_exchange_opts)
end

もし /^イベントキューをアンバインドする$/ do
  unbind_queue(@tengine_event_queue_name, @tengine_event_exchange_name, @tengine_event_queue_opts)
end

ならば /^イベントキューが存在しないこと$/ do
  exec_command = "rabbitmqctl list_queues name | grep #{@tengine_event_queue_name}"
  `#{exec_command}`.chomp.should be_empty
end

ならば /^イベントエクスチェンジが存在しないこと$/ do
  exec_command = "rabbitmqctl list_exchanges name | grep #{@tengine_event_exchange_name}"
  `#{exec_command}`.chomp.should be_empty
end

ならば /^イベントキューをバインドしていないこと$/ do
  exec_command = "rabbitmqctl list_bindings source_name destination_name | grep #{@tengine_event_exchange_name}"
  result = `#{exec_command}`.chomp
  result.include?("tengine_event_queue").should be_false
end

#############
# 画面
#############

もし /^"([^"]*)"に"([^"]*)"を入力する$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

ならば /^"([^\"]*)"に以下の行が表示されること$/ do |arg1, expected_table|
  Then %{I should see the following drivers:}, expected_table
end

ならば /^以下の行が表示されること$/ do |expected_table|
  actual = tableish('table tr', 'td,th')
  expected_table.diff!(actual, :surplus_row => false)
end

ならば /^一件も表示されていないこと$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table tr', 'td,th')
  # ヘッダのみとれるのsizeは1になる
  actual.size.should == 1
end


ならば /^一件以上表示されていること$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table tr', 'td,th')
  # ヘッダが含まれるのでsizeは1より多くなるべき
  actual.size.should > 1
end

ならば /^一件以上されていること$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table tr', 'td,th')
  # ヘッダが含まれるのでsizeは2になるべき
  actual.size.should == 2
end


ならば /^"([^\"]*)画面"を表示していないこと$/ do |page_name|
  current_path = URI.parse(current_url).path
  current_path.should_not == path_to(page_name)
end

#############
# ファイル操作
#############

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

もし /^"([^"]*)ファイル""([^"]*)"を参照する$/ do |name, file_path|
  raise "#{name}:#{file_path}が存在しません" unless FileTest.exists?(file_path)
  # ファイルを展開した文字配列を格納する
  @h = {}
  @h[name] = {:file_path => file_path, :read_lines => File.readlines(file_path)}
end

ならば /^"([^"]*)ファイル"に"([^"]*)"と記述されていること$/ do |name, text|
  @h[name][:read_lines].grep(/#{text}/).should_not be_empty
end

ならば /^"([^"]*)ファイル"に"([^"]*)"と記述されていないこと$/ do |name, text|
  @h[name][:read_lines].grep(/#{text}/).should be_empty
end

もし /^Tengineコアの設定ファイル"([^"]*)"を作成する$/ do |config_file_path|
  FileUtils.cp("./features/support/config/tengine.yml", config_file_path)
end

もし /^Tengineコアの設定ファイル"([^"]*)"を修正する$/ do |config_file_path|
  FileUtils.cp("./features/support/config/tengine.yml", config_file_path)
end

もし /^(.*ファイル)"([^"]*)"を作成する$/ do |name, file_path|
  dir_name = File.dirname(file_path)
  FileUtils.mkdir_p(dir_name) unless File.exists?(dir_name)
  FileUtils.touch(file_path)
end

もし /^(.*ファイル)"([^"]*)"に以下の記述をする$/ do |name, file_path, text|
  File.open(file_path, 'w') {|f| f.puts(text) }
end

前提 /^yamlファイルとして不正なTengineコアの設定ファイルinvalid_tengine.ymlが存在する$/ do
  FileUtils.cp("./features/support/config/invalid_tengine.yml", "./tmp/end_to_end_test/config/invalid_tengine.yml")
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


server ={
  :host => 'localhost',
  :port => 5672,
  :vhost => '/',
  :user => 'guest',
  :pass => 'guest',
}


# キューの削除
def delete_queue(queue_name, options = {})
  AMQP.start(@mq_server) do |connection, open_ok|
    AMQP::Channel.new(connection) do |channel, open_ok|
      queue = channel.queue(queue_name, options)
      queue.delete
      connection.close { EM.stop { exit } }
    end
  end
end

# エクスチェンジの削除
def delete_exchange(exchange_name, type = :direct, options = {})
  AMQP.start(@mq_server) do |connection, open_ok|
    AMQP::Channel.new(connection) do |channel, open_ok|
      exchange = AMQP::Exchange.new(channel, type, exchange_name, options)
      exchange.delete
      connection.close { EM.stop { exit } }
    end
  end
end

# キューのアンバインド
def unbind_queue(queue_name, exchange_name, options = {})
  AMQP.start(@mq_server) do |connection, open_ok|
    AMQP::Channel.new(connection) do |channel, open_ok|
      queue = channel.queue(queue_name, options)
      queue.unbind(exchange_name)
      connection.close { EM.stop { exit } }
    end
  end
end
