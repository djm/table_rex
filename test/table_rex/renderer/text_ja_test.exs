defmodule TableRex.Renderer.TextTestJa do
  use ExUnit.Case, async: true
  alias TableRex.Table
  alias Unicode.EastAsianWidth, as: Width

  def string_width(string) do
    width =
      string
      |> String.to_charlist()
      |> Enum.map(&Width.east_asian_width_category(&1))
      |> Enum.reduce(0, fn width, acc -> if(width == :w, do: acc + 2, else: acc + 1) end)

    # IO.inspect("#{string} -> #{width}")
    width
  end

  setup do
    title = "一球目のホームラン"
    header = ["選手", "チーム", "本塁打"]

    rows = [
      ["大山 悠輔", "阪神", 6],
      ["ポランコ グレゴリー", "巨人", 3],
      ["塩見 泰隆", "ヤクルト", 3]
    ]

    table = Table.new(rows, header, title)

    {:ok, table: table}
  end

  test "default render", %{table: table} do
    {:ok, rendered} = Table.render(table)

    assert rendered == """
           +-------------------------+
           |        一球目のホームラン        |
           +------------+------+-----+
           | 選手         | チーム  | 本塁打 |
           +------------+------+-----+
           | 大山 悠輔      | 阪神   | 6   |
           | ポランコ グレゴリー | 巨人   | 3   |
           | 塩見 泰隆      | ヤクルト | 3   |
           +------------+------+-----+
           """
  end

  test "default render with unicode widths for table fields", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.put_header(nil)
      |> Table.put_column_meta([0, 1], width_calc: &string_width/1)
      |> Table.render()

    assert rendered == """
           +---------------------+----------+---+
           | 大山 悠輔           | 阪神     | 6 |
           | ポランコ グレゴリー | 巨人     | 3 |
           | 塩見 泰隆           | ヤクルト | 3 |
           +---------------------+----------+---+
           """
  end

  test "default render with unicode widths for table headers and fields", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.put_column_meta(0..2, width_calc: &string_width/1)
      |> Table.render()

    assert rendered == """
           +---------------------+----------+--------+
           | 選手                | チーム   | 本塁打 |
           +---------------------+----------+--------+
           | 大山 悠輔           | 阪神     | 6      |
           | ポランコ グレゴリー | 巨人     | 3      |
           | 塩見 泰隆           | ヤクルト | 3      |
           +---------------------+----------+--------+
           """
  end
end
