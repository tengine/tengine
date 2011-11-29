#language:ja
機能: Credentialsを管理する
  [ゴール]を達成するために
  [利害関係者、アクター]
  は [振る舞い] をしたい

  背景:
    前提 日本語でアクセスする

  シナリオ: 新しいCredentialを登録する
    前提 "Credential新規登録画面"を表示している
    かつ "登録する"ボタンをクリックする

  シナリオ: Credentialを削除する
    前提 以下のCredentialsが登録されている
      ||
      ||
      ||
      ||
      ||
    もし "Credential一覧画面"で3番目のCredentialを削除する
    ならば 以下のCredentialsの一覧が表示されること
      ||
      ||
      ||
      ||
