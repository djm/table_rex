defmodule TableRex do
  @moduledoc """
  TableRex generates configurable, text-based tables for display
  """
  alias TableRex.Renderer
  alias TableRex.Table

  @doc """
  A shortcut function to render with a one-liner.
  Sacrifices all customisation for those that just want sane defaults.
  Returns `{:ok, rendered_string}` on success and `{:error, reason}` on failure.
  """
  @spec quick_render(list, list, String.t() | nil) :: Renderer.render_return()
  def quick_render(rows, header \\ [], title \\ nil) when is_list(rows) and is_list(header) do
    Table.new(rows, header, title)
    |> Table.render()
  end

  @doc """
  A shortcut function to render with a one-liner.
  Sacrifices all customisation for those that just want sane defaults.
  Returns the `rendered_string` on success and raises `RuntimeError` on failure.
  """
  @spec quick_render!(list, list, String.t() | nil) :: String.t() | no_return
  def quick_render!(rows, header \\ [], title \\ nil) when is_list(rows) and is_list(header) do
    case quick_render(rows, header, title) do
      {:ok, rendered} -> rendered
      {:error, reason} -> raise TableRex.Error, message: reason
    end
  end
end

defmodule TableRex.Error do
  defexception [:message]
end
