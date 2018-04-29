defmodule TableRex.Table do
  @moduledoc """
  A set of functions for working with tables.

  The `Table` is represented internally as a struct though the
  fields are private and must not be accessed directly. Instead,
  use the functions in this module.
  """
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Renderer
  alias TableRex.Table

  defstruct title: nil, header_row: [], rows: [], columns: %{}, default_column: %Column{}

  @type t :: %__MODULE__{}

  @default_renderer Renderer.Text

  @doc """
  Creates a new blank table.

  The table created will not be able to be rendered until it has some row data.

  ## Examples

      iex> Table.new
      %TableRex.Table{}

  """
  @spec new() :: Table.t()
  def new, do: %Table{}

  @doc """
  Creates a new table with an initial set of rows and an optional header and title.
  """
  @spec new(list, list, String.t()) :: Table.t()
  def new(rows, header_row \\ [], title \\ nil) when is_list(rows) and is_list(header_row) do
    new()
    |> put_title(title)
    |> put_header(header_row)
    |> add_rows(rows)
  end

  # ------------
  # Mutation API
  # ------------

  @doc """
  Sets a string as the optional table title.
  Set to `nil` or `""` to remove an already set title from renders.
  """
  @spec put_title(Table.t(), String.t() | nil) :: Table.t()
  def put_title(%Table{} = table, ""), do: put_title(table, nil)

  def put_title(%Table{} = table, title) when is_binary(title) or is_nil(title) do
    %Table{table | title: title}
  end

  @doc """
  Sets a list as the optional header row.
  Set to `nil` or `[]` to remove an already set header from renders.
  """
  @spec put_header(Table.t(), list | nil) :: Table.t()
  def put_header(%Table{} = table, nil), do: put_header(table, [])

  def put_header(%Table{} = table, header_row) when is_list(header_row) do
    new_header_row = Enum.map(header_row, &Cell.to_cell(&1))
    %Table{table | header_row: new_header_row}
  end

  @doc """
  Sets column level information such as padding and alignment.
  """
  @spec put_column_meta(Table.t(), integer | atom | Enum.t(), Keyword.t()) :: Table.t()
  def put_column_meta(%Table{} = table, col_index, col_meta)
      when is_integer(col_index) and is_list(col_meta) do
    col_meta = col_meta |> Enum.into(%{})
    col = get_column(table, col_index) |> Map.merge(col_meta)
    new_columns = Map.put(table.columns, col_index, col)
    %Table{table | columns: new_columns}
  end

  def put_column_meta(%Table{} = table, :all, col_meta) when is_list(col_meta) do
    col_meta = col_meta |> Enum.into(%{})
    # First update default column, then any already set columns.
    table = put_in(table.default_column, Map.merge(table.default_column, col_meta))

    new_columns =
      Enum.reduce(table.columns, %{}, fn {col_index, col}, acc ->
        new_col = Map.merge(col, col_meta)
        Map.put(acc, col_index, new_col)
      end)

    %Table{table | columns: new_columns}
  end

  def put_column_meta(%Table{} = table, col_indexes, col_meta) when is_list(col_meta) do
    Enum.reduce(col_indexes, table, &put_column_meta(&2, &1, col_meta))
  end

  @doc """
  Sets cell level information such as alignment.
  """
  @spec put_cell_meta(Table.t(), integer, integer, Keyword.t()) :: Table.t()
  def put_cell_meta(%Table{} = table, col_index, row_index, cell_meta)
      when is_integer(col_index) and is_integer(row_index) and is_list(cell_meta) do
    cell_meta = cell_meta |> Enum.into(%{})
    inverse_row_index = -(row_index + 1)

    rows =
      List.update_at(table.rows, inverse_row_index, fn row ->
        List.update_at(row, col_index, &Map.merge(&1, cell_meta))
      end)

    %Table{table | rows: rows}
  end

  @doc """
  Sets cell level information for the header cells.
  """
  @spec put_header_meta(Table.t(), integer | Enum.t(), Keyword.t()) :: Table.t()
  def put_header_meta(%Table{} = table, col_index, cell_meta)
      when is_integer(col_index) and is_list(cell_meta) do
    cell_meta = cell_meta |> Enum.into(%{})
    header_row = List.update_at(table.header_row, col_index, &Map.merge(&1, cell_meta))
    %Table{table | header_row: header_row}
  end

  def put_header_meta(%Table{} = table, col_indexes, cell_meta) when is_list(cell_meta) do
    Enum.reduce(col_indexes, table, &put_header_meta(&2, &1, cell_meta))
  end

  @doc """
  Adds a single row to the table.
  """
  @spec add_row(Table.t(), list) :: Table.t()
  def add_row(%Table{} = table, row) when is_list(row) do
    new_row = Enum.map(row, &Cell.to_cell(&1))
    %Table{table | rows: [new_row | table.rows]}
  end

  @doc """
  Adds multiple rows to the table.
  """
  @spec add_rows(Table.t(), list) :: Table.t()
  def add_rows(%Table{} = table, rows) when is_list(rows) do
    rows =
      rows
      |> Enum.reverse()
      |> Enum.map(fn row ->
        Enum.map(row, &Cell.to_cell(&1))
      end)

    %Table{table | rows: rows ++ table.rows}
  end

  @doc """
  Removes column meta for all columns, effectively resetting
  column meta back to the default options across the board.
  """
  @spec clear_all_column_meta(Table.t()) :: Table.t()
  def clear_all_column_meta(%Table{} = table) do
    %Table{table | columns: %{}}
  end

  @doc """
  Removes all row data from the table, keeping everything else.
  """
  @spec clear_rows(Table.t()) :: Table.t()
  def clear_rows(%Table{} = table) do
    %Table{table | rows: []}
  end

  @doc """
  Sorts the table rows by using the values in a specified column.

  This is very much a simple sorting function and relies on Elixir's
  built-in comparison operators & types to cover the basic cases.

  As each cell retains the original value it was created with, we
  use that value to sort on as this allows us to sort on many
  built-in types in the most obvious fashions.

  Remember that rows are stored internally in reverse order that
  they will be output in, to allow for fast insertion.

  Parameters:

      `column_index`: the 0-indexed column number to sort by
      `order`: supply :desc or :asc for sort direction.

  Returns a new Table, with sorted rows.
  """
  @spec sort(Table.t(), integer, atom) :: Table.t()
  def sort(table, column_index, order \\ :desc)

  def sort(%Table{rows: [first_row | _]}, column_index, _order)
      when length(first_row) <= column_index do
    raise TableRex.Error,
      message:
        "You cannot sort by column #{column_index}, as the table only has #{length(first_row)} column(s)"
  end

  def sort(table = %Table{rows: rows}, column_index, order) do
    %Table{table | rows: Enum.sort(rows, build_sort_function(column_index, order))}
  end

  defp build_sort_function(column_index, order) when order in [:desc, :asc] do
    fn previous, next ->
      %{raw_value: prev_value} = Enum.at(previous, column_index)
      %{raw_value: next_value} = Enum.at(next, column_index)

      if order == :desc do
        next_value > prev_value
      else
        next_value < prev_value
      end
    end
  end

  defp build_sort_function(_column_index, order) do
    raise TableRex.Error,
      message: "Invalid sort order parameter: #{order}. Must be an atom, either :desc or :asc."
  end

  # -------------
  # Retrieval API
  # -------------

  defp get_column(%Table{} = table, col_index) when is_integer(col_index) do
    Map.get(table.columns, col_index, table.default_column)
  end

  @doc """
  Retreives the value of a column meta option at the specified col_index.
  If no value has been set, default values are returned.
  """
  @spec get_column_meta(Table.t(), integer, atom) :: any
  def get_column_meta(%Table{} = table, col_index, key)
      when is_integer(col_index) and is_atom(key) do
    get_column(table, col_index)
    |> Map.fetch!(key)
  end

  @doc """
  Returns a boolean detailing if the passed table has any row data set.
  """
  @spec has_rows?(Table.t()) :: boolean
  def has_rows?(%Table{rows: []}), do: false
  def has_rows?(%Table{rows: rows}) when is_list(rows), do: true

  @doc """
  Returns a boolean detailing if the passed table has a header row set.
  """
  @spec has_header?(Table.t()) :: boolean
  def has_header?(%Table{header_row: []}), do: false
  def has_header?(%Table{header_row: header_row}) when is_list(header_row), do: true

  # -------------
  # Rendering API
  # -------------

  @doc """
  Renders the current table state to string, ready for display via `IO.puts/2` or other means.

  At least one row must have been added before rendering.

  Returns `{:ok, rendered_string}` on success and `{:error, reason}` on failure.
  """
  @spec render(Table.t(), list) :: Renderer.render_return()
  def render(%Table{} = table, opts \\ []) when is_list(opts) do
    {renderer, opts} = Keyword.pop(opts, :renderer, @default_renderer)
    opts = opts |> Enum.into(renderer.default_options)

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
  @spec render!(Table.t(), list) :: String.t() | no_return
  def render!(%Table{} = table, opts \\ []) when is_list(opts) do
    case render(table, opts) do
      {:ok, rendered_string} -> rendered_string
      {:error, reason} -> raise TableRex.Error, message: reason
    end
  end
end
