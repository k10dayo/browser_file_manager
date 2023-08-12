defmodule BrowserFileManagerWeb.FormComponent do
  use BrowserFileManagerWeb, :live_component

  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File
  alias BrowserFileManager.FileData

  alias BrowserFileManagerWeb.FileHTML
  alias Phoenix.LiveView.JS

  # def mount(params, session, socket) do
  #   IO.puts "まうんとおおおおおおおおおおおおおお"
  #   IO.puts inspect session
  #   IO.puts inspect socket
  #   {:ok, socket, layout: false}
  # end

  @impl true
  def render(assigns) do
    IO.puts "レンダー"
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage file records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="file-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:star]} type="number" label="Star" />
      <.input field={@form[:parent_id]} type="number" label="Parent" />

      <% tag_zip = FileHTML.tag_select_origin @form, @changeset %>
      <div class="font-bold">Tags</div>
      <div>
        <select multiple="multiple" name="tags[]"} id="multiple" phx-hook="MultipleSelect">
          <%= for x <- tag_zip do %>
            <optgroup label={"#{elem(x, 0).name}"}>
              <%= for y <- elem(x, 1) do%>
                <%= if y.selected do%>
                  <option value={"#{y.value}"} selected="true" ><%= inspect y.key %></option>
                <% else %>
                <option value={"#{y.value}"}><%= inspect y.key %></option>
                <% end %>

              <% end %>
            </optgroup>
          <% end %>
        </select>
      </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save File</.button>
        </:actions>
      </.simple_form>

      <div id="test">わお</div>
      <script src="/assets/test.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
      <script src="https://unpkg.com/multiple-select@1.6.0/dist/multiple-select.min.js"></script>
      <script src="/assets/multiple_select.min.js"></script>
      <link rel="stylesheet" href="https://unpkg.com/multiple-select@1.6.0/dist/multiple-select.min.css">

      <script>
        $(function () {
            $('select').multipleSelect({
                width: 500,
                isOpen: true,
                keepOpen: true,
                multiple: true,
                filter: true,
                filterGroup: true,
                hideOptgroupCheckboxes: true,
                multipleWidth: "auto",
                formatSelectAll: function() {
                    return 'すべて';
                },
                formatAllSelected: function() {
                    return '全て選択されています';
                },
                styler: function(row) {
                    return 'max-width: 150px'
                }
            });
        });
      </script>
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
