defmodule BrowserFileManagerWeb.FormComponent do
  use BrowserFileManagerWeb, :live_component

  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File
  alias BrowserFileManager.FileData

  alias BrowserFileManagerWeb.FileHTML
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    IO.puts "レンダー"
    ~H"""
    <div class="">

      <div class="h-[10%]">
        <.header>
          <span><%= @title %></span>
          <!--<:subtitle>Use this form to manage file records in your database.</:subtitle>-->
          <div></div>
        </.header>
      </div>

      <div class="h-[90%]">
        <.simple_form
          for={@form}
          id="file-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >

          <div class="h-[10%]">
            <span class="hidden"><.input field={@form[:name]} type="text" label="Name" disabled /></span>
            <span class="hidden"><.input field={@form[:parent_id]} type="number" label="Parent" disabled class="hidden"/></span>
            <.input field={@form[:star]} type="number" label="Star" />
          </div>

          <div class="max-h-[90%]">
            <% tag_zip = FileHTML.tag_select_origin @form, @changeset %>
            <div class="font-bold">Tags</div>
            <div>
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


          <:actions>
            <div class="w-full flex justify-end">
              <.button phx-disable-with="Saving...">Save File</.button>
            </div>
          </:actions>

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
    |> assign(assigns)
    |> assign_form(changeset)}
  end

  def handle_event("validate", %{"file" => file_params}, socket) do
    IO.puts "ハンドルイベント validate"
    changeset =
      socket.assigns.file
      |> Content.change_file(file_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", params, socket) do
    IO.puts "ハンドルイベント save"
    save_file(socket, socket.assigns.action, params)
  end

  defp save_file(socket, :edit, params) do
    IO.puts "セーブユーザー :edit"
    IO.puts inspect params
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
