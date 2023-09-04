defmodule BrowserFileManagerWeb.SearchFormComponent do
  use BrowserFileManagerWeb, :live_component
  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File
  alias BrowserFileManagerWeb.FileHTML

  def render(assigns) do
    ~H"""
      <div>
        <div>Hello Serch</div>
        <.simple_form
            for={@form}
            id="file-form"
            phx-target={@myself}
            phx-change="validate"
            phx-submit="save"
            class="変更 flex h-full ここまで"
          >

            <div class="">
              <span class="hidden"><.input field={@form[:name]} type="text" label="Name" disabled /></span>
              <span class="hidden"><.input field={@form[:parent_id]} type="number" label="Parent" disabled class="hidden"/></span>
              <span class="hidden"><.input field={@form[:star]} type="number" label="Star"/></span>
            </div>

            <div class="h-[calc(100%-50px)]">
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


            <div class="h-[50px] w-full flex justify-end">
              <.button phx-disable-with="Saving...">Search File</.button>
            </div>

          </.simple_form>
        </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    IO.puts "アップデート"

    changeset = Content.change_file(%File{})

    {:ok,
    socket
    |> assign(assigns)
    |> assign_form(changeset)}
  end

  def handle_event("validate", _params, socket) do
    IO.puts "ハンドルイベント validate"
    changeset =
      %File{}
      |> Content.change_file()
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
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
