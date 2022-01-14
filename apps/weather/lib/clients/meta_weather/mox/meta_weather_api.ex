defmodule Weather.Clients.MetaWeather.Mox.MetaWeatherAPI do
  @moduledoc """
  sometthing
  """

  @implementation Application.get_env(
                    :weather,
                    :meta_weather_api_mox,
                    Weather.Clients.MetaWeather.Location
                  )

  def search(city_name), do: @implementation.search(city_name)
  def find_by_id(woeid), do: @implementation.find_by_id(woeid)
  def location_info_by_date(woeid, date), do: @implementation.location_info_by_date(woeid, date)
end
