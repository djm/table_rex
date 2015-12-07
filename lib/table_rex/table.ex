defmodule TableRex.Table do
  alias TableRex.Column
  alias TableRex.Table

  defstruct title: nil, header_row: [], rows: [], columns: %{}

  @type t :: %__MODULE__{}

  @doc """
  Retreives the column struct containing column meta at a given col_index.
  If one does not exist, a default %TableRex.Column{} is returned.
  """
  def get_column(%Table{} = table, col_index) when is_number(col_index) do
    Dict.get(table.columns, col_index, %Column{})
  end

  @doc"""
  Retreives the value of a column meta option at the specified col_index.
  If no value has been set, default values are returned.
  """
  def get_column_meta(%Table{} = table, col_index, key) when is_number(col_index) and is_atom(key) do
    get_column(table, col_index)
    |> Map.fetch!(key)
  end

  @doc"""
  Returns a boolean detailing if the passed table has any (expected) row data set.
  """
  def has_rows?(%Table{rows: []}), do: false
  def has_rows?(%Table{rows: rows}) when is_list(rows), do: true

end
