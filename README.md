# BrowserFileManager

**環境**  
  Ubuntu (lsコマンドを使用できる環境)  
  Elixir,Phoenixフレームワーク  
  Apache (xampp)  

**初期設定**  
  /config/config.exs の config :browser_file_manager　の　root:にルートに設定したい絶対パス、xampp_http_ip:にapacheのドキュメントルートにアクセスするurlを設定する  
  例  
  config :browser_file_manager,  
  　　ecto_repos: [BrowserFileManager.Repo],  
  　　root: "/home/user/Pictures",　# ここを設定  
      xampp_http_ip: "http://localhost"　# ここを設定  
  
  apacheのhttpd.confで、上で設定したrootをドキュメントルートに設定する  
  例  
  DocumentRoot "/home/user/Pictures"  
      <Directory "/home/user/Pictures">  

**使い方**  
  リポジトリをcloneする　　
  このプロジェクト内のターミナルで　mix deps.get と mix ecto.create を実行  
  続けて、 mix phx.server　で起動する  
  http://localhost:4000/live　にブラウザでアクセスする  
  
  localhost:4000/live　がルートファイルになる  
  localhost:4000/properties　でタグのプロパティを追加する  
  localhost:4000/tags　でタグを設定する  
  localhost:4000/files　は登録されたデータを一覧で見れる  
    
  localhost:4000/liveのページで、表示されるファイルの画像部分をクリックすると、そのファイルに入れる（フォルダならその中へ、画像、動画なら閲覧へ)  
  ファイルの名前部分をクリックすると選択され、右上のハンバーガーボタンからメニューを開くと、選択したファイルの詳細を確認でき、new や editからタグを設定できる  
  
  右上の虫眼鏡ボタンから設定したタグの検索が行える、　ルートパスからの検索で、or検索のみ対応  

**lan内で接続可能にする方法**  
  /config/dev.exsで  
    http: [ip: {127, 0, 0, 1}, port: 4000],を　http: [ip: {0, 0, 0, 0}, port: 4000],　に変更する  
  /config/config.exsで
    xampp_http_ip: にapacheのドキュメントルートにつながるプライベートipアドレスのurlにする
    例　xampp_http_ip: "http://172.16.232.97"　（apacheはポート指定しなくてもいいっぽい）
    ※　ターミナル上でipコマンドなどで、プライベートipアドレスを確認
