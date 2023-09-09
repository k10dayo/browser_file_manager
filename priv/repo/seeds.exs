# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BrowserFileManager.Repo.insert!(%BrowserFileManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BrowserFileManager.Repo
alias BrowserFileManager.Information.Property
alias BrowserFileManager.Information.Tag
alias BrowserFileManager.Content.File

Repo.insert! %Property{
  name: "ポケモン"
}
Repo.insert! %Property{
  name: "ドラクエ"
}
Repo.insert! %Tag{
  name: "ピカチュー",
  property_id: 1
}
Repo.insert! %Tag{
  name: "スライム",
  property_id: 2
}
