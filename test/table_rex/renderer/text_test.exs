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
    table =
      Table.new
      |> Table.set_title(title)
      |> Table.set_header(header)
      |> Table.add_rows(rows)
    {:ok, table: table}
  end

  test "default render", %{table: table} do
    {:ok, rendered} = Table.render(table)
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

  test "default render without title", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title("")
      |> Table.render
    assert rendered == """
    +----------------+----------------------+------+
    |     Artist     |        Track         | Year |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render without title & header", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title("")
      |> Table.set_header(nil)
      |> Table.render
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render with title but no header", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header(nil)
      |> Table.render
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
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
    |     Artist              Track           Year |
    +----------------------------------------------+
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    +----------------------------------------------+
    """
  end

  test "render with no title & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title("")
      |> Table.render(vertical_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |     Artist              Track           Year |
    +----------------------------------------------+
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    +----------------------------------------------+
    """
  end

  test "render with no title or header & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title("")
      |> Table.set_header([])
      |> Table.render(vertical_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    +----------------------------------------------+
    """
  end

  test "render with title but no header & vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(vertical_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------------------------------------+
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
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
         Artist              Track           Year
    ----------------------------------------------
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    ----------------------------------------------
    """
  end

  test "render with no title & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(vertical_style: :off)
    assert rendered == """
    ----------------------------------------------
         Artist              Track           Year
    ----------------------------------------------
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    ----------------------------------------------
    """
  end

  test "render with no title or header & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(vertical_style: :off)
    assert rendered == """
    ----------------------------------------------
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    ----------------------------------------------
    """
  end

  test "render with title but no header & vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(vertical_style: :off)
    assert rendered == """
    ----------------------------------------------
              Renegade Hardware Releases
    ----------------------------------------------
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    ----------------------------------------------
    """
  end

  test "render with horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |          Renegade Hardware Releases          |
    |                                              |
    |     Artist              Track           Year |
    |                                              |
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with no title & horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |     Artist              Track           Year |
    |                                              |
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with title but not header & horizontal style: off, vertical style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |          Renegade Hardware Releases          |
    |                                              |
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |          Renegade Hardware Releases          |
    |                                              |
    |     Artist     |        Track         | Year |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with no title & horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |     Artist     |        Track         | Year |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with title but no header & horizontal style: off, vertical style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |          Renegade Hardware Releases          |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :off, vertical_style: :off)
    assert rendered == """
              Renegade Hardware Releases

         Artist              Track           Year

        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with no title & horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :off, vertical_style: :off)
    assert rendered == """
         Artist              Track           Year

        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :off)
    assert rendered == """
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with title but no header & horizontal style: off, vertical style: off", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :off, vertical_style: :off)
    assert rendered == """
              Renegade Hardware Releases

        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with horizontal style: frame", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    |                                              |
    |     Artist     |        Track         | Year |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :frame)
    assert rendered == """
    +----------------+----------------------+------+
    |     Artist     |        Track         | Year |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with not title or header & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :frame)
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but no header & horizontal style: frame", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
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
    |     Artist     |        Track         | Year |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :all)
    assert rendered == """
    +----------------+----------------------+------+
    |     Artist     |        Track         | Year |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title or header & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all)
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but not header & horizontal style: all", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all)
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
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
    |     Artist     |        Track         | Year |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title & horizontal style: all, header_separator_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :all, header_separator_symbol: "=")
    assert rendered == """
    +----------------+----------------------+------+
    |     Artist     |        Track         | Year |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title or header & horizontal style: all, top_frame_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all, top_frame_symbol: "=")
    assert rendered == """
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but no header & horizontal style: all, header_separator_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all, header_separator_symbol: "=")
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but no header & horizontal style: all, title_separator_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=")
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} = Table.render(table, horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +================+======================+======+
    |     Artist     |        Track         | Year |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
    assert rendered == """
    +----------------+----------------------+------+
    |     Artist     |        Track         | Year |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with no title or header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_title(nil)
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but no header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_header([])
      |> Table.render(horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +================+======================+======+
    |    Konflict    |       Cyanide        | 1999 |
    +----------------+----------------------+------+
    | Keaton & Hive  |      The Plague      | 2003 |
    +----------------+----------------------+------+
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render with alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(0, align: :left)
      |> Table.set_column_meta(1, align: :right)
      |> Table.render
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    | Artist         |                Track | Year |
    +----------------+----------------------+------+
    | Konflict       |              Cyanide | 1999 |
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
    |     Artist     |        Track         | Year |
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render with added padding", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(0, padding: 3)
      |> Table.set_column_meta(1, padding: 3)
      |> Table.set_column_meta(2, padding: 3)
      |> Table.render
    assert rendered == """
    +----------------------------------------------------------+
    |                Renegade Hardware Releases                |
    +--------------------+--------------------------+----------+
    |       Artist       |          Track           |   Year   |
    +--------------------+--------------------------+----------+
    |      Konflict      |         Cyanide          |   1999   |
    |   Keaton & Hive    |        The Plague        |   2003   |
    |   Vicious Circle   |   Welcome To Shanktown   |   2007   |
    +--------------------+--------------------------+----------+
    """
  end

  test "default render with added padding & alignment", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(0, padding: 3, align: :left)
      |> Table.set_column_meta(1, padding: 3, align: :right)
      |> Table.set_column_meta(2, padding: 3, align: :right)
      |> Table.render
    assert rendered == """
    +----------------------------------------------------------+
    |                Renegade Hardware Releases                |
    +--------------------+--------------------------+----------+
    |   Artist           |                  Track   |   Year   |
    +--------------------+--------------------------+----------+
    |   Konflict         |                Cyanide   |   1999   |
    |   Keaton & Hive    |             The Plague   |   2003   |
    |   Vicious Circle   |   Welcome To Shanktown   |   2007   |
    +--------------------+--------------------------+----------+
    """
  end

  test "minimal render (zero padding)", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(:all, padding: 0)
      |> Table.render(horizontal_style: :off, vertical_style: :off)
    assert rendered == """
           Renegade Hardware Releases

        Artist            Track         Year

       Konflict          Cyanide        1999
    Keaton & Hive       The Plague      2003
    Vicious Circle Welcome To Shanktown 2007
    """
  end

  test "default render with set column meta across all columns", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(:all, align: :left)
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

  test "default render with set column meta across all columns and specific column override", %{table: table} do
    {:ok, rendered} =
      table
      |> Table.set_column_meta(:all, align: :left)
      |> Table.set_column_meta(1, align: :right)
      |> Table.render
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    | Artist         |                Track | Year |
    +----------------+----------------------+------+
    | Konflict       |              Cyanide | 1999 |
    | Keaton & Hive  |           The Plague | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render with cell level alignment", %{table: table} do
    {:ok, rendered} =
      table
    |> Table.set_column_meta(:all, align: :left)
    |> Table.set_cell_meta(0, 0, align: :right)
    |> Table.set_cell_meta(1, 1, align: :right)
    |> Table.render
    assert rendered == """
    +----------------------------------------------+
    |          Renegade Hardware Releases          |
    +----------------+----------------------+------+
    | Artist         | Track                | Year |
    +----------------+----------------------+------+
    |       Konflict | Cyanide              | 1999 |
    | Keaton & Hive  |           The Plague | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

 end
