defmodule TableRex.Cell do
  @moduledoc """
  Defines a struct that represents a single table cell, and helper functions.

  A cell stores both the original data _and_ the string-rendered version,
  this decision was taken as a tradeoff: this way uses more memory to store
  the table structure but the renderers gain the ability to get direct access
  to the string-coerced data rather than having to risk repeated coercion or
  handle their own storage of the computer values.

  Fields:

    * `raw_value`: The un-coerced original value

    * `rendered_value`: The stringified value for rendering

    * `wrapped_lines`: A list of 1 or more string values representing
      the line(s) within the cell to be rendered

    * `align`:
      * `:left`: left align text in the cell.
      * `:center`: center text in the cell.
      * `:right`: right align text in the cell.
      * `nil`: align text in cell according to column alignment.

    * `color`: the ANSI color of the cell.

  If creating a Cell manually: raw_value is the only required key to
  enable that Cell to work well with the rest of TableRex. It should
  be set to a piece of data that can be rendered to string.
  """
  alias TableRex.Cell

  defstruct raw_value: nil, rendered_value: "", align: nil, color: nil, wrapped_lines: [""]

  @type t :: %__MODULE__{}

  @doc """
  Converts the passed value to be a normalised %Cell{} struct.

  If a non %Cell{} value is passed, this function returns a new
  %Cell{} struct with:

    * the `rendered_value` key set to the stringified binary of the
      value passed in.
    * the `raw_value` key set to original data passed in.
    * any other options passed are applied over the normal struct
      defaults, which allows overriding alignment & color.

  If a %Cell{} is passed in with no `rendered_value` key, then the
  `raw_value` key's value is rendered and saved against it, otherwise
  the Cell is passed through untouched. This is so that advanced use
  cases which require direct Cell creation and manipulation are not
  hindered.
  """
  @spec to_cell(Cell.t()) :: Cell.t()
  def to_cell(%Cell{rendered_value: rendered_value} = cell)
      when is_binary(rendered_value) and rendered_value != "" do
    %Cell{cell | wrapped_lines: wrapped_lines(rendered_value)}
  end

  def to_cell(%Cell{raw_value: raw_value} = cell) do
    rendered_value = to_string(raw_value)
    %Cell{cell | rendered_value: rendered_value, wrapped_lines: wrapped_lines(rendered_value)}
  end

  @spec to_cell(any, list) :: Cell.t()
  def to_cell(value, opts \\ [])

  def to_cell(list, opts) when is_list(list) do
    if List.improper?(list) do
      list
      |> to_string()
      |> to_cell(opts)
    else
      list
      |> Enum.join("\n")
      |> to_cell(opts)
    end
  end

  def to_cell(value, opts) do
    opts = Enum.into(opts, %{})

    rendered_value = to_string(value)

    %Cell{
      raw_value: value,
      rendered_value: rendered_value,
      wrapped_lines: wrapped_lines(rendered_value)
    }
    |> Map.merge(opts)
  end

  @spec height(Cell.t()) :: integer
  def height(%Cell{wrapped_lines: lines}), do: length(lines)

  defp wrapped_lines(value) when is_binary(value) do
    String.split(value, "\n")
  end
end
