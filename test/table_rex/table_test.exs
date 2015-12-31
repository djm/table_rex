defmodule TableRex.TableTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Table

  setup do
    table = Table.new
    {:ok, table: table}
  end

  test "adding a single row with values", %{table: table} do
    row = ["Dom & Roland", "Thunder", 1998]
    table = Table.add_row(table, row)
    assert table.rows == [[
       %Cell{value: "Dom & Roland"},
       %Cell{value: "Thunder"},
       %Cell{value: "1998"}
     ]]
    second_row = ["Calyx", "Downpour", 2001]
    table = Table.add_row(table, second_row)
    assert table.rows == [
      [
        %Cell{value: "Calyx"},
        %Cell{value: "Downpour"},
        %Cell{value: "2001"}
      ],
      [
        %Cell{value: "Dom & Roland"},
        %Cell{value: "Thunder"},
        %Cell{value: "1998"}
      ]
    ]
  end

  test "adding a single row with cell structs", %{table: table} do
    row = [
      "Rascal & Klone",
      %Cell{value: "The Grind", align: :left},
      %Cell{value: 2000, align: :right}
    ]
    table = Table.add_row(table, row)
    assert table.rows == [[
      %Cell{value: "Rascal & Klone"},
      %Cell{value: "The Grind", align: :left},
      %Cell{value: "2000", align: :right}
    ]]
  end

  test "adding multiple rows multiple times results in sane order output", %{table: table} do
    rows = [
      ["E-Z Rollers", "Tough At The Top", %Cell{value: 1998, align: :right}],
      ["nCode", "Spasm", %Cell{value: 1999, align: :right}],
    ]
    additional_rows = [
      ["Aquasky", "Uptight", %Cell{value: 2000, align: :right}],
      ["Dom & Roland", "Dance All Night", %Cell{value: 2004, align: :right}]
    ]
    table = Table.add_rows(table, rows)
    table = Table.add_rows(table, additional_rows)
    assert table.rows == [
      [
        %Cell{value: "Dom & Roland"},
        %Cell{value: "Dance All Night"},
        %Cell{value: "2004", align: :right},
      ],
      [
        %Cell{value: "Aquasky"},
        %Cell{value: "Uptight"},
        %Cell{value: "2000", align: :right},
      ],
      [
        %Cell{value: "nCode"},
        %Cell{value: "Spasm"},
        %Cell{value: "1999", align: :right},
      ],
      [
        %Cell{value: "E-Z Rollers"},
        %Cell{value: "Tough At The Top"},
        %Cell{value: "1998", align: :right},
      ]
    ]
  end

  test "add methods used together results in sane/expected output order", %{table: table} do
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
        %Cell{value: "Omni Trio"},
        %Cell{value: "Lucid"},
        %Cell{value: "2001"},
      ],
      [
        %Cell{value: "Dom & Roland"},
        %Cell{value: "Killa Bullet"},
        %Cell{value: "1999"},
      ],
      [
        %Cell{value: "Deep Blue"},
        %Cell{value: "The Helicopter Tune"},
        %Cell{value: "1993"},
      ],
      [
        %Cell{value: "Blame"},
        %Cell{value: "Music Takes You"},
        %Cell{value: "1992"},
      ]
    ]
  end

  test "setting and overriding a title", %{table: table} do
    title_1 = "Metalheadz Releases"
    table = Table.set_title(table, title_1)
    assert table.title == title_1
    title_2 = "Moving Shadow Releases"
    table = Table.set_title(table, title_2)
    assert table.title == title_2
  end

  test "clearing a title", %{table: table} do
    title = "Moving Shadow Releases"
    table = Table.set_title(table, title)
    table = Table.set_title(table, "")
    assert table.title == nil
    table = Table.set_title(table, title)
    table = Table.set_title(table, nil)
    assert table.title == nil
  end

  test "setting and then overriding a header row", %{table: table} do
    header_row = ["Artist"]
    table = Table.set_header(table, header_row)
    assert table.header_row == [
      %Cell{value: "Artist"},
    ]
    header_row = ["Artist", "Track", "Year"]
    table = Table.set_header(table, header_row)
    assert table.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track"},
      %Cell{value: "Year"}
    ]
  end

  test "setting a header row with cell structs", %{table: table} do
    header_row = [
      "Artist",
      %Cell{value: "Track", align: :left},
      %Cell{value: "Year", align: :right}
     ]
    table = Table.set_header(table, header_row)
    assert table.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track", align: :left},
      %Cell{value: "Year", align: :right},
    ]
  end

  test "clearing a set header row", %{table: table} do
    header_row = ["Artist"]
    table =
      table
      |> Table.set_header(header_row)
      |> Table.set_header(nil)
    assert table.header_row == []
    table =
      table
      |> Table.set_header(header_row)
      |> Table.set_header([])
    assert table.header_row == []
  end

  test "setting column meta for a specific column", %{table: table} do
    assert table.columns == %{}
    table = Table.set_column_meta(table, 0, align: :right)
    assert table.columns == %{
      0 => %Column{align: :right}
    }
    table = Table.set_column_meta(table, 0, align: :left, padding: 2)
    table = Table.set_column_meta(table, 1, align: :right)
    assert table.columns == %{
      0 => %Column{align: :left, padding: 2},
      1 => %Column{align: :right}
    }
  end

  test "setting column meta across specific columns", %{table: table} do
    table = Table.set_column_meta(table, 0..2, align: :right)
    assert table.columns == %{
      0 => %Column{align: :right},
      1 => %Column{align: :right},
      2 => %Column{align: :right}
    }
    table = Table.set_column_meta(table, 1..3, padding: 2)
    assert table.columns == %{
      0 => %Column{align: :right},
      1 => %Column{align: :right, padding: 2},
      2 => %Column{align: :right, padding: 2},
      3 => %Column{padding: 2}
    }
  end

  test "setting column meta across all columns", %{table: table} do
    assert Table.get_column_meta(table, 0, :align) == :center
    assert Table.get_column_meta(table, 1, :align) == :center
    table = Table.set_column_meta(table, :all, align: :right)
    assert Table.get_column_meta(table, 0, :align) == :right
    assert Table.get_column_meta(table, 1, :align) == :right
    table = Table.set_column_meta(table, :all, align: :left)
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :left
  end

  test "overriding column meta across all columns", %{table: table} do
    table = Table.set_column_meta(table, 0, align: :right)
    assert Table.get_column_meta(table, 0, :align) == :right
    assert Table.get_column_meta(table, 1, :align) == :center
    table = Table.set_column_meta(table, :all, align: :left)
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
      |> Table.set_cell_meta(0, 0, align: :right)
      |> Table.set_cell_meta(1, 1, align: :left)

    assert table.rows == [
      [
        %Cell{value: "Calyx", align: nil},
        %Cell{value: "Downpour", align: :left},
        %Cell{value: "2001", align: nil}
      ],
      [
        %Cell{value: "Dom & Roland", align: :right},
        %Cell{value: "Thunder", align: nil},
        %Cell{value: "1998", align: nil}
      ]
    ]
  end

  test "setting header cell meta", %{table: table} do
    header = ["Artist", "Track", "Year"]
    table =
      table
      |> Table.set_header(header)
      |> Table.set_header_meta(0, align: :left)
      |> Table.set_header_meta(1, align: :right)
    assert table.header_row == [
        %Cell{value: "Artist", align: :left},
        %Cell{value: "Track", align: :right},
        %Cell{value: "Year", align: nil}
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
      |> Table.set_title(title)
      |> Table.set_header(header)
      |> Table.add_rows(rows)
      |> Table.clear_rows
    assert table.title == title
    assert table.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track"},
      %Cell{value: "Year"}
    ]
    assert table.rows == []
  end

  test "copying to a new table", %{table: existing_table} do
    new_row = ["Calyx", "Get Myself To You", 2005]
    existing_table = Table.add_row(existing_table, new_row)
    new_table = existing_table
    assert new_table.rows == [[
      %Cell{value: "Calyx"},
      %Cell{value: "Get Myself To You"},
      %Cell{value: "2005"}
    ]]
    additional_row = ["E-Z Rollers", "Back To Love", 2002]
    new_table = Table.add_row(new_table, additional_row)
    assert existing_table.rows == [[
      %Cell{value: "Calyx"},
      %Cell{value: "Get Myself To You"},
      %Cell{value: "2005"}
    ]]
    assert new_table.rows == [
      [
        %Cell{value: "E-Z Rollers"},
        %Cell{value: "Back To Love"},
        %Cell{value: "2002"}
      ],
      [
        %Cell{value: "Calyx"},
        %Cell{value: "Get Myself To You"},
        %Cell{value: "2005"}
      ]
    ]
  end

  test "get_column_meta returns correct values and defaults", %{table: table} do
    table = Table.set_column_meta(table, 0, align: :left)
    assert Table.get_column_meta(table, 0, :align) == :left
    assert Table.get_column_meta(table, 1, :align) == :center
    assert Table.get_column_meta(table, 2, :padding) == 1
  end

  test "has_rows? returns correct response", _setup do
    table = Table.new
    assert table |> Table.has_rows? == false
    table = %Table{rows: [["Exile", "Silver Spirit", "2003"]]}
    assert table |> Table.has_rows? == true
    table = %Table{rows: []}
    assert table |> Table.has_rows? == false
  end

  test "has_header? returns correct response", _setup do
    table = Table.new
    assert table |> Table.has_header? == false
    table = %Table{header_row: ["Artist", "Track", "Year"]}
    assert table |> Table.has_header? == true
    table = %Table{header_row: []}
    assert table |> Table.has_header? == false
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
      send self(), {:rendering, table, render_opts}
      {:ok, "Rendered String"}
    end

  end

  test "render/2 default runs" do
    {:ok, rendered} =
      Table.new
      |> Table.add_row(["a"])
      |> Table.render
    assert is_binary(rendered)
  end

  test "render/2 calls correctly" do
    {:ok, _} =
      Table.new
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
      Table.new
      |> Table.render(renderer: TestRenderer)
    assert reason == "Table must have at least one row before being rendered"
    refute_received {:rendering, _, _}
  end

  test "render!/2 default runs" do
    rendered =
      Table.new
      |> Table.add_row(["a"])
      |> Table.render!
    assert is_binary(rendered)
  end

  test "render!/2 calls correctly" do
    rendered =
      Table.new
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
      Table.new
      |> Table.render!
    end
  end

end
