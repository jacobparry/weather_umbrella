defmodule Weather.Clients.MetaWeather.Mimic.LocationTest do
  use ExUnit.Case, async: true, async: true
  use Mimic

  alias Weather.Clients.MetaWeather.Location

  test "gets and formats temperature and humidity" do
    Location
    |> expect(:search, fn _search_term -> search_return() end)
    |> expect(:find_by_id, fn _woeid -> find_by_id_return() end)
    |> expect(:location_info_by_date, fn _woeid, _date -> location_info_by_date_return() end)

    assert Location.search("salt") ==
             {:ok,
              %Tesla.Env{
                body: [
                  %{
                    "latt_long" => "40.759499,-111.888229",
                    "location_type" => "City",
                    "title" => "Salt Lake City",
                    "woeid" => 2_487_610
                  }
                ],
                status: 200,
                url: "https://www.metaweather.com/api/location/search/?query=salt"
              }}

    assert Location.find_by_id(2_487_610) ==
             {:ok,
              %Tesla.Env{
                body: %{
                  "consolidated_weather" => [],
                  "latt_long" => "40.759499,-111.888229",
                  "location_type" => "City",
                  "sources" => 1,
                  "title" => "Salt Lake City",
                  "woeid" => 2_487_610
                },
                status: 200,
                url: "https://www.metaweather.com/api/location/2487610/"
              }}

    {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

    assert Location.location_info_by_date(2_487_610, date) ==
             {:ok,
              %Tesla.Env{
                body: [],
                status: 200,
                url: "https://www.metaweather.com/api/location/2487610/2020/1/1/"
              }}
  end

  defp search_return() do
    {:ok,
     %Tesla.Env{
       body: [
         %{
           "latt_long" => "40.759499,-111.888229",
           "location_type" => "City",
           "title" => "Salt Lake City",
           "woeid" => 2_487_610
         }
       ],
       status: 200,
       url: "https://www.metaweather.com/api/location/search/?query=salt"
     }}
  end

  defp find_by_id_return() do
    {:ok,
     %Tesla.Env{
       body: %{
         "consolidated_weather" => [],
         "latt_long" => "40.759499,-111.888229",
         "location_type" => "City",
         "sources" => 1,
         "title" => "Salt Lake City",
         "woeid" => 2_487_610
       },
       status: 200,
       url: "https://www.metaweather.com/api/location/2487610/"
     }}
  end

  defp location_info_by_date_return() do
    {:ok,
     %Tesla.Env{
       body: [],
       status: 200,
       url: "https://www.metaweather.com/api/location/2487610/2020/1/1/"
     }}
  end
end
