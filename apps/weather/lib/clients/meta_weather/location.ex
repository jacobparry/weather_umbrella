defmodule Weather.Clients.MetaWeather.Location do
  use Tesla

  import Weather.Clients.MetaWeather.GuardUtils, only: [is_woeid: 1]

  plug(Tesla.Middleware.BaseUrl, "https://www.metaweather.com/api/location/")
  plug(Tesla.Middleware.JSON)

  def search(city_name)
      when is_binary(city_name) and
             not is_map(city_name) and
             not is_list(city_name) and
             not is_atom(city_name) do
    get("/search/?query=#{city_name}")
  end

  def search(_) do
    {:error, "Incorrect parameter utilized."}
  end

  def find_by_id(woeid) when is_integer(woeid) do
    get("/#{woeid}/")
  end

  def find_by_id(_) do
    {:error, "Incorrect where-on-earth-id utilized. Must be an integer."}
  end

  def location_info_by_date(woeid, %DateTime{} = date) when is_woeid(woeid) do
    {:ok, date} = Weather.DateUtils.format_date(date)
    get("/#{woeid}/#{date}/")
  end

  def location_info_by_date(_, %DateTime{}),
    do: {:error, "Must provide valid woeid."}

  def location_info_by_date(woeid, _) when is_woeid(woeid),
    do: {:error, "Must provide valid datetime."}

  def location_info_by_date(_, _),
    do: {:error, "Must provide valid parameters."}
end
