defmodule Api.Resolvers.CityResolver do
  @moduledoc """
  GraphQL resolver functions for getting City Data
  """

  alias Weather.WeatherSaver

  @slc_woeid 2_487_610
  @la_woeid 2_442_047
  @boise_woeid 2_366_355

  @doc """
  This is just a classic, "Go fetch this data" resolver, nothing concurrent, hit this api.
  """
  def get_city_data_sequentially(_parent, _args, _resolution) do
    {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

    {:ok, %Tesla.Env{body: %{"title" => slc_city_name}}} = Weather.Clients.MetaWeather.Location.find_by_id(@slc_woeid)
    {:ok, %Tesla.Env{body: %{"title" => la_city_name}}} = Weather.Clients.MetaWeather.Location.find_by_id(@la_woeid)

    {:ok, %Tesla.Env{body: %{"title" => boise_city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(@boise_woeid)

    slc =
      Weather.Forecast.forecast_day(@slc_woeid, date, :max_temp)
      |> format_result(slc_city_name)

    la =
      Weather.Forecast.forecast_day(@la_woeid, date, :max_temp)
      |> format_result(la_city_name)

    boise =
      Weather.Forecast.forecast_day(@boise_woeid, date, :max_temp)
      |> format_result(boise_city_name)

    {:ok, [slc, la, boise]}
  end

  @doc """
  This utilizes Task.async to spin off tasks and then await the results. Not "fire-n-forget" but async none-the-less
  """
  def get_city_data_async(_parent, _args, _resolution) do
    {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

    task_slc = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@slc_woeid) end)
    task_la = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@la_woeid) end)
    task_boise = Task.async(fn -> Weather.Clients.MetaWeather.Location.find_by_id(@boise_woeid) end)

    result_slc = Task.await(task_slc)
    result_la = Task.await(task_la)
    result_boise = Task.await(task_boise)

    {:ok, %Tesla.Env{body: %{"woeid" => slc_woeid, "title" => slc_city_name}}} = result_slc
    {:ok, %Tesla.Env{body: %{"woeid" => la_woeid, "title" => la_city_name}}} = result_la
    {:ok, %Tesla.Env{body: %{"woeid" => boise_woeid, "title" => boise_city_name}}} = result_boise

    task_slc_2 = Task.async(fn -> Weather.Forecast.forecast_day(slc_woeid, date, :max_temp) end)
    task_la_2 = Task.async(fn -> Weather.Forecast.forecast_day(la_woeid, date, :max_temp) end)
    task_boise_2 = Task.async(fn -> Weather.Forecast.forecast_day(boise_woeid, date, :max_temp) end)

    result_slc_2 = Task.await(task_slc_2)
    result_la_2 = Task.await(task_la_2)
    result_boise_2 = Task.await(task_boise_2)

    slc = format_result(result_slc_2, slc_city_name)
    la = format_result(result_la_2, la_city_name)
    boise = format_result(result_boise_2, boise_city_name)

    {:ok, [slc, la, boise]}
  end

  @doc """
  This starts a Genserver, which then uses genserver to make requests and save state.
  """
  def get_city_data_genserver(_parent, _args, _resolution) do
    {:ok, date, _} = DateTime.from_iso8601("2020-01-01 00:00:00Z")

    {:ok, server} = WeatherSaver.start_link()

    WeatherSaver.save_weather(@slc_woeid, date, server)
    WeatherSaver.save_weather(@la_woeid, date, server)
    WeatherSaver.save_weather(@boise_woeid, date, server)

    %{cities: city_data} = WeatherSaver.get_weather(server)

    {:ok, city_data}
  end

  @doc """
  With this function, I spawn a named genserver on application start up `Weather.Application`
  Here, I locate that named process and use it to gather the info it has in its state.
  """
  def get_city_data_genserver_named(_parent, _args, _resolution) do
    server = Process.whereis(:saver)

    %{cities: city_data} = WeatherSaver.get_weather(server)

    {:ok, city_data}
  end

  defp format_result(result, city_name) do
    %{name: city_name, average_max_temp: result.average}
  end
end
