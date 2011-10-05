#language:ja
機能: アプリケーション開発者が開発環境でTengineコア、Tengineコンソールを起動し、接続テストを行い、停止する2

  シナリオ: sample
      もし "接続テスト"を行うために"tengined -k test -f ./features/config/tengine.yml"というコマンドを実行する
      ならば "接続テスト"の標準出力に"Connection test success."と出力されていること
