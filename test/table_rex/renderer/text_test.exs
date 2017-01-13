defmodule TableRex.Renderer.TextTest do
  use ExUnit.Case, async: true
  alias TableRex.Table

  setup do
    title = "Renegade Hardware Releases"
    header = ["Artist", "Track", "Year"]
    rows = [
      ["Konflict", "Cyanide", 1999],
      ["Keaton & Hive", "The Plague", 2003],
      ["Vicious Circle", "Welcome To Shanktown", 2007],
    ]
    table = Table.new(rows, header, title)
    {:ok, table: table}
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
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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

  test "render with no title or header & horizontal style: off, vertical style: frame", %{table: table} do
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

  test "render with title but not header & horizontal style: off, vertical style: frame", %{table: table} do
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

  test "render with no title or header & horizontal style: off, vertical style: all", %{table: table} do
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

  test "render with title but no header & horizontal style: off, vertical style: all", %{table: table} do
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

  test "render with no title or header & horizontal style: off, vertical style: off", %{table: table} do
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

  test "render with title but no header & horizontal style: off, vertical style: off", %{table: table} do
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

  test "render with no title or header & horizontal style: all, top_frame_symbol: =", %{table: table} do
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

  test "render with no title or header & horizontal style: all, top_frame_symbol: =, bottom_frame_symbol: =", %{table: table} do
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

  test "render with title but no header & horizontal style: all, header_separator_symbol: =", %{table: table} do
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

  test "render with title but no header & horizontal style: all, title_separator_symbol: =", %{table: table} do
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

  test "render with horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :all, title_separator_symbol: "~", header_separator_symbol: "=")
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

  test "render with no title & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

  test "render with no title or header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_title(nil)
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

  test "render with title but no header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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
      |> Table.render
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
      |> Table.clear_all_column_meta
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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
      |> Table.put_column_meta(2, color: fn(t, v) -> if v in ["1999", "2007"], do: [:blue, t], else: t end)
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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
      |> Table.render
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

  test "default render with set column meta across all columns and specific column override", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(:all, align: :center)
      |> Table.put_column_meta(1, align: :right)
      |> Table.render
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
    |> Table.render
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
    |> Table.render
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
    |> Table.render
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
    |> Table.render
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
    |> Table.put_cell_meta(1, 1, color: fn(t, _) -> ["\e[48;5;30m", :white, t] end)
    |> Table.render
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
      |> Table.render
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

  test "default render with header cell color", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_header_meta(0, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render
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

  test "default render with set column meta color across all columns and specific header override", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :blue)
      |> Table.render
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

  test "default render with set column meta color across all columns and clear header", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.put_column_meta(1, color: :red)
      |> Table.put_header_meta(1, color: :reset)
      |> Table.render
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
 end
