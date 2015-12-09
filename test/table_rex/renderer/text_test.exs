defmodule TableRex.Renderer.TextTest do
  use ExUnit.Case, async: true

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

  test "default render without title", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, "")
    rendered = TableRex.render(table_rex)
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

  test "default render without title & header", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, "")
    TableRex.set_header(table_rex, nil)
    rendered = TableRex.render(table_rex)
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "default render with title but no header", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, nil)
    rendered = TableRex.render(table_rex)
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

  test "render with no title & vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, "")
    rendered = TableRex.render(table_rex, vertical_style: :frame)
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

  test "render with no title or header & vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, "")
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, vertical_style: :frame)
    assert rendered == """
    +----------------------------------------------+
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    +----------------------------------------------+
    """
  end

  test "render with title but no header & vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, vertical_style: :frame)
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

  test "render with no title & vertical style: off", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, vertical_style: :off)
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

  test "render with no title or header & vertical style: off", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, vertical_style: :off)
    assert rendered == """
    ----------------------------------------------
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    ----------------------------------------------
    """
  end

  test "render with title but no header & vertical style: off", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, vertical_style: :off)
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

  test "render with no title & horizontal style: off, vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |     Artist              Track           Year |
    |                                              |
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |    Konflict            Cyanide          1999 |
    | Keaton & Hive         The Plague        2003 |
    | Vicious Circle   Welcome To Shanktown   2007 |
    """
  end

  test "render with title but not header & horizontal style: off, vertical style: frame", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :frame)
    assert rendered == """
    |          Renegade Hardware Releases          |
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

  test "render with no title & horizontal style: off, vertical style: all", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |     Artist     |        Track         | Year |
    |                                              |
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: all", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    """
  end

  test "render with title but no header & horizontal style: off, vertical style: all", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :all)
    assert rendered == """
    |          Renegade Hardware Releases          |
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

  test "render with no title & horizontal style: off, vertical style: off", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :off)
    assert rendered == """
         Artist              Track           Year

        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with no title or header & horizontal style: off, vertical style: off", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :off)
    assert rendered == """
        Konflict            Cyanide          1999
     Keaton & Hive         The Plague        2003
     Vicious Circle   Welcome To Shanktown   2007
    """
  end

  test "render with title but no header & horizontal style: off, vertical style: off", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :off, vertical_style: :off)
    assert rendered == """
              Renegade Hardware Releases

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

  test "render with no title & horizontal style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :frame)
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

  test "render with not title or header & horizontal style: frame", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :frame)
    assert rendered == """
    +----------------+----------------------+------+
    |    Konflict    |       Cyanide        | 1999 |
    | Keaton & Hive  |      The Plague      | 2003 |
    | Vicious Circle | Welcome To Shanktown | 2007 |
    +----------------+----------------------+------+
    """
  end

  test "render with title but no header & horizontal style: frame", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :frame)
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

  test "render with no title & horizontal style: all", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :all)
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

  test "render with no title or header & horizontal style: all", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all)
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

  test "render with title but not header & horizontal style: all", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all)
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

  test "render with horizontal style: all, header_separator_symbol: =", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :all, header_separator_symbol: "=")
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

  test "render with no title & horizontal style: all, header_separator_symbol: =", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :all, header_separator_symbol: "=")
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

  test "render with no title or header & horizontal style: all, top_frame_symbol: =", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all, top_frame_symbol: "=")
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

  test "render with title but no header & horizontal style: all, header_separator_symbol: =", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all, header_separator_symbol: "=")
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

  test "render with title but no header & horizontal style: all, title_separator_symbol: =", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_separator_symbol: "=")
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

  test "render with horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table_rex: table_rex} do
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

  test "render with no title & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

  test "render with no title or header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table_rex: table_rex} do
    TableRex.set_title(table_rex, nil)
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

  test "render with title but no header & horizontal style: all, title_separator_symbol & header_horizontal_symbol: =", %{table_rex: table_rex} do
    TableRex.set_header(table_rex, [])
    rendered = TableRex.render(table_rex, horizontal_style: :all, title_separator_symbol: "=", header_separator_symbol: "=")
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

 end
