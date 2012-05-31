# -*- coding: utf-8 -*-
require 'mongodb_support'

Before do |s|
  # rails
#  ENV.delete("RAILS_ENV") #RAILS_ENVの値を削除しないとrails s -e productionで起動してもtestの設定で起動してしまう

#  system("ps -e |grep \"ruby script/rails s -e production\" |grep -v grep|awk '{print $1}'|xargs kill -9")
#  system("rm -rf  ~/tmp/mongodb_test/tengine_production.*")

  # MongoDB
#  MongodbSupport.kill
#  MongodbSupport.rm_mongo_lock

end
After do |s|
  # CentOSの環境では、シナリオが終了した後にrailsが停止しなかったので暫定的にここでkillします。
#  system("ps aux | grep 'script/rails' | grep -v grep | awk '{print $2}' | xargs kill -9")

  system("ps -e |grep tengined|grep -v grep |awk '{print $1}' |xargs kill -9")

  # MongoDB
#  MongodbSupport.kill
#  MongodbSupport.rm_mongo_lock

end

#at_exit do
# examples =  Dir::entries("../tengine_core/examples")
# failure_examples =  Dir::entries("../tengine_core/failure_examples")
# only_features =  Dir::entries("uscases/core/dsls")
# dsls = examples + failure_examples + only_features 
#end
