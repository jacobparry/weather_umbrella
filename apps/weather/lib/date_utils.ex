defmodule Weather.DateUtils do
  @moduledoc """
  Utils for manipulating datetimes exactly how I want them to be.
  """

  @doc """
  MetaWeather wants dates formated like this.
  """
  @spec format_date(DateTime) :: {:ok, binary()}
  def format_date(%DateTime{} = date) do
    Timex.format(date, "{YYYY}/{M}/{D}")
  end

  @doc """
  Compares two dates to know if I need to make a historical api call or a current api call for the forecast data.
  """
  @spec compare_dates(DateTime, DateTime) :: atom()
  def compare_dates(%DateTime{} = date1, %DateTime{} = date2) do
    case Timex.compare(date1, date2, :days) do
      1 -> :second_comes_first
      -1 -> :first_comes_first
      0 -> :equal
      _ -> :error
    end
  end
end
