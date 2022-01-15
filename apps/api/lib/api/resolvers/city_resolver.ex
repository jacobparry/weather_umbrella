defmodule Api.Resolvers.CityResolver do
  @moduledoc """
  GraphQL resolver functions for getting City Data
  """

  alias Weather.WeatherSaver

  @slc_woeid 2_487_610
  @la_woeid 2_442_047
  @boise_woeid 2_366_355

  @doc """
  Hard coded to return the wanted data for the proof. Will look something like this:

  {
  "data": {
    "triCityData": [
      {
        "averageMaxTemp": 4.53,
        "name": "Salt Lake City"
      },
      {
        "averageMaxTemp": 21.23,
        "name": "Los Angeles"
      },
      {
        "averageMaxTemp": 1.68,
        "name": "Boise"
      }
    ]
  }
  }
  """
  def get_city_data_sequentially(_parent, _args, _resolution) do
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(@slc_woeid)

    slc =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(@la_woeid)

    la =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(@boise_woeid)

    boise =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    {:ok, [slc, la, boise]}
  end

  def get_city_data_async(_parent, _args, _resolution) do
    task_slc = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@slc_woeid) end)
    task_la = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@la_woeid) end)

    task_boise = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@boise_woeid) end)

    result_slc = Task.await(task_slc)
    result_la = Task.await(task_la)
    result_boise = Task.await(task_boise)

    # Salt Lake City 2487610
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} = result_slc

    slc =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    # Los Angeles 2442047
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} = result_la

    la =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    # Boise 2366355
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} = result_boise

    boise =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    {:ok, [slc, la, boise]}
  end

  def get_city_data_genserver(_parent, _args, _resolution) do
    {:ok, server} = WeatherSaver.start_link()

    WeatherSaver.save_weather(@slc_woeid, server)
    WeatherSaver.save_weather(@la_woeid, server)
    WeatherSaver.save_weather(@boise_woeid, server)

    %{cities: city_data} = WeatherSaver.get_weather(server)

    {:ok, city_data}
  end

  def get_city_data_genserver_named(_parent, _args, _resolution) do
    server = Process.whereis(:saver)

    %{cities: city_data} = WeatherSaver.get_weather(server)

    {:ok, city_data}
  end

  defp format_result(result, city_name) do
    %{name: city_name, average_max_temp: result.average}
  end
end
