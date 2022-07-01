defmodule BrewDash.Factory do
  use ExMachina.Ecto, repo: BrewDash.Repo

  alias BrewDash.Schema

  def bottle_factory do
    %Schema.Bottle{
      company: Faker.Company.name(),
      name: Faker.Beer.name(),
      drunk_at: nil,
      style: nil,
      vintage: random_date(),
      quantity: 1,
      location: ""
    }
  end

  defp random_date, do: ~D[2000-01-01] |> Faker.Date.between(~D[2022-12-25]) |> Date.to_string()
end
