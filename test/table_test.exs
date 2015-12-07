defmodule TableRex.TableTest do
  use ExUnit.Case, async: true
  alias TableRex.Column
  alias TableRex.Table

  setup do
    {:ok, table_rex} = TableRex.start_link
    TableRex.set_column_meta(table_rex, 0, :align, :left)
    table = TableRex.get_table(table_rex)
    {:ok, table: table}
  end

  test "get_column returns correct column struct", %{table: table} do
    assert Table.get_column(table, 0) == %Column{align: :left}
    assert Table.get_column(table, 1) == %Column{}
  end

  test "get_column_meta returns correct values and defaults", %{table: table} do
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :center
    assert Table.get_column_meta(table, 2, :padding) == 1
  end

end
