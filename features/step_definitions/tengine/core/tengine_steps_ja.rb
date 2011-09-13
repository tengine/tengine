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
  if name == "Tengineコアプロセス"
    io = IO.popen("bin/tengined")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
  end
  if name == "Tengineコンソール"
    io = IO.popen("rails s")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
  end
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

前提 /^"([^"]*)"がオプション"([^"]*)"で起動している$/ do |name,option|
  if name == "Tengineコアプロセス"
    io = IO.popen("bin/tengined #{option}")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
　elsif name == "DBプロセス"
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
  message_out = false
  unless match
    time_out(10) do
      while line = @h[name][:io].gets
        puts line
        @h[name][:stdout] << line
        message_out = line.match(word)
        if message_out
          # puts "match:#{word}"
          break
        end
      end
    end
  end
  message_out.should be_true
end

ならば /^"([^"]*)"の標準出力からPIDを確認できること$/ do |name|
  # TODO Tengineコアをフォアグラウンド起動した際に標準出力が決まっていないので、PIDの取得部分は暫定的に正規表現で数値を引っこ抜いている
  if name == "Tengineコアプロセス"
    pid_regexp = /PID:(\d+)/
  elsif name == "Tengineコンソールプロセス"
    pid_regexp = /pid=(\d+)/
  end
  get_pid = false
  time_out(5) {
    while line = @h[name][:io].gets
      @h[name][:stdout] << line
      get_pid = line.match(pid_regexp)
      if get_pid then
        pid = line.match(pid_regexp)[1]
        @h[name][:pid] = pid
        break
      end
    end
  }
  get_pid.should be_true
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
  process_started = false
  time_out(5) do
    while true
      process_started = system(exec_command)
      break if process_started
      sleep 1
    end
  end
  process_started.should be_true
end

# Tengieコアはバックグラウンドで起動している前提です
前提 /^"([^"]*)"から"([^"]*)"の"起動時刻"を確認する$/ do |file, name|
  raise "サポート外の定義です。" unless file == "アプリケーションログファイル" && "Tengineコアプロセス"
  @h ||= {}
  @h[name] ||= {}
  pids = tengine_core_process_running_pids
  raise "#{name}が起動していません" if pids.empty?
  raise "#{name}が2つ以上起動しています。:pids => #{pids}" if 1 < pids.size
  @h[name][:start_time] = tengine_core_process_start_time(pids[0]) 
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
  process_stop = false
  time_out(5) do
    while true
      process_stop = system(exec_command)
      break unless process_stop
      sleep 1
    end
  end
  process_stop.should be_false
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

# 取得した値を入力する場合に使う
もし /^"([^"]*)"に"([^"]*)"を入力する$/ do |field, value|
  value = @event_key if value == '"#{イベントキー}"'
  もし %{"#{field}"に"#{value}"と入力する}
end

# 取得した値を入力する場合に使う
もし /^"([^"]*)"に"([^"]*)"の"([^"]*)"を入力する$/ do |field, name, value|

  # 発生時刻には入力項目が2つあり、日本語指定では入力できなかったので暫定対応
  field = "finder_occurred_at_start" if field == "発生時刻(開始)"

  if value == '#{開始時刻}'
    raise "#{name}の開始時刻が取得できませんでした。" unless @h[name][:start_time]
    value = @h[name][:start_time].strftime(view_time_format)
  elsif value == '#{イベント発火時刻}'
    raise "#{name}のイベント発火時刻が取得できませんでした。" unless @h[name][:event_ignition_time]
    value = @h[name][:event_ignition_time].strftime(view_time_format)
  end 
  もし %{"#{field}"に"#{value}"と入力する}
end

もし /^"([^"]*)"に"([^"]*)"のイベント発火時刻として現在の時刻を入力し記録しておく$/ do |field, name|
  @h ||= {}
  @h[name] ||= {}
  now = Time.now
  @h[name][:event_ignition_time] = now
  value = now.strftime(view_time_format)
  もし %{"#{field}"に"#{value}"と入力する}
end

ならば /^"([^"]*)"に以下の行が表示されること$/ do |arg1, expected_table|
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

ならば /^一件表示されていること$/ do
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

# UUIDを生成し、インスタンス変数にセットする
もし /^RailsConsoleで"([^"]*)"と実行し生成したイベントキーを確認する$/ do |arg1|
  @event_key = Tengine::Event.uuid_gen.generate
end

ならば /^"([^"]*)ファイル"に"([^"]*)"と記述されていること$/ do |name, text|
  # イベントキーを表すキーワードが含まれていたら置換する
  text = text.gsub(/\#{イベントキー}/, @event_key)
  @h[name][:read_lines].grep(/#{text}/).should_not be_empty
end

# expected_tableに指定された1番目のデータを探し、そこを起点に次のデータを探します。
# 定義されたデータ間に他のデータがあった場合は読飛ばします。
#
# 定義の例：
#  ならば "Tengineコアプロセスのイベント処理ログファイル"に以下の順で記述されていること
#    |aaa|
#    |bbb|
#    |ccc|
#
# OKなログの出力パターン:
#  1:aaa # <- 起点となる１番目のデータ
#  2:bbb
#  3:foo # <- 読飛ばされる
#  4:ccc
#
# NGなログの出力パターン:
#  1:bbb # <- 起点となるデータの前なので対象外となる
#  2:aaa # <- 起点となる１番目のデータ
#  3:ccc
#
ならば /^"([^"]*)ファイル"に以下の順で記述されていること$/ do |name, expected_table|
  raise "指定した列数が多いです。想定の列数は1です。" unless expected_table.headers.size == 1
  raise "イベントキーが取得できませんでした" unless @event_key
  expected_lines = []
  expected_table.each_cells_row do |cells|
    value = cells.value(0)
    # イベントキーは置換します
    expected_lines << value.gsub(/\#{イベントキー}/, @event_key)
  end
  actual_lines = []
  search_lines = expected_lines.dup
  search_text = search_lines.shift
  @h[name][:read_lines].each do |line|
    if line.match(/#{search_text}/)
      actual_lines << search_text
      break if search_lines.empty?
      search_text = search_lines.shift
    end
  end
  # actualの作成では順序を意識しているため、実際は "aaa", "bbb", "ccc" と出力されていても
  # リストactual_lines は ["aaa"] という内容になります。
  actual_lines.should == expected_lines
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

前提 /^"([^"]*)"ファイルに書き込み権限がない$/ do |arg1|
   rails "権限の変更に失敗しました" unless system("chmod -w #{path}")
end

前提 /^"([^"]*)"ファイルに書き込み権限がある$/ do |arg1|
   rails "権限の変更に失敗しました" unless system("chmod +r #{path}")
end

def view_time_format
  "%Y-%m-%d %H:%M:%S"
end

def tengine_core_process_pids(status)
  pids = []
  command = "bin/tengined -k status | grep #{status} | awk '{print $1}'"
  IO.popen(command) do |io|
    pid = io.gets.chomp
    pids << pid
  end
  return pids
end

def tengine_core_process_running_pids
  tengine_core_process_pids "running"
end

def tengine_core_process_start_time(pid)
  start_time = ""
  # tengined起動でTengineコアが初めて出力するロガーの初期化を開始としています。
  startline = "Tengine::Core::Config#setup_loggers complete"
  command = "cat log/tengined.*_#{pid}_stdout.log | grep '#{startline}' | tail -n 1 | awk '{print $1}'"
  IO.popen(command) do |io|
    start_time = io.gets
  end
  Time.parse(start_time)
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

#############
# pending一覧
#############

前提 /^(\d+)バージョンのイベントハンドラ定義がイベントハンドラストアに登録されている$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

もし /^イベントハンドラ定義のデプロイをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^イベントハンドラ定義のデプロイがされること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^イベントハンドラ定義のロールバックをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^イベントハンドラ定義のロールバックがされること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^DBのリストアをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBがリストアされていること$/ do
  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"にDBのバックアップファイルが存在する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

もし /^DBのリカバリをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBのリカバリがされていること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^DBのロールバックをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBのロールバックがされていること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^Tengineコアパッケージをバージョン\(\.\*\)から\(\.\*\)に更新する$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^Tengineコアパッケージをバージョン\(\.\*\)から\(\.\*\)に更新されていること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^Tengineコアパッケージをバージョン\(\.\*\)から\(\.\*\)にロールバックする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^Tengineコアパッケージがバージョン\(\.\*\)で起動していること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^DBを"([^"]*)"から物理バックアップする$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

ならば /^"([^"]*)"にDBの物理バックアップファイルが存在すること$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

ならば /^DBが物理リストアされていること$/ do
  pending # express the regexp above with the code you wish you had
end

前提 /^DBパッケージがバージョン(\d+)\.(\d+)\.(\d+)で起動している$/ do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

もし /^DBパッケージをバージョン\(\.\*\)から\(\.\*\)に更新する$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBパッケージをバージョン\(\.\*\)から\(\.\*\)に更新されていること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^DBパッケージをバージョン\(\.\*\)から\(\.\*\)にロールバックする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBパッケージをバージョン\(\.\*\)から\(\.\*\)にロールバックされていること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^DBのマイグレーションをする$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^DBのマイグレーションがされていること$/ do
  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"で"([^"]*)"が停止している$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"で"([^"]*)"が起動している$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

#############
# pending・ネットワーク一覧
#############

もし /^コアが動作しているサーバとキューが動作しているサーバ間のネットワークが接続する$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^コアが動作しているサーバとキューが動作しているサーバ間のネットワークが接続していること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^コアが動作しているサーバとDBが動作しているサーバ間のネットワークが切断する$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^コアが動作しているサーバとDBが動作しているサーバ間のネットワークが接続する$/ do
  pending # express the regexp above with the code you wish you had
end

ならば /^コアが動作しているサーバとDBが動作しているサーバ間のネットワークが接続していること$/ do
  pending # express the regexp above with the code you wish you had
end

もし /^コアが動作しているサーバとキューが動作しているサーバ間のネットワークが切断する$/ do
  pending # express the regexp above with the code you wish you had
end


#############
# pending・パッケージ一覧
#############

前提 /^(.*)パッケージがバージョン(.*)で起動している$/ do
  pending # express the regexp above with the code you wish you had
end

#############
# pending・サーバ設定
#############

前提 /^Tengine周辺のサーバの時刻が同期されている$/ do
  pending # express the regexp above with the code you wish you had
end
