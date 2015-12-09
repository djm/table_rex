defmodule TableRex do
  @moduledoc """
  TableRex generates configurable, text-based tables for display
  """
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Table

  @column_fields %Column{} |> Map.from_struct |> Map.keys

  @doc """
  Starts a new table server, linked to the calling process.
  """
  @spec start_link(Table.t, GenServer.options) :: Agent.on_start
  def start_link(table_data \\ %Table{}, options \\ []) do
    Agent.start_link(fn -> table_data end, options)
  end

  @doc """
  Starts a new table server, unlinked from the calling process.
  """
  @spec start(Table.t, GenServer.options) :: Agent.on_start
  def start(table_data \\ %Table{}, options \\ []) do
    Agent.start(fn -> table_data end, options)
  end

  # Mutation API

  @doc """
  Sets an optional table title.
  """
  def set_title(agent, ""), do: set_title(agent, nil)
  def set_title(agent, title) when is_binary(title) or is_nil(title) do
    Agent.update(agent, &Map.put(&1, :title, title))
  end

  @doc """
  Sets an optional header row.
  """
  def set_header(agent, nil), do: set_header(agent, [])
  def set_header(agent, header_row) when is_list(header_row) do
    new_header_row = Enum.map(header_row, &Cell.to_cell(&1))
    Agent.update(agent, &Map.put(&1, :header_row, new_header_row))
  end

  @doc """
  Set the column meta for the passed column index.
  """
  def set_column_meta(agent, col_index, key, value) when is_number(col_index) and key in @column_fields do
    update_fun = fn table_data ->
      col = Table.get_column(table_data, col_index) |> Map.update!(key, fn _ -> value end)
      new_columns = Map.put(table_data.columns, col_index, col)
      %{table_data | columns: new_columns}
    end
    Agent.update(agent, update_fun)

  end

  def set_column_meta(_agent, _col_index, key, _value) do
    valid_opts = Enum.join @column_fields, ", "
    raise RuntimeError, message: "TableRex.set_column_meta failed. Are you using a valid meta option? " <>
                                 "You used: '#{key}'; valid options are: #{valid_opts}."
  end

  @doc """
  Adds a single row to the table.
  """
  def add_row(agent, row) when is_list(row) do
    new_row = Enum.map(row, &Cell.to_cell(&1))
    Agent.update(agent, fn table_data ->
      %{table_data | rows: [new_row | table_data.rows]}
    end)
  end

  @doc """
  Adds multiple rows to the table.
  """
  def add_rows(agent, rows) when is_list(rows) do
    rows = rows
     |> Enum.reverse
     |> Enum.map(fn row ->
          Enum.map(row, &Cell.to_cell(&1))
        end)
    Agent.update(agent, fn table_data ->
      %{table_data | rows: rows ++ table_data.rows}
    end)
  end

  @doc """
  Removes column meta for all columns, effectively resetting
  column meta back to the default options across the board.
  """
  def clear_all_column_meta(agent) do
    Agent.update(agent, &Map.put(&1, :columns, %{}))
  end

  @doc """
  Removes all row data from the table, keeping everything else.
  """
  def clear_rows(agent) do
    Agent.update(agent, &Map.put(&1, :rows, []))
  end

  @doc """
  Returns the table back to default empty state.
  """
  def reset(agent) do
    Agent.update(agent, fn _table_data ->
      %Table{}
    end)
  end

  # Retrieval API

  @doc """
  Returns the current server state. Useful
  for copying to a new process.
  """
  def get_table(agent) do
    Agent.get(agent, &(&1))
  end

  @doc """
  Asks the server whether a header row has been set, returns a boolean.
  """
  def has_header?(agent) do
    Agent.get(agent, &Table.has_header?/1)
  end

  @doc """
  Asks the server whether any rows have been set, returns a boolen.
  """
  def has_rows?(agent) do
    Agent.get(agent, &Table.has_rows?/1)
  end

  @doc """
  Shortcut function to render the current table state to string.
  """
  def render(agent, opts \\ [])
  def render(agent, opts) do
    get_table(agent) |> TableRex.Rendering.render(opts)
  end
  def render(agent, renderer, opts) do
    get_table(agent) |> TableRex.Rendering.render(renderer, opts)
  end

end
