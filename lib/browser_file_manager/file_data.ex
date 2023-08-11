defmodule BrowserFileManager.FileData do
  alias BrowserFileManager.Content.File
  defstruct file_category: nil,
            file_name: nil,
            file_path: nil,
            file_db: %File{},
            group_tags: nil,
            file_img: nil
end
