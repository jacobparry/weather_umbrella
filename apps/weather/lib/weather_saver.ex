defmodule Weather.WeatherSaver do
  use GenServer

  # Client
  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def register(user, server) do
    GenServer.call(server, {:new_user, user})
  end

  def greet(user, server) do
    GenServer.call(server, {:greet, user})
  end

  # Server
  def init(_args) do
    state = %{
      users: []
    }

    {:ok, state}
  end

  def handle_call({:new_user, user}, _from, state) do
    new_state = %{state | users: [user | state.users]}

    {:reply, "added", new_state}
  end

  def handle_call({:greet, user}, _from, state) do
    {:reply, generate_response(user, state), state}
  end

  defp generate_response(user, %{users: users} = _state) do
    case Enum.any?(users, fn u -> u == user end) do
      true -> "Welcome back, #{user}!"
      _false -> "You must register first"
    end
  end
end
