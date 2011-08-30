#language:ja
機能: アプリケーション開発者が開発環境へインストールする
  [Tengineの評価や, イベントハンドラ定義を作成]するために
  [アプリケーション開発者]
  は [Tengineコア, Tengineコンソール, DB, キューをインストール] したい


  シナリオ: アプリケーション開発者が開発環境へインストールする_案1
      前提 OSの種類は"Macintosh"である
	    もし 次のコマンドを実行しMongoDBをインストールする
        $ wget http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.3.tgz /tmp/mongodb-osx-x86_64-1.8.3.tgz
        $ tar zxvf /tmp/mongodb-osx-x86_64-1.8.3.tgz
        $ mv /tmp/mongodb-osx-x86_64-1.8.3.tgz /usr/local/
        $ ln -s /usr/local/mongodb-osx-x86_64-1.8.3.tgz /usr/local/mongodb
			かつ ユーザログインシェルに以下を追記する # .bashrcを想定
        export MONGODB_HOME=/usr/local/mongodb
        export PATH=$PATH:$MONGODB_HOME/bin
      かつ ユーザログインシェルの再読み込みを行う
      かつ 次のコマンドを実行してアーカイブを削除する
        $  rm mongodb-linux-x86_64-1.6.5.tgz
			かつ 次のコマンドを実行してMongoDBの起動を行う
			  $ mongod --dbpath ~/mongodb --fork --logpath ~/mongodb/mongodb.log
      # (以下省略します)

			
  シナリオ: アプリケーション開発者が開発環境へインストールする_案2
      前提 OSの種類は"Macintosh"である
      もし "http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.3.tgz"から"/tmp"に"mongodb-osx-x86_64-1.8.3.tgz"というファイル名でダウンロードする
      かつ "/tmp/mongodb-osx-x86_64-1.8.3.tgz"を解凍する
			かつ "/tmp/mongodb-osx-x86_64-1.8.3"を"/usr/local/"に移動する
			かつ "/usr/local/mongodb-osx-x86_64-1.8.3"から"/usr/local/mongodb"というシンボリックリンクを作成する # 表現がおかしいかも
      # (以下省略します)

			# 所感：実行したいコマンドをCucumberで書いただけになってしまい、とても読み辛い。

			
  シナリオ: アプリケーション開発者が開発環境へインストールする_案3
      前提 OSの種類は"Macintosh"である
			かつ OSのバージョンは"Mac OS X"である

			# 以下は変数の定義をしていると思ってください
			かつ "MongoDBのアーカイブ"は"mongodb-osx-x86_64-1.8.3.tgz"である
			かつ "MongoDBの展開ファイル"は"mongodb-osx-x86_64-1.8.3"である
      かつ "MongoDBのアーカイブのURL"は"http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.3.tgz"である
      かつ "MongoDBのインストールディレクトリ"は"/usr/local/mongodb"である
      かつ "MongoDBのデータディレクトリのパス"は"~/mongodb"である
      かつ "MongoDBのログファイルのパス"は"~/mongodb/mongodb.log"である
      かつ "MongoDBのポート"は"27071"である
			かつ "作業ディレクトリ"は"/tmp"
			
			もし "MongoDBのアーカイブのURL"から"作業ディレクトリ"へ"MongoDBのアーカイブ"というファイル名でダウンロードする
			かつ "作業ディレクトリ"の"MongoDBのアーカイブ"を"MongoDBの展開ファイル"という名前で解凍する
			かつ "MongoDBの展開ファイル"を"MongoDBのインストールディレクトリ"に移動する
      かつ MongoDBの

  シナリオ: アプリケーション開発者が開発環境へインストールする_案4
      前提 OSの種類は"Macintosh"である
			# 以下は変数の定義をしていると思ってください
			かつ "MongoDBのアーカイブ"は"mongodb-osx-x86_64-1.8.3.tgz"である
			かつ "MongoDBの展開ファイル"は"mongodb-osx-x86_64-1.8.3"である
      かつ "MongoDBのアーカイブのURL"は"http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.3.tgz"である
      かつ "MongoDBのインストールディレクトリ"は"/usr/local/mongodb"である
      かつ "MongoDBのデータディレクトリのパス"は"~/mongodb"である
      かつ "MongoDBのログファイルのパス"は"~/mongodb/mongodb.log"である
      かつ "MongoDBのポート"は"27071"である
			かつ "作業ディレクトリ"は"/tmp"

			# 「開発環境にDBのインストールを行う」というstep定義の中で
			# 前提で定義した変数を参照し、インストールの手順を実行する。
			# もしくは、変数の定義を別の場所で行う。例えば、設定ファイルなど。「Mac版のMongoDBのURLは"http://~~~"」など
      もし 開発環境にDBのインストールを行う
			
      かつ 開発環境でDBのプロセスを起動する
      ならば 開発環境のDBのプロセスが起動している

			

-----------------------------------			

      前提 OSの種類は"Macintosh"である
			かつ OSのバージョンは"Mac OS X"である
			かつ OSのビット幅は"64bit"である
			かつ "Ruby"のバージョンは"1.9.2"である
			かつ "Rubygems"のバージョンは"1.5.0"である
			かつ "Tengineコア"のバージョンは"1.0.0"である
			かつ "Tengineコンソール"のバージョンは"1.0.0"である
			かつ "MongoDB"のバージョンは"1.8.3"である

      かつ "MongoDBのアーカイブをダウンロードするURL"は"http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.3.tgz"である
      かつ "MongoDBのインストールディレクトリ"は"/usr/local/mongodb"である
      かつ "MongoDBのデータディレクトリのパス"は"~/mongodb"である
      かつ "MongoDBのログファイルのパス"は"~/mongodb/mongodb.log"である
      かつ "MongoDBのポート"は"27071"である
			かつ "Erlang"のバージョンは"R14B03"である
			かつ "RabbitMQ"のバージョンは"2.5.1"である
			かつ "RabbitMQをDLするURL"は"http://www.rabbitmq.com/releases/rabbitmq-server/v2.5.1/rabbitmq-server-2.5.1.tar.gz"である
      かつ "RabbitMQのインストールディレクトリ"は"/usr/local/rabbitmq"である
      かつ "RabbitMQのポート"は"5672"である
