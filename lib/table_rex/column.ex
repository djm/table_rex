defmodule TableRex.Column do
  @moduledoc """
  Defines a struct that represents a column's metadata
  """

  defstruct align: :left, padding: 1, color: nil

  @type t :: %__MODULE__{}

  @alignment_options [:left, :center, :right]
end
