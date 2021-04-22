defmodule Inmana.Supplies.Get do
  alias Inmana.{Repo, Supply}

  # FLOW CONTROL OPTION:
  #
  # def call(uuid) do
  #   case Repo.get(Supply, uuid) do
  #     nil -> {:error, %{result: "Supply not found", status: :not_found}}
  #     supply -> {:ok, supply}
  #   end
  # end

  def call(uuid) do
    Supply
    |> Repo.get(uuid)
    |> handle_get()
  end

  defp handle_get(%Supply{} = result), do: {:ok, result}

  defp handle_get(nil) do
    {:error, %{result: "Supply not found", status: :not_found}}
  end
end
