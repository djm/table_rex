defmodule TableRex.Column do
  @moduledoc """
  Defines a struct that represents a column's metadata
  """

  defstruct align: :center, padding: 1

  @type t :: %__MODULE__{}

  @alignment_options [:left, :center, :right]
end
