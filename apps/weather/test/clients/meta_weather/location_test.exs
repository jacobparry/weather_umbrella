defmodule Weather.Clients.MetaWeather.LocationTest do
  use ExUnit.Case, async: true
  doctest Weather.Clients.MetaWeather.Location

  alias Weather.Clients.MetaWeather.Location

  describe "find_by_name/1" do
    test "Find Salt Lake City by name" do
      assert {:ok,
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
              }} = Location.search("salt")
    end

    test "finds no if search string is poor" do
      assert {:ok,
              %Tesla.Env{
                body: [],
                status: 200,
                url: "https://www.metaweather.com/api/location/search/?query=saltlake"
              }} = Location.search("saltlake")
    end

    test "fails if incorrect parameter type is used" do
      assert {:error, "Incorrect parameter utilized."} = Location.search(1234)
      assert {:error, "Incorrect parameter utilized."} = Location.search(:atom)
      assert {:error, "Incorrect parameter utilized."} = Location.search(%{})
      assert {:error, "Incorrect parameter utilized."} = Location.search([])
      assert {:error, "Incorrect parameter utilized."} = Location.search(true)
    end
  end

  describe "find_by_id/1" do
    test "success" do
      assert {:ok,
              %Tesla.Env{
                body: %{
                  "consolidated_weather" => _,
                  "latt_long" => "40.759499,-111.888229",
                  "location_type" => "City",
                  "sources" => _,
                  "title" => "Salt Lake City",
                  "woeid" => 2_487_610
                },
                status: 200,
                url: "https://www.metaweather.com/api/location/2487610/"
              }} = Location.find_by_id(2_487_610)
    end

    test "fails if incorrect parameter type is used" do
      assert {:error, "Incorrect where-on-earth-id utilized. Must be an integer."} = Location.find_by_id("1234")
      assert {:error, "Incorrect where-on-earth-id utilized. Must be an integer."} = Location.find_by_id(:atom)
      assert {:error, "Incorrect where-on-earth-id utilized. Must be an integer."} = Location.find_by_id(%{})
      assert {:error, "Incorrect where-on-earth-id utilized. Must be an integer."} = Location.find_by_id([])
      assert {:error, "Incorrect where-on-earth-id utilized. Must be an integer."} = Location.find_by_id(true)
    end
  end

  describe "location_info_by_date/2" do
    test "success" do
      {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

      assert {:ok,
              %Tesla.Env{
                body: _,
                status: 200,
                url: "https://www.metaweather.com/api/location/2487610/2020/1/1/"
              }} = Location.location_info_by_date(2_487_610, date)
    end

    test "parses out consolidated_weather" do
      {:ok, %Tesla.Env{body: %{"consolidated_weather" => consolidated_weather}}} = Location.find_by_id(2_487_610)

      Enum.each(consolidated_weather, fn weather ->
        assert %{
                 "air_pressure" => _,
                 "applicable_date" => _,
                 "created" => _,
                 "humidity" => _,
                 "id" => _,
                 "max_temp" => _,
                 "min_temp" => _,
                 "predictability" => _,
                 "the_temp" => _,
                 "visibility" => _,
                 "weather_state_abbr" => _,
                 "weather_state_name" => _,
                 "wind_direction" => _,
                 "wind_direction_compass" => _,
                 "wind_speed" => _
               } = weather
      end)
    end

    test "fails if incorrect parameters are used" do
      assert {:error, "Must provide valid woeid."} = Location.location_info_by_date("1234", DateTime.utc_now())
      assert {:error, "Must provide valid woeid."} = Location.location_info_by_date(:woeid, DateTime.utc_now())
      assert {:error, "Must provide valid woeid."} = Location.location_info_by_date(%{}, DateTime.utc_now())
      assert {:error, "Must provide valid woeid."} = Location.location_info_by_date([], DateTime.utc_now())
      assert {:error, "Must provide valid woeid."} = Location.location_info_by_date(true, DateTime.utc_now())
      assert {:error, "Must provide valid datetime."} = Location.location_info_by_date(2_487_610, Date.utc_today())
      assert {:error, "Must provide valid datetime."} = Location.location_info_by_date(2_487_610, "2022/1/1")
      assert {:error, "Must provide valid datetime."} = Location.location_info_by_date(2_487_610, nil)
      assert {:error, "Must provide valid parameters."} = Location.location_info_by_date(nil, nil)
    end
  end
end
