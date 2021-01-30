<img src="http://i.imgur.com/ipa4UVa.png" width="500" />

[![Hex.pm](https://img.shields.io/hexpm/v/table_rex.svg)](https://hex.pm/packages/table_rex)
[![Build Status](https://github.com/djm/table_rex/workflows/TableRex%20CI/badge.svg)](https://github.com/djm/table_rex/actions)
[![Awesome Elixir](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/h4cc/awesome-elixir#command-line-applications)

**An Elixir app which generates text-based tables for display**

<img src="https://raw.githubusercontent.com/djm/table_rex/master/assets/examples.gif" width="500" alt="Layout Examples" />


#### Features

* A one-liner for rendering ASCII-style tables with sane defaults.
* Rendering via:
  * the built-in plain-text "ASCII-style" renderer.
  * your own rendering module.

The data structures support:

* column & cell level text alignment: left, center, right.
* table titles & column headers.
* sorting based on raw input data (rather than just strings).
* column, header & cell level <img src="http://i.imgur.com/LCfvYYM.png" width="44" /> support.
* automatic but defineable column & cell level padding.
* styling the table with various vertical & horizontal framing.
* styling the table with custom separator symbols.
* multi-line cell support.

The built-in "ASCII-style" renderer supports all of these features
out-of-the-box, but your custom renderers can support a subset if
they wish.

#### Documentation

See the quick start below or check out the
[full API docs at HexDocs](https://hexdocs.pm/table_rex/).

#### Stability

This software is now post v1 and therefore, as per semver, can be considered
stable and will have no breaking changes without incrementing the major version
number. Any breaking changes, and they will be few and far between, will be
documented in the [CHANGELOG](CHANGELOG.md).

The project officially will attempt to support the last 3 minor versions of
Elixir, and the latest 2 majors for OTP. If you are looking for support for
older version, then look at older releases.

Current minimum requirements:

* Elixir: 1.8
* OTP: 21

## Installation

The package is [available on Hex](https://hex.pm/packages/table_rex), therefore:

**Add** `table_rex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:table_rex, "~> 3.1.1"}]
end
```

Then run `mix deps.get`. That's it for modern Elixir.

**If** you are on Elixir 1.3 or lower, then **start** `table_rex` by adding it to `application/0` in `mix.exs`:

```elixir
def application do
  [applications: [:logger, :table_rex]]
end
```

## Quick Start

Use the `TableRex.quick_render` and `TableRex.quick_render!` functions; for
those that just want a table quickly.

Given this data:

```elixir
title = "Drum & Bass Releases"
header = ["Artist", "Track", "Label", "Year"]
rows = [
  ["Konflict", "Cyanide", "Renegade Hardware", 1999],
  ["Marcus Intalex", "Temperance", "Soul:r", 2004],
  ["Kryptic Minds", "The Forgotten", "Defcom Records", 2007]
]
```

### TableRex.quick_render!/1

```elixir
TableRex.quick_render!(rows)
|> IO.puts
```

```
+----------------|---------------|-------------------|------+
| Konflict       | Cyanide       | Renegade Hardware | 1999 |
| Marcus Intalex | Temperance    | Soul:r            | 2004 |
| Kryptic Minds  | The Forgotten | Defcom Records    | 2007 |
+----------------|---------------|-------------------|------+
```

### TableRex.quick_render!/2

```elixir
TableRex.quick_render!(rows, header)
|> IO.puts
```

```
+----------------|---------------|-------------------|------+
| Artist         | Track         | Label             | Year |
+----------------|---------------|-------------------|------+
| Konflict       | Cyanide       | Renegade Hardware | 1999 |
| Marcus Intalex | Temperance    | Soul:r            | 2004 |
| Kryptic Minds  | The Forgotten | Defcom Records    | 2007 |
+----------------|---------------|-------------------|------+
```

### TableRex.quick_render!/3

```elixir
TableRex.quick_render!(rows, header, title)
|> IO.puts
```

```
+-----------------------------------------------------------+
|                   Drum & Bass Releases                    |
+----------------|---------------|-------------------|------+
| Artist         | Track         | Label             | Year |
+----------------|---------------|-------------------|------+
| Konflict       | Cyanide       | Renegade Hardware | 1999 |
| Marcus Intalex | Temperance    | Soul:r            | 2004 |
| Kryptic Minds  | The Forgotten | Defcom Records    | 2007 |
+----------------|---------------|-------------------|------+
```

### Utilising TableRex.Table for deeper customisation

These examples all use: `alias TableRex.Table` to shorten the namespace.

**Set alignment & padding for specific columns or column ranges:**

```elixir
Table.new(rows, header)
|> Table.put_column_meta(0, align: :right, padding: 5) # `0` is the column index.
|> Table.put_column_meta(1..2, align: :center) # `1..2` is a range of column indexes. :all also works.
|> Table.render!
|> IO.puts
```

```
+------------------------|---------------|-------------------|------+
|             Artist     | Track         | Label             | Year |
+------------------------|---------------|-------------------|------+
|           Konflict     |    Cyanide    | Renegade Hardware | 1999 |
|     Marcus Intalex     |  Temperance   |      Soul:r       | 2004 |
|      Kryptic Minds     | The Forgotten |  Defcom Records   | 2007 |
+------------------------|---------------|-------------------|------+
```

**Sort the rows of the table using a column's values:**

```elixir
Table.new(rows, header)
|> Table.sort(3, :desc) # `3` is the column index, order is :desc or :asc for descending/ascending.
|> Table.render!
|> IO.puts
```

```
+----------------|---------------|-------------------|------+
| Artist         | Track         | Label             | Year |
+----------------|---------------|-------------------|------+
| Kryptic Minds  | The Forgotten | Defcom Records    | 2007 |
| Marcus Intalex | Temperance    | Soul:r            | 2004 |
| Konflict       | Cyanide       | Renegade Hardware | 1999 |
+----------------|---------------|-------------------|------+
```

**Change the table styling:**

```elixir
Table.new(rows, header)
|> Table.put_column_meta(:all, align: :center)
|> Table.render!(header_separator_symbol: "=", horizontal_style: :all)
|> IO.puts
```

```
+----------------|---------------|-------------------|------+
|     Artist     |     Track     |       Label       | Year |
+================+===============+===================+======+
|    Konflict    |    Cyanide    | Renegade Hardware | 1999 |
+----------------|---------------|-------------------|------+
| Marcus Intalex |  Temperance   |      Soul:r       | 2004 |
+----------------|---------------|-------------------|------+
| Kryptic Minds  | The Forgotten |  Defcom Records   | 2007 |
+----------------|---------------|-------------------|------+
```

_Available render options:_

* `horizontal_style`: one of `:off`, `:frame`, `:header` or `:all`.
* `vertical_style`: one of `:off`, `:frame` or `:all`.
* `horizontal_symbol`: draws horizontal row separators.
* `vertical_symbol`: draws vertical separators.
* `intersection_symbol`: draws the symbol where horizontal and vertical
  seperators intersect.
* `top_frame_symbol`: draws the frame's top horizontal separator.
* `title_separator_symbol`: draws the horizontal separator under the title.
* `header_separator_symbol`: draws to draw the horizontal separator under the
  header.
* `bottom_frame_symbol`: draws the frame's bottom horizontal separator.

**Set cell level meta (including for the header cells):**

```elixir
Table.new(rows, header)
|> Table.put_header_meta(0..4, align: :center) # row index(es)
|> Table.put_cell_meta(2, 1, align: :right) # column index, row index.
|> Table.render!
|> IO.puts
```

```
+----------------|---------------|-------------------|------+
|     Artist     |     Track     |       Label       | Year |
+----------------|---------------|-------------------|------+
| Konflict       | Cyanide       | Renegade Hardware | 1999 |
| Marcus Intalex | Temperance    |            Soul:r | 2004 |
| Kryptic Minds  | The Forgotten | Defcom Records    | 2007 |
+----------------|---------------|-------------------|------+
```

**Set color for the column, header, and cell:**

```elixir
Table.new(rows, header)
|> Table.put_column_meta(0, color: :red) # sets column header to red, too
|> Table.put_header_meta(1..4, color: IO.ANSI.color(31))
|> Table.put_cell_meta(2, 1, color: [:green_background, :white])
|> Table.render!
|> IO.puts
```

_Supported color value types:_

* atom: a named ANSI sequence defined in
  [IO.ANSI](https://hexdocs.pm/elixir/IO.ANSI.html#content)
* string: an embedded ANSI sequence
* chardata: a list of atoms and/or strings
* function: `(text, value) -> text`
  * where text is the padded value and where the value is a string
  * **Note:** to render the correct padding, always format and return the text

**Conditionally set a color:**

```elixir
Table.new(rows, header)
|> Table.put_column_meta(3, color: fn(text, value) -> if value in ["1999", "2007"], do: [:blue, text], else: text end)
|> Table.render!
|> IO.puts
```

**Change/pass in your own renderer module:**

The default renderer is `TableRex.Renderer.Text`.

Custom renderer modules must be behaviours of `TableRex.Renderer`.

```elixir
Table.new(rows, header)
|> Table.render!(renderer: YourCustom.Renderer.Module)
```

**Go mad:**

```elixir
Table.new(rows, header)
|> Table.render!(horizontal_style: :all, top_frame_symbol: "*", header_separator_symbol: "=", horizontal_symbol: "~", vertical_symbol: "!")
|> IO.puts
```

```
+****************+***************+*******************+******+
! Artist         ! Track         ! Label             ! Year !
+================+===============+===================+======+
! Konflict       ! Cyanide       ! Renegade Hardware ! 1999 !
+~~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~~~~~+~~~~~~+
! Marcus Intalex ! Temperance    ! Soul:r            ! 2004 !
+~~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~~~~~+~~~~~~+
! Kryptic Minds  ! The Forgotten ! Defcom Records    ! 2007 !
+----------------|---------------|-------------------|------+
```

## Run the tests

We have an extensive test suite which helps showcase project usage. For example:
the
[quick render functions](https://github.com/djm/table_rex/blob/master/test/table_rex_test.exs),
[table manipulation API](https://github.com/djm/table_rex/blob/master/test/table_rex/table_test.exs)
or
[the text renderer module](https://github.com/djm/table_rex/blob/master/test/table_rex/renderer/text_test.exs).

To run the test suite, from the project directory, do:

```bash
mix test
```

## Release package to Hex

First, bump the semver version & write the changelog, pushing that commit.

Then, tag HEAD with the version & push:

```bash
git tag -a vx.x.x -m "vx.x.x"
git push --tags
```

Then login & publish to Hex:

```bash
# Login to hex to retrieve API Key
mix hex.user auth

# Then publish by first setting to docs env to allow building to hexdocs.
MIX_ENV=docs mix hex.publish
```

## Roadmap/Contributing

First off, welcome & thanks!

We use the Github Issues tracker.

If you have found something wrong, please raise an issue.

If you'd like to contribute, check the issues to see where you can help.

Contributions are welcome from anyone at any time but if the piece of work is
significant in size, please raise an issue first to avoid instances of wasted
work.

## License

MIT. See the [full license](LICENSE).

## Thanks

* Ryanz720, for the
  [original T-Rex image](https://commons.wikimedia.org/wiki/File:Trex_Roar.jpg).

* Everyone in #elixir-lang on freenode, for answering the endless questions.

* All of our contributors.
