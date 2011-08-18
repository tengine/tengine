#language:ja
機能: ドライバsを管理する
  [ゴール]を達成するために
  [利害関係者、アクター]
  は [振る舞い] をしたい

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
    前提 以下のドライバsが登録されている
      |name|version|enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 3|version 3|false|
      |name 4|version 4|true|
    もし "ドライバ一覧画面"で3番目のドライバを削除する
    ならば 以下のドライバsの一覧が表示されること
      |Name|Version|Enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 4|version 4|true|
