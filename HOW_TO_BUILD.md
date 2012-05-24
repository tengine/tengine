# How to build Tengine gems

## Requirements

### Max OS X

* [RVM](https://rvm.io//)
* [MongoDB 2.0.x](http://www.mongodb.org/display/DOCS/Quickstart+OS+X)
* [RabbitMQ 2.4.x](http://www.rabbitmq.com/install-homebrew.html)

## Usage

### 6 steps for first build and test

    $ rvm install ruby-1.9.3-head
    $ git clone git@github.com:tengine/tengine.git
    $ cd tengine
    $ rake gemsets:create
    $ rake rebuild
    $ rake spec

### パッケージをテスト(tengine_coreでの例)

    $ cd path/to/tengine/tengine_core
    $ rake spec

### パッケージをビルド(tengine_coreでの例)

    $ cd path/to/tengine/tengine_core
    $ rake gem

### 変更が他のパッケージに影響しているかをテスト

    $ cd path/to/tengine
    $ rake rebuild
    $ rake spec

### バージョンを上げてビルドしてテスト

    $ cd path/to/tengine
    $ rake version:inc
    $ rake rebuild
    $ rake spec

## Memo

### rvm gemset

各gemのパッケージをビルドする環境それぞれについて、それと同じ名前のgemsetを作成して使用することを前提にしています。
例えばtengine/tengine_coreならば tengine_core という名前のgemsetを使います。

これは tengine/Rakefile が提供するタスクのための規則であり、必要に応じて変更することは可能です。

#### 一括削除

    $ rake gemsets:delete

各パッケージ用のgemsetを削除します

#### 一括作成

    $ rake gemsets:create

各パッケージ用のgemsetを作成して、各パッケージ用の.rvmrcを生成します。
