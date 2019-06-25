defmodule TableRex.Renderer.Text do
  @moduledoc """
  Renderer module which handles outputting ASCII-style tables for display.
  """
  alias TableRex.Cell
  alias TableRex.Table
  alias TableRex.Renderer.Text.Meta

  @behaviour TableRex.Renderer

  # horizontal_styles: [:all, :header, :frame:, :off]
  # vertical_styles: [:all, :frame, :off]

  # Which horizontal/vertical styles render a specific separator.
  @render_horizontal_frame_styles [:all, :frame, :header]
  @render_vertical_frame_styles [:all, :frame]
  @render_column_separators_styles [:all]
  @render_row_separators_styles [:all]

  @doc """
  Provides a level of sane defaults for the Text rendering module.
  """
  def default_options do
    %{
      horizontal_style: :header,
      vertical_style: :all,
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
      top_left_corner_symbole: "┌",
      top_right_corner_symbole: "┐",
      bottom_left_corner_symbole: "└",
      bottom_right_corner_symbole: "┘"
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
    render_horizontal_frame? = opts[:horizontal_style] in @render_horizontal_frame_styles
    render_vertical_frame? = opts[:vertical_style] in @render_vertical_frame_styles
    render_column_separators? = opts[:vertical_style] in @render_column_separators_styles
    render_row_separators? = opts[:horizontal_style] in @render_row_separators_styles
    table_width = table_width(col_widths, vertical_frame?: render_vertical_frame?)
    intersections = intersections(table_width, col_widths, vertical_style: opts[:vertical_style])

    meta = %Meta{
      col_widths: col_widths,
      row_heights: row_heights,
      table_width: table_width,
      inner_intersections: intersections,
      top_left_corners: [0],
      top_right_corners: [table_width - 1],
      bottom_left_corners: [],
      bottom_right_corners: [],
      left_intersections: [],
      right_intersections: [],
      top_intersections: [],
      bottom_intersections: [],
      render_horizontal_frame?: render_horizontal_frame?,
      render_vertical_frame?: render_vertical_frame?,
      render_column_separators?: render_column_separators?,
      render_row_separators?: render_row_separators?
    }

    rendered =
      {table, meta, opts, []}
      |> render_top_frame
      |> render_title
      |> render_title_separator
      |> render_header
      |> render_header_separator
      |> render_rows
      |> render_bottom_frame
      |> render_to_string

    {:ok, rendered}
  end

  defp render_top_frame({table, %Meta{render_horizontal_frame?: false} = meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_top_frame({%Table{title: title} = table, meta, opts, rendered})
       when is_binary(title) do
    intersections = if meta.render_vertical_frame?, do: [0, meta.table_width - 1], else: []

    line =
      render_line(
        meta,
        opts[:top_frame_symbol],
        opts
      )

    {table, meta, opts, [line | rendered]}
  end

  defp render_top_frame({table, meta, opts, rendered}) do
    line =
      render_line(
        meta,
        opts[:top_frame_symbol],
        opts
      )

    {table, meta, opts, [line | rendered]}
  end

  defp render_line(%Meta{} = meta, horizontal_symbol, opts) do
    for n <- 0..(meta.table_width - 1) do
      cond do
        if(n in meta.inner_intersections) -> opts[:inner_intersection_symbol]
        if(n in meta.top_left_corners) -> opts[:top_left_corner_symbole]
        if(n in meta.top_right_corners) -> opts[:top_right_corner_symbole]
        if(n in meta.bottom_left_corners) -> opts[:bottom_left_corner_symbole]
        if(n in meta.bottom_right_corners) -> opts[:bottom_right_corner_symbole]
        if(n in meta.left_intersections) -> opts[:left_intersection_symbol]
        if(n in meta.right_intersections) -> opts[:right_intersection_symbol]
        if(n in meta.top_intersections) -> opts[:top_intersection_symbol]
        if(n in meta.bottom_intersections) -> opts[:bottom_intersection_symbol]
        true -> horizontal_symbol
      end
    end
    |> Enum.join()
  end

  defp render_title({%Table{title: nil} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_title({%Table{title: title} = table, meta, opts, rendered}) do
    inner_width = Meta.inner_width(meta)
    line = do_render_cell(title, inner_width)

    line =
      if meta.render_vertical_frame? do
        line |> frame_with(opts[:vertical_symbol])
      else
        line
      end

    {table, meta, opts, [line | rendered]}
  end

  defp render_title_separator({%Table{title: nil} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_title_separator(
         {table, meta, %{horizontal_style: horizontal_style} = opts, rendered}
       )
       when horizontal_style in [:all, :header] do
    line =
      render_line(
        meta.table_width,
        meta.intersections,
        opts[:title_separator_symbol],
        opts[:intersection_symbol]
      )

    {table, meta, opts, [line | rendered]}
  end

  defp render_title_separator({table, %Meta{render_vertical_frame?: true} = meta, opts, rendered}) do
    line = render_line(meta.table_width, [0, meta.table_width - 1], " ", opts[:vertical_symbol])
    {table, meta, opts, [line | rendered]}
  end

  defp render_title_separator(
         {table, %Meta{render_vertical_frame?: false} = meta, opts, rendered}
       ) do
    {table, meta, opts, ["" | rendered]}
  end

  defp render_header({%Table{header_row: []} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_header({%Table{header_row: header_row} = table, meta, opts, rendered}) do
    separator = if meta.render_column_separators?, do: opts[:vertical_symbol], else: " "
    line = render_cell_row(table, meta, {header_row, 0}, separator)

    line =
      if meta.render_vertical_frame? do
        line |> frame_with(opts[:vertical_symbol])
      else
        line
      end

    {table, meta, opts, [line | rendered]}
  end

  defp render_header_separator({%Table{header_row: []} = table, meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_header_separator(
         {table, meta, %{horizontal_style: horizontal_style} = opts, rendered}
       )
       when horizontal_style in [:all, :header] do
    line =
      render_line(
        meta.table_width,
        meta.intersections,
        opts[:header_separator_symbol],
        opts[:intersection_symbol]
      )

    {table, meta, opts, [line | rendered]}
  end

  defp render_header_separator(
         {table, %Meta{render_vertical_frame?: true} = meta, opts, rendered}
       ) do
    line = render_line(meta.table_width, [0, meta.table_width - 1], " ", opts[:vertical_symbol])
    {table, meta, opts, [line | rendered]}
  end

  defp render_header_separator(
         {table, %Meta{render_vertical_frame?: false} = meta, opts, rendered}
       ) do
    {table, meta, opts, ["" | rendered]}
  end

  defp render_rows({%Table{rows: rows} = table, meta, opts, rendered}) do
    separator = if meta.render_column_separators?, do: opts[:vertical_symbol], else: " "

    lines =
      Enum.with_index(rows, 1)
      |> Enum.map(&render_cell_row(table, meta, &1, separator))

    lines =
      if meta.render_vertical_frame? do
        Enum.map(lines, &frame_with(&1, opts[:vertical_symbol]))
      else
        lines
      end

    lines =
      if meta.render_row_separators? do
        row_separator =
          render_line(
            meta.table_width,
            meta.intersections,
            opts[:horizontal_symbol],
            opts[:intersection_symbol]
          )

        Enum.intersperse(lines, row_separator)
      else
        lines
      end

    rendered = lines ++ rendered
    {table, meta, opts, rendered}
  end

  defp render_bottom_frame({table, %Meta{render_horizontal_frame?: false} = meta, opts, rendered}) do
    {table, meta, opts, rendered}
  end

  defp render_bottom_frame({table, meta, opts, rendered}) do
    line =
      render_line(
        meta.table_width,
        meta.intersections,
        opts[:bottom_frame_symbol],
        opts[:intersection_symbol]
      )

    {table, meta, opts, [line | rendered]}
  end

  defp render_cell_row(%Table{} = table, %Meta{} = meta, {row, row_index}, separator) do
    # IO.inspect(meta, label: "meta")
    # IO.inspect(row_index, label: "index")
    # IO.inspect(row, label: "row")
    row
    |> Enum.with_index()
    |> Enum.map(&render_cell(table, meta, row_index, &1))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.intersperse(&1, separator))
    |> Enum.join("\n ")
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
    |> add_height_padding(col_width, row_height, col_padding)
    |> Enum.map(&do_render_cell(&1, col_width, col_padding, align: cell_align))
    |> Enum.map(&format_with_color(&1, cell_color))
  end

  defp add_height_padding(lines, inner_width, row_height, col_padding)
       when is_list(lines) and is_integer(row_height) and is_integer(inner_width) do
    IO.inspect(row_height, label: "row_height")
    IO.inspect(max(0, row_height - length(lines)), label: "maxx")

    empty_line = String.duplicate(" ", inner_width - col_padding)
    res = lines ++ List.duplicate(empty_line, max(0, row_height - length(lines)))

    IO.inspect(res, label: "res")
    res
  end

  defp do_render_cell(value, inner_width) do
    do_render_cell(value, inner_width, 0, align: :center)
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

    # IO.inspect(alt_side_padding, label: "alt")
    # IO.inspect(padding, label: "padding")
    {pre_value, post_value} =
      case align do
        :left ->
          {padding, alt_side_padding}

        :right ->
          {alt_side_padding, padding}
      end

    String.duplicate(" ", pre_value) <> value <> String.duplicate(" ", post_value)
  end

  defp intersections(_table_width, _col_widths, vertical_style: :off), do: []

  defp intersections(_table_width, _col_widths, vertical_style: :frame), do: []

  defp intersections(_table_width, col_widths, vertical_style: :all) do
    col_widths = ordered_col_widths(col_widths)

    inner_intersections =
      Enum.reduce(col_widths, [0], fn x, [acc_h | _] = acc ->
        [acc_h + x + 1 | acc]
      end)

    inner_intersections
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

  defp table_width(%{} = col_widths, vertical_frame?: vertical_frame?) do
    width =
      col_widths
      |> Map.values()
      |> Enum.intersperse(1)
      |> Enum.sum()

    if vertical_frame?, do: width + 2, else: width
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
