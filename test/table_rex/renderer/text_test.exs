defmodule TableRex.Renderer.TextTest do
  use ExUnit.Case, async: true
  alias TableRex.Table

  setup do
    {:ok, table_rex} = TableRex.start_link
    TableRex.set_title(table_rex, "Renegade Hardware Releases")
    TableRex.set_header(table_rex, ["Artist", "Track", "Year"])
    TableRex.add_rows(table_rex, [
      ["Konflict", "Cyanide", 1999],
      ["Keaton & Hive", "The Plague", 2003],
      ["Vicious Circle", "Welcome To Shanktown", 2007],
    ])
    {:ok, table_rex: table_rex}
  end

  test "default render", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex)
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

  test "render with vertical style: frame", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, vertical_style: :frame)
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

  test "render with vertical style: off", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, vertical_style: :off)
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

  test "render with horizontal style: off, vertical style: frame", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :frame)
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

  test "render with horizontal style: off, vertical style: all", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :all)
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

  test "render with horizontal style: off, vertical style: off", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :off)
    assert rendered == """
              Renegade Hardware Releases

         Artist              Track           Year

        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with horizontal style: frame", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :frame)
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

  test "render with horizontal style: all", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :all)
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

  test "render with horizontal style: all, header_line_symbol: =", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :all, header_line_symbol: "=")
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

  test "render with horizontal style: all, title_line_symbol & header_horizontal_symbol: =", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_line_symbol: "=", header_line_symbol: "=")
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

 end
