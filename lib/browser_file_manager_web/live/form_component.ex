defmodule BrowserFileManagerWeb.FormComponent do
  use BrowserFileManagerWeb, :live_component

  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File
  alias BrowserFileManager.FileData

  alias BrowserFileManagerWeb.FileHTML

  @impl true
  def render(assigns) do
    IO.puts "レンダー"
    ~H"""
    <div class="">

      <div class="h-[5%]">
        <.header>
          <span><%= inspect @file_data.file_name %></span>
          <!--<:subtitle>Use this form to manage file records in your database.</:subtitle>-->
          <div></div>
        </.header>
      </div>

      <div class="h-[95%]">
        <.simple_form
          for={@form}
          id="file-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="変更 flex h-full ここまで"
        >

          <div class="h-[80px]">
            <span class="hidden"><.input field={@form[:name]} type="text" label="Name" readonly /></span>
            <span class="hidden"><.input field={@form[:parent_id]} type="number" label="Parent" readonly/></span>
            <.input field={@form[:star]} type="number" label="Star"/>
          </div>

          <div class="h-[calc(100%-130px)]">
            <% tag_zip = FileHTML.tag_select_origin @form, @changeset %>
            <div class="h-[30px] font-bold">Tags</div>
            <div class="h-[calc(100%-30px)] overflow-y-scroll">
              <%= for x <- tag_zip do %>
                <div>
                  <div><%= elem(x, 0).name %></div>
                  <%= for y <- elem(x, 1) do %>
                    <div class="inline-block rounded-lg bg-red-300 m-1">
                    <label class="flex items-center mx-1">
                        <%= if y.selected do %>
                          <input type="checkbox" id={"#{y.value}"} name="tags[]" value={"#{y.value}"} checked="true"/><%= inspect y.key %>
                        <% else %>
                          <input type="checkbox" id={"#{y.value}"} name="tags[]" value={"#{y.value}"}/><%= inspect y.key %>
                        <% end %>
                    </label>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>


          <!-- <:actions> -->
          <div class="h-[50px] w-full flex justify-end">
            <.button phx-disable-with="Saving...">Save File</.button>
          </div>
          <!-- </:actions> -->

        </.simple_form>
      </div>
    </div>

    """
  end

  @impl true
  def update(assigns, socket) do
    IO.puts "アップデート"
    %{file: file} = assigns
    #:newだったら、pathを入れる処理
    file = if assigns.action == :new do
      %File{file | name: assigns.file_data.file_path}
    else
      file
    end
    changeset = Content.change_file(file)


    {:ok,
    socket
    |> assign(assigns) # socketにassignsをセットする
    |> assign(file: file) # 上で作成したfileに更新する
    |> assign_form(changeset)}
  end

  # def handle_event("validate", %{"file" => file_params}, socket) do
  @spec handle_event(<<_::32, _::_*32>>, nil | maybe_improper_list | map, %{
          :assigns => atom | map,
          optional(any) => any
        }) :: {:noreply, map}
  def handle_event("validate", params, socket) do
    IO.puts "ハンドルイベント validate"
    IO.puts inspect params

    file_params = params["file"]

    changeset =
      socket.assigns.file
      |> Content.change_file(file_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", params, socket) do
    IO.puts "ハンドルイベント save"
    IO.puts inspect params
    save_file(socket, socket.assigns.action, params)
  end

  defp save_file(socket, :edit, params) do
    IO.puts "セーブユーザー :edit"
    id = params["id"]
    file_params = params["file"]
    tag_ids = if Map.has_key?(params, "tags"), do: params["tags"], else: []
    file_params = Map.put(file_params, "tag_ids", tag_ids)
    IO.puts inspect file_params

    case Content.update_file(socket.assigns.file, file_params) do
      {:ok, file} ->
        notify_parent({:saved, file})

        {:noreply,
        socket
        |> put_flash(:info, "File updated successfully")
        |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_file(socket, :new, params) do
    IO.puts "セーブファイル :new"

    #タグをくっつける
    file_params = params["file"]

    tag_ids = if Map.has_key?(params, "tags"), do: params["tags"], else: []
    file_params = Map.put(file_params, "tag_ids", tag_ids)
    IO.puts inspect file_params

    case Content.create_file(file_params) do
      {:ok, file} ->
        notify_parent({:saved, file})

        patch = "/live/new/" <> inspect file.id
        {:noreply,
        socket
        |> put_flash(:info, "File created successfully")
        |> push_patch(to: patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    IO.puts "アサインフォーム"
    socket
    |> assign(:form, to_form(changeset))
    |> assign(:changeset, changeset)
  end

  defp notify_parent(msg) do
    IO.puts "ノーティファイペアレント"
    send(self(), {__MODULE__, msg})
  end
end
