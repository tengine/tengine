Before do |s|
  `touch ~/test_before1`
  IO.popen("ps -e |grep \"mongod --port 21039\" |grep -v grep|awk '{print $1}' |xargs kill -2")
  IO.popen("rm -rf  ~/tmp/mongodb_test/tengine_production.*")
end
After do |s|
  `touch ~/after_c2`
  IO.popen("ps -e |grep tengined|grep -v grep |awk '{print $1}' |xargs kill -9")
  IO.popen("ps -e |grep \"mongod --port 21039\" |grep -v grep|awk '{print $1}' |xargs kill -2")
end
