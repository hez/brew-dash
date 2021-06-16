defmodule GrainFather.Recipe do
  @fields ["id", "name", "og", "fg", "abv", "srm", "ibu", "image", "image_url"]

  def from_api(json), do: Map.take(json, @fields)

  def to_brew_dash(brew), do: Map.take(brew, ["id", "name"])
end
