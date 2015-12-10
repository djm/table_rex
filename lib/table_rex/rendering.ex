defmodule TableRex.Rendering do
  @moduledoc """
  Provides `render/1`, `render/2` and `render/3` which allow for rendering with
  sane-defaults or with further customisation.
  """
  alias TableRex.Renderer
  alias TableRex.Table

  @default_renderer Renderer.Text

  @spec render(Table.t) :: Renderer.render_return
  def render(table) do
    render(table, @default_renderer, [])
  end

  @spec render(Table.t, list) :: Renderer.render_return
  def render(table, opts) when is_list(opts) do
    render(table, @default_renderer, opts)
  end

  @spec render(Table.t, module) :: Renderer.render_return
  def render(table, renderer) when is_atom(renderer) do
    render(table, renderer, [])
  end

  @spec render(Table.t, module, list) :: Renderer.render_return
  def render(%Table{} = table, renderer, opts) when is_atom(renderer) and is_list(opts) do
    render_opts = Dict.merge(renderer.default_options, opts)
    if Table.has_rows?(table) do
      renderer.render(table, render_opts)
    else
      {:error, "Table must have at least one row before being rendered"}
    end
  end
end
