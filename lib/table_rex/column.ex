defmodule TableRex.Column do
  @moduledoc """
  Defines a struct that represents a column's metadata

  The align field can be one of :left, :center or :right.
  """

  defstruct align: :left, padding: 1, color: nil

  @type t :: %__MODULE__{}
end
