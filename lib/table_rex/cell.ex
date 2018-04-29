defmodule TableRex.Cell do
  @moduledoc """
  Defines a struct that represents a single table cell, and helper functions.

  The `align` field can be of:

    * `:left`: left align text in the cell.
    * `:center`: center text in the cell.
    * `:right`: right align text in the cell.
    * `nil`: align text in cell according to column alignment.
  """
  alias TableRex.Cell

  defstruct value: "", align: nil, color: nil

  @type t :: %__MODULE__{}

  @doc """
  Converts the passed value to be a normalised %Cell{} struct.

  If a non %Cell{} struct is passed, this function returns a new
  %Cell{} struct with the `value` key set to the stringified binary
  of the content passed in and any options passed are applied over
  the normal struct defaults.

  If a %Cell{} is passed in those with a binary entry for their `value`
  key will pass straight through; all others will have their `value` key
  stringified before being passed through.
  """
  @spec to_cell(Cell.t()) :: Cell.t()
  def to_cell(%Cell{value: value} = cell) when is_binary(value), do: cell

  def to_cell(%Cell{value: value} = cell) do
    %{cell | value: to_string(value)}
  end

  @spec to_cell(any, list) :: Cell.t()
  def to_cell(value, opts \\ []) do
    opts = Enum.into(opts, %{})

    %Cell{value: to_string(value)}
    |> Map.merge(opts)
  end
end
