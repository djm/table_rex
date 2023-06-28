defmodule TableRex.Renderer.TextTest do
  use ExUnit.Case, async: true
  alias TableRex.Table

  setup do
    title = "Renegade Hardware Releases"
    header = ["Artist", "Track", "Year"]

    rows = [
      ["Konflict", "Cyanide", 1999],
      ["Keaton & Hive", "The Plague", 2003],
      ["Vicious Circle", "Welcome To Shanktown", 2007]
    ]

    table = Table.new(rows, header, title)

    multi_header = ["Artist", "Track", "Details", "Year"]

    multi_rows = [
      ["Konflict", "Cyanide", "Label: Renegade Hardware\nCat#: RH020", 1999],
      [
        "Keaton & Hive",
        "The Plague",
        "Label: Renegade Hardware\nCat#: RH45\nBarcode: 5 029651 001759",
        2003
      ],
      ["Vicious Circle", "Welcome To Shanktown", "Label: Renegade Hardware\nCat#: HWARE02", 2007]
    ]

    multiline = Table.new(multi_rows, multi_header)

    {:ok, table: table, multiline: multiline}
  end

  test "default render", %{table: table} do
    {:ok, rendered} = Table.render(table)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render without title", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.render()

    assert rendered == """
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render without title & header", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.put_header(nil)
      |> Table.render()

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with title but no header", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header(nil)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with alphabetic ascending sort by artist name", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.sort(0, :asc)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           | Konflict       | Cyanide              | 1999 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with alphabetic descending sort by track name", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.sort(1, :desc)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           """
  end

  test "default render with numeric ascending sort by year", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.sort(2, :asc)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with numeric descending sort by year", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.sort(2, :desc)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           """
  end

  test "render with vertical style: frame", %{table: table} do
    {:ok, rendered} = Table.render(table, vertical_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------------------------------------+
           | Artist           Track                  Year |
           +----------------------------------------------+
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           +----------------------------------------------+
           """
  end

  test "render with no title & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.render(vertical_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           | Artist           Track                  Year |
           +----------------------------------------------+
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           +----------------------------------------------+
           """
  end

  test "render with no title or header & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("")
      |> Table.put_header([])
      |> Table.render(vertical_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           +----------------------------------------------+
           """
  end

  test "render with title but no header & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(vertical_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------------------------------------+
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           +----------------------------------------------+
           """
  end

  test "render with vertical style: off", %{table: table} do
    {:ok, rendered} = Table.render(table, vertical_style: :off)

    assert rendered == """
           ----------------------------------------------
                     Renegade Hardware Releases
           ----------------------------------------------
            Artist           Track                  Year
           ----------------------------------------------
            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           ----------------------------------------------
           """
  end

  test "render with no title & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(vertical_style: :off)

    assert rendered == """
           ----------------------------------------------
            Artist           Track                  Year
           ----------------------------------------------
            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           ----------------------------------------------
           """
  end

  test "render with no title or header & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(vertical_style: :off)

    assert rendered == """
           ----------------------------------------------
            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           ----------------------------------------------
           """
  end

  test "render with title but no header & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(vertical_style: :off)

    assert rendered == """
           ----------------------------------------------
                     Renegade Hardware Releases
           ----------------------------------------------
            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           ----------------------------------------------
           """
  end

  test "render with horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :frame)

    assert rendered == """
           |          Renegade Hardware Releases          |
           |                                              |
           | Artist           Track                  Year |
           |                                              |
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           """
  end

  test "render with no title & horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :frame)

    assert rendered == """
           | Artist           Track                  Year |
           |                                              |
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           """
  end

  test "render with no title or header & horizontal style: off, vertical style: frame", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :frame)

    assert rendered == """
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           """
  end

  test "render with title but not header & horizontal style: off, vertical style: frame", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :frame)

    assert rendered == """
           |          Renegade Hardware Releases          |
           |                                              |
           | Konflict         Cyanide                1999 |
           | Keaton & Hive    The Plague             2003 |
           | Vicious Circle   Welcome To Shanktown   2007 |
           """
  end

  test "render with horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :all)

    assert rendered == """
           |          Renegade Hardware Releases          |
           |                                              |
           | Artist         | Track                | Year |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           """
  end

  test "render with no title & horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :all)

    assert rendered == """
           | Artist         | Track                | Year |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           """
  end

  test "render with no title or header & horizontal style: off, vertical style: all", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :all)

    assert rendered == """
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           """
  end

  test "render with title but no header & horizontal style: off, vertical style: all", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :all)

    assert rendered == """
           |          Renegade Hardware Releases          |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           """
  end

  test "render with horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :off)

    assert rendered == """
                     Renegade Hardware Releases

            Artist           Track                  Year

            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           """
  end

  test "render with no title & horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :off)

    assert rendered == """
            Artist           Track                  Year

            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           """
  end

  test "render with no title or header & horizontal style: off, vertical style: off", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :off)

    assert rendered == """
            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           """
  end

  test "render with title but no header & horizontal style: off, vertical style: off", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :off)

    assert rendered == """
                     Renegade Hardware Releases

            Konflict         Cyanide                1999
            Keaton & Hive    The Plague             2003
            Vicious Circle   Welcome To Shanktown   2007
           """
  end

  test "render with horizontal style: frame", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           |                                              |
           | Artist         | Track                | Year |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :frame)

    assert rendered == """
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with not title or header & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :frame)

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with title but no header & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :frame)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           |                                              |
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with horizontal style: all", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :all)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :all)

    assert rendered == """
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title or header & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all)

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with title but not header & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all)

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with horizontal style: all, header_separator_symbol: =", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :all, header_separator_symbol: "=")

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title & horizontal style: all, header_separator_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

    assert rendered == """
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title or header & horizontal style: all, top_frame_symbol: =", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, top_frame_symbol: "=")

    assert rendered == """
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title or header & horizontal style: all, top_frame_symbol: =, bottom_frame_symbol: =",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, top_frame_symbol: "=", bottom_frame_symbol: "=")

    assert rendered == """
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +================+======================+======+
           """
  end

  test "render with title but no header & horizontal style: all, header_separator_symbol: =", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with title but no header & horizontal style: all, title_separator_symbol: =", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=")

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with horizontal style: all, title_separator_symbol & header_horizontal_symbol: =",
       %{table: table} do
    {:ok, rendered} =
      Table.render(
        table,
        horizontal_style: :all,
        title_separator_symbol: "~",
        header_separator_symbol: "="
      )

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +~~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~~~~~~~~+~~~~~~+
           | Artist         | Track                | Year |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(
        horizontal_style: :all,
        title_separator_symbol: "=",
        header_separator_symbol: "="
      )

    assert rendered == """
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with no title or header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(
        horizontal_style: :all,
        title_separator_symbol: "=",
        header_separator_symbol: "="
      )

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "render with title but no header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(
        horizontal_style: :all,
        title_separator_symbol: "=",
        header_separator_symbol: "="
      )

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +================+======================+======+
           | Konflict       | Cyanide              | 1999 |
           +----------------+----------------------+------+
           | Keaton & Hive  | The Plague           | 2003 |
           +----------------+----------------------+------+
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(0, align: :center)
      |> Table.put_column_meta(1, align: :right)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |     Artist     |                Track | Year |
           +----------------+----------------------+------+
           |    Konflict    |              Cyanide | 1999 |
           | Keaton & Hive  |           The Plague | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """

    {:ok, rendered} =
      table
      |> Table.clear_all_column_meta()
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with added padding", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, padding: 3)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------------------+
           |                Renegade Hardware Releases                |
           +--------------------+--------------------------+----------+
           |   Artist           |   Track                  |   Year   |
           +--------------------+--------------------------+----------+
           |   Konflict         |   Cyanide                |   1999   |
           |   Keaton & Hive    |   The Plague             |   2003   |
           |   Vicious Circle   |   Welcome To Shanktown   |   2007   |
           +--------------------+--------------------------+----------+
           """
  end

  test "default render with added padding & alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(0, padding: 3, align: :center)
      |> Table.put_column_meta(1..2, padding: 3, align: :right)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------------------+
           |                Renegade Hardware Releases                |
           +--------------------+--------------------------+----------+
           |       Artist       |                  Track   |   Year   |
           +--------------------+--------------------------+----------+
           |      Konflict      |                Cyanide   |   1999   |
           |   Keaton & Hive    |             The Plague   |   2003   |
           |   Vicious Circle   |   Welcome To Shanktown   |   2007   |
           +--------------------+--------------------------+----------+
           """
  end

  test "default render with added color using a named ANSI sequence", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         |\e[31m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       |\e[31m Cyanide              \e[0m| 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle |\e[31m Welcome To Shanktown \e[0m| 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with added color using an embedded ANSI sequence", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: "\e[31m")
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         |\e[31m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       |\e[31m Cyanide              \e[0m| 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle |\e[31m Welcome To Shanktown \e[0m| 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with added color using multiple ANSI sequences", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: ["\e[48;5;30m", :white])
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         |\e[48;5;30m\e[37m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       |\e[48;5;30m\e[37m Cyanide              \e[0m| 1999 |
           | Keaton & Hive  |\e[48;5;30m\e[37m The Plague           \e[0m| 2003 |
           | Vicious Circle |\e[48;5;30m\e[37m Welcome To Shanktown \e[0m| 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with added color using a function", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(
        2,
        color: fn t, v -> if v in ["1999", "2007"], do: [:blue, t], else: t end
      )
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year \e[0m|
           +----------------+----------------------+------+
           | Konflict       | Cyanide              |\e[34m 1999 \e[0m|
           | Keaton & Hive  | The Plague           | 2003 \e[0m|
           | Vicious Circle | Welcome To Shanktown |\e[34m 2007 \e[0m|
           +----------------+----------------------+------+
           """
  end

  test "default render with increases padding across all rows (using list)", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta([0, 1, 2], align: :left, padding: 3)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------------------+
           |                Renegade Hardware Releases                |
           +--------------------+--------------------------+----------+
           |   Artist           |   Track                  |   Year   |
           +--------------------+--------------------------+----------+
           |   Konflict         |   Cyanide                |   1999   |
           |   Keaton & Hive    |   The Plague             |   2003   |
           |   Vicious Circle   |   Welcome To Shanktown   |   2007   |
           +--------------------+--------------------------+----------+
           """
  end

  test "minimal render (zero padding)", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, padding: 0)
      |> Table.render(horizontal_style: :off, vertical_style: :off)

    assert rendered == """
                  Renegade Hardware Releases

           Artist         Track                Year

           Konflict       Cyanide              1999
           Keaton & Hive  The Plague           2003
           Vicious Circle Welcome To Shanktown 2007
           """
  end

  test "default render with set column meta across all columns", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :center)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |     Artist     |        Track         | Year |
           +----------------+----------------------+------+
           |    Konflict    |       Cyanide        | 1999 |
           | Keaton & Hive  |      The Plague      | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with set column meta color across all columns", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, color: :red)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |\e[31m Artist         \e[0m|\e[31m Track                \e[0m|\e[31m Year \e[0m|
           +----------------+----------------------+------+
           |\e[31m Konflict       \e[0m|\e[31m Cyanide              \e[0m|\e[31m 1999 \e[0m|
           |\e[31m Keaton & Hive  \e[0m|\e[31m The Plague           \e[0m|\e[31m 2003 \e[0m|
           |\e[31m Vicious Circle \e[0m|\e[31m Welcome To Shanktown \e[0m|\e[31m 2007 \e[0m|
           +----------------+----------------------+------+
           """
  end

  test "default render with set column meta across all columns and specific column override", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :center)
      |> Table.put_column_meta(1, align: :right)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |     Artist     |                Track | Year |
           +----------------+----------------------+------+
           |    Konflict    |              Cyanide | 1999 |
           | Keaton & Hive  |           The Plague | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with cell level alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :right)
      |> Table.put_cell_meta(0, 0, align: :center)
      |> Table.put_cell_meta(1, 1, align: :left)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |         Artist |                Track | Year |
           +----------------+----------------------+------+
           |    Konflict    |              Cyanide | 1999 |
           |  Keaton & Hive | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with cell level color using a named ANSI sequence", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: :red)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with cell level color using an embedded ANSI sequence", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: "\e[31m")
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with cell level color using multiple ANSI sequences", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: ["\e[48;5;30m", :white])
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  |\e[48;5;30m\e[37m The Plague           \e[0m| 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with cell level color using a function", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_cell_meta(1, 1, color: fn t, _ -> ["\e[48;5;30m", :white, t] end)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  |\e[48;5;30m\e[37m The Plague           \e[0m| 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with header cell alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header_meta(0, align: :center)
      |> Table.put_header_meta(1, align: :right)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |     Artist     |                Track | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  describe "multiline cells" do
    test "rendering with center alignment", %{multiline: table} do
      {:ok, rendered} =
        table
        |> Table.put_column_meta(:all, align: :center)
        |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

      assert rendered == """
             +----------------+----------------------+--------------------------+------+
             |     Artist     |        Track         |         Details          | Year |
             +================+======================+==========================+======+
             |    Konflict    |       Cyanide        | Label: Renegade Hardware | 1999 |
             |                |                      |       Cat#: RH020        |      |
             +----------------+----------------------+--------------------------+------+
             | Keaton & Hive  |      The Plague      | Label: Renegade Hardware | 2003 |
             |                |                      |        Cat#: RH45        |      |
             |                |                      | Barcode: 5 029651 001759 |      |
             +----------------+----------------------+--------------------------+------+
             | Vicious Circle | Welcome To Shanktown | Label: Renegade Hardware | 2007 |
             |                |                      |      Cat#: HWARE02       |      |
             +----------------+----------------------+--------------------------+------+
             """
    end

    test "rendering with left alignment", %{multiline: table} do
      {:ok, rendered} =
        table
        |> Table.put_column_meta(:all, align: :left)
        |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

      assert rendered == """
             +----------------+----------------------+--------------------------+------+
             | Artist         | Track                | Details                  | Year |
             +================+======================+==========================+======+
             | Konflict       | Cyanide              | Label: Renegade Hardware | 1999 |
             |                |                      | Cat#: RH020              |      |
             +----------------+----------------------+--------------------------+------+
             | Keaton & Hive  | The Plague           | Label: Renegade Hardware | 2003 |
             |                |                      | Cat#: RH45               |      |
             |                |                      | Barcode: 5 029651 001759 |      |
             +----------------+----------------------+--------------------------+------+
             | Vicious Circle | Welcome To Shanktown | Label: Renegade Hardware | 2007 |
             |                |                      | Cat#: HWARE02            |      |
             +----------------+----------------------+--------------------------+------+
             """
    end

    test "rendering with right alignment", %{multiline: table} do
      {:ok, rendered} =
        table
        |> Table.put_column_meta(:all, align: :right)
        |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

      assert rendered == """
             +----------------+----------------------+--------------------------+------+
             |         Artist |                Track |                  Details | Year |
             +================+======================+==========================+======+
             |       Konflict |              Cyanide | Label: Renegade Hardware | 1999 |
             |                |                      |              Cat#: RH020 |      |
             +----------------+----------------------+--------------------------+------+
             |  Keaton & Hive |           The Plague | Label: Renegade Hardware | 2003 |
             |                |                      |               Cat#: RH45 |      |
             |                |                      | Barcode: 5 029651 001759 |      |
             +----------------+----------------------+--------------------------+------+
             | Vicious Circle | Welcome To Shanktown | Label: Renegade Hardware | 2007 |
             |                |                      |            Cat#: HWARE02 |      |
             +----------------+----------------------+--------------------------+------+
             """
    end

    test "can be specified using list literals" do
      header = ["Artist", "Track", "Details", "Year"]

      rows = [
        ["Konflict", "Cyanide", ["Label: Renegade Hardware", "Cat#: RH020"], 1999],
        [
          "Keaton & Hive",
          "The Plague",
          ["Label: Renegade Hardware", "Cat#: RH45", "Barcode: 5 029651 001759"],
          2003
        ],
        [
          "Vicious Circle",
          "Welcome To Shanktown",
          ["Label: Renegade Hardware", "Cat#: HWARE02"],
          2007
        ]
      ]

      {:ok, rendered} =
        Table.new(rows, header)
        |> Table.render(horizontal_style: :all, vertical_style: :off)

      assert rendered ==
               [
                 "-------------------------------------------------------------------------",
                 " Artist           Track                  Details                    Year",
                 "-------------------------------------------------------------------------",
                 " Konflict         Cyanide                Label: Renegade Hardware   1999 ",
                 "                                         Cat#: RH020",
                 "-------------------------------------------------------------------------",
                 " Keaton & Hive    The Plague             Label: Renegade Hardware   2003 ",
                 "                                         Cat#: RH45                      ",
                 "                                         Barcode: 5 029651 001759",
                 "-------------------------------------------------------------------------",
                 " Vicious Circle   Welcome To Shanktown   Label: Renegade Hardware   2007 ",
                 "                                         Cat#: HWARE02",
                 "-------------------------------------------------------------------------",
                 ""
               ]
               |> Enum.join("\n")
    end

    test "support formatting with color", %{multiline: table} do
      {:ok, rendered} =
        table
        |> Table.put_cell_meta(2, 1, color: "\e[31m")
        |> Table.put_column_meta(:all, align: :right)
        |> Table.render(horizontal_style: :all, header_separator_symbol: "=")

      assert rendered == """
             +----------------+----------------------+--------------------------+------+
             |         Artist |                Track |                  Details | Year |
             +================+======================+==========================+======+
             |       Konflict |              Cyanide | Label: Renegade Hardware | 1999 |
             |                |                      |              Cat#: RH020 |      |
             +----------------+----------------------+--------------------------+------+
             |  Keaton & Hive |           The Plague |\e[31m Label: Renegade Hardware \e[0m| 2003 |
             |                |                      |\e[31m               Cat#: RH45 \e[0m|      |
             |                |                      |\e[31m Barcode: 5 029651 001759 \e[0m|      |
             +----------------+----------------------+--------------------------+------+
             | Vicious Circle | Welcome To Shanktown | Label: Renegade Hardware | 2007 |
             |                |                      |            Cat#: HWARE02 |      |
             +----------------+----------------------+--------------------------+------+
             """
    end

    test "rendering lines with different lengths" do
      {:ok, rendered} =
        [["aaa\nb", "a\nbbb"]]
        |> Table.new()
        |> Table.render()

      assert rendered == """
             +-----+-----+
             | aaa | a   |
             | b   | bbb |
             +-----+-----+
             """
    end
  end

  test "default render with header cell color", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header_meta(0, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           |\e[31m Artist         \e[0m|\e[34m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with set column meta color across all columns and specific header override",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         |\e[34m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       |\e[31m Cyanide              \e[0m| 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle |\e[31m Welcome To Shanktown \e[0m| 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with set column meta color across all columns and clear header", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :reset)
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         |\e[0m Track                \e[0m| Year |
           +----------------+----------------------+------+
           | Konflict       |\e[31m Cyanide              \e[0m| 1999 |
           | Keaton & Hive  |\e[31m The Plague           \e[0m| 2003 |
           | Vicious Circle |\e[31m Welcome To Shanktown \e[0m| 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with title that is one less than the combined column widths", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Be Here Now")
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           | Renegade Hardware Releases That Be Here Now  |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with title that exactly matches combined column widths", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Here Now")
      |> Table.render()

    assert rendered == """
           +----------------------------------------------+
           | Renegade Hardware Releases That Are Here Now |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "default render with title that exceeds combined column widths by 1 character", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Seen Here")
      |> Table.render()

    assert rendered == """
           +-------------------------------------------------+
           |  Renegade Hardware Releases That Are Seen Here  |
           +-----------------+-----------------------+-------+
           | Artist          | Track                 | Year  |
           +-----------------+-----------------------+-------+
           | Konflict        | Cyanide               | 1999  |
           | Keaton & Hive   | The Plague            | 2003  |
           | Vicious Circle  | Welcome To Shanktown  | 2007  |
           +-----------------+-----------------------+-------+
           """
  end

  test "default render with title that far exceeds combined column widths", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.render()

    assert rendered == """
           +-------------------------------------------------------------+
           |  Renegade Hardware Releases That Are Present In This Table  |
           +---------------------+---------------------------+-----------+
           | Artist              | Track                     | Year      |
           +---------------------+---------------------------+-----------+
           | Konflict            | Cyanide                   | 1999      |
           | Keaton & Hive       | The Plague                | 2003      |
           | Vicious Circle      | Welcome To Shanktown      | 2007      |
           +---------------------+---------------------------+-----------+
           """
  end

  test "default render with title that far exceeds combined column widths with irregular alignments",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.put_column_meta(0, align: :right)
      |> Table.put_column_meta(1, align: :center)
      |> Table.render()

    assert rendered == """
           +-------------------------------------------------------------+
           |  Renegade Hardware Releases That Are Present In This Table  |
           +---------------------+---------------------------+-----------+
           |              Artist |           Track           | Year      |
           +---------------------+---------------------------+-----------+
           |            Konflict |          Cyanide          | 1999      |
           |       Keaton & Hive |        The Plague         | 2003      |
           |      Vicious Circle |   Welcome To Shanktown    | 2007      |
           +---------------------+---------------------------+-----------+
           """
  end

  test "default render with title exceeding combined column widths by multiple of number of columns",
       %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases Seen In This Very Table")
      |> Table.render()

    assert rendered == """
           +----------------------------------------------------+
           | Renegade Hardware Releases Seen In This Very Table |
           +------------------+------------------------+--------+
           | Artist           | Track                  | Year   |
           +------------------+------------------------+--------+
           | Konflict         | Cyanide                | 1999   |
           | Keaton & Hive    | The Plague             | 2003   |
           | Vicious Circle   | Welcome To Shanktown   | 2007   |
           +------------------+------------------------+--------+
           """
  end

  test "default render with title exactly matching combined column widths when only 2 columns" do
    title = "Renegade Hardware Releases Shown Here"
    header = ["Artist", "Track"]

    rows = [
      ["Konflict", "Cyanide"],
      ["Keaton & Hive", "The Plague"],
      ["Vicious Circle", "Welcome To Shanktown"]
    ]

    {:ok, rendered} =
      Table.new(rows, header, title)
      |> Table.render()

    assert rendered === """
           +---------------------------------------+
           | Renegade Hardware Releases Shown Here |
           +----------------+----------------------+
           | Artist         | Track                |
           +----------------+----------------------+
           | Konflict       | Cyanide              |
           | Keaton & Hive  | The Plague           |
           | Vicious Circle | Welcome To Shanktown |
           +----------------+----------------------+
           """
  end

  test "default render with title exceeding combined column widths by 1 character when only 2 columns" do
    title = "Renegade Hardware Releases Shown Here!"
    header = ["Artist", "Track"]

    rows = [
      ["Konflict", "Cyanide"],
      ["Keaton & Hive", "The Plague"],
      ["Vicious Circle", "Welcome To Shanktown"]
    ]

    {:ok, rendered} =
      Table.new(rows, header, title)
      |> Table.render()

    assert rendered === """
           +-----------------------------------------+
           | Renegade Hardware Releases Shown Here!  |
           +-----------------+-----------------------+
           | Artist          | Track                 |
           +-----------------+-----------------------+
           | Konflict        | Cyanide               |
           | Keaton & Hive   | The Plague            |
           | Vicious Circle  | Welcome To Shanktown  |
           +-----------------+-----------------------+
           """
  end

  test "default render with individual cells containing ANSI color codes" do
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
      |> Table.render()

    assert rendered === """
           +----------------------------------------------+
           |          Renegade Hardware Releases          |
           +----------------+----------------------+------+
           | Artist         | Track                | Year |
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | \e[31m19\e[1m99\e[0m |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 200\e[32m7\e[0m |
           +----------------+----------------------+------+
           """
  end

  test "minimal render (zero padding) with title exceeding combined column widths", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.put_column_meta(:all, padding: 0)
      |> Table.render(horizontal_style: :off, vertical_style: :off)

    assert rendered == """
           Renegade Hardware Releases That Are Present In This Table

           Artist               Track                      Year

           Konflict             Cyanide                    1999
           Keaton & Hive        The Plague                 2003
           Vicious Circle       Welcome To Shanktown       2007
           """
  end

  test "render with vertical style: frame with title exceeding combined column widths", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.render(vertical_style: :frame)

    assert rendered == """
           +-------------------------------------------------------------+
           |  Renegade Hardware Releases That Are Present In This Table  |
           +-------------------------------------------------------------+
           | Artist                Track                       Year      |
           +-------------------------------------------------------------+
           | Konflict              Cyanide                     1999      |
           | Keaton & Hive         The Plague                  2003      |
           | Vicious Circle        Welcome To Shanktown        2007      |
           +-------------------------------------------------------------+
           """
  end

  test "render with irregular column paddings with title exceeding combined column widths", %{
    table: table
  } do
    {:ok, rendered} =
      table
      |> Table.put_title("Renegade Hardware Releases That Are Present In This Table")
      |> Table.put_column_meta(0..1, padding: 0)
      |> Table.put_column_meta(2, padding: 1)
      |> Table.render()

    assert rendered == """
           +------------------------------------------------------------+
           | Renegade Hardware Releases That Are Present In This Table  |
           +--------------------+--------------------------+------------+
           |Artist              |Track                     | Year       |
           +--------------------+--------------------------+------------+
           |Konflict            |Cyanide                   | 1999       |
           |Keaton & Hive       |The Plague                | 2003       |
           |Vicious Circle      |Welcome To Shanktown      | 2007       |
           +--------------------+--------------------------+------------+
           """
  end

  test "render with choice row colors" do
    title = "Drum & Bass Releases"
    header = ["Artist", "Track", "Label", "Year"]

    rows = [
      ["Konflict", "Cyanide", "Renegade Hardware", 1999],
      ["Marcus Intalex", "Temperance", "Soul:r", 2004],
      ["Kryptic Minds", "The Forgotten", "Defcom Records", 2007],
      ["Konflict", "Cyanide", "Renegade Hardware", 1999],
      ["Marcus Intalex", "Temperance", "Soul:r", 2004],
      ["Kryptic Minds", "The Forgotten", "Defcom Records", 2007]
    ]

    {:ok, rendered} =
      Table.new(rows, header, title)
      |> Table.put_header_meta(0..4, color: :light_blue)
      |> Table.row_colors([:light_yellow, [:black, :green_background], :light_magenta])
      |> Table.render()

    assert rendered == """
           +-----------------------------------------------------------+\n|                   Drum & Bass Releases                    |\n+----------------+---------------+-------------------+------+\n|\e[94m Artist         \e[0m|\e[94m Track         \e[0m|\e[94m Label             \e[0m|\e[94m Year \e[0m|\n+----------------+---------------+-------------------+------+\n|\e[95m Konflict       \e[0m|\e[95m Cyanide       \e[0m|\e[95m Renegade Hardware \e[0m|\e[95m 1999 \e[0m|\n|\e[30m\e[42m Marcus Intalex \e[0m|\e[30m\e[42m Temperance    \e[0m|\e[30m\e[42m Soul:r            \e[0m|\e[30m\e[42m 2004 \e[0m|\n|\e[93m Kryptic Minds  \e[0m|\e[93m The Forgotten \e[0m|\e[93m Defcom Records    \e[0m|\e[93m 2007 \e[0m|\n|\e[95m Konflict       \e[0m|\e[95m Cyanide       \e[0m|\e[95m Renegade Hardware \e[0m|\e[95m 1999 \e[0m|\n|\e[30m\e[42m Marcus Intalex \e[0m|\e[30m\e[42m Temperance    \e[0m|\e[30m\e[42m Soul:r            \e[0m|\e[30m\e[42m 2004 \e[0m|\n|\e[93m Kryptic Minds  \e[0m|\e[93m The Forgotten \e[0m|\e[93m Defcom Records    \e[0m|\e[93m 2007 \e[0m|\n+----------------+---------------+-------------------+------+
           """
  end
end
