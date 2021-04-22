defmodule Inmana.Supplies.Scheduler do
  use GenServer

  alias Inmana.Supplies.ExpirationNotification

  # CLIENT
  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  # SERVER

  @impl true
  def init(state \\ %{}) do
    schedule_notification()
    {:ok, state}
  end

  @impl true
  def handle_info(:generate, state) do
    ExpirationNotification.send()

    schedule_notification()

    {:noreply, state}
  end

  defp schedule_notification do
    Process.send_after(self(), :generate, 1000 * 60 * 60 * 24 * 7)
  end

  # async: Que não acontece juntamente com outra coisa.
  #
  # def handle_cast({:put, key, value}, state) do
  #   {:noreply, Map.put(state, key, value)}
  # end

  # sync: Que acontece exatamente ao mesmo tempo que outra coisa.
  #
  # def handle_call({:get, key}, _from, state) do
  #   {:reply, Map.get(state, key), state}
  # end
end
