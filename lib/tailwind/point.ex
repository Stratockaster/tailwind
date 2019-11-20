defmodule Tailwind.Point do
  @moduledoc false

  defstruct latitude: nil, longitude: nil

  @type t :: %Tailwind.Point{latitude: float, longitude: float}
end

defprotocol Tailwind.PointData do
  @moduledoc false

  @doc "Returns point latitude"
  def latitude(point)

  @doc "Returns point longitude"
  def longitude(point)

  @doc "Converts point into 2 comma separated geo value: lat,lon"
  def to_string(point)
end

defimpl Tailwind.PointData, for: Tailwind.Point do
  def latitude(%Tailwind.Point{latitude: lat}), do: lat
  def longitude(%Tailwind.Point{longitude: lon}), do: lon
  def to_string(%Tailwind.Point{latitude: lat, longitude: lon}), do: "#{lat},#{lon}"
end
