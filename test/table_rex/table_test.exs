defmodule TableRex.TableTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Table

  doctest Table

  setup do
    table = Table.new()
    {:ok, table: table}
  end

  test "new with no arguments", _ do
    assert Table.new() == %Table{}
  end

  test "new with initial rows", _ do
    rows = [["Dom & Roland", "Thunder", 1998]]

    assert Table.new(rows) == %Table{
             rows: [
               [
                 Cell.to_cell("Dom & Roland"),
                 Cell.to_cell("Thunder"),
                 Cell.to_cell(1998)
               ]
             ]
           }
  end

  test "new with initial rows and header", _ do
    rows = [["Dom & Roland", "Thunder", 1998]]
    header = ["Artist", "Track", "Year"]

    assert Table.new(rows, header) == %Table{
             header_row: [
               Cell.to_cell("Artist"),
               Cell.to_cell("Track"),
               Cell.to_cell("Year")
             ],
             rows: [
               [
                 Cell.to_cell("Dom & Roland"),
                 Cell.to_cell("Thunder"),
                 Cell.to_cell(1998)
               ]
             ]
           }
  end

  test "new with initial rows, header and title", _ do
    title = "Dom & Roland Releases"
    rows = [["Dom & Roland", "Thunder", 1998]]
    header = ["Artist", "Track", "Year"]

    assert Table.new(rows, header, title) == %Table{
             title: "Dom & Roland Releases",
             header_row: [
               Cell.to_cell("Artist"),
               Cell.to_cell("Track"),
               Cell.to_cell("Year")
             ],
             rows: [
               [
                 Cell.to_cell("Dom & Roland"),
                 Cell.to_cell("Thunder"),
                 Cell.to_cell(1998)
               ]
             ]
           }
  end

  test "adding a single row with values", %{table: table} do
    row = ["Dom & Roland", "Thunder", 1998]
    table = Table.add_row(table, row)

    assert table.rows == [
             [
               Cell.to_cell("Dom & Roland"),
               Cell.to_cell("Thunder"),
               Cell.to_cell(1998)
             ]
           ]

    second_row = ["Calyx", "Downpour", 2001]
    table = Table.add_row(table, second_row)

    assert table.rows == [
             [
               Cell.to_cell("Calyx"),
               Cell.to_cell("Downpour"),
               Cell.to_cell(2001)
             ],
             [
               Cell.to_cell("Dom & Roland"),
               Cell.to_cell("Thunder"),
               Cell.to_cell(1998)
             ]
           ]
  end

  test "adding a single row with cell structs", %{table: table} do
    row = [
      "Rascal & Klone",
      %Cell{raw_value: "The Grind", align: :left, color: :red},
      %Cell{raw_value: 2000, align: :right}
    ]

    table = Table.add_row(table, row)

    assert table.rows == [
             [
               Cell.to_cell("Rascal & Klone"),
               Cell.to_cell("The Grind", align: :left, color: :red),
               Cell.to_cell(2000, align: :right)
             ]
           ]
  end

  test "adding multiple rows multiple times results in sane order output", %{table: table} do
    rows = [
      ["E-Z Rollers", "Tough At The Top", %Cell{raw_value: 1998, align: :right}],
      ["nCode", "Spasm", %Cell{raw_value: 1999, align: :right}]
    ]

    additional_rows = [
      ["Aquasky", "Uptight", %Cell{raw_value: 2000, align: :right}],
      ["Dom & Roland", "Dance All Night", %Cell{raw_value: 2004, align: :right, color: :red}]
    ]

    table = Table.add_rows(table, rows)
    table = Table.add_rows(table, additional_rows)

    assert table.rows == [
             [
               Cell.to_cell("Dom & Roland"),
               Cell.to_cell("Dance All Night"),
               Cell.to_cell(2004, align: :right, color: :red)
             ],
             [
               Cell.to_cell("Aquasky"),
               Cell.to_cell("Uptight"),
               Cell.to_cell(2000, align: :right)
             ],
             [
               Cell.to_cell("nCode"),
               Cell.to_cell("Spasm"),
               Cell.to_cell(1999, align: :right)
             ],
             [
               Cell.to_cell("E-Z Rollers"),
               Cell.to_cell("Tough At The Top"),
               Cell.to_cell(1998, align: :right)
             ]
           ]
  end

  test "add functions used together results in sane/expected output order", %{table: table} do
    first_row = ["Blame", "Music Takes You", 1992]

    middle_rows = [
      ["Deep Blue", "The Helicopter Tune", 1993],
      ["Dom & Roland", "Killa Bullet", 1999]
    ]

    fourth_row = ["Omni Trio", "Lucid", 2001]
    table = Table.add_row(table, first_row)
    table = Table.add_rows(table, middle_rows)
    table = Table.add_row(table, fourth_row)

    assert table.rows == [
             [
               Cell.to_cell("Omni Trio"),
               Cell.to_cell("Lucid"),
               Cell.to_cell(2001)
             ],
             [
               Cell.to_cell("Dom & Roland"),
               Cell.to_cell("Killa Bullet"),
               Cell.to_cell(1999)
             ],
             [
               Cell.to_cell("Deep Blue"),
               Cell.to_cell("The Helicopter Tune"),
               Cell.to_cell(1993)
             ],
             [
               Cell.to_cell("Blame"),
               Cell.to_cell("Music Takes You"),
               Cell.to_cell(1992)
             ]
           ]
  end

  test "setting and overriding a title", %{table: table} do
    title_1 = "Metalheadz Releases"
    table = Table.put_title(table, title_1)
    assert table.title == title_1
    title_2 = "Moving Shadow Releases"
    table = Table.put_title(table, title_2)
    assert table.title == title_2
  end

  test "clearing a title", %{table: table} do
    title = "Moving Shadow Releases"
    table = Table.put_title(table, title)
    table = Table.put_title(table, "")
    assert table.title == nil
    table = Table.put_title(table, title)
    table = Table.put_title(table, nil)
    assert table.title == nil
  end

  test "setting and then overriding a header row", %{table: table} do
    header_row = ["Artist"]
    table = Table.put_header(table, header_row)

    assert table.header_row == [
             Cell.to_cell("Artist")
           ]

    header_row = ["Artist", "Track", "Year"]
    table = Table.put_header(table, header_row)

    assert table.header_row == [
             Cell.to_cell("Artist"),
             Cell.to_cell("Track"),
             Cell.to_cell("Year")
           ]
  end

  test "setting a header row with cell structs", %{table: table} do
    header_row = [
      "Artist",
      %Cell{raw_value: "Track", align: :left, color: :red},
      %Cell{raw_value: "Year", align: :right}
    ]

    table = Table.put_header(table, header_row)

    assert table.header_row == [
             Cell.to_cell("Artist"),
             Cell.to_cell("Track", align: :left, color: :red),
             Cell.to_cell("Year", align: :right)
           ]
  end

  test "clearing a set header row", %{table: table} do
    header_row = ["Artist"]

    table =
      table
      |> Table.put_header(header_row)
      |> Table.put_header(nil)

    assert table.header_row == []

    table =
      table
      |> Table.put_header(header_row)
      |> Table.put_header([])

    assert table.header_row == []
  end

  test "setting column meta for a specific column", %{table: table} do
    assert table.columns == %{}
    table = Table.put_column_meta(table, 0, align: :right)

    assert table.columns == %{
             0 => %Column{align: :right}
           }

    table = Table.put_column_meta(table, 0, align: :left, padding: 2, color: :red)
    table = Table.put_column_meta(table, 1, align: :right)

    assert table.columns == %{
             0 => %Column{align: :left, padding: 2, color: :red},
             1 => %Column{align: :right}
           }
  end

  test "setting column meta across specific columns", %{table: table} do
    table = Table.put_column_meta(table, 0..2, align: :right)

    assert table.columns == %{
             0 => %Column{align: :right},
             1 => %Column{align: :right},
             2 => %Column{align: :right}
           }

    table = Table.put_column_meta(table, 1..3, padding: 2)

    assert table.columns == %{
             0 => %Column{align: :right},
             1 => %Column{align: :right, padding: 2},
             2 => %Column{align: :right, padding: 2},
             3 => %Column{padding: 2}
           }

    table = Table.put_column_meta(table, [1, 2], padding: 4)

    assert table.columns == %{
             0 => %Column{align: :right},
             1 => %Column{align: :right, padding: 4},
             2 => %Column{align: :right, padding: 4},
             3 => %Column{padding: 2}
           }

    table = Table.put_column_meta(table, [2, 3], color: :red)

    assert table.columns == %{
             0 => %Column{align: :right},
             1 => %Column{align: :right, padding: 4},
             2 => %Column{align: :right, padding: 4, color: :red},
             3 => %Column{padding: 2, color: :red}
           }
  end

  test "setting column meta across all columns", %{table: table} do
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :left
    table = Table.put_column_meta(table, :all, align: :right)
    assert Table.get_column_meta(table, 0, :align) == :right
    assert Table.get_column_meta(table, 1, :align) == :right
    table = Table.put_column_meta(table, :all, align: :left)
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :left
    assert Table.get_column_meta(table, 2, :align) == :left
  end

  test "overriding column meta across all columns", %{table: table} do
    table = Table.put_column_meta(table, 0, align: :right)
    assert Table.get_column_meta(table, 0, :align) == :right
    assert Table.get_column_meta(table, 1, :align) == :left
    table = Table.put_column_meta(table, :all, align: :left)
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :left
  end

  test "setting cell meta", %{table: table} do
    rows = [
      ["Dom & Roland", "Thunder", 1998],
      ["Calyx", "Downpour", 2001]
    ]

    table =
      table
      |> Table.add_rows(rows)
      |> Table.put_cell_meta(0, 0, align: :right)
      |> Table.put_cell_meta(0, 1, color: :red)
      |> Table.put_cell_meta(1, 0, color: :red)
      |> Table.put_cell_meta(1, 1, align: :left)

    assert table.rows == [
             [
               Cell.to_cell("Calyx", color: :red),
               Cell.to_cell("Downpour", align: :left),
               Cell.to_cell(2001)
             ],
             [
               Cell.to_cell("Dom & Roland", align: :right),
               Cell.to_cell("Thunder", color: :red),
               Cell.to_cell(1998)
             ]
           ]
  end

  test "setting header cell meta", %{table: table} do
    header = ["Artist", "Track", "Year"]

    table =
      table
      |> Table.put_header(header)
      |> Table.put_header_meta(0, align: :left)
      |> Table.put_header_meta(1, align: :right)
      |> Table.put_header_meta(2, color: :red)

    assert table.header_row == [
             Cell.to_cell("Artist", align: :left),
             Cell.to_cell("Track", align: :right),
             Cell.to_cell("Year", color: :red)
           ]
  end

  test "setting header cell meta across multiple cells", %{table: table} do
    header = ["Artist", "Track", "Year"]

    table =
      table
      |> Table.put_header(header)
      |> Table.put_header_meta(0..2, align: :center)

    assert table.header_row == [
             Cell.to_cell("Artist", align: :center),
             Cell.to_cell("Track", align: :center),
             Cell.to_cell("Year", align: :center)
           ]

    table = Table.put_header_meta(table, [1, 2], align: :right)

    assert table.header_row == [
             Cell.to_cell("Artist", align: :center),
             Cell.to_cell("Track", align: :right),
             Cell.to_cell("Year", align: :right)
           ]
  end

  test "clearing rows", %{table: table} do
    title = "Moving Shadow Releases"
    header = ["Artist", "Track", "Year"]

    rows = [
      ["Blame", "Neptune", 1996],
      ["Rob & Dom", "Distorted Dreams", 1997]
    ]

    table =
      table
      |> Table.put_title(title)
      |> Table.put_header(header)
      |> Table.add_rows(rows)
      |> Table.clear_rows()

    assert table.title == title

    assert table.header_row == [
             Cell.to_cell("Artist"),
             Cell.to_cell("Track"),
             Cell.to_cell("Year")
           ]

    assert table.rows == []
  end

  test "copying to a new table", %{table: existing_table} do
    new_row = ["Calyx", "Get Myself To You", 2005]
    existing_table = Table.add_row(existing_table, new_row)
    new_table = existing_table

    assert new_table.rows == [
             [
               Cell.to_cell("Calyx"),
               Cell.to_cell("Get Myself To You"),
               Cell.to_cell(2005)
             ]
           ]

    additional_row = ["E-Z Rollers", "Back To Love", 2002]
    new_table = Table.add_row(new_table, additional_row)

    assert existing_table.rows == [
             [
               Cell.to_cell("Calyx"),
               Cell.to_cell("Get Myself To You"),
               Cell.to_cell(2005)
             ]
           ]

    assert new_table.rows == [
             [
               Cell.to_cell("E-Z Rollers"),
               Cell.to_cell("Back To Love"),
               Cell.to_cell(2002)
             ],
             [
               Cell.to_cell("Calyx"),
               Cell.to_cell("Get Myself To You"),
               Cell.to_cell(2005)
             ]
           ]
  end

  test "get_column_meta returns correct values and defaults", %{table: table} do
    table = Table.put_column_meta(table, 0, align: :right)
    assert Table.get_column_meta(table, 0, :align) == :right
    assert Table.get_column_meta(table, 1, :align) == :left
    assert Table.get_column_meta(table, 2, :padding) == 1
  end

  test "has_rows? returns correct response", _setup do
    table = Table.new()
    assert table |> Table.has_rows?() == false
    table = %Table{rows: [["Exile", "Silver Spirit", "2003"]]}
    assert table |> Table.has_rows?() == true
    table = %Table{rows: []}
    assert table |> Table.has_rows?() == false
  end

  test "has_header? returns correct response", _setup do
    table = Table.new()
    assert table |> Table.has_header?() == false
    table = %Table{header_row: ["Artist", "Track", "Year"]}
    assert table |> Table.has_header?() == true
    table = %Table{header_row: []}
    assert table |> Table.has_header?() == false
  end

  defmodule TestRenderer do
    @behaviour TableRex.Renderer

    def default_options do
      %{
        horizontal_style: :header,
        vertical_style: :all,
        renderer_specific_option: true
      }
    end

    def render(table, render_opts) do
      send(self(), {:rendering, table, render_opts})
      {:ok, "Rendered String"}
    end
  end

  test "render/2 default runs" do
    {:ok, rendered} =
      Table.new()
      |> Table.add_row(["a"])
      |> Table.render()

    assert is_binary(rendered)
  end

  test "render/2 calls correctly" do
    {:ok, _} =
      Table.new()
      |> Table.add_row(["a"])
      |> Table.render(renderer: TestRenderer)

    expected_opts = %{
      horizontal_style: :header,
      vertical_style: :all,
      renderer_specific_option: true
    }

    assert_received {:rendering, _table, ^expected_opts}
  end

  test "render/2 errors when not enough rows" do
    {:error, reason} =
      Table.new()
      |> Table.render(renderer: TestRenderer)

    assert reason == "Table must have at least one row before being rendered"
    refute_received {:rendering, _, _}
  end

  test "render!/2 default runs" do
    rendered =
      Table.new()
      |> Table.add_row(["a"])
      |> Table.render!()

    assert is_binary(rendered)
  end

  test "render!/2 calls correctly" do
    Table.new()
    |> Table.add_row(["a"])
    |> Table.render!(renderer: TestRenderer)

    expected_opts = %{
      horizontal_style: :header,
      vertical_style: :all,
      renderer_specific_option: true
    }

    assert_received {:rendering, _table, ^expected_opts}
  end

  test "render/2 raises an error on failure" do
    assert_raise TableRex.Error, fn ->
      Table.new()
      |> Table.render!()
    end
  end

  test "sort/3 should sort the table using the first column (desc)" do
    table =
      Table.new()
      |> Table.add_row([1, "a"])
      |> Table.add_row([2, "b"])
      |> Table.add_row([3, "c"])
      |> Table.add_row([3, "d"])
      |> Table.sort(0, :desc)

    # Remember: rows are stored in reverse internally.
    assert table.rows == [
             [
               %Cell{raw_value: 1, rendered_value: "1", wrapped_lines: ["1"]},
               %Cell{raw_value: "a", rendered_value: "a", wrapped_lines: ["a"]}
             ],
             [
               %Cell{raw_value: 2, rendered_value: "2", wrapped_lines: ["2"]},
               %Cell{raw_value: "b", rendered_value: "b", wrapped_lines: ["b"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "c", rendered_value: "c", wrapped_lines: ["c"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "d", rendered_value: "d", wrapped_lines: ["d"]}
             ]
           ]
  end

  test "sort/3 should sort the table using the first column (asc)" do
    table =
      Table.new()
      |> Table.add_row([1, "a"])
      |> Table.add_row([2, "b"])
      |> Table.add_row([3, "c"])
      |> Table.add_row([3, "d"])
      |> Table.sort(0, :asc)

    # Remember: rows are stored in reverse internally.
    assert table.rows == [
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "c", rendered_value: "c", wrapped_lines: ["c"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "d", rendered_value: "d", wrapped_lines: ["d"]}
             ],
             [
               %Cell{raw_value: 2, rendered_value: "2", wrapped_lines: ["2"]},
               %Cell{raw_value: "b", rendered_value: "b", wrapped_lines: ["b"]}
             ],
             [
               %Cell{raw_value: 1, rendered_value: "1", wrapped_lines: ["1"]},
               %Cell{raw_value: "a", rendered_value: "a", wrapped_lines: ["a"]}
             ]
           ]
  end

  test "sort/3 should sort the table by the specified column (desc)" do
    table =
      Table.new()
      |> Table.add_row([1, "a"])
      |> Table.add_row([2, "b"])
      |> Table.add_row([3, "c"])
      |> Table.add_row([3, "d"])
      |> Table.sort(1, :desc)

    # Remember: rows are stored in reverse internally.
    assert table.rows == [
             [
               %Cell{raw_value: 1, rendered_value: "1", wrapped_lines: ["1"]},
               %Cell{raw_value: "a", rendered_value: "a", wrapped_lines: ["a"]}
             ],
             [
               %Cell{raw_value: 2, rendered_value: "2", wrapped_lines: ["2"]},
               %Cell{raw_value: "b", rendered_value: "b", wrapped_lines: ["b"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "c", rendered_value: "c", wrapped_lines: ["c"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "d", rendered_value: "d", wrapped_lines: ["d"]}
             ]
           ]
  end

  test "sort/3 should sort the table by the specified column (asc)" do
    table =
      Table.new()
      |> Table.add_row([1, "a"])
      |> Table.add_row([2, "b"])
      |> Table.add_row([3, "c"])
      |> Table.add_row([3, "d"])
      |> Table.sort(1, :asc)

    # Remember: rows are stored in reverse internally.
    assert table.rows == [
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "d", rendered_value: "d", wrapped_lines: ["d"]}
             ],
             [
               %Cell{raw_value: 3, rendered_value: "3", wrapped_lines: ["3"]},
               %Cell{raw_value: "c", rendered_value: "c", wrapped_lines: ["c"]}
             ],
             [
               %Cell{raw_value: 2, rendered_value: "2", wrapped_lines: ["2"]},
               %Cell{raw_value: "b", rendered_value: "b", wrapped_lines: ["b"]}
             ],
             [
               %Cell{raw_value: 1, rendered_value: "1", wrapped_lines: ["1"]},
               %Cell{raw_value: "a", rendered_value: "a", wrapped_lines: ["a"]}
             ]
           ]
  end

  test "sort/3 should raise when column index exists out of bounds" do
    assert_raise TableRex.Error, fn ->
      Table.new()
      |> Table.add_row([3, "a"])
      |> Table.sort(3, :asc)
    end
  end

  test "sort/3 should raise when order parameter is invalid" do
    assert_raise TableRex.Error, fn ->
      Table.new()
      |> Table.add_row([3, "a"])
      |> Table.sort(0, :crap)
    end
  end
end
