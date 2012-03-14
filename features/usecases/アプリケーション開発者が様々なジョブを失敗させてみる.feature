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

  @01_02_01
  シナリオ: [正常系]1つのジョブが含まれるジョブネットが失敗
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/01_02_01_one_job_in_jobnet_failure.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし ジョブネット"jobnet1101"を実行する
    かつ ジョブネット"jobnet1101"が完了することを確認する
    
    ならば ジョブネット"/jobnet1101" のステータスがエラー終了であること

    もし ジョブ"/jobnet1101/job1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    かつ "tengine_job_failure_test job1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_failure_test job1 finish"と"スクリプトログ"に出力されており、"tengine_job_failure_test job1 start"の後であること


  # ../tengine_job/examples/0004_retry_one_layer.rb
  #  -------------------
  #  # -*- coding: utf-8 -*-
  #
  #require 'tengine_job'
  #
  ## [jn0004]
  ##               |-->[j2]-->
  ##||
  ## [S1]-->[j1]-->          |-->[j4]-->[E1]
  ##               |-->[j3]-->
  ##                     _________finally________
  ##                    {                        }
  ##                    {[S2]-->[jn0004_f]-->[E2]}
  ##                    {________________________}
  ##                     
  # jobnet("jn0004", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1", "$HOME/0004_retry_one_layer.sh", :to => ["j2", "j3"])
  #   job("j2", "$HOME/0004_retry_one_layer.sh", :to => "j4")
  #   job("j3", "$HOME/0004_retry_one_layer.sh", :to => "j4")
  #   job("j4", "$HOME/0004_retry_one_layer.sh")
  #   finally do
  #     job("jn0004_f", "$HOME/0004_retry_one_layer.sh")
  #   end
  # end

  @01_02_02
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork前で失敗
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J1_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されていないこと

    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること


  @01_02_03
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork後で片方が失敗
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J3_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j2" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j3" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j2 start"の後であること
    かつ "tengine_job_test /jn0004/j3 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/j3 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること


  @01_02_04
  シナリオ: [正常系]finally付きのジョブネットを試してみる_fork後で両方が失敗
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0004"を事前実行コマンド"export J2_FAIL='true' && export J3_FAIL='true'"で実行する
    かつ ジョブネット"jn0004"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0004" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0004/j2" のステータスがエラー終了であること
    かつ ジョブ"/jn0004/j3" のステータスがエラー終了であること
    かつ ジョブネット"/jn0004/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0004/finally/jn0004_f" のステータスが正常終了であること

    もし ジョブ"/jn0004/j2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    もし ジョブ"/jn0004/j3"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0004/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 start"の後であること
    かつ "tengine_job_test /jn0004/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/j3 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0004/j1 finish"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/j2 start"と"tengine_job_test /jn0004/j3 start"の後であること
    かつ "tengine_job_test /jn0004/jn0004_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0004/jn0004_f start"の後であること



  # ../tengine_job/examples/0005_retry_two_layer.rb
  #  -------------------
  # -*- coding: utf-8 -*-
  #
  #require 'tengine_job'
  #
  # [jn0005]
  #                     ________________[jn4]________________
  #                   {                                          }
  #                   {               |-->[j42]-->               }
  #                   {||               }|
  # [S1]-->[j1]-->F-->{ [S2]-->[j41]-->          |-->[j44]-->[E2]}-->J--[j4]-->[E1]
  #|   {                                              |-->[j43]-->               }|
  #|   {         __________finally__________      }   |
  #|   {        { [S3]-->[jn4_f]-->[E3] }     }       |
  #|   { _________________________________________}   |
  #|-------------------->[j2]------------------------>|
  #
  #   ________________________________finally________________________________
  #  {         _____________________jn0005_fjn__________                     }
  #  {        {                                         }                    }
  #  {        { [S5]-->[jn0005_f1]-->[jn0005_f2]-->[E5] }                    }
  #  { [S4]-->{                                         }-->[jn0005_f]-->[E4]}
  #  {        {      ____________finally________        }                    }
  #  {        {      {[S6]-->[jn0005_fif]-->[E6]}       }                    }
  #  {        {_________________________________________}                    }
  #  { ______________________________________________________________________}
  # jobnet("jn0005", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("j1")
  #   job("j1", "$HOME/0005_retry_two_layer.sh", :to => ["j2", "jn4"])
  #   job("j2", "$HOME/0005_retry_two_layer.sh", :to => "j4")
  #   jobnet("jn4", :to => "j4") do
  #     boot_jobs("j41")
  #     job("j41", "$HOME/0005_retry_two_layer.sh", :to => ["j42", "j43"])
  #     job("j42", "$HOME/0005_retry_two_layer.sh", :to => "j44")
  #     job("j43", "$HOME/0005_retry_two_layer.sh", :to => "j44")
  #     job("j44", "$HOME/0005_retry_two_layer.sh")
  #     finally do
  #       job("jn4_f", "$HOME/0005_retry_two_layer.sh")
  #     end
  #   end
  #   job("j4", "$HOME/0005_retry_two_layer.sh")
  #   finally do
  #     boot_jobs("jn0005_fjn")
  #     jobnet("jn0005_fjn", :to => "jn0005_f") do
  #       boot_jobs("jn0005_f1")
  #       job("jn0005_f1", "$HOME/0005_retry_two_layer.sh", :to => ["jn0005_f2"])
  #       job("jn0005_f2", "$HOME/0005_retry_two_layer.sh")
  #       finally do
  #         job("jn0005_fif","$HOME/0005_retry_two_layer.sh")
  #       end 
  #     end
  #     job("jn0005_f", "$HOME/0005_retry_two_layer.sh")
  #   end
  # end
  #  -------------------
  @01_02_05
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する
  
  
    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J41_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/j41"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j2 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j41 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test  /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること


  @01_02_06
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_fork後片方

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J43_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/j43"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j2 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること

  @01_02_07
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_fork後片方_ジョブネット外のfork後片方

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export J2_FAIL='true' && export J43_FAIL='true' && export J2_SLEEP='5' && export JN4_F_SLEEP='10'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/j2"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    もし ジョブ"/jn0005/jn4/j43"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/j2 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 start"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること


  @01_02_08
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_finallyがエラー終了

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export JN4_F_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j44" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスがエラー終了であること
    かつ ジョブネット"/jn0005/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f" のステータスが正常終了であること

    もし ジョブ"/jn0005/jn4/finally/jn4_f"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j42 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"と"スクリプトログ"に一回出力されており、"tengine_job_test  /jn0005/finally/jn0005_fjn/jn0005_f2 start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f2 finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f start"の後であること



  @01_02_09
  シナリオ: [正常系]finally付きジョブネットを試してみる_ジョブネット内のジョブが失敗する_finally内のfinallyを持つジョブネット内のジョブがエラー終了

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0005_retry_two_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0005"を事前実行コマンド"export JN0005_F1_FAIL='true'"で実行する
    かつ ジョブネット"jn0005"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0005" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/j1" のステータスが正常終了であること
    かつ ジョブ"/jn0005/j2" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j41" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j42" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j43" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/j44" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/jn4/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/jn4/finally/jn4_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0005/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1" のステータスがエラー終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f2" のステータスが初期化済であること
    かつ ジョブネット"/jn0005/finally/jn0005_fjn/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_fjn/finally/jn0005_fif" のステータスが正常終了であること
    かつ ジョブ"/jn0005/finally/jn0005_f"のステータスが初期化済であること

    もし ジョブ"/jn0005/finally/jn0005_fjn/jn0005_f1"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test j1 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0005/j1 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 start"の後であること
    かつ "tengine_job_test /jn0005/j2 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/j1 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j41 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j42 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j41 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j43 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j43 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j42 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/j44 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/j44 finish"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0005/jn4/jn4_f start"の後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/j42 finish"と"tengine_job_test /jn0005/jn4/j43 start"後であること
    かつ "tengine_job_test /jn0005/jn4/finally/jn4_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/jn4/finally/jn0004_f start"の後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/j2 finish"と"tengine_job_test /jn0005/jn4/finally/jn4_f finish"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f1 start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0005/finally/jn0005_fjn/finally/jn0005_fif start"後であること
    かつ "tengine_job_test /jn0005/finally/jn0005_fjn/jn0005_f finish"と"スクリプトログ"に一回出力されていないこと


  # ------------
  # # -*- coding: utf-8 -*-
  # 
  # require 'tengine_job'
  # 
  # # finallyを追加する
  # # [jn0006]
  # #          __________________________[jn1]____________________________        ______________[jn2]_____________________________________
  # #         {          __________[jn11]_______________                  }     {                 _____________[jn22]____________         }
  # #         {         {                               }                 }     {                {                              }         } 
  # #  [S1]-->{ [S2]--> { [S3]-->[j111]-->[j112]-->[E3] } -->[j12]-->[E2] } --> { [S6]-->[j21]-->{ [S7]-->[j221]-->[j222]-->[E7]} -->[E6] } -->[E1] 
  # #         {         {                               }                 }     {                {                              }         }
  # #         {         {   _______finally_______       }                 }     {                {  _________finally_______     }         }
  # #         {         {  {[S4]-->[jn11_f]-->[E4]}     }                 }     {                {  {[S8]-->[jn22_f]-->[E8]}    }         }
  # #         {         {_______________________________}                 }     {                {______________________________}         }
  # #         {                                                           }     {                                                         }
  # #         {                                   _______finally_______   }     {                               _______finally_______     }
  # #         {                                  {[S5]-->[jn1_f]-->[E5]}  }     {                             {[S9]-->[jn2_f]-->[E9]}     }
  # #         {___________________________________________________________}     {_________________________________________________________}
  # #
  # #                                                                                           _______finally_______
  # #                                                                                          {[S10]-->[jn_f]-->[E10]}
  # #
  # jobnet("jn0006", :instance_name => "test_server1", :credential_name => "test_credential1") do
  #   boot_jobs("jn1")
  #   jobnet("jn1", :to => "jn2") do
  #    boot_jobs("j11")
  #    jobnet("j11", :to => "j12") do
  #      boot_jobs("j111")
  #      job("j111", "$HOME/0006_retry_three_layer.sh",:to => "j112")
  #      job("j112", "$HOME/0006_retry_three_layer.sh" )
  #      finally do
  #        job("jn11_f","$HOME/0006_retry_three_layer.sh")
  #      end
  #    end
  #    job("j12", "$HOME/0006_retry_three_layer.sh")    
  #    finally do
  #      job("jn1_f","$HOME/0006_retry_three_layer.sh")
  #    end
  #   end
  #   jobnet("jn2") do
  #    boot_jobs("j21")
  #    job("j21", "$HOME/0006_retry_three_layer.sh", :to => "j22")    
  #    jobnet("j22") do
  #      boot_jobs("j221")
  #      job("j221", "$HOME/0006_retry_three_layer.sh",:to => "j222")
  #      job("j222", "$HOME/0006_retry_three_layer.sh" )
  #      finally do
  #        job("jn22_f","$HOME/0006_retry_three_layer.sh")
  #      end
  #    end
  #    finally do
  #      job("jn2_f","0006_retry_three_layer.sh")
  #    end
  #   end
  #   finally do 
  #     job("jn_f","$HOME/0006_retry_three_layer.sh")
  #   end
  # end
  @01_02_10
  シナリオ: [正常系]ジョブネット内ジョブネット内のジョブが失敗する

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0006_retry_three_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0006"を事前実行コマンド"export J111_FAIL='true'"で実行する
    かつ ジョブネット"jn0006"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0006" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/jn11" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j111" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j112" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/jn11/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/jn11/finally/jn11_f" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/j12" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/finally/jn1_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn2/" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/j21" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn2/jn22" のステータスが初期化済終了であること
    かつ ジョブ"/jn0006/jn2/jn22/j221" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j222" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22//finally/jn22_f" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/finally/jn2_f" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/finally/jn_f" のステータスが正常終了であること

    もし ジョブ"/jn0006/jn1/jn11/j111"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test /jn0006/jn1/jn11/j111 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0006/jn1/jn11/j111 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/j1/jn11/finally/jn11_f start"の後であること
    かつ "tengine_job_test /jn0006/jn1/j12 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f start"の後であること
    かつ "tengine_job_test /jn0006/jn2/j21 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/j221 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/jn222 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/finally/jn22_f start"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/finally/jn2_f finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/finally/jn_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f finish"の後であること
    かつ "tengine_job_test /jn0006/finally/jn_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/finally/jn_f start"の後であること


  @01_02_11
  シナリオ: [正常系]jn0006_ジョブネット内ジョブネット内のfinally内のジョブが失敗する

    前提 仮想サーバ"test_server1"のファイル:"/home/goku/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0006_retry_three_layer.rb -f ./features/config/tengine.yml"というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    
    もし ジョブネット"jn0006"を事前実行コマンド"export JN11_F_FAIL='true'"で実行する
    かつ ジョブネット"jn0006"がエラー終了することを確認する
    
    ならば ジョブネット"/jn0006" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/" のステータスがエラー終了であること
    かつ ジョブネット"/jn0006/jn1/jn11" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j111" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/jn11/j112" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn1/jn11/finally" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/jn11/finally/jn11_f" のステータスがエラー終了であること
    かつ ジョブ"/jn0006/jn1/j12" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn1/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/jn1/finally/jn1_f" のステータスが正常終了であること
    かつ ジョブネット"/jn0006/jn2/" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/j21" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/jn2/jn22" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j221" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/j222" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/jn22/finally/jn22_f" のステータスが初期化済であること
    かつ ジョブ"/jn0006/jn2/finally/jn2_f" のステータスが初期化済であること
    かつ ジョブネット"/jn0006/finally" のステータスが正常終了であること
    かつ ジョブ"/jn0006/finally/jn_f" のステータスが正常終了であること

    もし ジョブ"/jn0006/jn1/jn11/jn11_f"の"表示"リンクをクリックする
    ならば "実行中のジョブ画面"が表示していること
    かつ "エラーメッセージ"に以下のメッセージが表示されていること
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Job process failed. STDOUT and STDERR were redirected to files."
    "You can see them at '#{標準出力のファイルパス}' and '#{標準エラー出力のファイルパス}'"
    "on the server '#{サーバ名}'"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  
    もし 仮想サーバ"test_server1"のファイル"/home/goku/tengine_job_test.log"を開く。このファイルを"スクリプトログ"と呼ぶこととする。
    ならば "tengine_job_test /jn0006/jn1/jn11/j111 start"と"スクリプトログ"に出力されていること
    かつ "tengine_job_test /jn0006/jn1/jn11/j111 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j111 finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/j112 finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j112 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/jn11/finally/jn11_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/j112 start"の後であること
    かつ "tengine_job_test /jn0006/jn1/j12 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f start"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/jn11/finally/jn11_f finish"の後であること
    かつ "tengine_job_test /jn0006/jn1/finally/jn1_f finish"と"スクリプトログ"に出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f start"の後であること
    かつ "tengine_job_test /jn0006/jn2/j21 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/j221 start"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/jn222 finish"と"スクリプトログ"に出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/jn22/finally/jn22_f start"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/jn2/finally/jn2_f finish"と"スクリプトログ"に一回出力されていないこと
    かつ "tengine_job_test /jn0006/finally/jn_f start"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/jn1/finally/jn1_f finish"の後であること
    かつ "tengine_job_test /jn0006/finally/jn_f finish"と"スクリプトログ"に一回出力されており、"tengine_job_test /jn0006/finally/jn_f start"の後であること