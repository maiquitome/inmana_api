defmodule Inmana.Welcomer do
  # Receive a name and age from the user
  def welcome(%{"name" => name, "age" => age}) do
    age = String.to_integer(age)

    # We have to treat the username for wrong entries, like "BaNaNa", "banana \n"
    name
    |> String.trim()
    |> String.downcase()
    # avaliar
    |> evaluate(age)
  end

  # If the user calls "Banana" and is 42 years old, he receives a special message
  # %{"name" => "banana", "age" => "42"} |> Inmana.Welcomer.welcome
  defp evaluate("banana", 42) do
    {:ok, "You are very special banana"}
  end

  # If the user is of age, he receives a normal message
  defp evaluate(name, age) when age >= 18 do
    {:ok, "Welcome #{name}"}
  end

  # If the user is a minor, we return an error
  defp evaluate(name, _age) do
    {:error, "You shall not pass #{name}"}
  end
end
