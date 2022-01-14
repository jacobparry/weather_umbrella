ExUnit.start()

Mox.defmock(Weather.Clients.MetaWeather.Mox.MetaWeatherAPIMock,
  for: Weather.Clients.MetaWeather.Mox.MetaWeatherBehaviour
)

Mimic.copy(Weather.Clients.MetaWeather.Location)
