defmodule Weather.WeatherSaver do
  use GenServer

  @slc_woeid 2_487_610
  @la_woeid 2_442_047
  @boise_woeid 2_366_355

  # Client
  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def save_weather(woeid, server) do
    GenServer.call(server, {:find_weather, woeid}, 20000)
  end

  def get_weather(server) do
    GenServer.call(server, {:get_weather, nil}, 20000)
  end

  # Server
  def init(_args) do
    state = %{
      cities: []
    }

    loaded_state =
      state
      |> load_city(@slc_woeid)
      |> load_city(@la_woeid)
      |> load_city(@boise_woeid)

    {:ok, loaded_state}
  end

  def handle_call({:find_weather, woeid}, _from, state) do
    new_state = load_city(state, woeid)

    {:reply, "Bam", new_state}
  end

  def handle_call({:get_weather, nil}, _from, state) do
    {:reply, state, state}
  end

  defp load_city(state, woeid) do
    {:ok, %Tesla.Env{body: %{"woeid" => woeid, "title" => city_name}}} =
      Weather.Clients.MetaWeather.Location.find_by_id(woeid)

    city_data =
      Weather.Forecast.forecast_day(woeid, DateTime.utc_now(), :max_temp)
      |> format_result(city_name)

    _new_state = %{state | cities: [city_data | state.cities]}
  end

  defp format_result(result, city_name) do
    %{name: city_name, average_max_temp: result.average}
  end
end
