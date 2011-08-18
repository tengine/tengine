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
    Given the following drivers:
      |name|version|enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 3|version 3|false|
      |name 4|version 4|true|
    When I delete the 3rd driver
    Then I should see the following drivers:
      |Name|Version|Enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 4|version 4|true|
