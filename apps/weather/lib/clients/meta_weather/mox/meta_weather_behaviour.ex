defmodule Weather.Clients.MetaWeather.Mox.MetaWeatherBehaviour do
  @moduledoc """
  something
  """

  @callback search(binary()) :: {:ok, %Tesla.Env{}} | {:error, binary()}
  @callback find_by_id(integer()) :: {:ok, %Tesla.Env{}} | {:error, binary()}
  @callback location_info_by_date(integer(), DateTime) :: {:ok, %Tesla.Env{}} | {:error, binary()}
end
