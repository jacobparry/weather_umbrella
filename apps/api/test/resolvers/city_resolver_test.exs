defmodule Api.Resolvers.CityResolverTest do
  @moduledoc """
  Test for the CityResolver module
  """
  use ExUnit.Case

  describe "get_city_data_sequentially/3" do
    test "returns wanted proof data" do
      query = """
      {
        triCityDataSequentially {
          name
          averageMaxTemp
        }
      }
      """

      assert {:ok,
              %{
                data: %{
                  "triCityDataSequentially" => [
                    %{"averageMaxTemp" => 4.53, "name" => "Salt Lake City"},
                    %{"averageMaxTemp" => 21.23, "name" => "Los Angeles"},
                    %{"averageMaxTemp" => 1.72, "name" => "Boise"}
                  ]
                }
              }} = Absinthe.run(query, Api.Schema, variables: [])
    end
  end

  describe "get_city_data_async/3" do
    test "returns wanted proof data" do
      query = """
      {
        triCityDataAsync {
          name
          averageMaxTemp
        }
      }
      """

      assert {:ok,
              %{
                data: %{
                  "triCityDataAsync" => [
                    %{"averageMaxTemp" => 4.53, "name" => "Salt Lake City"},
                    %{"averageMaxTemp" => 21.23, "name" => "Los Angeles"},
                    %{"averageMaxTemp" => 1.72, "name" => "Boise"}
                  ]
                }
              }} = Absinthe.run(query, Api.Schema, variables: [])
    end
  end

  describe "get_city_data_genserver/3" do
    test "returns wanted proof data" do
      query = """
      {
        triCityDataGenserver {
          name
          averageMaxTemp
        }
      }
      """

      assert {:ok,
              %{
                data: %{
                  "triCityDataGenserver" => [
                    %{"averageMaxTemp" => 4.53, "name" => "Salt Lake City"},
                    %{"averageMaxTemp" => 21.23, "name" => "Los Angeles"},
                    %{"averageMaxTemp" => 1.72, "name" => "Boise"}
                  ]
                }
              }} = Absinthe.run(query, Api.Schema, variables: [])
    end
  end

  describe "get_city_data_genserver_named/3" do
    test "returns wanted proof data" do
      query = """
      {
        triCityDataGenserverNamed {
          name
          averageMaxTemp
        }
      }
      """

      assert {:ok,
              %{
                data: %{
                  "triCityDataGenserverNamed" => [
                    %{"averageMaxTemp" => 4.53, "name" => "Salt Lake City"},
                    %{"averageMaxTemp" => 21.23, "name" => "Los Angeles"},
                    %{"averageMaxTemp" => 1.72, "name" => "Boise"}
                  ]
                }
              }} = Absinthe.run(query, Api.Schema, variables: [])
    end
  end
end
