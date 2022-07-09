defmodule GrainFather.Recipe do
  @fields ["id", "name", "og", "fg", "abv", "srm", "ibu", "image", "image_url", "is_archived"]
  @default %{
    image_url: nil,
    is_archived: false,
    name: nil,
    source: "grain_father",
    source_id: nil
  }

  def from_api(json), do: Map.take(json, @fields)

  def to_brew_dash(brew) do
    %{
      @default
      | image_url: to_brew_dash_image(brew),
        is_archived: brew["is_archived"],
        name: brew["name"],
        source_id: to_string(brew["id"])
    }
  end

  def to_brew_dash_image(%{"image" => %{"url" => url}}) when is_binary(url), do: url
  def to_brew_dash_image(%{"image_url" => url}) when is_binary(url), do: url
  def to_brew_dash_image(_), do: nil

  def brew_dash_fields, do: Map.keys(@default)
end
