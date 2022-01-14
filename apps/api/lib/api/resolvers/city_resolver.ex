defmodule Api.Resolvers.CityResolver do
  @moduledoc """
  GraphQL resolver functions for getting City Data
  """

  def get_city_data(_parent, _args, _resolution) do
    # Salt Lake City 2487610
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(2_487_610)

    slc =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)
      |> IO.inspect()

    # Los Angeles 2442047
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(2_442_047)

    la =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)
      |> IO.inspect()

    # Boise 2366355
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(2_366_355)

    boise =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)
      |> IO.inspect()

    {:ok, [slc, la, boise]}
  end

  defp format_result(result, city_name) do
    %{name: city_name, average_max_temp: result.average}
  end
end
