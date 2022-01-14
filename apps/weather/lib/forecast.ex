defmodule Weather.Forecast do
  @moduledoc """
  Used to get forecast weather data for a city id, date, and then wanted data key
  """

  alias Weather.Clients.MetaWeather.Location
  alias Weather.DateUtils

  @doc """
  Using the MetaWeather API, we are able to get predicted weather data for a specific location.any()

  This functions takes a `where-on-earth-id (woeid), a date, and then a forecast_key (:max_temp, :min_temp).
  Will then find the average of the forecast_key type for the given date (which is usually a series of days)

  Compares dates to know whether it is going to be looking at historical data vs current data
  """
  @spec forecast_day(integer(), DateTime, atom()) :: map()
  def forecast_day(woeid, %DateTime{} = date, forecast_key) do
    case DateUtils.compare_dates(DateTime.utc_now(), date) do
      :first_comes_first ->
        Location.find_by_id(woeid)
        |> find_forecasted_weather(:current)
        |> find_average(forecast_key)

      _ ->
        # Look up DB instead of query API
        Location.location_info_by_date(woeid, date)
        |> find_forecasted_weather(:historical)
        |> find_average(forecast_key)
    end
  end

  @doc """
  Receives a payload from Tesla, and exctracts out the wanted consolidated weather data.
  The structure matters because if it is :current vs :historical, the payload structure changes
  """
  @spec find_forecasted_weather({:ok, Tesla.Env}, atom()) :: list(map())
  def find_forecasted_weather({:ok, %Tesla.Env{body: %{"consolidated_weather" => consolidated_weather}}}, :current) do
    consolidated_weather
  end

  def find_forecasted_weather({:ok, %Tesla.Env{body: consolidated_weather}}, :historical) do
    consolidated_weather
  end

  @doc """
  Takes a list of forecasted weather maps, and performs a reduce to get the sum, count, and average temps based on the type passed in
  """
  @spec find_average(list(map()), atom()) :: map()
  def find_average(consolidated_weather, :max_temp = type) when is_list(consolidated_weather) do
    Enum.reduce(consolidated_weather, %{sum: 0, count: 0, average: 0}, fn %{"max_temp" => temp}, acc ->
      perform_average_calculation(type, temp, acc)
    end)
  end

  def find_average(consolidated_weather, :min_temp = type) when is_list(consolidated_weather) do
    Enum.reduce(consolidated_weather, %{sum: 0, count: 0, average: 0}, fn %{"min_temp" => temp}, acc ->
      perform_average_calculation(type, temp, acc)
    end)
  end

  def perform_average_calculation(type, temp, acc) do
    %{sum: sum, count: count, average: _average} = acc

    new_sum =
      (temp + sum)
      |> Float.round(2)

    new_count = count + 1

    new_average =
      (new_sum / new_count)
      |> Float.round(2)

    %{type: type, sum: new_sum, count: new_count, average: new_average}
  end
end
