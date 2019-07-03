defmodule TableRex.Renderer.TextTest do
  use ExUnit.Case, async: true
  alias TableRex.Table

  setup do
    title = "Renegade Hardware Releases"
    header = ["Artist", "Track", "Year\nDate"]

    rows = [
      ["Konflict", "Cyanide", 1999],
      [
        "Keaton & Hive!",
        "The Plague\nhello\nhello\nworld",
        2003
      ],
      ["Vicious Circle", "Welcome To\nShanktown", 2007]
    ]

    table = Table.new(rows, header, title)

    opts = [
      header_color_function: fn _ -> nil end,
      table_color_function: fn _, _ -> nil end,
      row_seperator: true
    ]

    {:ok, table: table, opts: opts}
  end

  test "empty table renders correctly", %{table: table, opts: opts} do
    {:ok, rendered} = Table.render(%{table | rows: []}, opts)

    assert rendered == """
           ├─Artist───┼─Track───┼─Year───┤
           ├──────────┼─────────┼─Date───┤
           └──────────┴─────────┴────────┘
           """
  end

  test "deactivating row seperator works", %{table: table, opts: opts} do
    {:ok, rendered} = Table.render(table, opts ++ [row_seperator: false])

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render", %{table: table, opts: opts} do
    {:ok, rendered} = Table.render(table, opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render without title", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render without title & header", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.put_header(nil)
      |> Table.render(opts)

    assert rendered == """
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with title but no header", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_header(nil)
      |> Table.render(opts)

    assert rendered == """
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with alphabetic ascending sort by artist name", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.sort(0, :asc)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with alphabetic descending sort by track name", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.sort(1, :desc)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Konflict       │ Cyanide    │ 1999 │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with numeric ascending sort by year", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.sort(2, :asc)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with numeric descending sort by year", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.sort(2, :desc)
      |> Table.render(opts)

    assert rendered ==
             """
             ├─Artist─────────┼─Track──────┼─Year─┤
             ├────────────────┼────────────┼─Date─┤
             │ Vicious Circle │ Welcome To │ 2007 │
             │                │ Shanktown  │      │
             │────────────────┼────────────┼──────│
             │ Keaton & Hive! │ The Plague │ 2003 │
             │                │ hello      │      │
             │                │ hello      │      │
             │                │ world      │      │
             │────────────────┼────────────┼──────│
             │ Konflict       │ Cyanide    │ 1999 │
             └────────────────┴────────────┴──────┘
             """
  end

  test "header_separator_symbol: =", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} = Table.render(table, opts ++ [header_separator_symbol: "="])

    assert rendered == """
           ├=Artist=========┼=Track======┼=Year=┤
           ├================┼============┼=Date=┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with alignment", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(0, align: :center)
      |> Table.put_column_meta(1, align: :right)
      |> Table.render(opts)

    assert rendered == """
           ├─────Artist─────┼──────Track─┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │    Konflict    │    Cyanide │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │      hello │      │
           │                │      hello │      │
           │                │      world │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │  Shanktown │      │
           └────────────────┴────────────┴──────┘
           """

    {:ok, rendered} =
      table
      |> Table.clear_all_column_meta()
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with added padding", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, padding: 3)
      |> Table.render(opts)

    assert rendered == """
           ├───Artist───────────┼───Track────────┼───Year───┤
           ├────────────────────┼────────────────┼───Date───┤
           │   Konflict         │   Cyanide      │   1999   │
           │────────────────────┼────────────────┼──────────│
           │   Keaton & Hive!   │   The Plague   │   2003   │
           │                    │   hello        │          │
           │                    │   hello        │          │
           │                    │   world        │          │
           │────────────────────┼────────────────┼──────────│
           │   Vicious Circle   │   Welcome To   │   2007   │
           │                    │   Shanktown    │          │
           └────────────────────┴────────────────┴──────────┘
           """
  end

  test "default render with added padding & alignment", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(0, padding: 3, align: :center)
      |> Table.put_column_meta(1..2, padding: 3, align: :right)
      |> Table.render(opts)

    assert rendered == """
           ├───────Artist───────┼────────Track───┼───Year───┤
           ├────────────────────┼────────────────┼───Date───┤
           │      Konflict      │      Cyanide   │   1999   │
           │────────────────────┼────────────────┼──────────│
           │   Keaton & Hive!   │   The Plague   │   2003   │
           │                    │        hello   │          │
           │                    │        hello   │          │
           │                    │        world   │          │
           │────────────────────┼────────────────┼──────────│
           │   Vicious Circle   │   Welcome To   │   2007   │
           │                    │    Shanktown   │          │
           └────────────────────┴────────────────┴──────────┘
           """
  end

  @tag :active
  test "default render with added color using a named ANSI sequence", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼\e[31m─Track──────\e[0m┼─Year─┤
           ├────────────────┼\e[31m────────────\e[0m┼─Date─┤
           │ Konflict       │\e[31m Cyanide    \e[0m│ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │\e[31m Welcome To \e[0m│ 2007 │
           │                │\e[31m Shanktown  \e[0m│      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with added color using an embedded ANSI sequence", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: "\e[31m")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼\e[31m─Track──────\e[0m┼─Year─┤
           ├────────────────┼\e[31m────────────\e[0m┼─Date─┤
           │ Konflict       │\e[31m Cyanide    \e[0m│ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │\e[31m Welcome To \e[0m│ 2007 │
           │                │\e[31m Shanktown  \e[0m│      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with added color using multiple ANSI sequences", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: ["\e[48;5;30m", :white])
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼\e[48;5;30m\e[37m─Track──────\e[0m┼─Year─┤
           ├────────────────┼\e[48;5;30m\e[37m────────────\e[0m┼─Date─┤
           │ Konflict       │\e[48;5;30m\e[37m Cyanide    \e[0m│ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[48;5;30m\e[37m The Plague \e[0m│ 2003 │
           │                │\e[48;5;30m\e[37m hello      \e[0m│      │
           │                │\e[48;5;30m\e[37m hello      \e[0m│      │
           │                │\e[48;5;30m\e[37m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │\e[48;5;30m\e[37m Welcome To \e[0m│ 2007 │
           │                │\e[48;5;30m\e[37m Shanktown  \e[0m│      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with increases padding across all rows (using list)", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta([0, 1, 2], align: :left, padding: 3)
      |> Table.render(opts)

    assert rendered == """
           ├───Artist───────────┼───Track────────┼───Year───┤
           ├────────────────────┼────────────────┼───Date───┤
           │   Konflict         │   Cyanide      │   1999   │
           │────────────────────┼────────────────┼──────────│
           │   Keaton & Hive!   │   The Plague   │   2003   │
           │                    │   hello        │          │
           │                    │   hello        │          │
           │                    │   world        │          │
           │────────────────────┼────────────────┼──────────│
           │   Vicious Circle   │   Welcome To   │   2007   │
           │                    │   Shanktown    │          │
           └────────────────────┴────────────────┴──────────┘
           """
  end

  test "minimal render (zero padding)", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, padding: 0)
      |> Table.render(opts)

    assert rendered == """
           ├Artist────────┼Track─────┼Year┤
           ├──────────────┼──────────┼Date┤
           │Konflict      │Cyanide   │1999│
           │──────────────┼──────────┼────│
           │Keaton & Hive!│The Plague│2003│
           │              │hello     │    │
           │              │hello     │    │
           │              │world     │    │
           │──────────────┼──────────┼────│
           │Vicious Circle│Welcome To│2007│
           │              │Shanktown │    │
           └──────────────┴──────────┴────┘
           """
  end

  test "default render with set column meta across all columns", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :center)
      |> Table.render(opts)

    assert rendered == """
           ├─────Artist─────┼───Track────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │    Konflict    │  Cyanide   │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │   hello    │      │
           │                │   hello    │      │
           │                │   world    │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with set column meta across all columns and specific column override", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :center)
      |> Table.put_column_meta(1, align: :right)
      |> Table.render(opts)

    assert rendered == """
           ├─────Artist─────┼──────Track─┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │    Konflict    │    Cyanide │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │      hello │      │
           │                │      hello │      │
           │                │      world │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │  Shanktown │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with cell level alignment", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :right)
      |> Table.put_cell_meta(0, 0, align: :center)
      |> Table.put_cell_meta(1, 1, align: :left)
      |> Table.render(opts)

    assert rendered == """
           ├─────────Artist─┼──────Track─┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │    Konflict    │    Cyanide │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │  Shanktown │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with cell level color using a named ANSI sequence", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: :red)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with cell level color using an embedded ANSI sequence", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: "\e[31m")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with cell level color using multiple ANSI sequences", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: ["\e[48;5;30m", :white])
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼─Track──────┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[48;5;30m\e[37m The Plague \e[0m│ 2003 │
           │                │\e[48;5;30m\e[37m hello      \e[0m│      │
           │                │\e[48;5;30m\e[37m hello      \e[0m│      │
           │                │\e[48;5;30m\e[37m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with header cell alignment", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_header_meta(0, align: :center)
      |> Table.put_header_meta(1, align: :right)
      |> Table.render(opts)

    assert rendered == """
           ├─────Artist─────┼──────Track─┼─Year─┤
           ├────────────────┼────────────┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with header cell color", %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_header_meta(0, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render(opts)

    assert rendered == """
           ├\e[31m─Artist─────────\e[0m┼\e[34m─Track──────\e[0m┼─Year─┤
           ├\e[31m────────────────\e[0m┼\e[34m────────────\e[0m┼─Date─┤
           │ Konflict       │ Cyanide    │ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │ The Plague │ 2003 │
           │                │ hello      │      │
           │                │ hello      │      │
           │                │ world      │      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │ Welcome To │ 2007 │
           │                │ Shanktown  │      │
           └────────────────┴────────────┴──────┘
           """
  end

  @tag :active
  test "default render with set column meta color across all columns and specific header override",
       %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼\e[34m─Track──────\e[0m┼─Year─┤
           ├────────────────┼\e[34m────────────\e[0m┼─Date─┤
           │ Konflict       │\e[31m Cyanide    \e[0m│ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │\e[31m Welcome To \e[0m│ 2007 │
           │                │\e[31m Shanktown  \e[0m│      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with set column meta color across all columns and clear header", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :reset)
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────┼\e[0m─Track──────\e[0m┼─Year─┤
           ├────────────────┼\e[0m────────────\e[0m┼─Date─┤
           │ Konflict       │\e[31m Cyanide    \e[0m│ 1999 │
           │────────────────┼────────────┼──────│
           │ Keaton & Hive! │\e[31m The Plague \e[0m│ 2003 │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m hello      \e[0m│      │
           │                │\e[31m world      \e[0m│      │
           │────────────────┼────────────┼──────│
           │ Vicious Circle │\e[31m Welcome To \e[0m│ 2007 │
           │                │\e[31m Shanktown  \e[0m│      │
           └────────────────┴────────────┴──────┘
           """
  end

  test "default render with title that is one less than the combined column widths", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Be Here Now")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist────────────┼─Track─────────┼─Year────┤
           ├───────────────────┼───────────────┼─Date────┤
           │ Konflict          │ Cyanide       │ 1999    │
           │───────────────────┼───────────────┼─────────│
           │ Keaton & Hive!    │ The Plague    │ 2003    │
           │                   │ hello         │         │
           │                   │ hello         │         │
           │                   │ world         │         │
           │───────────────────┼───────────────┼─────────│
           │ Vicious Circle    │ Welcome To    │ 2007    │
           │                   │ Shanktown     │         │
           └───────────────────┴───────────────┴─────────┘
           """
  end

  test "default render with title that exactly matches combined column widths", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Here Now")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────────┼─Track──────────┼─Year─────┤
           ├────────────────────┼────────────────┼─Date─────┤
           │ Konflict           │ Cyanide        │ 1999     │
           │────────────────────┼────────────────┼──────────│
           │ Keaton & Hive!     │ The Plague     │ 2003     │
           │                    │ hello          │          │
           │                    │ hello          │          │
           │                    │ world          │          │
           │────────────────────┼────────────────┼──────────│
           │ Vicious Circle     │ Welcome To     │ 2007     │
           │                    │ Shanktown      │          │
           └────────────────────┴────────────────┴──────────┘
           """
  end

  test "default render with title that exceeds combined column widths by 1 character", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Seen Here")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────────┼─Track──────────┼─Year─────┤
           ├────────────────────┼────────────────┼─Date─────┤
           │ Konflict           │ Cyanide        │ 1999     │
           │────────────────────┼────────────────┼──────────│
           │ Keaton & Hive!     │ The Plague     │ 2003     │
           │                    │ hello          │          │
           │                    │ hello          │          │
           │                    │ world          │          │
           │────────────────────┼────────────────┼──────────│
           │ Vicious Circle     │ Welcome To     │ 2007     │
           │                    │ Shanktown      │          │
           └────────────────────┴────────────────┴──────────┘
           """
  end

  test "default render with title that far exceeds combined column widths", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist─────────────────┼─Track──────────────┼─Year─────────┤
           ├────────────────────────┼────────────────────┼─Date─────────┤
           │ Konflict               │ Cyanide            │ 1999         │
           │────────────────────────┼────────────────────┼──────────────│
           │ Keaton & Hive!         │ The Plague         │ 2003         │
           │                        │ hello              │              │
           │                        │ hello              │              │
           │                        │ world              │              │
           │────────────────────────┼────────────────────┼──────────────│
           │ Vicious Circle         │ Welcome To         │ 2007         │
           │                        │ Shanktown          │              │
           └────────────────────────┴────────────────────┴──────────────┘
           """
  end

  test "default render with title that far exceeds combined column widths with irregular alignments",
       %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.put_column_meta(0, align: :right)
      |> Table.put_column_meta(1, align: :center)
      |> Table.render(opts)

    assert rendered == """
           ├─────────────────Artist─┼───────Track────────┼─Year─────────┤
           ├────────────────────────┼────────────────────┼─Date─────────┤
           │               Konflict │      Cyanide       │ 1999         │
           │────────────────────────┼────────────────────┼──────────────│
           │         Keaton & Hive! │     The Plague     │ 2003         │
           │                        │       hello        │              │
           │                        │       hello        │              │
           │                        │       world        │              │
           │────────────────────────┼────────────────────┼──────────────│
           │         Vicious Circle │     Welcome To     │ 2007         │
           │                        │     Shanktown      │              │
           └────────────────────────┴────────────────────┴──────────────┘
           """
  end

  test "default render with title exceeding combined column widths by multiple of number of columns",
       %{table: table, opts: opts} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases Seen In This Very Table")
      |> Table.render(opts)

    assert rendered == """
           ├─Artist───────────────┼─Track────────────┼─Year───────┤
           ├──────────────────────┼──────────────────┼─Date───────┤
           │ Konflict             │ Cyanide          │ 1999       │
           │──────────────────────┼──────────────────┼────────────│
           │ Keaton & Hive!       │ The Plague       │ 2003       │
           │                      │ hello            │            │
           │                      │ hello            │            │
           │                      │ world            │            │
           │──────────────────────┼──────────────────┼────────────│
           │ Vicious Circle       │ Welcome To       │ 2007       │
           │                      │ Shanktown        │            │
           └──────────────────────┴──────────────────┴────────────┘
           """
  end

  test "default render with title exactly matching combined column widths when only 2 columns", %{
    table: table,
    opts: opts
  } do
    title = "Renegade Hardware Releases Shown Here"
    header = ["Artist", "Track"]

    rows = [
      ["Konflict", "Cyanide"],
      ["Keaton & Hive", "The Plague"],
      ["Vicious Circle", "Welcome To Shanktown"]
    ]

    {:ok, rendered} =
      Table.new(rows, header, title)
      |> Table.render(opts)

    assert rendered === """
           ├─Artist─────────┼─Track────────────────┤
           │ Konflict       │ Cyanide              │
           │────────────────┼──────────────────────│
           │ Keaton & Hive  │ The Plague           │
           │────────────────┼──────────────────────│
           │ Vicious Circle │ Welcome To Shanktown │
           └────────────────┴──────────────────────┘
           """
  end

  test "default render with title exceeding combined column widths by 1 character when only 2 columns",
       %{table: table, opts: opts} do
    title = "Renegade Hardware Releases Shown Here!"
    header = ["Artist", "Track"]

    rows = [
      ["Konflict", "Cyanide"],
      ["Keaton & Hive", "The Plague"],
      ["Vicious Circle", "Welcome To Shanktown"]
    ]

    {:ok, rendered} =
      Table.new(rows, header, title)
      |> Table.render(opts)

    assert rendered === """
           ├─Artist──────────┼─Track─────────────────┤
           │ Konflict        │ Cyanide               │
           │─────────────────┼───────────────────────│
           │ Keaton & Hive   │ The Plague            │
           │─────────────────┼───────────────────────│
           │ Vicious Circle  │ Welcome To Shanktown  │
           └─────────────────┴───────────────────────┘
           """
  end

  test "default render with individual cells containing ANSI color codes", %{
    table: table,
    opts: opts
  } do
    title = "Renegade Hardware Releases"
    header = ["Artist", "Track", "Year"]

    rows = [
      ["Konflict", "Cyanide", IO.ANSI.format([:red, "19", :bright, "99"])],
      ["Keaton & Hive", "The Plague", 2003],
      ["Vicious Circle", "Welcome To Shanktown", IO.ANSI.format(["200", :green, "7"])]
    ]

    {:ok, rendered} =
      rows
      |> Table.new(header, title)
      |> Table.render(opts ++ [row_seperator: false])

    assert rendered === """
           ├─Artist─────────┼─Track────────────────┼─Year─┤
           │ Konflict       │ Cyanide              │ \e[31m19\e[1m99\e[0m │
           │ Keaton & Hive  │ The Plague           │ 2003 │
           │ Vicious Circle │ Welcome To Shanktown │ 200\e[32m7\e[0m │
           └────────────────┴──────────────────────┴──────┘
           """
  end

  test "render with irregular column paddings with title exceeding combined column widths", %{
    table: table,
    opts: opts
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.put_column_meta(0..1, padding: 0)
      |> Table.put_column_meta(2, padding: 1)
      |> Table.render(opts)

    assert rendered == """
           ├Artist─────────────────┼Track──────────────┼─Year──────────┤
           ├───────────────────────┼───────────────────┼─Date──────────┤
           │Konflict               │Cyanide            │ 1999          │
           │───────────────────────┼───────────────────┼───────────────│
           │Keaton & Hive!         │The Plague         │ 2003          │
           │                       │hello              │               │
           │                       │hello              │               │
           │                       │world              │               │
           │───────────────────────┼───────────────────┼───────────────│
           │Vicious Circle         │Welcome To         │ 2007          │
           │                       │Shanktown          │               │
           └───────────────────────┴───────────────────┴───────────────┘
           """
  end
end
