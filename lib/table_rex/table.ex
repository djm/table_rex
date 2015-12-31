defmodule TableRex.Table do
  @moduledoc """
  Defines a struct that represents a table and provides functions for working with it
  """
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Renderer
  alias TableRex.Table

  defstruct title: nil, header_row: [], rows: [], columns: %{}, default_column: %Column{}

  @type t :: %__MODULE__{}

  @default_renderer Renderer.Text

  @doc """
  Creates a new table.
  """
  @spec new() :: Table.t
  def new do
    %Table{}
  end

  # Mutation API

  @doc """
  Sets a string as the optional table title.
  Set to `nil` or `""` to remove an already set title from renders.
  """
  @spec set_title(Table.t, String.t | nil) :: Table.t
  def set_title(%Table{} = table, ""), do: set_title(table, nil)
  def set_title(%Table{} = table, title) when is_binary(title) or is_nil(title) do
    %Table{table | title: title}
  end

  @doc """
  Sets a list as the optional header row.
  Set to `nil` or `[]` to remove an already set header from renders.
  """
  @spec set_header(Table.t, list | nil) :: Table.t
  def set_header(%Table{} = table, nil), do: set_header(table, [])
  def set_header(%Table{} = table, header_row) when is_list(header_row) do
    new_header_row = Enum.map(header_row, &Cell.to_cell(&1))
    %Table{table | header_row: new_header_row}
  end

  @doc """
  Sets column level information such as padding and alignment.
  """
  @spec set_column_meta(Table.t, integer | Range.t | atom, Keyword.t) :: Table.t
  def set_column_meta(%Table{} = table, col_index, col_meta) when is_integer(col_index) and is_list(col_meta) do
    col_meta = col_meta |> Enum.into(%{})
    col = get_column(table, col_index) |> Map.merge(col_meta)
    new_columns = Map.put(table.columns, col_index, col)
    %Table{table | columns: new_columns}
  end

  def set_column_meta(%Table{} = table, %Range{} = col_range, col_meta) when is_list(col_meta) do
    Enum.reduce(col_range, table, &set_column_meta(&2, &1, col_meta))
  end

  def set_column_meta(%Table{} = table, :all, col_meta) when is_list(col_meta) do
    col_meta = col_meta |> Enum.into(%{})
    # First update default column, then any already set columns.
    table = put_in(table.default_column, Map.merge(table.default_column, col_meta))
    new_columns = Enum.reduce(table.columns, %{}, fn({col_index, col}, acc) ->
      new_col = Map.merge(col, col_meta)
      Map.put(acc, col_index, new_col)
    end)
    %Table{table | columns: new_columns}
  end

  @doc """
  Sets cell level information such as alignment.
  """
  @spec set_cell_meta(Table.t, integer, integer, Keyword.t) :: Table.t
  def set_cell_meta(%Table{} = table, col_index, row_index, cell_meta) when is_integer(col_index) and is_integer(row_index) and is_list(cell_meta) do
    cell_meta = cell_meta |> Enum.into(%{})
    inverse_row_index = -(row_index + 1)
    rows = List.update_at(table.rows, inverse_row_index, fn(row) ->
      List.update_at(row, col_index, &Map.merge(&1, cell_meta))
    end)
    %Table{table | rows: rows}
  end

  @doc """
  Sets cell level information for the header cells.
  """
  @spec set_header_meta(Table.t, integer, Keyword.t) :: Table.t
  def set_header_meta(%Table{} = table, col_index, cell_meta) when is_integer(col_index) and is_list(cell_meta) do
    cell_meta = cell_meta |> Enum.into(%{})
    header_row = List.update_at(table.header_row, col_index, &Map.merge(&1, cell_meta))
    %Table{table | header_row: header_row}
  end

  @doc """
  Adds a single row to the table.
  """
  @spec add_row(Table.t, list) :: Table.t
  def add_row(%Table{} = table, row) when is_list(row) do
    new_row = Enum.map(row, &Cell.to_cell(&1))
    %Table{table | rows: [new_row | table.rows]}
  end

  @doc """
  Adds multiple rows to the table.
  """
  @spec add_rows(Table.t, list) :: Table.t
  def add_rows(%Table{} = table, rows) when is_list(rows) do
    rows = rows
     |> Enum.reverse
     |> Enum.map(fn row ->
          Enum.map(row, &Cell.to_cell(&1))
        end)
    %Table{table | rows: rows ++ table.rows}
  end

  @doc """
  Removes column meta for all columns, effectively resetting
  column meta back to the default options across the board.
  """
  @spec clear_all_column_meta(Table.t) :: Table.t
  def clear_all_column_meta(%Table{} = table) do
    %Table{table | columns: %{}}
  end

  @doc """
  Removes all row data from the table, keeping everything else.
  """
  @spec clear_rows(Table.t) :: Table.t
  def clear_rows(%Table{} = table) do
    %Table{table | rows: []}
  end

  # Retrieval API

  defp get_column(%Table{} = table, col_index) when is_integer(col_index) do
    Dict.get(table.columns, col_index, table.default_column)
  end

  @doc """
  Retreives the value of a column meta option at the specified col_index.
  If no value has been set, default values are returned.
  """
  @spec get_column_meta(Table.t, integer, atom) :: any
  def get_column_meta(%Table{} = table, col_index, key) when is_integer(col_index) and is_atom(key) do
    get_column(table, col_index)
    |> Map.fetch!(key)
  end

  @doc """
  Returns a boolean detailing if the passed table has any row data set.
  """
  @spec has_rows?(Table.t) :: boolean
  def has_rows?(%Table{rows: []}), do: false
  def has_rows?(%Table{rows: rows}) when is_list(rows), do: true

  @doc """
  Returns a boolean detailing if the passed table has a header row set.
  """
  @spec has_header?(Table.t) :: boolean
  def has_header?(%Table{header_row: []}), do: false
  def has_header?(%Table{header_row: header_row}) when is_list(header_row), do: true

  # Rendering API

  @doc """
  Renders the current table state to string, ready for display via `IO.puts/2` or other means.

  At least one row must have been added before rendering.

  Returns `{:ok, rendered_string}` on success and `{:error, reason}` on failure.
  """
  @spec render(Table.t, list) :: Renderer.render_return
  def render(%Table{} = table, opts \\ []) when is_list(opts) do
    {renderer, opts} = Keyword.pop(opts, :renderer, @default_renderer)
    opts = Dict.merge(renderer.default_options, opts)
    if Table.has_rows?(table) do
      renderer.render(table, opts)
    else
      {:error, "Table must have at least one row before being rendered"}
    end
  end

  @doc """
  Renders the current table state to string, ready for display via `IO.puts/2` or other means.

  At least one row must have been added before rendering.

  Returns the rendered string on success, or raises `TableRex.Error` on failure.
  """
  @spec render!(Table.t, list) :: String.t | no_return
  def render!(%Table{} = table, opts \\ []) when is_list(opts) do
    case render(table, opts) do
      {:ok, rendered_string} -> rendered_string
      {:error, reason} -> raise TableRex.Error, message: reason
    end
  end
end
