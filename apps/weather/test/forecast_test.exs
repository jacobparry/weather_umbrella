defmodule Weather.ForecastTest do
  @moduledoc """
  Tests for Weather.Forecast
  """

  use ExUnit.Case, async: true
  doctest Weather.Forecast

  alias Weather.Clients.MetaWeather.Location
  alias Weather.Forecast

  describe "forecast_day/3" do
    test "max_temp" do
      {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

      assert %{average: 1.46, count: 72, sum: 105.35, type: :max_temp} =
               Forecast.forecast_day(2_487_610, date, :max_temp)
    end

    test "min_temp" do
      {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

      assert %{average: -3.04, count: 72, sum: -218.7, type: :min_temp} =
               Forecast.forecast_day(2_487_610, date, :min_temp)
    end
  end

  describe "find_forecasted_weather/1" do
    test "returns list of weather predictions for the current day/period" do
      results =
        Location.find_by_id(2_487_610)
        |> Forecast.find_forecasted_weather(:current)

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
             } = List.first(results)

      assert Enum.count(results) == 6
    end

    test "returns list of weather predictions for a historical day/period" do
      {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

      results =
        Location.location_info_by_date(2_487_610, date)
        |> Forecast.find_forecasted_weather(:historical)

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
             } = List.first(results)

      assert Enum.count(results) == 72
    end
  end
end
