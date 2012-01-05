#!/usr/bin/env bash
typeset -i time=$1
export LOGFILE=tengine_job_test.log
echo "`date` <$$> tengine_job_env_test $2 start" >> $LOGFILE
sleep `expr 1 + $time`

# MM_ACTUAL_JOB_ID : 実行される末端のジョブのMM上でのID
echo "`date` <$$> $2 MM_ACTUAL_JOB_ID: $MM_ACTUAL_JOB_ID" >> $LOGFILE

# MM_ACTUAL_JOB_ANCESTOR_IDS : 実行される末端のジョブの祖先のMM上でのIDをセミコロンで繋げた文字列
#  expansionで展開されたルートジョブネットの場合は、そのルートジョブネットより上位の祖先は含みません。
echo "`date` <$$> $2 MM_ACTUAL_JOB_ANCESTOR_IDS: $MM_ACTUAL_JOB_ANCESTOR_IDS" >> $LOGFILE

# MM_FULL_ACTUAL_JOB_ANCESTOR_IDS : 実行される末端のジョブの祖先のMM上でのIDをセミコロンで繋げた文字列
#  expansionで展開されたルートジョブネットの場合でも、そのルートジョブネットより上位の祖先も含みます
echo "`date` <$$> $2 MM_FULL_ACTUAL_JOB_ANCESTOR_IDS: $MM_FULL_ACTUAL_JOB_ANCESTOR_IDS" >> $LOGFILE

# MM_ACTUAL_JOB_NAME_PATH : 実行されるジョブの識別子 (祖先からのフルパス)
#  例) /root_jobnet/job1/job001
echo "`date` <$$> $2 MM_ACTUAL_JOB_NAME_PATH: $MM_ACTUAL_JOB_NAME_PATH" >> $LOGFILE

# MM_ACTUAL_JOB_SECURITY_TOKEN : 公開API呼び出しのためのセキュリティ用のワンタイムトークン
echo "`date` <$$> $2 MM_ACTUAL_JOB_SECURITY_TOKEN: $MM_ACTUAL_JOB_SECURITY_TOKEN" >> $LOGFILE

# MM_TEMPLATE_JOB_ID : テンプレートジョブ(=実行される末端のジョブの元となったジョブ)のID
echo "`date` <$$> $2 MM_TEMPLATE_JOB_ID: $MM_TEMPLATE_JOB_ID" >> $LOGFILE

# MM_TEMPLATE_JOB_ANCESTOR_IDS : テンプレートジョブの祖先のMM上でのIDをセミコロンで繋げたもの
echo "`date` <$$> $2 MM_TEMPLATE_JOB_ANCESTOR_IDS: $MM_TEMPLATE_JOB_ANCESTOR_IDS" >> $LOGFILE

# MM_SCHEDULE_ID : 実行スケジュールのID
echo "`date` <$$> $2 MM_SCHEDULE_ID: $MM_SCHEDULE_ID" >> $LOGFILE

# MM_SCHEDULE_ESTIMATED_TIME : 実行スケジュールの見積り時間。単位は分。
echo "`date` <$$> $2 MM_SCHEDULE_ESTIMATED_TIME: $MM_SCHEDULE_ESTIMATED_TIME" >> $LOGFILE

# MM_SCHEDULE_ESTIMATED_END : 実行スケジュールの見積り終了時刻をYYYYMMDDHHMMSS式で。
#  (できればISO 8601など、タイムゾーンも表現できる標準的な形式の方が良い？)
echo "`date` <$$> $2 MM_SCHEDULE_ESTIMATED_END: $MM_SCHEDULE_ESTIMATED_END" >> $LOGFILE

# MM_FAILED_JOB_ID : ジョブが失敗した場合にrecoverやfinally内のジョブを実行時に設定される、失敗したジョブのMM上でのID。
echo "`date` <$$> $2 MM_FAILED_JOB_ID: $MM_FAILED_JOB_ID" >> $LOGFILE

# MM_FAILED_JOB_ANCESTOR_IDS : ジョブが失敗した場合にrecoverやfinally内のジョブを実行時に設定される、失敗したジョブの祖先のMM上でのIDをセミコロンで繋げた文字列。
echo "`date` <$$> $2 MM_FAILED_JOB_ANCESTOR_IDS: $MM_FAILED_JOB_ANCESTOR_IDS" >> $LOGFILE

# MM_SERVER_NAME : 仮想サーバ名
echo "`date` <$$> $2 MM_SERVER_NAME: $MM_SERVER_NAME" >> $LOGFILE

# SSH_ID ジョブ実行サーバがssh接続に用いる秘密鍵のパスが渡される。現在は /home/kiban/.ssh/id_rsa-tengineが渡される
echo "`date` <$$> $2 SSH_ID: $SSH_ID" >> $LOGFILE

#JOBTRACKER_HOST JobTrackerのホスト名。仮想サーバー名 "rac1-ZPPPS001M001" を必ず渡している
echo "`date` <$$> $2 JOBTRACKER_HOST: $JOBTRACKER_HOST" >> $LOGFILE

#NAMENODE_HOST NAMENODEのホスト名。仮想サーバー名 "rac1-ZPPPS001M001" を必ず渡している
echo "`date` <$$> $2 NAMENODE_HOST: $NAMENODE_HOST" >> $LOGFILE

#SECONDARY_NAMENODE_HOST SecondaryNameNodeのホスト名。SecondaryNameNodeを立ち上げない場合は渡さない。 仮想サーバー名 "rac1-ZPPPS001S002" を必ず渡している
echo "`date` <$$> $2 SECONDARY_NAMENODE_HOST: $SECONDARY_NAMENODE_HOST" >> $LOGFILE

#SLAVE_HOSTS rac1-ZPPPS001M001, rac1-ZPPPS001S002以外のホスト名をカンマ区切りで渡す
echo "`date` <$$> $2 SLAVE_HOSTS: $SLAVE_HOSTS" >> $LOGFILE

#HOSTS 全てのホスト名をカンマ区切りで渡す
echo "`date` <$$> $2 HOSTS: $HOSTS" >> $LOGFILE


# 実行スケジュールに設定された環境変数
# ※ スクリプトの第3引数以降に指定した名称の変数を出力します。
shift 2
for name in $*
do
t="\$$name"
echo "`date` <$$> $2 $name: `eval echo $t`" >> $LOGFILE
done

echo "`date` <$$> tengine_job_evn_test $2 finish" >> $LOGFILE

