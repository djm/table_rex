defmodule TableRex.Renderer.Text.Meta do
  @moduledoc """
  The data structure for the `TableRex.Renderer.Text` rendering module, it holds results
  of style & dimension calculations to be passed down the render pipeline.
  """
  alias TableRex.Renderer.Text.Meta
  
  defstruct col_widths: %{},
            row_heights: %{},
            table_width: 0,
            inner_intersections: []

  @doc """
  Retreives the "inner width" of the table, which is the full width minus any frame.
  """
  def inner_width(%Meta{table_width: table_width}) do
    table_width
  end

  @doc """
  Retreives the column width at the given column index.
  """
  def col_width(meta, col_index) do
    Map.get(meta.col_widths, col_index)
  end

  @doc """
  Retreives the row width at the given row index.
  """
  def row_height(meta, row_index) do
    Map.get(meta.row_heights, row_index)
  end
end
