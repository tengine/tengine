# -*- coding: utf-8 -*-
require 'timeout'
require 'amqp'
require 'pty'
require 'mongodb_support'

tengine_yaml = YAML::load(IO.read('./features/config/tengine.yml'))
@mq_server = tengine_yaml["event_queue"]["conn"]
@tengine_event_queue_opts = tengine_yaml["event_queue"]["queue"]
@tengine_event_queue_name = @tengine_event_queue_opts.delete("name")
@tengine_event_exchange_opts = tengine_yaml["event_queue"]["exchange"]
@tengine_event_exchange_name = @tengine_event_exchange_opts.delete("name")
@tengine_event_exchange_type = @tengine_event_exchange_opts.delete("type")

end_to_end_test_yaml = YAML::load(IO.read('./config/end_to_end_test.yml'))

# インストール、セットアップ関係は優先度を下げるため後ほど実装する
前提 /^"([^"]*)パッケージ"のインストールおよびセットアップが完了している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"が起動している$/ do |name|
  @h ||= {}
  if name == "Tengineコアプロセス"
    command = "tengined -k start -f features/config/tengine.yml"
    io = IO.popen(command)

    @h[name] = {:io => io, :stdout => [] ,:command => command}
    pid_regexp = /<(\d+)>/
    get_pid_from_stdout name,pid_regexp
  elsif name == "Tengineコンソールプロセス"
    unless TengineConsoleSupport.running?
      system("rm -rf ./tmp/pids/server.pid")
      io = IO.popen("rails s -e production")

      @h[name] = {:io => io, :stdout => []}
      get_pid_from_file(name, "./tmp/pids/server.pid")
    end
  elsif name == "DBプロセス"
    unless MongodbSupport.running?
      MongodbSupport.start_mongodb(@h, name)
    end
  elsif name == "キュープロセス"
    io = IO.popen("rabbitmqctl status")

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
    unless MongodbSupport.running?
      MongodbSupport.start_mongodb(@h, name)
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

前提 /^DBにユーザ"e2e"が存在し、パスワードは"password"である$/ do
  MongodbSupport.add_user
end


前提 /^"([^"]*)"が停止している$/ do |name|
  if name == "DBプロセス"
    if MongodbSupport.running?
      MongodbSupport.shutdown
    end
  elsif name == "キュープロセス"
    io = IO.popen("rabbitmqctl status")
    @h ||= {}
    @h[name] = {:io => io, :stdout => []}
    contains = contains_message_from_stdout(name,"running_applications")
    if contains
      command = "rabbitmqctl stop"
      puts "command: #{command}"
      raise "RabbitMQの停止に失敗しました" unless system(command)
    end
  elsif name == "Tengineコアプロセス"
    # 起動しているTengineコアプロセスを全てkillする
    tengine_core_process_kill_all
  elsif name == "Tengineコンソールプロセス"
    if system('ps -eo pid | grep `cat tmp/pids/server.pid`')
      raise "Tengineコアの停止に失敗しました" unless system('kill -KILL `cat tmp/pids/server.pid`')
    end
  else
    raise "#{name}はサポート外です。"
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
  command = "#{command} 2>&1"
  puts "command:#{command}"
  io = IO.popen(command)
  @h ||= {}
  @h[name] = {:io => io, :stdout => [], :command => command}
end

もし /^"([^"]*)"の起動を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  IO.popen("rm -rf ./tmp/pids/server.pid") if name == "Tengineコンソールプロセス"
  command = "#{command} 2>&1"
  puts "command:#{command}"

  @h ||= {}
  if /DBプロセス/ =~ name
    MongodbSupport.start_mongodb(@h, name)
  else
    start_process(name, command)
  end

  sleep 5
end

def start_process(name, command)
  @h ||= {}
  @h[name] = {:stdout => [], :command => command}

  output, input, p = PTY.spawn(command)
  Thread.start {
    while line = begin
                   output.gets          # FreeBSD returns nil.
                 rescue Errno::EIO # GNU/Linux raises EIO.
                   nil
                 end

    puts line 
      @h[name][:stdout] << line
    end
  }
end


もし /^"([^"]*)"の停止を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  command = "#{command} 2>&1"
  puts "command:#{command}"
  `#{command}`
end

ならば /^約"([^"]*)"秒以内に"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/  do |time, name, word|
  match = contains_message_from_stdout(name, word, {timeout:time.to_i})
  match.should be_true
end

ならば /^"([^"]*)"の標準出力からPIDを確認できること$/ do |name|
  if name == "Tengineコアプロセス"
#    get_pid = get_pid_from_ps name
    pid_regexp = /tengined<(\d+)>/
    get_pid = get_pid_from_stdout(name, pid_regexp)
    get_pid.should be_true
  elsif name == "Tengineコンソールプロセス"
    pid_regexp = /pid=(\d+)/
    get_pid = get_pid_from_stdout name,pid_regexp
    get_pid.should be_true
  end
end


ならば /^"([^"]*)"のPIDファイル"([^"]*)"からPIDを確認できること$/ do |name, file_path|
  @h ||= {}
  @h[name] ||= {}
  pid = get_pid_from_file(name,file_path)
  @h[name][:pid].should_not be_empty
  puts "pid:#{pid}"
end

ならば /^"([^"]*)"が起動していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  # cucumberからのテストでforkしたプロセスは、killされた場合にゾンビプロセスが残ってしまうので
  # statusがZのプロセスは省く処理を入れます。
  # よって、指定するps コマンドには"-o stat"というオプションが必須になります。
#  exec_command = "#{command.gsub(/PID/, pid)} | grep -v Z > /dev/null"
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  puts "command: #{exec_command}"
  status = false
  time_out(10) do
    while true
      status = system(exec_command)
      break if status
      sleep 1
    end
  end
  status.should be_true
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
        result = MongodbSupport.running? ? "running" : nil
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

#  exec_command = "#{command.gsub(/PID/, pid)} | grep -v Z"
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  puts "command: #{exec_command}"
  status = true
  time_out(10) do
    while true
#      process_stop = `#{exec_command}`.chomp
#      break if process_stop.empty?
      status = system(exec_command)
      break unless status
      sleep 1
    end
  end
  status.should be_false
end

ならば /^"([^"]*)"が停止していること$/ do |name|
  result = ""
  time_out(10) do
    while true
      if name == "DBプロセス"
        result = MongodbSupport.running? ? "running" : nil
      elsif name == "キュープロセス"
        io = IO.popen("rabbitmqctl status")
        @h ||= {}
        @h[name] = {:io => io, :stdout => []}
        # 起動している場合は標準出力に "running_applications" の文字列が出力される
        result = "running" if contains_message_from_stdout(name,"running_applications")
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
  puts "command: #{exec_command}"
  system(exec_command)
end

もし /^"([^"]*)"を強制停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill -KILL #{pid}"
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

ならば /^"([^"]*)と同じ内容の以下の行が表示されること$/ do |file_name, expected_table|
  replaced_expected_table = expected_table.arguments_replaced(job_id_replace(file_name, expected_table))
  Then %{I should see the following drivers:}, replaced_expected_table
end


def job_id_replace(file_name, expected_table)
  replace = {}
  expected_table.hashes.each do |row|
    row.each do |key, value|
      if value.include?("テンプレートID") || value.include?("実行時ID")
        /^(.*)の/ =~ value
        index = @h[file_name]["MM_ACTUAL_JOB_NAME_PATH"].index($1)
        if index
          id = @h[file_name]["MM_TEMPLATE_JOB_ANCESTOR_IDS"][index] 
          replace.push({value => id }) 
        end
      end
      if value.include?("実行時ID")
#        ids_reader(file_name, "MM_ACTUAL_JOB_ANCESTOR_IDS")
        /^(.*)の/ =~ value
        index = @h[file_name]["MM_ACTUAL_JOB_NAME_PATH"].index($1)
        if index
          id = @h[file_name]["MM_FULL_ACTUAL_JOB_ANCESTOR_IDS"][index]
          replace.push({value => id })
        end
      end
    end
  end
  replace
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
  sleep 30
  current_path.should_not == path_to(page_name)
end

ならば /^URLのexecuteのIDとログのexecuteのIDが一緒であること$/ do |page_name|
  current_path = URI.parse(current_url).path
  # TODO noguchi : syntax 
#   @["MM_SCHEDULE_ID"].should_eql current_path.slice(path.rindex("/")+1,path.size)
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

ならば /^"([^"]*)ファイル"に"([^"]*)"と出力されていること$/ do |name, text|
  # TODO assert_output を使うようにする
  text = text.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
  @h[name][:read_lines].grep(/^.*#{text}/).should_not be_empty
end

ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/ do |name, text|
  text = text.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
  match = contains_message_from_stdout(name, text)
  match.should be_true
end

ならば /^"([^"]*)ファイル"に"([^"]*)"と出力されていないこと$/ do |name, text|
  text = text.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
  @h[name][:read_lines].grep(/^.*#{text}/).should be_empty
end

ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていないこと$/ do |name, text|
  text = text.gsub(/\#{イベントキー}/, @event_key) unless @event_key == nil
  @h[name][:stdout].grep(/^.*#{text}/).should be_empty
end


ならば /^"([^"]*)ファイル"に以下の順で出力されていること$/ do |name, expected_table|
  assert_output(@h[name][:read_lines], expected_table)
end

ならば /^"([^"]*)"の標準出力に以下の順で出力されていること$/ do |name, expected_table|
  assert_output(@h[name][:stdout], expected_table)
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
# 引数 lines はログの1行分の文字列配列
def assert_output(lines, expected_table) 
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
  lines.each do |line|
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

前提 /^(.*ファイル)"([^"]*)"が以下の内容で存在する$/ do |name, file_path, text|
  dirname = File.dirname(file_path)
  Dir.mkdir(dirname) unless FileTest.exists?(dirname)
  FileUtils.touch(file_path)
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

def purge_queue(queue_name)
  AMQP.start(@mq_server) do |connection|
    channel  = AMQP::Channel.new(connection)
    queue = channel.queue(queue_name, durable:true)
    queue.purge
    EM.add_timer(1) do
      connection.close { EventMachine.stop }
    end
  end
end

def get_pid_from_stdout(name,pid_regexp, options = {})
  timeout = options[:timeout] || 20

  get_pid = false

if @h[name][:io]
  time_out(timeout) {
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
else
  puts "PTYから pid をとる"
  time_out(timeout) {
    count = 1
#    while true
      puts "count:#{count}"
      @h[name][:stdout].each do |line|
      puts " ====> #{line}"
        get_pid = line.match(pid_regexp)
        if get_pid then
          pid = line.match(pid_regexp)[1]
          @h[name][:pid] = pid
          break
        end
      end
      count = count + 1
      sleep 1
#    end
  }
end

  get_pid
end

def get_pid_from_file(name, file_path)
  pid = nil
  while  true
    sleep 1
    if File.exist?(file_path) 
      pid = `cat #{file_path}`.chomp
      @h[name][:pid] = pid
      break
    end
  end
  pid
end

# psコマンドを利用してPIDを取得する
def get_pid_from_ps(name)
  get_pid = false
  command = "ps aux | grep \"" + @h[name][:command]  + "\" | grep -v grep "
  puts "command:#{command}"
  IO.popen(command) { |io|
    if line = io.gets
      puts " => #{line}"
      @h[name][:pid] = line.split(" ")[1]
      get_pid = true
    end
  }
  get_pid
end

def contains_message_from_stdout(name,word, options = {})
  timeout = options[:timeout] || 30
  match = nil

# IOがあればこれまで通り
if @h[name][:io]
  @h[name][:stdout].each do |line|
    puts "既に:#{line}"
    match = line.match(/^.*#{word}.*/)
    break if match
  end
  unless match
    time_out(timeout) do
      while line = @h[name][:io].gets
#        puts line  TODO
        @h[name][:stdout] << line
        match = line.match(/^.*#{word}.*/)
        if match
          puts "match:#{word}"
          break
        end
      end
    end
  end

# なければPTYをつかってる
else 

  time_out(timeout) do
  while true
    @h[name][:stdout].each do |line|
      puts line
      @h[name][:stdout] << line
      match = line.match(/^.*#{word}.*/)
      if match
        puts "match:#{word}"
        break
      end
    end
    if match
      puts "match:#{word}"
      break
    end
    sleep 1
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

もし /^(.*)秒間待機する$/ do |time|
  sleep time.to_i
end


前提 /^Tengineを使ったアプリケーションのプロジェクトを"([^"]*)"に新規で作成する$/ do |path|
  FileUtils.rm_rf(path) if FileTest.exists?(path)
  # プロジェクトのディレクトリ構造を作成します。
  FileUtils.mkdir_p(path)
  FileUtils.mkdir_p("#{path}/app")
  FileUtils.mkdir_p("#{path}/spec/support")
end


前提 /^テンプレートジョブが1件も登録されていない$/ do
  Tengine::Job::RootJobnetTemplate.delete_all
end

前提 /^実行ジョブが1件もない$/ do
  Tengine::Job::Execution.delete_all
end

前提 /^イベントが1件もない$/ do
  Tengine::Core::Event.delete_all 
end

前提 /^仮想サーバがインスタンス識別子:"([^"]*)"で登録されていること$/ do |server_name|
  server_config = end_to_end_test_yaml["servers"][server_name]
  addresses = server_config["addresses"]
  unless Tengine::Resource::VirtualServer.first(conditions:{name:server_name})
    s = Tengine::Resource::VirtualServer.create!(name:server_name, addresses:addresses, properties: {})
    puts "create server => #{s.inspect}"
  end
end

前提 /^認証情報が名称:"([^"]*)"で登録されている$/ do |credential_name|
  credential_config = end_to_end_test_yaml["credentials"][credential_name]
  auth_type_key = credential_config["auth_type_key"].to_sym
  user = credential_config["user"]
  password = credential_config["password"]
  unless Tengine::Resource::Credential.first(conditions:{name:credential_name})
     c = Tengine::Resource::Credential.create!(name:credential_name, auth_type_key: auth_type_key, auth_values: {"username"=>user, "password"=>password})
     puts "create credential => #{c.inspect}"
  end
end

もし /^ジョブネット"([^"]*)"を実行する$/ do |name|
  template = Tengine::Job::RootJobnetTemplate.first(conditions: {name:name})
  raise "RootJobnetTemplate が取得できませんでした。 name => #{name}" unless template
  execution = nil
  EM.run{ execution = template.execute(:sender => Tengine::Event) }
  root_jobnet = execution.root_jobnet

  CucumberSession.session["execution"] = execution
  CucumberSession.session["root_jobnet"] = root_jobnet
  CucumberSession.session["element_ids"] = {}

end


def jobnet_finished_confirme(name, time)
  time_out(time) do
    while true
      root_jobnet = CucumberSession.session["root_jobnet"]
      root_jobnet.reload
      phase_key = root_jobnet.phase_key
      puts "root_jobnet.phase_key => #{phase_key}"
      break if phase_key.match(/success|error/)
      sleep 1
    end
  end
end

もし /^ジョブネット"([^"]*)"が完了することを確認する$/ do |name|
  # jobnet_finished_confirme(name, 60)
  jobnet_finished_confirme(name, 20)
end

もし /^ジョブネット"([^"]*)"が完了することを確認する。少なくとも([^"]*)秒間は待つ。$/ do |name, time|
  jobnet_finished_confirme(name, time.to_i)
end

ならば /^ジョブネット"([^"]*)" のステータスが([^"]*)であること$/ do |path, status|
  root_jobnet = CucumberSession.session["root_jobnet"]
  jobnet = root_jobnet.vertex_by_name_path(path)
  raise "ジョブネット #{path} は存在しません。" unless jobnet
  case status
  when "初期化済"
    jobnet.phase_key.should == :initialized
  when "正常終了"
    jobnet.phase_key.should == :success
  when "エラー終了"
    jobnet.phase_key.should == :error
  else
   raise "#{status}はstep定義でサポートしていないステータスです。"
  end
end

ならば /^ジョブ"([^"]*)" のステータスが([^"]*)であること$/ do |path, status|
  root_jobnet = CucumberSession.session["root_jobnet"]
  job = root_jobnet.vertex_by_name_path(path)
  raise "ジョブ #{path} は存在しません。" unless job
  case status
  when "初期化済"
    job.phase_key.should == :initialized
  when "準備中"
    job.phase_key.should == :ready
  when "開始中"
    job.phase_key.should == :starting
  when "実行中"
    job.phase_key.should == :running
  when "強制停止中"
    job.phase_key.should == :dying
  when "状態不明"
    job.phase_key.should == :stuck
  when "正常終了"
    job.phase_key.should == :success
  when "エラー終了"
    job.phase_key.should == :error
  else
   raise "#{status}はstep定義でサポートしていないステータスです。"
  end
end


もし /^"([^"]*)"の標準出力からPIDを確認する$/ do |name|
  if name == "Tengineコアプロセス"
    # ログのヘッダにPIDが出力される [2011-11-21T18:03:33.543749 #42686]
    pid_regexp = /\s#(\d+)]/
    get_pid = get_pid_from_stdout(name, pid_regexp)
    get_pid.should be_true
  else
    raise "サポートしてません"
  end
end


もし /^"([^"]*)"の状態が"([^"]*)"であることを確認する$/ do |name, status_name|
  raise "#{name}のPIDが取得できていません。" unless pid = @h[name][:pid]
  status = nil

  case status_name
  when "初期化済み"
    status = "initialized"
  when "起動中"
    status = "starting"
  when "稼働要求待ち"
    status = "waiting_activation"
  when "稼働中"
    status = "running"
  when "停止中"
    status = "shutting_down"
  when "停止済"
    status = "terminated"
  else
    raise "サポートしてません"
  end

  time_out(10) do
    while true
      command = "tengined -k status | grep #{pid} | awk '{print $2}'"
      puts "command:#{command}"
      s = `#{command}`.chomp
      puts "#{name} status => #{s}"
      break if s == status
      sleep 1
    end
  end
end

ならば /^"([^"]*)"の状態が"([^"]*)"であること$/ do |name, status_name|
   もし %{"#{name}"の状態が"#{status_name}"であることを確認する}
end


前提 /^イベントキューにメッセージが1件もない$/ do
  purge_queue("tengine_event_queue")
end


前提 /^仮想サーバ"([^"]*)"のファイル:"([^"]*)"が存在しないこと$/ do |server_name, file_path|
  server_config = end_to_end_test_yaml["servers"][server_name]
  host = server_config["host"]
  user = server_config["user"]
  password = server_config["password"]
  ssh_opts = {:password => password}
  ssh = SSH.new(host, user, nil, ssh_opts)
  command = "rm -f #{file_path}"
  output = nil
  ssh.open do |session|
    output = session.exec(command)
  end
end

require 'net/ssh'

もし /^仮想サーバ"([^"]*)"のファイル"([^"]*)"を開く。このファイルを"([^"]*)"と呼ぶこととする。$/ do |server_name, file_path, file_name|
  @h[file_name] = []
  server_config = end_to_end_test_yaml["servers"][server_name]
  host = server_config["host"]
  user = server_config["user"]
  password = server_config["password"]
  ssh_opts = {:password => password}
  ssh = SSH.new(host, user, nil, ssh_opts)
  command = "cat ~/tengine_job_test.log"
  output = nil
  ssh.open do |session|
    output = session.exec(command)
  end
  @h[file_name] = output.split(/\n/) if output

  # TODO 環境変数をログから確認するstep定義は別で作成する
#  key_reader(file_name)
end

ならば /^"([^"]*)"の"([^"]*)"の値が"([^"]*)"であること$/ do |job_name, key, value|
  @h[job_name][key].should_eql value
end

ならば /^"([^"]*)"の"([^"]*)"の値が"([^"]*)"で区切られていること$/ do |job_name, key, separator|
  @h[job_name][key].include?(separator).should be_true
end

#以下のようなパターンからジョブ名、環境変数名、環境変数の値を抜き出します
#Thu Nov 24 18:49:26 JST 2011 <47889> job1 MM_FAILED_JOB_ANCESTOR_IDS:
#Thu Nov 24 18:49:29 JST 2011 <48067> jobnet1048_finally MM_ACTUAL_JOB_ANCESTOR_IDS: 4ece1322cd67c8ba61000003;4ece1322cd67c8ba6100000b
def key_reader(file_name)
 ids_reader(file_name, "MM_ACTUAL_JOB_NAME_PATH")
 ids_reader(file_name, "MM_ACTUAL_JOB_ANCESTOR_IDS")
 ids_reader(file_name, "MM_TEMPLATE_JOB_ANCESTOR_IDS")
 ids_reader(file_name, "MM_FULL_ACTUAL_JOB_ANCESTOR_IDS")

  @h[file_name].each do|line|
    if /> (.*) (.*):(.*)$/ =~ line
      env = $3.slice(1,env.size) unless $3.size == 0
      if $2 == "MM_SCHEDULE_ID"
        @h["MM_SCHEDULE_ID"] = env
      else
        @h[$1] = {}
        @h[$1][$2] = env
      end
    end
  end
end

def ids_reader(file_name, ids_key)
  separator = nil
  if ids_key == "MM_ACTUAL_JOB_NAME_PATH"
    separator = "/"
  else
    separator = ";"
  end
  @h[file_name].each do|line|
    if /> (.*) (.*):(.*)$/ =~ line
      if ids_key == $2
        env = $3.slice(1,env.size) unless $3.size == 0
        @h[file_name][ids_key] = [] if @h[file_name][ids_key]
        env_split = env.split(separator)
        env_split.each_with_index do |path, index|
          path = env_split[index-1] << "/" << path  if path == "finally"
          @h[file_name][ids_key].add(path) if @h[file_name][ids_key].include?(path)
        end
      end
    end
  end
end

ならば /^"([^"]*)"と"([^"]*)"の先頭に出力されていること$/ do |text, file_name|
  raise "先頭は\"#{text}\"ではなく、\"#{@h[file_name].first}\"です。" unless @h[file_name].first =~ /#{text}/
end

ならば /^"([^"]*)"と"([^"]*)"に出力されていること$/ do |text, file_name|
  raise "\"#{text}\"は含まれていません。" unless text_exist?(text, @h[file_name])
end

ならば /^"([^"]*)"と"([^"]*)"に出力されていないこと$/ do |text, file_name|
  raise "\"#{text}\"が含まれています。" if text_exist?(text, @h[file_name])
end

def text_exist?(text, lines) 
  lines.each do |line|
     return true if line =~ /#{text}/
  end 
  return false
end

def get_line_no(text, lines) 
  line_no = nil
  lines.each_with_index do |line, index| 
    if line =~ /#{text}/
      line_no = index
      break
    end
  end
  line_no
end

ならば /^"([^"]*)"と"([^"]*)"に出力されており、"([^"]*)"の前であること$/ do |text, file_name, after_text|
  lines = @h[file_name]

  text_line_no = get_line_no(text, lines)
  raise "\"#{text}\"は出力されていません。" unless text_line_no

  after_line_no = get_line_no(after_text, lines)
  raise "\"#{after_text}\"は出力されていません。" unless after_line_no

  raise " \\"#{after_text}\"の前に\"#{text}\"は出力されていません。 " unless (text_line_no < after_line_no)
end

ならば /^"([^"]*)"と"([^"]*)"に出力されており、"([^"]*)"の後であること$/ do |text, file_name, before_text|

  lines = @h[file_name]

  before_line_no = get_line_no(before_text, lines)
  raise "\"#{before_text}\"は出力されていません。" unless before_line_no

  text_line_no = get_line_no(text, lines)
  raise "\"#{text}\"は出力されていません。" unless text_line_no

  raise " \"#{before_text}\"の後に\"#{text}\"は出力されていません。 " unless (before_line_no < text_line_no)
end


ならば /^"([^"]*)"と"([^"]*)"に出力されており、"([^"]*)"と"([^"]*)"の間であること$/ do |text, file_name, before_text, after_text|

  lines = @h[file_name]

  before_line_no = get_line_no(before_text, lines)
  raise "\"#{before_text}\"は出力されていません。" unless before_line_no

  text_line_no = get_line_no(text, lines)
  raise "\"#{text}\"は出力されていません。" unless text_line_no

  after_line_no = get_line_no(after_text, lines)
  raise "\"#{after_text}\"は出力されていません。" unless after_line_no

  raise " \"#{before_text}\"と\"#{after_text}\"の間に\"#{text}\"は出力されていません。 " unless (before_line_no < text_line_no && text_line_no < after_line_no)

end

ならば /^"([^"]*)"と"([^"]*)"の末尾に出力されていること$/ do |text, file_name|
  raise "末尾は\"#{text}\"ではなく、\"#{@h[file_name].last}\"です。" unless @h[file_name].last =~ /#{text}/
end



もし /^実行ジョブ"([^"]*)"のExecutionを"([^"]*)"と呼ぶことにする$/ do |actual_job_name, element_name|
    CucumberSession.session["element_ids"][element_name] = CucumberSession.session["execution"]
end

もし /^実行ジョブ"([^"]*)"の(ルートジョブネット|スタート|エッジ|ジョブ|エンド)"([^"]*)"を"([^"]*)"と呼ぶことにする$/ do |actual_job_name, element_type_name, notation_or_execution, element_name|
puts "------------"
puts actual_job_name
puts notation_or_execution
puts element_name
puts "------------"
    CucumberSession.session["element_ids"][element_name] = CucumberSession.session["root_jobnet"].element notation_or_execution
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"と出力されていること$/ do |name, text|
  pending
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"と出力されており、"([^"]*)"の後であること$/ do |name, text, before_text|
  pending
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"とイベントを受け取った情報が出力されていること$/ do |name, text|
  pending
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"とイベントを受け取った情報が出力されており、"([^"]*)"の後であること$/ do |name, text, before_text|
  pending
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"とジョブのフェーズが変更した情報が出力されていること$/ do |name, text|
  assert_output_for_application_log(name, text)
end

ならば /^"([^"]*)"のアプリケーションログに"([^"]*)"とジョブのフェーズが変更した情報が出力されており、"([^"]*)"の後であること$/ do |name, text, before_text|
  assert_output_and_before_output_for_application_log(name, text, before_text)
end

def assert_output_for_application_log(name, text)
  # 置換する文字を取り出す
  element_name = text.match(/\#{(.*)}/)[1]
  element = CucumberSession.session["element_ids"][element_name]
# execution phase changed. <4eca2fe642d9eb072600000a> initialized -> ready
# job phase changed. <4eca2fe642d9eb0726000006> starting -> running
  text = text.gsub(/\#{.*}/, "<#{element.id.to_s}>")
  match = contains_message_from_stdout(name, text)
  match.should be_true
end

def assert_output_and_before_output_for_application_log(name, text, before_text)
  before_element_name = before_text.match(/\#{(.*)}/)[1]
  before_element = CucumberSession.session["element_ids"][before_element_name]
  before_text = before_text.gsub(/\#{.*}/, "<#{before_element.id.to_s}>")

  element_name = text.match(/\#{(.*)}/)[1]
  element = CucumberSession.session["element_ids"][element_name]
  text = text.gsub(/\#{.*}/, "<#{element.id.to_s}>")

  lines = @h[name][:stdout]

  before_line_no = get_line_no(before_text, lines)
  raise "\"#{before_text}\"は出力されていません。" unless before_line_no

  text_line_no = get_line_no(text, lines)
  raise "\"#{text}\"は出力されていません。" unless text_line_no

  raise " \"#{before_text}\"の後に\"#{text}\"は出力されていません。 " unless (before_line_no < text_line_no)
end
