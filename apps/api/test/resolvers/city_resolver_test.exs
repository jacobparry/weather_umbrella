defmodule Api.Resolvers.CityResolverTest do
  @moduledoc """
  Test for the CityResolver module

  These tests are going to fail. I wrote them in such a way to show the result set in the format requested,
  but due to not passing in specific dates, the temperatures are going to vary daily, as well as ordering is not guaranteed.
  """
  use ExUnit.Case, async: true

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

      assert {
               :ok,
               %{
                 data: %{
                   "triCityDataSequentially" => [
                     %{"averageMaxTemp" => 1.46, "name" => "Salt Lake City"},
                     %{"averageMaxTemp" => 17.9, "name" => "Los Angeles"},
                     %{"averageMaxTemp" => 2.23, "name" => "Boise"}
                   ]
                 }
               }
             } = Absinthe.run(query, Api.Schema, variables: [])
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

      assert {
               :ok,
               %{
                 data: %{
                   "triCityDataAsync" => [
                     %{"averageMaxTemp" => 1.46, "name" => "Salt Lake City"},
                     %{"averageMaxTemp" => 17.9, "name" => "Los Angeles"},
                     %{"averageMaxTemp" => 2.23, "name" => "Boise"}
                   ]
                 }
               }
             } = Absinthe.run(query, Api.Schema, variables: [])
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

      assert {
               :ok,
               %{
                 data: %{
                   "triCityDataGenserverNamed" => [
                     %{"averageMaxTemp" => 1.47, "name" => "Boise"},
                     %{"averageMaxTemp" => 22.84, "name" => "Los Angeles"},
                     %{"averageMaxTemp" => 3.34, "name" => "Salt Lake City"}
                   ]
                 }
               }
             } = Absinthe.run(query, Api.Schema, variables: [])
    end
  end
end
