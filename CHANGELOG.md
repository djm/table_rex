# Changelog

## v2.0.0

Version 2 has no external API breaking changes but we are bumping the major version
number as the internal data structure of the %Cell{} struct has changed. See
note below.

New features:

* sort! Tables can now have a basic sort function which uses Elixir's term
  ordering to sort your table rows by a specific column in either ascending or
  descending order. Please see the README for usage; many thanks to everyone
  at @elixir-poa for this change.

* you are now free to add your own ANSI color wrappers to text within an inline
  cell, the extra characters this adds are ignored as part of width calculations
  and therefore the structure of the table no longer breaks when you do this.
  Thanks to @geolessel for this change.


**%Cell{} struct change**

Previously Cells only stored the string-coerced version of the data you wanted
to insert into the table. This was limiting as it meant we could not sort your
tables as type information was lost in that process. It also opens up TableRex
to many other features now that we keep the original data.

The stringified value of a Cell used to be stored at `value`, it is now stored
at `rendered_value` - with the original being stored at `raw_value`.

To migrate:

* If you are creating Cells, instead of passing `value`, pass `raw_value`.
* If you are using Cells, it's likely you'll want to use `Cell.rendered_value`
  which is now what the removed `Cell.value` used to be.


## v1.0.0

The API seems stable enough, sans major complaints, and has no major open bugs
so here is our version 1 release!

This release brings only new feature:

* TableRex has gained the ability to stretch the table width to accomodate long
titles, thanks to @matt-harvey.

And one breaking change:

* We are dropping support for Elixir v1.2.x and Erlang 18.x. For the time
being, we support the latest 3 minor versions of Elixir, and the latest 2
major versions for Erlang.

From now on - as per semver, new breaking changes will increment the major release
number, new non-breaking features will increment the minor release number and
bug fixes will update the patch number.

## v0.10.0

**Breaking changes**

Dropped support for Elixir v1.1.x. We support the latest 3 minor versions, and
the latest 2 major versions for Erlang OTP.

Other changes:

Fixed all compiler warnings resulting from Elixir 1.3 and 1.4 releases.

## v0.9.0

Justin G (@theredcoder) has added support for header, column and cell level
foreground & background ANSI colouring. Many thanks to Justin.

## v0.8.3

Fixed warnings caused by Elixir 1.3's unsafe variable checker.

## v0.8.2

Updated some locked development dependencies to reduce warning output during usage.

## v0.8.1

Fixed a compilation bug in the new Elixir 1.3. No other changes.

## v0.8.0

**Breaking changes**

All `Table.set_*` functions have been changed to `Table.put_*` to better
reflect their functionality and mimic convention used elsewhere in the
Elixir ecosphere.

## v0.7.0

**Breaking changes**

The default alignment for columns is now `:left` rather than `:center`.

This could be a breaking change for your project as if you had not explicitly
set columns to be of a certain alignment then your tables will now be output
with columns aligned to the left rather than centered as before. This change
was made as it's much more likely that a LTR language user is going to want
left aligned columns, especially with the multiline cell support which will
land soon.

If you wish to remain using center-aligned columns then you can manipulate
your table struct by calling:

```elixir
Table.set_column_meta(table, :all, align: :center)
```

Other changes:

`Table.set_column_meta` and `Table.set_header_meta` now can also take their
column index(es) argument as an enumerable. Previously `set_header_meta` could
not do this and `set_column_meta` could only be provided a range.

Example usage:

```elixir
Table.set_column_meta(table, 0, align: :right) # aligns column 0 to the right.
Table.set_column_meta(table, 0..4, align: :right) # aligns column 0 through 4 to the right.
Table.set_column_meta(table, [0, 3, 5], align: :right) # aligns column 0, 3 & 5 to the right.
Table.set_column_meta(table, :all, align: :right) # aligns all current and future columns to the right.
```

```elixir
Table.set_header_meta(table, 0, align: :right) # aligns header cell 0 to the right.
Table.set_header_meta(table, 0..4, align: :right) # aligns header cells 0 through 4 to the right.
Table.set_header_meta(table, [0, 3, 5], align: :right) # aligns header cells 0, 3 & 5 to the right.
```

## v0.6.0

**No breaking changes**

`Table.new/0` has been supplemented with `Table.new/3` which takes `rows` and
an optional `header` and `title`. This change was made as when the data is known
upfront it was quite verbose doing:

```elixir
Table.new
|> Table.add_rows(rows)
|> Table.set_header(header)
|> Table.set_title(title)
|> Table.render
```

The following can now be used instead:

```
Table.new(rows, header, title)
|> Table.render
```

## v0.5.0

**No breaking changes**

`TableRex.Table.set_column_meta` now supports applying the column
meta to a range of columns as so:

```elixir
TableRex.Table.set_column_meta(table, 0..3, align: :right)
```

This would right-align columns 0 through 3.

It is different to using the `:all` atom as it allows for a subset.

## v0.4.0

**No breaking changes**

Added `TableRex.Table.set_header_meta/2` which allows a user
to set the cell-level attributes (namely, alignment) of a
header cell. Header cells can now be aligned individually,
separately from the default which is picked up from the column.

See issue [#3](https://github.com/djm/table_rex/issues/3).

## v0.3.0

**No breaking changes**

Simply an update to bump the version due to an oversight as the generated
docs for older version contained documentation for uncommited files which
were not part of the package. This has been remedied as of this version.

## v0.2.0

**Breaking changes**

* The original `TableRex.Table.render!/1`, `TableRex.Table.render!/2` and `TableRex.Table.render!/3` have been removed and consolidated with `TableRex.Table.render!/2`. Choosing a custom renderer module has been moved from a first class argument into the `:renderer` key of the options argument.

What was previously:
```elixir
Table.new
|> Table.add_row(row)
|> Table.render(CustomRenderer.Module, horizontal_style: :off)
```

is now:

```elixir
Table.new
|> Table.add_row(row)
|> Table.render(renderer: CustomRenderer.Module, horizontal_style: :off)
```

** Other changes**

* `TableRex.Table.render!/2` has been added as a brother to `TableRex.Table.render/2`. It raises `TableRex.Error` on failure and returns the rendered string directly as opposed to it's brother which returns an Erlang style `:ok/:error` tuple.


## v0.1.0

First release on hex.pm
