defmodule Api.Schema do
  @moduledoc """
  GraphQL Schema for our GraphQL API.
  """

  use Absinthe.Schema

  query do
    field(:health, :string) do
      resolve(fn _, _, _ ->
        {:ok, "up"}
      end)
    end

    field(:tri_city_data, list_of(:city_data)) do
      resolve(&Api.Resolvers.CityResolver.get_city_data/3)
    end
  end

  object :city_data do
    field(:name, :string)
    field(:average_max_temp, :float)
  end
end
