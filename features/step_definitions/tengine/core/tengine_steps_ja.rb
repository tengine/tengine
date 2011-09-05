# -*- coding: utf-8 -*-

# インストール、セットアップ関係は優先度を下げるため後ほど実装する
前提 /^"([^"]*)パッケージ"のインストールおよびセットアップが完了している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)プロセス"が起動している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)プロセス"が停止している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

もし /^"([^"]*)"を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  @io = IO.popen(command)
end

もし /^"([^"]*)"の起動を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  io = IO.popen(command)
  @h = {} 
  @h[name] = {:io => io}
end

# TODO 動作未確認
ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/ do |name, word|
  while line = @h[name][:io].gets
    if line.match(word) then
      break
    end
  end
end

ならば /^"([^"]*)"の標準出力からPIDを確認することができること$/ do |name|
  # TODO Tengineコアをフォアグラウンド起動した際に標準出力が決まっていないので、PIDの取得部分は暫定的に正規表現で数値を引っこ抜いている
  pid_regexp = /PID:(\d+)/
  while line = @h[name][:io].gets
    if line.match(pid_regexp) then
      pid = line.match(pid_regexp)[1]
      @h[name][:pid] = pid
      break
    end
  end
end

ならば /^"([^"]*)"が起動していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  system(exec_command).should be_true
end

ならば /^"([^"]*)"が停止していることをPIDを用いて"([^"]*)"というコマンドで確認できること$/ do |name,  command|
  pid = @h[name][:pid]
  exec_command = "#{command.gsub(/PID/, pid)} > /dev/null"
  system(exec_command).should be_false
end

もし /^"([^"]*)プロセス"を Ctl\+c で停止する$/ do |name|
  pid = @h[name][:pid]
  exec_command = "kill -2 #{pid} > /dev/null"
  system(exec_command)
end

もし /^"([^"]*)プロセス"を強制停止する$/ do |arg1|
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

# TODO
もし /^Tengineコアの設定ファイル"([^"]*)"を作成する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

# TODO
もし /^不正なTengineコアプロセスの設定ファイル"([^"]*)"を修正する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

前提 /.*イベントハンドラ定義"([^"]*)"が登録されている$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

もし /^"([^"]*)"へ問い合わせる$/ do
#  pending # express the regexp above with the code you wish you had
end

もし /^"([^"]*)"イベントを発火する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
