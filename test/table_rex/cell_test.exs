defmodule TableRex.CellTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell

  doctest Cell

  test "default struct" do
    assert %Cell{} == %Cell{
             raw_value: nil,
             rendered_value: "",
             align: nil,
             color: nil
           }
  end

  test "to_cell with float value" do
    assert Cell.to_cell(1.345) == %Cell{
             raw_value: 1.345,
             rendered_value: "1.345",
             wrapped_lines: ["1.345"]
           }
  end

  test "to_cell with integer value" do
    assert Cell.to_cell(13) == %Cell{raw_value: 13, rendered_value: "13", wrapped_lines: ["13"]}
  end

  test "to_cell with binary value" do
    assert Cell.to_cell("Thirteen") == %Cell{
             raw_value: "Thirteen",
             rendered_value: "Thirteen",
             wrapped_lines: ["Thirteen"]
           }
  end

  test "to_cell with binary value wraps on newlines" do
    assert Cell.to_cell("one\ntwo\nthree") == %Cell{
             raw_value: "one\ntwo\nthree",
             rendered_value: "one\ntwo\nthree",
             wrapped_lines: ["one", "two", "three"]
           }
  end

  test "to_cell with extra options" do
    assert Cell.to_cell("Thirteen", align: :left, color: :red) ==
             %Cell{
               raw_value: "Thirteen",
               rendered_value: "Thirteen",
               wrapped_lines: ["Thirteen"],
               align: :left,
               color: :red
             }
  end

  test "to_cell with %Cell{} value with no rendered_value set" do
    assert Cell.to_cell(%Cell{raw_value: 1.345}) == %Cell{
             raw_value: 1.345,
             rendered_value: "1.345",
             wrapped_lines: ["1.345"]
           }
  end

  test "to_cell with %Cell{} value with set rendered_value" do
    assert Cell.to_cell(%Cell{rendered_value: "17"}) == %Cell{
             rendered_value: "17",
             wrapped_lines: ["17"]
           }
  end
end
