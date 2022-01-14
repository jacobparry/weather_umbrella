defmodule Weather.Clients.MetaWeather.GuardUtils do
  defguard is_woeid(value) when is_integer(value)
end
