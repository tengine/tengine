#language:ja
機能: アプリケーション開発者がとても時間がかかるジョブネット定義を試してみる

  背景:
    前提 "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ テンプレートジョブが1件も登録されていない
    かつ 実行ジョブが1件もない
    かつ イベントが1件もない
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ イベントキューにメッセージが1件もない

  @1016
  シナリオ: [正常系]1016_Asakusaが出力したジョブネットを試してみる

		前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1016_large_and_complicated_jobnet_asakusa -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"expand_root_jobnet.001"を実行する
    かつ ジョブネット"expand_root_jobnet.001"が完了することを確認する。およそ1800秒間は待つ。

    ならば ジョブを実行してから、最初のジョブが実行されるまでの時間が1分以内であること
    ならば ジョブネット"/expand_root_jobnet.001" のステータスが正常終了であること


  # ./usecases/job/dsl/1045_long_time_job.rb
	#  -------------------
  # 
  # require 'tengine_job'
  # 
  # jobnet("jobnet1045", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("job1")
  #   job("job1", "$HOME/tengine_job_test.sh 3600 job1"
  # end
  #  -------------------
	@1045
  シナリオ: [正常系]1045_とても時間がかかるジョブ_を試してみる

		前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1045_long_time_job.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
		もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
		
    もし ジョブネット"jobnet1045"を実行する
    かつ ジョブネット"jobnet1045"が完了することを確認する。少なくとも3600秒間は待つ。
		
    ならば ジョブネット"/jobnet1045" のステータスが正常終了であること
    かつ ジョブ"/jobnet1045/job1" のステータスが正常終了であること

		もし 仮想サーバ"test_server1"のファイル"~/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test job1 start"と"スクリプトログ"の先頭に出力されていること
    かつ "tengine_job_test job1 finish"と"スクリプトログ"の末尾に出力されていること

