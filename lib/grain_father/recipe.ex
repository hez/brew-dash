defmodule GrainFather.Recipe do
  @fields ["id", "name", "og", "fg", "abv", "srm", "ibu", "image", "image_url"]

  def from_api(json), do: Map.take(json, @fields)

  def to_brew_dash(brew) do
    brew
    |> Map.take(["id", "name"])
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.put(:image_url, to_brew_dash_image(brew))
  end

  def to_brew_dash_image(%{"image" => %{"url" => url}}) when is_binary(url), do: url
  def to_brew_dash_image(%{"image_url" => url}) when is_binary(url), do: url
  def to_brew_dash_image(_), do: nil
end
