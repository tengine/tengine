# -*- coding: utf-8 -*-
# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

# エンドツーエンドテストは production モードで実行する
ENV["RAILS_ENV"] = 'production'

# エンドツーエンドテストの設定ファイル
end_to_end_test_yaml = YAML::load(IO.read('config/end_to_end_test.yml'))

# features/support/lib を $LOAD_PATH に追加
$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))

require 'mongodb_support'
MongodbSupport.nodes end_to_end_test_yaml["db"]["nodes"]

require 'tengine/core'

require 'cucumber_session'
# MongoDBが上がっていないとcucumber/railsをロードするところで落ちるの起動する
MongodbSupport.start_mongodb(CucumberSession.session, "DBプロセス") unless MongodbSupport.running?

require 'cucumber/rails'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
#begin
  # DatabaseCleaner.strategy = :transaction
#  DatabaseCleaner.strategy = :truncation
#rescue NameError
#  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
#end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#




Capybara.configure do |config|
  config.run_server = false
  tengine_console = end_to_end_test_yaml['tengine_console']
  if tengine_console['port']
    config.app_host = "#{tengine_console['host']}:#{tengine_console['port']}"
  else
    config.app_host = tengine_console['host']
  end
end 


# cucumber のオプション --format に junit を指定すると、xml形式のリポートファイルを出力しますが、
# feature名が長過ぎるとファイルシステムが設けているファイル名サイズの制約でエラーにならないようになるため、
# その場合、切り詰めたファイル名にするモンキーパッチをあてます。
# ファイルシステムはext4を想定しているため255byteに切り詰めます
#  参考:http://en.wikipedia.org/wiki/Comparison_of_file_systems#Limits
require 'cucumber/formatter/junit'
module Cucumber
  module Formatter
    class Junit
      # リポートファイル名を取得する拡張対象のメソッドです
      def feature_result_filename(feature_file)
        reduce_file_path(File.join(@reportdir, "TEST-#{basename(feature_file)}.xml"))
      end

      def reduce_file_path(file_path)
        return file_path if File::basename(file_path).bytesize <= 255
        # ファイル名の拡張子以外の部分を末尾から1文字ずつ切り詰める
        non_ext_file_name = File::basename(file_path, '.xml')
        reduce_file_path("#{File::dirname(file_path)}/#{non_ext_file_name[0, non_ext_file_name.length - 1]}.xml")
      end
    end
  end
end




at_exit do
  # 全てのテストが終了したら rails をkillする。
  rails_kill_command = "ps aux | grep 'script/rails' | grep -v grep | awk '{print $2}' | xargs kill -9"
  puts "command : #{rails_kill_command}"
  system(rails_kill_command)
end