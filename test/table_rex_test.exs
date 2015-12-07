defmodule TableRex.TableRexTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell
  alias TableRex.Column
  alias TableRex.Table

  setup do
    {:ok, table_rex} = TableRex.start_link
    {:ok, table_rex: table_rex}
  end

  test "start and stop unlinked", _ do
    {:ok, table_rex} = TableRex.start
    :ok = Agent.stop(table_rex, 5_000)
  end

  test "adding a single row with values", %{table_rex: table_rex} do
    row = ["Dom & Roland", "Thunder", 1998]
    :ok = TableRex.add_row(table_rex, row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.rows == [[
       %Cell{value: "Dom & Roland"},
       %Cell{value: "Thunder"},
       %Cell{value: "1998"}
     ]]
    second_row = ["Calyx", "Downpour", 2001]
    :ok = TableRex.add_row(table_rex, second_row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.rows == [
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

  test "adding a single row with cell structs", %{table_rex: table_rex} do
    row = [
      "Rascal & Klone",
      %Cell{value: "The Grind", align: :left},
      %Cell{value: 2000, align: :right}
    ]
    :ok = TableRex.add_row(table_rex, row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.rows == [[
      %Cell{value: "Rascal & Klone"},
      %Cell{value: "The Grind", align: :left},
      %Cell{value: "2000", align: :right}
    ]]
  end

  test "adding multiple rows multiple times results in sane order output", %{table_rex: table_rex} do
    rows = [
      ["E-Z Rollers", "Tough At The Top", %Cell{value: 1998, align: :right}],
      ["nCode", "Spasm", %Cell{value: 1999, align: :right}],
    ]
    additional_rows = [
      ["Aquasky", "Uptight", %Cell{value: 2000, align: :right}],
      ["Dom & Roland", "Dance All Night", %Cell{value: 2004, align: :right}]
    ]
    :ok = TableRex.add_rows(table_rex, rows)
    :ok = TableRex.add_rows(table_rex, additional_rows)
    table_state = TableRex.get_table(table_rex)
    assert table_state.rows == [
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

  test "add methods used together results in sane/expected output order", %{table_rex: table_rex} do
    first_row = ["Blame", "Music Takes You", 1992]
    middle_rows = [
      ["Deep Blue", "The Helicopter Tune", 1993],
      ["Dom & Roland", "Killa Bullet", 1999]
    ]
    fourth_row = ["Omni Trio", "Lucid", 2001]
    :ok = TableRex.add_row(table_rex, first_row)
    :ok = TableRex.add_rows(table_rex, middle_rows)
    :ok = TableRex.add_row(table_rex, fourth_row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.rows == [
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

  test "setting and overriding a title", %{table_rex: table_rex} do
    title_1 = "Metalheadz Releases"
    :ok = TableRex.set_title(table_rex, title_1)
    table_state = TableRex.get_table(table_rex)
    assert table_state.title == title_1
    title_2 = "Moving Shadow Releases"
    :ok = TableRex.set_title(table_rex, title_2)
    table_state = TableRex.get_table(table_rex)
    assert table_state.title == title_2
  end

  test "clearing a title", %{table_rex: table_rex} do
    title = "Moving Shadow Releases"
    :ok = TableRex.set_title(table_rex, title)
    :ok = TableRex.set_title(table_rex, "")
    table_state = TableRex.get_table(table_rex)
    assert table_state.title == nil
    :ok = TableRex.set_title(table_rex, title)
    :ok = TableRex.set_title(table_rex, nil)
    table_state = TableRex.get_table(table_rex)
    assert table_state.title == nil
  end

  test "setting and then overriding a header row", %{table_rex: table_rex} do
    header_row = ["Artist"]
    :ok = TableRex.set_header(table_rex, header_row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.header_row == [
      %Cell{value: "Artist"},
    ]
    header_row = ["Artist", "Track", "Year"]
    :ok = TableRex.set_header(table_rex, header_row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track"},
      %Cell{value: "Year"}
    ]
  end

  test "setting a header row with cell structs", %{table_rex: table_rex} do
    header_row = [
      "Artist",
      %Cell{value: "Track", align: :left},
      %Cell{value: "Year", align: :right}
     ]
    :ok = TableRex.set_header(table_rex, header_row)
    table_state = TableRex.get_table(table_rex)
    assert table_state.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track", align: :left},
      %Cell{value: "Year", align: :right},
    ]
  end

  test "clearing a set header row", %{table_rex: table_rex} do
    header_row = ["Artist"]
    :ok = TableRex.set_header(table_rex, header_row)
    :ok = TableRex.set_header(table_rex, nil)
    table_state = TableRex.get_table(table_rex)
    assert table_state.header_row == []
    :ok = TableRex.set_header(table_rex, header_row)
    :ok = TableRex.set_header(table_rex, [])
    table_state = TableRex.get_table(table_rex)
    assert table_state.header_row == []
  end

  test "adding meta to a column", %{table_rex: table_rex} do
    table_state = TableRex.get_table(table_rex)
    assert table_state.columns == %{}
    :ok = TableRex.set_column_meta(table_rex, 0, :align, :right)
    table_state = TableRex.get_table(table_rex)
    assert table_state.columns == %{
      0 => %Column{align: :right}
    }
    :ok = TableRex.set_column_meta(table_rex, 0, :align, :left)
    :ok = TableRex.set_column_meta(table_rex, 0, :padding, 2)
    :ok = TableRex.set_column_meta(table_rex, 1, :align, :right)
    table_state = TableRex.get_table(table_rex)
    assert table_state.columns == %{
      0 => %Column{align: :left, padding: 2},
      1 => %Column{align: :right}
    }
  end

  test "adding incorrect meta to a column", %{table_rex: table_rex} do
    assert_raise RuntimeError, fn ->
      TableRex.set_column_meta(table_rex, 0, :some_fake_option, "Whatever")
    end
  end

  test "clearing rows", %{table_rex: table_rex} do
    title = "Moving Shadow Releases"
    header_row = ["Artist", "Track", "Year"]
    rows = [
      ["Blame", "Neptune", 1996],
      ["Rob & Dom", "Distorted Dreams", 1997]
    ]
    :ok = TableRex.set_title(table_rex, title)
    :ok = TableRex.set_header(table_rex, header_row)
    :ok = TableRex.add_rows(table_rex, rows)
    :ok = TableRex.clear_rows(table_rex)
    table_state = TableRex.get_table(table_rex)
    assert table_state.title == title
    assert table_state.header_row == [
      %Cell{value: "Artist"},
      %Cell{value: "Track"},
      %Cell{value: "Year"}
    ]
    assert table_state.rows == []
  end

  test "resetting table", %{table_rex: table_rex} do
    title = "Moving Shadow Releases"
    header_row = ["Artist", "Track", "Year"]
    rows = [
      ["Blame", "Neptune", 1996],
      ["Rob & Dom", "Distorted Dreams", 1997]
    ]
    :ok = TableRex.set_title(table_rex, title)
    :ok = TableRex.set_header(table_rex, header_row)
    :ok = TableRex.add_rows(table_rex, rows)
    :ok = TableRex.reset(table_rex)
    table_state = TableRex.get_table(table_rex)
    assert table_state == %Table{}
  end

  test "copying of state to a new table process", %{table_rex: existing_table} do
    existing_row = ["Calyx", "Get Myself To You", 2005]
    :ok = TableRex.add_row(existing_table, existing_row)
    existing_table_state = TableRex.get_table(existing_table)
    {:ok, new_table} = TableRex.start_link(existing_table_state)
    assert TableRex.get_table(new_table).rows == [[
      %Cell{value: "Calyx"},
      %Cell{value: "Get Myself To You"},
      %Cell{value: "2005"}
    ]]
    additional_row = ["E-Z Rollers", "Back To Love", 2002]
    :ok = TableRex.add_row(new_table, additional_row)
    assert TableRex.get_table(new_table).rows == [
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

  test "has_header? check", %{table_rex: table_rex} do
    assert TableRex.has_header?(table_rex) == false
    header_row = ["Artist", "Track", "Year"]
    :ok = TableRex.set_header(table_rex, header_row)
    assert TableRex.has_header?(table_rex) == true
  end

  test "has_rows? check", %{table_rex: table_rex} do
    assert TableRex.has_rows?(table_rex) == false
    row = ["E-Z Rollers", "Walk This Land", 1999]
    :ok = TableRex.add_row(table_rex, row)
    assert TableRex.has_rows?(table_rex) == true
  end

end
