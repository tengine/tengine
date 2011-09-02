# -*- coding: utf-8 -*-
前提 /^"([^"]*)"パッケージのインストールおよびセットアップが完了している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"のインストールおよびセットアップが完了している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"プロセスが起動している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end

前提 /^"([^"]*)"プロセスが停止している$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
end


もし /^"([^"]*)"を行うために"([^"]*)"というコマンドを実行する$/ do |name, command|
  io = IO.popen(command)
  @stdout = ""
  io = IO.popen(command)
  while line = io.gets
    if line.empty? then
      break
    end
    @stdout << line
  end
end

ならば /^"([^"]*)"の標準出力に"([^"]*)"と出力されていること$/ do |name, stdout|
  @stdout.should match(/#{stdout}/)
end

#もし /^"([^"]*)"を起動するために"([^"]*)"というコマンドを実行する$/ do |arg1, arg2|
#  pending # express the regexp above with the code you wish you had
#end

ならば /^"([^"]*)"の標準出力からPIDを確認することができること$/ do |name|
  @pid = @stdout.match(/\d+/)[0]
  @pid.should_not be_empty
end

ならば /^"([^"]*)"が起動していることを"([^"]*)"で確認できること$/ do |name, command|
  result = `#{command.gsub(/PID/, @pid)}`
  result.should match(/#{@pid}/)
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

もし /^"([^"]*)"プロセスを Ctl\+c で停止する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

ならば /^"([^"]*)"が停止していることを"([^"]*)"で確認できること$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

もし /^"([^"]*)"を Ctl\+c で停止する$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
