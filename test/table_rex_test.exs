defmodule TableRex.TableRexTest do
  use ExUnit.Case, async: true

  doctest TableRex

  test "quick_render with title, header and rows" do
    {:ok, rendered} =
      TableRex.quick_render(
        [
          ["Konflict", "Cyanide", 1999],
          ["Keaton & Hive", "The Plague", 2003],
          ["Vicious Circle", "Welcome To Shanktown", 2007]
        ],
        ["Artist", "Track", "Year"],
        "Renegade Hardware Releases"
      )

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

  test "quick_render with header and rows" do
    {:ok, rendered} =
      TableRex.quick_render(
        [
          ["Konflict", "Cyanide", 1999],
          ["Keaton & Hive", "The Plague", 2003],
          ["Vicious Circle", "Welcome To Shanktown", 2007]
        ],
        ["Artist", "Track", "Year"]
      )

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

  test "quick_render with just rows" do
    {:ok, rendered} =
      TableRex.quick_render([
        ["Konflict", "Cyanide", 1999],
        ["Keaton & Hive", "The Plague", 2003],
        ["Vicious Circle", "Welcome To Shanktown", 2007]
      ])

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "quick_render with no rows to test error return" do
    {:error, _reason} = TableRex.quick_render([])
  end

  test "quick_render! with title, header and rows" do
    rendered =
      TableRex.quick_render!(
        [
          ["Konflict", "Cyanide", 1999],
          ["Keaton & Hive", "The Plague", 2003],
          ["Vicious Circle", "Welcome To Shanktown", 2007]
        ],
        ["Artist", "Track", "Year"],
        "Renegade Hardware Releases"
      )

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

  test "quick_render! with header and rows" do
    rendered =
      TableRex.quick_render!(
        [
          ["Konflict", "Cyanide", 1999],
          ["Keaton & Hive", "The Plague", 2003],
          ["Vicious Circle", "Welcome To Shanktown", 2007]
        ],
        ["Artist", "Track", "Year"]
      )

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

  test "quick_render! with just rows" do
    rendered =
      TableRex.quick_render!([
        ["Konflict", "Cyanide", 1999],
        ["Keaton & Hive", "The Plague", 2003],
        ["Vicious Circle", "Welcome To Shanktown", 2007]
      ])

    assert rendered == """
           +----------------+----------------------+------+
           | Konflict       | Cyanide              | 1999 |
           | Keaton & Hive  | The Plague           | 2003 |
           | Vicious Circle | Welcome To Shanktown | 2007 |
           +----------------+----------------------+------+
           """
  end

  test "quick_render! with no rows to test error is raised" do
    assert_raise TableRex.Error, fn ->
      TableRex.quick_render!([])
    end
  end
end
