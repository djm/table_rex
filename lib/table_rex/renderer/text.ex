defmodule TableRex.Renderer.Text do
  @moduledoc """
  Renderer module which handles outputting ASCII-style tables for display.
  """
  alias TableRex.Cell
  alias TableRex.Table
  alias TableRex.Renderer.Text.Meta

  @behaviour TableRex.Renderer

  @horizontal_styles [:all, :frame, :header, :off]
  @vertical_styles [:all, :frame, :off]

  @render_horizontal_frame_styles [:all, :frame, :header]
  @render_vertical_frame_styles [:all, :frame]
  @render_column_separators_styles [:all]
  @render_row_separators_styles [:all]
  @render_vertical_styling [:all, :frame]

  def default_options do
    %{
      horizontal_style:    :header,
      vertical_style:      :all,
      top_frame_symbol:    "-",
      intersection_symbol: "+",
      horizontal_symbol:   "-",
      vertical_symbol:     "|",
      title_line_symbol:   "-",
      header_line_symbol:  "-",
      bottom_frame_symbol: "-"
    }
  end

  def render(table = %Table{}, opts) do
    {col_widths, row_heights} = max_dimensions(table)

    render_horizontal_frame? = opts[:horizontal_style] in @render_horizontal_frame_styles
    render_vertical_frame? = opts[:vertical_style] in @render_vertical_frame_styles
    render_column_separators? = opts[:vertical_style] in @render_column_separators_styles
    render_row_separators? = opts[:horizontal_style] in @render_row_separators_styles
    vertical_styling? = opts[:vertical_style] in @render_vertical_styling

    table_width = table_width(col_widths, vertical_styling?: vertical_styling?)
    intersections = intersections(table_width, col_widths, vertical_style: opts[:vertical_style])

    meta = %Meta{
      col_widths: col_widths,
      row_heights: row_heights,
      table_width: table_width,
      intersections: intersections,
      render_horizontal_frame?: render_horizontal_frame?,
      render_vertical_frame?: render_vertical_frame?,
      render_column_separators?: render_column_separators?,
      render_row_separators?: render_row_separators?,
      vertical_styling?: vertical_styling?
    }

    {table, meta, opts, []}
    |> render_top_frame
    |> render_title
    |> render_intersected_line(opts[:title_line_symbol], opts[:intersection_symbol])
    |> render_header
    |> render_intersected_line(opts[:header_line_symbol], opts[:intersection_symbol])
    |> render_rows
    |> render_bottom_frame
    |> render_to_string
  end

  defp render_top_frame({table, %Meta{render_horizontal_frame?: false} = meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_top_frame({table, meta, opts, rendered}) do
    intersections = if meta.vertical_styling?, do: [0, meta.table_width - 1], else: []
    line = render_horizontal_separator(meta.table_width, intersections, opts[:top_frame_symbol], opts[:intersection_symbol])
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_title({%Table{title: nil} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_title({%Table{title: title} = table, meta, opts, rendered}) do
    inner_width = Meta.inner_width(meta)
    line = do_render_cell(title, inner_width)
    if meta.render_vertical_frame? do
      line = line |> frame_with(opts[:vertical_symbol])
    end
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_intersected_line({%Table{title: nil} = table, meta, opts, rendered}, _symbol, _intersection_symbol) do
    rendered = ["" | rendered]
    {table, meta, opts, rendered}
  end

  defp render_intersected_line({table, meta, %{horizontal_style: horizontal_style} = opts, rendered}, _symbol, _intersection_symbol) when horizontal_style in [:off, :frame] do
    inner_width = Meta.inner_width(meta)
    line = String.duplicate(" ", inner_width)
    if meta.render_vertical_frame? do
      line = line |> frame_with(opts[:vertical_symbol])
    end
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_intersected_line({table, meta, opts, rendered}, symbol, intersection_symbol) do
    intersections = if meta.vertical_styling?, do: meta.intersections, else: []
    line = render_horizontal_separator(meta.table_width, intersections, symbol, intersection_symbol)
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_header({%Table{header_row: []} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_header({%Table{header_row: header_row} = table, meta, opts, rendered}) do
    row_height = Meta.row_height(meta, 0)
    separator = if meta.render_column_separators?, do: opts[:vertical_symbol], else: " "
    line = render_cell_row(table, meta, header_row, separator)
    if meta.render_vertical_frame? do
      line = line |> frame_with(opts[:vertical_symbol])
    end
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_rows({%Table{rows: rows} = table, meta, opts, rendered}) do
    separator = if meta.render_column_separators?, do: opts[:vertical_symbol], else: " "
    lines = Enum.map(rows, &render_cell_row(table, meta, &1, separator))
    if meta.render_vertical_frame? do
      lines = Enum.map(lines, &frame_with(&1, opts[:vertical_symbol]))
    end
    if meta.render_row_separators? do
      {_, _, _, [row_separator | _]} = render_intersected_line({table, meta, opts, []}, opts[:horizontal_symbol], opts[:intersection_symbol])
      lines = Enum.intersperse(lines, row_separator)
    end
    rendered = lines ++ rendered
    {table, meta, opts, rendered}
  end

  defp render_bottom_frame({table, %Meta{render_horizontal_frame?: false} = meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_bottom_frame({table, meta, opts, rendered}) do
    intersections = if meta.vertical_styling?, do: meta.intersections, else: []
    line = render_horizontal_separator(meta.table_width, intersections, opts[:bottom_frame_symbol], opts[:intersection_symbol])
    rendered = [line | rendered]
    {table, meta, opts, rendered}
  end

  defp render_horizontal_separator(table_width, intersections, separator_symbol, intersection_symbol) do
    for n <- 0..table_width - 1 do
      if n in intersections, do: intersection_symbol, else: separator_symbol
    end
    |> Enum.join
  end

  defp render_cell_row(%Table{} = table, %Meta{} = meta, row, separator) do
    row
    |> Enum.with_index
    |> Enum.map(&render_cell(table, meta, &1))
    |> Enum.intersperse(separator)
    |> Enum.join
  end

  defp render_cell(%Table{} = table, %Meta{} = meta, {%Cell{} = cell, col_index}) do
    col_width = Meta.col_width(meta, col_index)
    col_padding = Table.get_column_meta(table, col_index, :padding)
    cell_align = Map.get(cell, :align)
    if cell_align == nil do
      cell_align = Table.get_column_meta(table, col_index, :align)
    end
    do_render_cell(cell.value, col_width, col_padding, align: cell_align)
  end

  defp do_render_cell(value, inner_width) do
    do_render_cell(value, inner_width, 0, align: :center)
  end

  defp do_render_cell(value, inner_width, _padding, align: :center) do
    value_len = String.length(value)
    post_value = ((inner_width - value_len) / 2) |> round
    pre_value = inner_width - (post_value + value_len)
    String.duplicate(" ", pre_value) <> value <> String.duplicate(" ", post_value)
  end

  defp do_render_cell(value, inner_width, padding, align: align) do
    value_len = String.length(value)
    alt_side_padding = inner_width - value_len - padding
    {pre_value, post_value} = case align do
      :left ->
        {padding, alt_side_padding}
      :right ->
        {alt_side_padding, padding}
    end
    String.duplicate(" ", pre_value) <> value <> String.duplicate(" ", post_value)
  end

  defp intersections(table_width, col_widths,  vertical_style: :all) do
    col_widths = ordered_col_widths(col_widths)
    inner_intersections = Enum.reduce(col_widths, [0], fn(x, [acc_h | _] = acc) ->
      [acc_h + x + 1 | acc]
    end)
    [0, table_width - 1] ++ inner_intersections
    |> Enum.into(HashSet.new)
  end

  defp intersections(table_width, _col_widths, vertical_style: :frame) do
    [0, table_width - 1]
    |> Enum.into(HashSet.new)
  end

  defp intersections(_table_width, _col_widths, vertical_style: :off), do: []

  defp max_dimensions(%Table{} = table) do
    [table.header_row | table.rows]
    |> Enum.with_index
    |> Enum.reduce({%{}, %{}}, &reduce_row_maximums(table, &1, &2))
  end

  defp reduce_row_maximums(%Table{} = table, {row, row_index}, {col_widths, row_heights}) do
    row
    |> Enum.with_index
    |> Enum.reduce({col_widths, row_heights}, &reduce_cell_maximums(table, &1, &2, row_index))
  end

  defp reduce_cell_maximums(%Table{} = table, {cell, col_index}, {col_widths, row_heights}, row_index) do
    padding = Table.get_column_meta(table, col_index, :padding)
    {width, height} = content_dimensions(cell.value, padding)
    col_widths = Dict.update(col_widths, col_index, width, &Enum.max([&1, width]))
    row_heights = Dict.update(row_heights, row_index, height, &Enum.max([&1, height]))
    {col_widths, row_heights}
  end

  defp content_dimensions(value, padding) when is_binary(value) and is_number(padding) do
    lines = String.split(value, "\n")
    height = Enum.count(lines)
    width = Enum.max(lines) |> String.length
    {width + (padding * 2), height}
  end

  defp table_width(%{} = col_widths, vertical_styling?: vertical_styling?) do
    width = col_widths
     |> Dict.values
     # Add one for each in-between column.
     |> Enum.intersperse(1)
     |> Enum.sum

    if vertical_styling? do
      # Add two for the outer frame.
      width = width + 2
    end

    width
  end

  defp ordered_col_widths(%{} = col_widths) do
    col_widths
    |> Enum.into([])
    |> Enum.sort
    |> Enum.map(&elem(&1, 1))
  end

  defp frame_with(string, frame) do
    frame <> string <> frame
  end

  defp render_to_string({_, _, _, rendered_lines}) when is_list(rendered_lines) do
    rendered_lines
    |> Enum.map(&String.rstrip/1)
    |> Enum.reverse
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
