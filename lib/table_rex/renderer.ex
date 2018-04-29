defmodule TableRex.Renderer do
  @moduledoc """
  An Elixir behaviour that defines the API Renderers should conform to, allowing
  for display output in a variety of formats.
  """

  @typedoc "Return value of the render function."
  @type render_return :: {:ok, String.t()} | {:error, String.t()}

  @doc "Returns a Map of the options and their default values required by the renderer."
  @callback default_options() :: map

  @doc "Renders a passed %TableRex.Table{} struct into a string."
  @callback render(table :: %TableRex.Table{}, opts :: list) :: render_return
end
