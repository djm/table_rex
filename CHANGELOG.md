# Changelog

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
