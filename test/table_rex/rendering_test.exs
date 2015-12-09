defmodule TableRex.RenderingTest do
  use ExUnit.Case, async: true
  alias TableRex.Cell
  alias TableRex.Table
  alias TableRex.Rendering

  defmodule TestRenderer do
    @behaviour TableRex.Renderer

    def default_options do
      %{
        horizontal_style: :header,
        vertical_style: :all,
        renderer_specific_option: true
      }
    end

    def render(table, render_opts) do
      send self(), {:rendering, table, render_opts}
      {:ok, "Rendered String"}
    end

  end

  test "render with no passed options (defaults)" do
    table = %Table{rows: [%Cell{}]}
    {:ok, _} = Rendering.render(table, TestRenderer)
    expected_opts = %{
      horizontal_style: :header,
      vertical_style: :all,
      renderer_specific_option: true
    }
    assert_received {:rendering, _table, ^expected_opts}
  end

  test "render with passed options" do
    table = %Table{rows: [%Cell{}]}
    opts = [horizontal_symbol: "~", renderer_specific_option: false]
    {:ok, _} = Rendering.render(table, TestRenderer, opts)
    expected_opts = %{
      horizontal_style: :header,
      vertical_style: :all,
      horizontal_symbol: "~",
      renderer_specific_option: false
    }
    assert_received {:rendering, _table, ^expected_opts}
  end

  test "table without rows fails render" do
    table = %Table{}
    {:error, reason} = Rendering.render(table, TestRenderer)
    assert reason == "Table must have at least one row before being rendered"
    refute_received {:rendering, _, _}
  end

end
