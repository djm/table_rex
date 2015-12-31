# Changelog

##v0.5.0

**No breaking changes**

`TableRex.Table.set_column_meta` now supports applying the column
meta to a range of columns as so:

```elixir
TableRex.Table.set_column_meta(table, 0..3, align: :right)
```

This would right-align columns 0 through 3.

It is different to using the `:all` atom as it allows for a subset.

##v0.4.0

**No breaking changes**

Added `TableRex.Table.set_header_meta/2` which allows a user
to set the cell-level attributes (namely, alignment) of a
header cell. Header cells can now be aligned individually,
separately from the default which is picked up from the column.

See issue [#3](https://github.com/djm/table_rex/issues/3).

##v0.3.0

**No breaking changes**

Simply an update to bump the version due to an oversight as the generated
docs for older version contained documentation for uncommited files which
were not part of the package. This has been remedied as of this version.

##v0.2.0

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


##v0.1.0

First release on hex.pm
