After do |s|
  IO.popen("ps -e |grep tengined|grep -v grep |awk '{print $1}' |xargs kill -9")
  IO.popen("ps -e |grep \"mongod --port 21039\" |grep -v grep|awk '{print $1}' |xargs kill -2")
end
