defmodule TableRex.Renderer.Text do
  @moduledoc """
  Renderer module which handles outputting ASCII-style tables for display.
  """
  alias TableRex.Cell
  alias TableRex.Table
  alias TableRex.Renderer.Text.Meta

  @behaviour TableRex.Renderer

  @doc """
  Provides a level of sane defaults for the Text rendering module.
  """
  def default_options do
    %{
      horizontal_symbol: "─",
      right_intersection_symbol: "┤",
      left_intersection_symbol: "├",
      vertical_symbol: "│",
      top_intersection_symbol: "┬",
      bottom_intersection_symbol: "┴",
      inner_intersection_symbol: "┼",
      top_frame_symbol: "─",
      title_separator_symbol: "─",
      header_separator_symbol: "─",
      bottom_frame_symbol: "─",
      top_left_corner_symbol: "┌",
      top_right_corner_symbol: "┐",
      bottom_left_corner_symbol: "└",
      bottom_right_corner_symbol: "┘"
    }
  end

  @doc """
  Implementation of the TableRex.Renderer behaviour.

  Available styling options.

  `horizontal_styles` controls horizontal separators and can be one of:

    * `:all`: display separators between and around every row.
    * `:header`: display outer and header horizontal separators only.
    * `:frame`: display outer horizontal separators only.
    * `:off`: display no horizontal separators.

  `vertical_styles` controls vertical separators and can be one of:

    * `:all`: display between and around every column.
    * `:frame`: display outer vertical separators only.
    * `:off`: display no vertical separators.
  """
  def render(table = %Table{}, opts) do
    {col_widths, row_heights} = max_dimensions(table)

    # Calculations that would otherwise be carried out multiple times are done once and their
    # results are stored in the %Meta{} struct which is then passed through the pipeline.
    table_width = table_width(col_widths)
    intersections = intersections(col_widths)

    meta = %Meta{
      col_widths: col_widths,
      row_heights: row_heights,
      table_width: table_width,
      inner_intersections: intersections
    }

    rendered =
      {table, meta, opts, []}
      |> render_header
      |> render_rows
      |> render_bottom_frame
      |> render_to_string

    {:ok, rendered}
  end

  defp render_line(table_width, intersections, separator_symbol, intersection_symbol) do
    for n <- 1..(table_width - 2) do
      if n in intersections, do: intersection_symbol, else: separator_symbol
    end
    |> Enum.join()
  end

  defp render_header({%Table{header_row: []} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_header({%Table{header_row: header_row} = table, meta, opts, rendered}) do
    single_line_header_row =
      header_row
      |> Enum.map(fn cell ->
        %{cell | rendered_value: String.replace(cell.rendered_value, "\n", "")}
      end)

    header =
      render_cell_row(table, meta, {single_line_header_row, 0}, opts[:top_intersection_symbol])
      |> Enum.map(&Enum.join(&1))
      |> Enum.map(&String.replace(&1, " ", opts[:header_separator_symbol]))
      |> List.last()

    line =
      opts[:top_left_corner_symbol] <>
        header <>
        opts[:top_right_corner_symbol]

    {table, meta, opts, [line | rendered]}
  end

  defp render_rows({%Table{rows: rows} = table, meta, opts, rendered}) do
    separator = opts[:vertical_symbol]

    row_separator =
      render_line(
        meta.table_width,
        meta.inner_intersections,
        opts[:horizontal_symbol],
        opts[:inner_intersection_symbol]
      )

    lines =
      Enum.with_index(rows, 1)
      |> Enum.map(&render_cell_row(table, meta, &1, separator))
      |> Enum.intersperse([[row_separator]])
      |> Enum.flat_map(& &1)
      |> Enum.map(&Enum.join(&1))
      |> Enum.map(&frame_with(&1, separator))

    IO.inspect(lines)

    rendered = lines ++ rendered

    {table, meta, opts, rendered}
  end

  defp render_bottom_frame({%Table{} = table, %Meta{} = meta, opts, rendered}) do
    line =
      opts[:bottom_left_corner_symbol] <>
        render_line(
          meta.table_width,
          meta.inner_intersections,
          opts[:bottom_frame_symbol],
          opts[:bottom_intersection_symbol]
        ) <>
        opts[:bottom_right_corner_symbol]

    {table, meta, opts, [line | rendered]}
  end

  defp render_cell_row(%Table{} = table, %Meta{} = meta, {row, row_index}, separator) do
    row
    |> Enum.with_index()
    |> Enum.map(&render_cell(table, meta, row_index, &1))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.intersperse(&1, separator))
  end

  defp render_cell(%Table{} = table, %Meta{} = meta, row_index, {%Cell{} = cell, col_index}) do
    col_width = Meta.col_width(meta, col_index)
    row_height = Meta.row_height(meta, row_index)
    col_padding = Table.get_column_meta(table, col_index, :padding)
    cell_align = Map.get(cell, :align) || Table.get_column_meta(table, col_index, :align)
    cell_color = Map.get(cell, :color) || Table.get_column_meta(table, col_index, :color)

    cell.rendered_value
    |> strip_ansi_color_codes()
    |> String.split("\n")
    |> Enum.reverse()
    |> add_height_padding(col_width, row_height, col_padding)
    |> Enum.map(&do_render_cell(&1, col_width, col_padding, align: cell_align))
    |> Enum.map(&format_with_color(&1, cell_color))
  end

  defp add_height_padding(lines, inner_width, row_height, col_padding)
       when is_list(lines) and is_integer(row_height) and is_integer(inner_width) do
    empty_line = String.duplicate(" ", inner_width - col_padding)
    List.duplicate(empty_line, max(0, row_height - length(lines))) ++ lines
  end

  defp do_render_cell(value, inner_width, _padding, align: :center) do
    value_len = String.length(strip_ansi_color_codes(value))
    post_value = ((inner_width - value_len) / 2) |> round
    pre_value = inner_width - (post_value + value_len)
    String.duplicate(" ", pre_value) <> value <> String.duplicate(" ", post_value)
  end

  defp do_render_cell(value, inner_width, padding, align: align) do
    value_len = String.length(strip_ansi_color_codes(value))
    alt_side_padding = inner_width - value_len - padding

    {pre_value, post_value} =
      case align do
        :left ->
          {padding, alt_side_padding}

        :right ->
          {alt_side_padding, padding}
      end

    String.duplicate(" ", pre_value) <> value <> String.duplicate(" ", post_value)
  end

  defp intersections(%{} = col_widths) do
    ordered_col_widths(col_widths)
    |> Enum.reduce([0], fn x, [acc_h | _] = acc ->
      [acc_h + x + 1 | acc]
    end)
    |> Enum.into(MapSet.new())
  end

  defp max_dimensions(%Table{} = table) do
    {col_widths, row_heights} =
      [table.header_row | table.rows]
      |> Enum.with_index()
      |> Enum.reduce({%{}, %{}}, &reduce_row_maximums(table, &1, &2))

    num_columns = Map.size(col_widths)

    # Infer padding on left and right of title
    title_padding =
      [0, num_columns - 1]
      |> Enum.map(&Table.get_column_meta(table, &1, :padding))
      |> Enum.sum()

    # Compare table body width with title width
    col_separators_widths = num_columns - 1
    body_width = (col_widths |> Map.values() |> Enum.sum()) + col_separators_widths
    title_width = if(is_nil(table.title), do: 0, else: String.length(table.title)) + title_padding

    # Add extra padding equally to all columns if required to match body and title width.
    revised_col_widths =
      if body_width >= title_width do
        col_widths
      else
        extra_padding = ((title_width - body_width) / num_columns) |> Float.ceil() |> round
        Enum.into(col_widths, %{}, fn {k, v} -> {k, v + extra_padding} end)
      end

    {revised_col_widths, row_heights}
  end

  defp reduce_row_maximums(%Table{} = table, {row, row_index}, {col_widths, row_heights}) do
    row
    |> Enum.with_index()
    |> Enum.reduce({col_widths, row_heights}, &reduce_cell_maximums(table, &1, &2, row_index))
  end

  defp reduce_cell_maximums(
         %Table{} = table,
         {cell, col_index},
         {col_widths, row_heights},
         row_index
       ) do
    padding = Table.get_column_meta(table, col_index, :padding)
    {width, height} = content_dimensions(cell.rendered_value, padding)
    col_widths = Map.update(col_widths, col_index, width, &Enum.max([&1, width]))
    row_heights = Map.update(row_heights, row_index, height, &Enum.max([&1, height]))
    {col_widths, row_heights}
  end

  defp content_dimensions(value, padding) when is_binary(value) and is_number(padding) do
    lines =
      value
      |> strip_ansi_color_codes()
      |> String.split("\n")

    height = Enum.count(lines)
    width = Enum.map(lines, &String.length(&1)) |> Enum.max()
    {width + padding * 2, height}
  end

  defp table_width(%{} = col_widths) do
    width =
      col_widths
      |> Map.values()
      |> Enum.intersperse(1)
      |> Enum.sum()

    width + 2
  end

  defp ordered_col_widths(%{} = col_widths) do
    col_widths
    |> Enum.into([])
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
  end

  defp frame_with(string, frame) do
    frame <> string <> frame
  end

  defp render_to_string({_, _, _, rendered_lines}) when is_list(rendered_lines) do
    rendered_lines
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.reverse()
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp format_with_color(text, nil), do: text

  defp format_with_color(text, color) do
    [[color | text] | IO.ANSI.reset()]
    |> IO.ANSI.format_fragment(true)
  end

  defp strip_ansi_color_codes(text) do
    Regex.replace(~r|\e\[\d+m|u, text, "")
  end
end
