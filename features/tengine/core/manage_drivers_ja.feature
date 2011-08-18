#language:ja
機能: ドライバを管理する
  [goal]をするために
  [stakeholder]
  は [behaviour] したい
  
  シナリオ: 新しいドライバを登録する
    前提 "ドライバ新規登録画面"を表示している
    もし "Name"に"name 1"と入力する
    かつ "Version"に"version 1"と入力する
    かつ "Enabled"のチェックを外す
    かつ "Create"ボタンをクリックする
    ならば "name 1"と表示されていること
    かつ "version 1"と表示されていること
    かつ "false"と表示されていること

  シナリオ: ドライバを削除する
    前提 以下のドライバが登録されている
      |name|version|enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 3|version 3|false|
      |name 4|version 4|true|
    もし "ドライバ一覧画面"で3番目のドライバを削除する
    ならば 以下のドライバの一覧が表示されること
      |Name|Version|Enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 4|version 4|true|
