defmodule Tailwind.Area do
  @moduledoc false

  defstruct southwest_point: nil, northeast_point: nil

  @type t :: %Tailwind.Area{southwest_point: Tailwind.Point, northeast_point: Tailwind.Point}
end

defprotocol Tailwind.AreaData do
  @doc "Converts area into 4 comma separated geo value: swlat,swlon,nelat,nelon"
  def to_string(area)
end

defimpl Tailwind.AreaData, for: Tailwind.Area do
  def southwest_point(%Tailwind.Area{southwest_point: southwest_point}), do: southwest_point
  def northeast_point(%Tailwind.Area{northeast_point: northeast_point}), do: northeast_point

  def to_string(area) do
    Tailwind.PointData.to_string(southwest_point(area)) <> "," <> Tailwind.PointData.to_string(northeast_point(area))
  end
end
