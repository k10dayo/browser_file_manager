# BrowserFileManager

**環境**  
  ubuntu (lsコマンドを使用できる環境)
  elixir環境
  apache (xampp)

**初期設定**
  /config/config.exs の config :browser_file_manager　とxamppのipアドレスを入れる
  例　config :browser_file_manager,
        ecto_repos: [BrowserFileManager.Repo],
        root: "/home/user/Pictures/",　# ここを設定
        xampp_http_ip: "http://localhost"　# ここを設定
  
  xamppのapacheのhttpd.confなどで上で設定したrootをルートに設定する
  例　DocumentRoot "/home/user/Pictures/file_manager_directory"
      <Directory "/home/user/Pictures/file_manager_directory">

**使い方**
  このプロジェクト上で、 mix phx.server　で起動する

  localhost:4000/live　がルートファイルになる
  localhost:4000/properties　でタグのプロパティを追加する
  localhost:4000/tags　でタグを設定する
  localhost:4000/files　は登録されたデータを一覧で見れる　開発用

  localhost:4000/liveのページで、表示されるファイルの画像部分をクリックすると、そのファイルに入れる（フォルダならその中へ、画像、動画ならviewへ)
  ファイルの名前部分をクリックすると選択され、右上のハンバーガーボタンからメニューを開くと、選択したファイルの詳細を確認でき、new や editからタグを設定できる

  右上の虫眼鏡ボタンから設定したタグの検索が行える、　ルートパスからの検索で、or検索のみ対応

**lan内で接続可能にする方法**
  /config/dev.exs
    http: [ip: {127, 0, 0, 1}, port: 4000],を　http: [ip: {0, 0, 0, 0}, port: 4000],　に変更する
  /config/config.exs
    xampp_http_ip: に自身のプライベートipアドレスのurl？xamppのルートにつながるプライベートipのurlにする
    例　xampp_http_ip: "http://172.16.232.97"
    ※　ターミナル上でip -br a とするとipアドレスがでる
