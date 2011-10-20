# -*- coding: utf-8 -*-
require 'timeout'
require 'amqp'

tengine_yaml = YAML::load(IO.read('./features/config/tengine.yml'))
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
    command = "tengined -k start -f features/config/tengine.yml"
    io = IO.popen(command)
    @h ||= {}
    @h[name] = {:io => io, :stdout => [] ,:command => command}
    pid_regexp = /<(\d+)>/
    get_pid_from_stdout name,pid_regexp
  elsif name == "Tengineコンソールプロセス"
    system("rm -rf ./tmp/pids/server.pid")
    io = IO.popen("rails s -e production")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    get_pid_from_file(name, "./tmp/pids/server.pid")
  elsif name == "DBプロセス"
    unless system("ps aux|grep -v \"grep\" | grep -e \"mongod.*--port.*21039\"")
      raise "MongoDBの起動に失敗しました" unless system('mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet')
    end
  elsif name == "キュープロセス"
    io = IO.popen("rabbitmqctl status")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    contains = contains_message_from_stdout(name,"running_applications")
    unless contains
      raise "RabbitMQの起動に失敗しました" unless system('rabbitmq-server -detached')
    end
  else 
    raise "#{name}がありません"
  end
  sleep 5 # TODO sleepさせるのやめたいです。
end

前提 /^"([^"]*)"がオプション"([^"]*)"で起動している$/ do |name,option|
  if /Tengineコアプロセス/ =~ name
    command = "tengined #{option}"
    puts command
    io = IO.popen(command)
    io = nil
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    sleep 5 # TODO sleepさせるのやめたいです。
  elsif name == "DBプロセス"
    unless system('ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"')
      raise "MongoDBの起動に失敗しました" unless system('mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet')
    end
  elsif name == "キュープロセス"
    io = IO.popen("rabbitmqctl status")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    contains = contains_message_from_stdout(name,"running_applications")
    unless contains
      raise "RabbitMQの起動に失敗しました" unless system('rabbitmq-server -detached')
    end
  else
    raise "#{name}はサポート外です。"
  end
end



前提 /^"([^"]*)"が停止している$/ do |name|
  if name == "DBプロセス"
    if system('ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"')
      raise "MongoDBの停止に失敗しました"  unless system("mongo localhost:21039/admin features/step_definitions/mongodb/shutdown")
    end
  elsif name == "キュープロセス"
    io = IO.popen("rabbitmqctl status")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    contains = contains_message_from_stdout(name,"running_applications")
    unless contains
      raise "RabbitMQの停止に失敗しました" unless system('rabbitmqctl stop')
    end
  elsif name == "Tengineコアプロセス"
#    # Tengineコアのpidファイル => tmp/tengine_pids/tengine.[0からの連番].[pid]
#    # 例：tmp/tengine_pids/tengine.0.3948
#    # ファイルの中はpidが記述されている
#    pids = IO.popen("cat tmp/tengine_pids/tengine.*").to_a
#    pids.each do |pid|
#      if system('ps -eo pid #{pid}}')
#        raise "Tengineコアの停止に失敗しました" unless system("kill -KILL #{pid}")
#      end
#    end

    # 起動しているTengineコアプロセスを全てkillする
    tengine_core_process_kill_all
  elsif name == "Tengineコンソールプロセス"
    if system('ps -eo pid | grep `cat tmp/pids/server.pid`')
      raise "Tengineコアの停止に失敗しました" unless system('kill -KILL `cat tmp/pids/server.pid`')
    end
  end
end

# ファイルは ./tmp/tengined_pids, ./tmp/tengined_status, ./tmp/tengined_activations ディレクトリ以下のファイルを想定
# 明示的にパスを指定して起動されたTengineコアプロセスのファイルについては対象外です。
前提 /^"([^"]*)"の"([^"]*)ファイル"が存在しない$/ do |name, file_name|
  if file_name == "pid"
    system('rm -fr ./tmp/tengined_pids/*')
  elsif file_name == "status"
    system('rm -fr ./tmp/tengined_status/*')
  elsif file_name == "activation"
    system('rm -fr ./tmp/tengined_activations/*')
  else
    raise "#{file_name}ファイルは、サポート外のファイルです。"
  end
end

もし /^"([^"]*)"を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  io = IO.popen(command)
  @h ||= {}
  @h[name] = {:io => io, :stdout => [], :command => command}
end

もし /^"([^"]*)"の起動を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  IO.popen("rm -rf ./tmp/pids/server.pid") if name == "Tengineコンソールプロセス"

  puts "command:#{command}"
  io = IO.popen(command)
  @h ||= {}
  @h[name] = {:io => io, :stdout => [], :command => command}
  sleep 5
end

もし /^"([^"]*)"の停止を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  puts "command:#{command}"
  `#{command}`
end

ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/ do |name, word|
  match = contains_message_from_stdout(name, word)
  match.should be_true
end

ならば /^"([^"]*)"の標準出力からPIDを確認できること$/ do |name|
  if name == "Tengineコアプロセス"
    get_pid = get_pid_from_ps name
    get_pid.should be_true
  elsif name == "Tengineコンソールプロセス"
    pid_regexp = /pid=(\d+)/
    get_pid = get_pid_from_stdout name,pid_regexp
    get_pid.should be_true
  end
end


#ならば /^"([^"]*)"の標準出力からPIDを確認できること$/ do |name|
#  if name == "Tengineコアプロセス"
#    pid_regexp = /tengined\<(\d+)\>/
#  elsif name == "Tengineコンソールプロセス"
#    pid_regexp = /pid=(\d+)/
#  end
#  get_pid = get_pid_from_stdout name,pid_regexp
#  get_pid.should be_true
#end

ならば /^"([^"]*)"のPIDファイル"([^"]*)"からPIDを確認できること$/ do |name, file_path|
  @h ||= {}
  @h[name] ||= {}
  get_pid_from_file(name,file_path)
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
  time_out(10) do
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
  raise "サポート外の定義です。" unless (file == "アプリケーションログファイル" && /Tengineコアプロセス/ =~ name)
  @h ||= {}
  @h[name] ||= {}
  pids = tengine_core_process_running_pids
  raise "#{name}が起動していません" if pids.empty?
#  raise "#{name}が2つ以上起動しています。:pids => #{pids}" if 1 < pids.size
  @h[name][:start_time] = tengine_core_process_start_time(pids.last) 
  @h[name][:pid] = pids.last
  puts "起動時刻 => #{@h[name][:start_time]}"
  puts "PID => #{@h[name][:pid]}"
end

ならば /^"([^"]*)"が起動していること$/ do |name|
  result = ""
  time_out(10) do
    while true
      if name == "DBプロセス"
        result = `ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"`.chomp
      elsif name == "キュープロセス"
        io = IO.popen("rabbitmqctl status")
        @h ||= {}
        @h[name] = {:io => io, :stdout => []}
        result = "ok" if contains_message_from_stdout(name,"running_applications")
      elsif name == "Tengineコアプロセス"
        # Tengineコアのpidファイル => tmp/tengined_pids/tengined.[0からの連番].[pid]
        # 例：tmp/tengined_pids/tengined.0.3948
        # ファイルの中はpidが記述されている
        pids = IO.popen("cat tmp/tengined_pids/tengined.*").to_a
        pids.each do |pid|
          result = `ps -eo pid #{pid}}`.chomp
        end
      elsif name == "Tengineコンソールプロセス"
        result = `ps -eo pid | grep \`cat tmp/pids/server.pid\``.chomp
      else
        raise "#{name}は不正な指定です。"
      end
      break unless result.blank?
      sleep 1
    end
  end
  # systemメソッドの戻り値が空でないことで起動を判断する
  result.should_not be_empty
end

ならば /^"([^"]*)"が停止していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  # cucumberからのテストでforkしたプロセスは、killされた場合にゾンビプロセスが残ってしまうので
  # statusがZのプロセスは省く処理を入れます。
  # よって、指定するps コマンドには"-o stat"というオプションが必須になります。
  exec_command = "#{command.gsub(/PID/, pid)} | grep -v Z"
  puts "stop confirm command: #{exec_command}"
  process_stop = ""
  time_out(10) do
    while true
      process_stop = `#{exec_command}`.chomp
      break if process_stop.empty?
      sleep 1
    end
  end
  process_stop.should be_empty
end

ならば /^"([^"]*)"が停止していること$/ do |name|
  result = ""
  time_out(10) do
    while true
      if name == "DBプロセス"
        result = `ps aux|grep -v "grep" | grep -e "mongod.*--port.*21039"`.chomp
      elsif name == "キュープロセス"
        io = IO.popen("rabbitmqctl status")
        @h ||= {}
        @h[name] = {:io => io, :stdout => []}
        result = "ok" if contains_message_from_stdout(name,"running_applications")
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
      break if result.blank?
    end
  end
  # systemメソッドの戻り値が空であることで停止を判断する
  result.should be_empty
end

ならば /^"([^"]*)"が起動していることと、起動時刻を確認する$/ do |name|
  もし %{"#{name}"が起動していること}
  @h ||= {}
  @h[name] ||= {}
  @h[name][:start_time] = Time.now
  puts "起動時刻 => #{@h[name][:start_time]}"
end

ならば /^"([^"]*)"が停止していることと、停止時刻を確認する$/ do |name|
  もし %{"#{name}"が停止していること}
  @h ||= {}
  @h[name] ||= {}
  @h[name][:stop_time] = Time.now
  puts "停止時刻 => #{@h[name][:stop_time]}"
end


もし /^"([^"]*)"を Ctrl\+c で停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill -INT #{pid} > /dev/null"
  #exec_command = "kill -KILL #{pid} > /dev/null"
#  system(exec_command)
  IO.popen(exec_command)
  puts "kill commando: #{exec_command}"
end

もし /^"([^"]*)"を強制停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill -KILL #{pid} > /dev/null"
  system(exec_command)
  puts "kill commando: #{exec_command}"
end

もし /^"([^"]*)"が起動していることを"([^"]*)"で確認できる$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

前提 /^tenginedハートビートの発火間隔が(.*)と設定されている$/ do |tengined_heartbeat_period|
  @tengined_heartbeat_period = tengined_heartbeat_period
end

もし /^発火間隔だけ待機する$/ do
  sleep @tengined_heartbeat_period.to_i
end

もし /^リカバリ間隔が(.*)と設定されている$/ do |tengined_retry_interval|
  @tengined_retry_interval = tengined_retry_interval
end

もし /^リカバリ間隔だけ待機する$/ do
  sleep @tengined_heartbeat_period.to_i
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
  value = @event_key if value == '#{イベントキー}'
  もし %{"#{field}"に"#{value}"と入力する}
end

# 取得した値を入力する場合に使う
もし /^"([^"]*)"に"([^"]*)"の"([^"]*)"を入力する$/ do |field, name, value|

  # 発生時刻には入力項目が2つあり、日本語指定では入力できなかったので暫定対応
  field = "finder_occurred_at_start" if field == "発生時刻(開始)"

  if /(起動|開始)時刻/ =~ value
    raise "#{name}の開始時刻が取得できませんでした。" unless @h[name][:start_time]
    value = @h[name][:start_time].strftime(view_time_format)
  elsif value == '#{停止時刻}'
    raise "#{name}の停止時刻が取得できませんでした。" unless @h[name][:stop_time]
    value = @h[name][:stop_time].strftime(view_time_format)
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
  puts "発火時刻 => #{@h[name][:event_ignition_time]}"
  value = now.strftime(view_time_format)
  もし %{"#{field}"に"#{value}"と入力する}
end

ならば /^"([^"]*)"に以下の行が表示されること$/ do |arg1, expected_table|
  Then %{I should see the following drivers:}, expected_table
end

ならば /^以下の行が表示されること$/ do |expected_table|
  actual = tableish('table.list tr', 'td,th')
  expected_table.diff!(actual, :surplus_row => false)
end

ならば /^一件も表示されていないこと$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table.list tr', 'td,th')
  # ヘッダのみとれるのsizeは1になる
  actual.size.should == 1
end


ならば /^一件以上表示されていること$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table.list tr', 'td,th')
  # ヘッダが含まれるのでsizeは1より多くなるべき
  actual.size.should > 1
end

ならば /^一件表示されていること$/ do
  # イベントドライバ一覧のテーブルを取得
  # actual.class # => Array
  actual = tableish('table.list tr', 'td,th')
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
  text = text.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
  @h[name][:read_lines].grep(/^.*#{text}/).should_not be_empty
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
    expected_lines << value.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
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
  @h[name][:read_lines].grep(/^.*#{text}/).should be_empty
end

もし /^Tengineコアの設定ファイル"([^"]*)"を作成する$/ do |config_file_path|
  FileUtils.cp("./features/config/tengine.yml", config_file_path)
end

もし /^Tengineコアの設定ファイル"([^"]*)"を修正する$/ do |config_file_path|
  FileUtils.cp("./features/config/tengine.yml", config_file_path)
end

もし /^(.*ファイル)"([^"]*)"を作成する$/ do |name, file_path|
  dirname = File.dirname(file_path)
  Dir.mkdir(dirname) unless FileTest.exists?(dirname)
  FileUtils.touch(file_path)
end

もし /^(.*ファイル)"([^"]*)"を削除する$/ do |name, file_path|
  FileUtils.rm(file_path) if FileTest.exists?(file_path)
end

もし /^(.*ファイル)"([^"]*)"に以下の記述をする$/ do |name, file_path, text|
  File.open(file_path, 'w') {|f| f.puts(text) }
end

#前提 /^yamlファイルとして不正なTengineコアの設定ファイル"([^"]*)"が存在する$/ do
#  FileUtils.cp("./features/config/invalid_tengine.yml", "./tmp/end_to_end_test/config/invalid_tengine.yml")
#end

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

前提 /^"([^"]*)"ファイルに書き込み権限がない$/ do |file_path|
   FileUtils.touch(file_path) unless File.exists?(file_path)
   raise "権限の変更に失敗しました" unless system("chmod -w #{file_path}")
end

前提 /^"([^"]*)"ファイルに書き込み権限がある$/ do |file_path|
   FileUtils.touch(file_path) unless File.exists?(file_path)
   raise "権限の変更に失敗しました" unless system("chmod +r #{file_path}")
end

前提 /^"([^"]*)"ファイルの読込権限がないこと$/ do |file_path|
   FileUtils.touch(file_path) unless File.exists?(file_path)
   raise "権限の変更に失敗しました" unless system("chmod -r #{file_path}")
end

前提 /^"([^"]*)"ファイルの読込権限があること$/ do |file_path|
   FileUtils.touch(file_path) unless File.exists?(file_path)
   raise "権限の変更に失敗しました" unless system("chmod +r #{file_path}")
end

def view_time_format
  "%Y-%m-%d %H:%M:%S"
end

# 起動した順番のpidの配列を返す
# 注意：このメソッドはTengineコアプロセスがデーモンモードで起動していることを想定しています。
#      デーモンモードと、そうでない場合では、 ps が出力する COMMAND の値に差異があるためです。
#     
def tengine_core_process_pids(status)
  pids = []
  lines = []
  # 出力結果の例：（デーモンモードで起動した場合のみ）
  # tengined.0:58812
  # tengined.1:58834
  command = "ps aux | grep tengined | awk '{print $11\":\"$2}'"
  puts command
  IO.popen(command) do |io|
    while io.gets()
     line = $_
     puts "pid line => #{line}"
     if /^tengined/ =~ line
       lines << line 
     end
    end
  end
 
 puts lines
# => ["tengined.0:58812", "tengined.1:58834"]

  lines.sort! do |a, b|
     a.split(':')[0] <=> b.split(':')[0]
  end
  lines.each do |line|
    pid = line.split(':')[1].chomp
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
  puts "tengine_core_process_start_time command => #{command}"
  IO.popen(command) do |io|
    start_time = io.gets
  end
  puts "tengine_core_process_start_time start_time => #{start_time}"
  Time.parse(start_time)
end

# 全てのTengineコアプロセスをkillします
def tengine_core_process_kill_all
  pids = tengine_core_process_running_pids
  pids.each do |pid|
    if system('ps -eo pid #{pid}}')
      command = "kill -KILL #{pid}"
      puts "tengine_core_process_kill_all command => #{command}"
      raise "Tengineコアの停止に失敗しました" unless system(command)
    end
  end
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

def get_pid_from_stdout(name,pid_regexp)
  get_pid = false
  time_out(20) {
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
  get_pid
end

def get_pid_from_file(name, file_path)
  while  true
    sleep 1
    if File.exist?(file_path) 
      @h[name][:pid] = `cat #{file_path}`.chomp
      break
    end
  end
end

# psコマンドを利用してPIDを取得する
def get_pid_from_ps(name)
  get_pid = false
  p "cmd:#{@h[name][:command]}"
  IO.popen("ps aux | grep \"" + @h[name][:command]  + "\" | grep -v grep ") { |io|
    if line = io.gets
      @h[name][:pid] = line.split(" ")[1]
      get_pid = true
    end
  }
  get_pid
end

def contains_message_from_stdout(name,word)
  match = nil
  @h[name][:stdout].each do |line|
    #puts "既に:#{line}"
    match = line.match(/^.*#{word}/)
    break if match
  end
  unless match
    time_out(30) do
      while line = @h[name][:io].gets
         #puts line
         @h[name][:stdout] << line
         match = line.match(/^.*#{word}/)
         if match
          # puts "match:#{word}"
          break
        end
      end
    end
  end
 match
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
#  pending # express the regexp above with the code you wish you had
end

もし /^(.*)秒間眠る$/ do |time|
  sleep time.to_i
end

前提 /^"Tengineコアプロセス"のpidファイルが残っていない$/ do
  `rm tmp/tengined_pids/tengined.*`
  `rm tmp/tengined_status/tengined*`
end

前提 /^Tengineを使ったアプリケーションのプロジェクトを"([^"]*)"に新規で作成する$/ do |path|
  FileUtils.rm_rf(path) if FileTest.exists?(path)
  # プロジェクトのディレクトリ構造を作成します。
  FileUtils.mkdir_p(path)
  FileUtils.mkdir_p("#{path}/app")
  FileUtils.mkdir_p("#{path}/spec/support")

  # tengine_icmp_monitor からテスティングフレームエクステンションをコピーします。
  # tengine_consoleと、tengine_icmp_monitor が同じディレクトリに配置されている前提になります。
  FileUtils.cp("../tengine_icmp_monitor/spec/support/tengine_core.rb", "#{path}/spec/support")
end
