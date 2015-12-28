<img src="http://i.imgur.com/ipa4UVa.png" width="500" />

**An Elixir app which generates tables for display**

Currently supports output in:

* in customisable ASCII format.
* with your own renderer.

####Features

* A one-liner for those that just want to render tabular data with sane defaults.
* Support for table titles & alignable headers.
* Support for column & cell level alignment (left, right, center).
* Supports easy forking of table data to a new process.
* ASCII format: multiple options for framing with vertical & horizontal styles.
* ASCII format: overridable custom separators.
* ASCII format: automatic padding but also the ability to set padding on a per-column basis.

####Documenation

See the quick start below for the most common use cases or check out the [fully rendered API docs](https://hexdocs.pm/table_rex/) courtesy of ExDoc.

## Installation

The package is [available on Hex](https://hex.pm/packages/tablerex), therefore:

  1. Add `table_rex` to your list of dependencies in `mix.exs`:

```elixir
        def deps do
          [{:table_rex, "~> 0.0.1"}]
        end
```

2. Start `table_rex` by adding it to `application/0` in `mix.exs`:

```elixir
        def application do
          [applications: [:logger, :table_rex]]
        end
```

##Quick Start
        
##Run the tests


        
        
##Roadmap/Contributing

We use the Github Issues tracker to track these.

Contributions are welcome from anyone at any time but if the piece of work is significant in size, please raise an issue first so that we can discuss it to reduce any wasted coding time.

##License

MIT. See the [full license](LICENSE).
