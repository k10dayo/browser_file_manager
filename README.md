# BrowserFileManager

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


#いじったファイル
config.exs
  環境変数を設定した
    root: "/home/unkochan/Pictures/file_manager_directory",
    xampp_http_ip: "http://localhost"
    # xampp_http_ip: "http://172.16.232.97"
router.ex
  ルートを追加した
    get "/manager", PageController, :manager
page_controller.ex
  アクションを追加、エイリアスの追加
page_html.ex
  関数の追加
manager.html.heex
  ページ内容の作成
file_data.ex
  構造体の定義　作成
data_shape.ex
  使いまわす関数の定義
/assets/css/app.css
  cssの追加
root.html.heex
  jqueryを追加
priv/static/assets/my_script.js
  jqueryの記述
live/image_view.ex
  LiveViewファイルの作成
live/image_view.html.heex
  image_viewの内容の作成
