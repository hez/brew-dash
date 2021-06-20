defmodule GrainFather.Recipe do
  @fields ["id", "name", "og", "fg", "abv", "srm", "ibu", "image", "image_url"]

  def from_api(json), do: Map.take(json, @fields)

  def to_brew_dash(brew),
    do: brew |> Map.take(["id", "name"]) |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
end
