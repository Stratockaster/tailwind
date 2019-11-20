defmodule Tailwind.Segment do
  @moduledoc false

  defstruct start_point: nil, end_point: nil

  @type t :: %Tailwind.Segment{start_point: Tailwind.Point, end_point: Tailwind.Point}
end
