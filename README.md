# Welcome to Tengine

## 概要

Tengineは単一障害点のないジョブを実現するための実行エンジンと、ジョブの実行のためのDSLを提供します。

実行エンジンは、AMQPとMongoDBを用いたメッセージングの仕組みで、イベントドリブンな制御を行うことができます。この制御のためにジョブ用のDSLとは別の基盤となるDSLも提供します。

## 利用方法

[Tengine framework Guide](http://tengine.github.com/) をご覧ください。


## 構成

### tengine_ui

ジョブの実行やリソースの管理を行うためのUIを提供します。

### tengine_job

ジョブの実行の制御とそのためのDSLを提供します。

### tengine_job_agent

ジョブを実行する際に実行環境を制御するためのエージェントです。

### tengine_resource

ジョブの実行などで使用されるリソースの制御のためのライブラリです。

### tengine_resource_ec2

AWS EC2を用いたリソースの制御のためのライブラリです。

### tengine_resource_wakame

Wakameを用いたリソースの制御のためのライブラリです。


### tengine_core

tengineの中心機能であるイベントハンドリングの機能とDSLを提供します。

### tengine_event

tengineで制御するイベントを発火するためのライブラリです。

### tengine_rails_plugin

Railsアプリからtengineのイベントを簡単に発火するためのライブラリです。


### tengine_support

tengineで使用する汎用的な機能を集めたライブラリです。





## 各gemのビルド

[How to build Tengine gems](https://github.com/tengine/tengine/blob/develop/HOW_TO_BUILD.md) をご覧ください。


## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## License

Tengine's gems are distributed under the MPL2.0 or LGPLv3 or the dual license of MPL2.0/LGPLv3

## Copyright
Copyright (c) 2012 - 2013 Groovenauts, Inc.
