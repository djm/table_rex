defmodule TableRex.CellTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell

  test "default struct" do
    assert %Cell{} == %Cell{
      value: "",
      align: nil
    }
  end

  test "to_cell with float" do
    %Cell{value: "1.333333"} = Cell.to_cell(1.333333)
  end

  test "to_cell with int" do
    %Cell{value: "13"} = Cell.to_cell(13)
  end

  test "to_cell with binary" do
    %Cell{value: "Thirteen"} = Cell.to_cell("Thirteen")
  end

  test "to_cell with binary & opts" do
    %Cell{value: "Thirteen", align: :left} = Cell.to_cell("Thirteen", align: :left)
  end

  test "to_cell with %Cell{value: float}" do
    %Cell{value: "1.333333"} = Cell.to_cell(%Cell{value: 1.333333})
  end

  test "to_cell with %Cell{value: int}" do
    %Cell{value: "13"} = Cell.to_cell(%Cell{value: 13})
  end

  test "to_cell with %Cell{value: binary}" do
    %Cell{value: "Thirteen"} = Cell.to_cell(%Cell{value: "Thirteen"})
  end

end
