defmodule Inmana.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:email, :name]

  # By default all keys except the :__struct__ key are encoded.
  # then we need to tell Jason.Encoder to render the fields to json
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  # iex> Jason.encode(%{name: "Maiqui", last_name: "Tomé"})
  # {:ok, "{\"last_name\":\"Tomé\",\"name\":\"Maiqui\"}"}
  #
  # iex> Jason.encode!(%{name: "Maiqui", last_name: "Tomé"})
  # "{\"last_name\":\"Tomé\",\"name\":\"Maiqui\"}"
  #
  # iex> Jason.encode!(%Inmana.Restaurant{})
  # "{\"email\":null,\"name\":null,\"id\":null}"

  schema "restaurants" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    # cast - change the data
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 2)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
  end
end
