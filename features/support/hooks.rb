Before do |s|
  ENV.delete("RAILS_ENV") #削除しないとrails s -e productionで起動してもtestの設定で起動してしまう
  system("ps -e |grep \"mongod --port 21039\" |grep -v grep|awk '{print $1}' |xargs kill -2")
  system("ps -e |grep \"ruby script/rails s -e production\" |grep -v grep|awk '{print $1}'|xargs kill -9")
  system("rm -rf  ~/tmp/mongodb_test/tengine_production.*")
end
After do |s|
  system("ps -e |grep tengined|grep -v grep |awk '{print $1}' |xargs kill -9")
  system("ps -e |grep \"mongod --port 21039\" |grep -v grep|awk '{print $1}' |xargs kill -2")
end
