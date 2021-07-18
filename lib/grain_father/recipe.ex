defmodule GrainFather.Recipe do
  @fields ["id", "name", "og", "fg", "abv", "srm", "ibu", "image", "image_url"]

  def from_api(json), do: Map.take(json, @fields)

  def to_brew_dash(brew) do
    %{
      image_url: to_brew_dash_image(brew),
      name: brew["name"],
      source: "grain_father",
      source_id: to_string(brew["id"])
    }
  end

  def to_brew_dash_image(%{"image" => %{"url" => url}}) when is_binary(url), do: url
  def to_brew_dash_image(%{"image_url" => url}) when is_binary(url), do: url
  def to_brew_dash_image(_), do: nil
end
