<div align="center">
  <img alt="refrigerator" height="150" src=".github/frigorifico.svg">
  <h1><strong>INMANA API</strong><br>&nbsp;Inventory Management</h1>

  ### 👨‍🍳 Loss prevention with intelligent _best before date_ management in a restaurant 👨‍🍳
  <a href="https://nextlevelweek.com/">This project was created during Rockeseat's NLW event</a>
</div>
<br>

### 🍔 About the project
* In every restaurant, in the kitchen, every manipulable food that is opened, like a jar of mayonnaise, this Anvisa label has to be attached. So, let's help the restaurant to use this resource intelligently so that no food spoils:

  <img alt="etiqueta-anvisa" height="150" src=".github/etiqueta-anvisa.jpg">

* Restaurants and supplies can be registered;
* It must be possible to view information from a procurement;
  - When does the food expire?
  - When was the food manipulated?
* A list of items due every week should be generated for each of the restaurants;
* The list of items should be sent to the restaurant's email.

<br>

### 🚀 Technologies used in this project
* Elixir Programming Language
* Phoenix Web Framework
* Credo - a static code analysis tool for the Elixir language with a focus on teaching and code consistency.
* Bamboo - to send emails

<br>

<div align="center">
Made with ♥ by Maiqui Tomé 😀
<br>

*Reach out to me* 👇

[![Codepen](https://img.shields.io/badge/Codepen-000000?style=flat-square&logo=codepen&logoColor=white "Codepen")](https://codepen.io/maiquitome)
[![Youtube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white "Youtube")](https://www.youtube.com/channel/UCoXn0XyxLsKpIE5px0UNuEw)
[![Medium](https://img.shields.io/badge/Medium-black?&style=flat-square&logo=medium&logoColor=white "Medium")](https://medium.com/@maiquitome)
[![Linkedin](https://img.shields.io/badge/LinkedIn-0A66C2.svg?&style=flat-square&logo=linkedin&logoColor=white "Linkedin")](https://www.linkedin.com/in/maiquitome)
[![Instagram](https://img.shields.io/badge/Instagram-D8226B.svg?&style=flat-square&logo=instagram&logoColor=white "Instagram")](https://www.instagram.com/maiquitome)
[![Facebook](https://img.shields.io/badge/Facebook-0674E7.svg?&style=flat-square&logo=facebook&logoColor=white "Facebook")](https://www.facebook.com/maiquitome)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?&style=flat-square&logo=twitter&logoColor=white "Twitter")](https://twitter.com/MaiquiTome)
</div>

<br>
<div align="center">

  # Creating the project from scratch

</div>

* [VIDEO 1: Reinforcing concepts](#Video-1-Reinforcing-concepts)
  - [Creating the project](#Creating-the-project)
  - [Creating the database](#Creating-the-database)
  - [Install Credo](#Install-credo)
  - [Creating welcomer](#Creating-welcomer)
  - [Creating a welcome route](#Creating-a-welcome-route)
  - [Creating the controller](#Creating-the-controller)
  - [Welcomer final result](#Welcomer-final-result)
* [VIDEO 2: Creating the restaurant](#Video-2-Creating-the-restaurant)
  - [Restaurant migration](#Restaurant-migration)
  - [Restaurant schema](#Restaurant-schema)
  - [Restaurant create](#Restaurant-create)
  - [Restaurant facade](#Restaurant-facade)
    - WEB
      - [Restaurant controller](#Restaurant-controller)
      - [Fallback controller](#Fallback-controller)
      - [Error view](#Error-view)
      - [Restaurant view](#Restaurant-view)
      - [Restaurant route](#Restaurant-route)
* [VIDEO 3: Creating the supplies](#Video-3-Creating-the-supplies)
  - [Supplies migration](#Supplies-migration)
  - [Supplies schema](#Supplies-schema)
  - [Supplies create](#Supplies-create)
  - [Supplies get](#Supplies-get)
  - [Supplies get by expiration](#Supplies-get-by-expiration)
  - [Supplies facade](#Supplies-facade)
    - WEB
      - [Supplies controller](#Supplies-controller)
      - [Supplies route](#Supplies-route)
      - [Supplies view](#Supplies-view)
      - [Supplies error view](#Supplies-error-view)
    - EMAIL
      - [Install bamboo](#Install-bamboo)
      - [Mailer](#Mailer)
      - [Expiration notification](#Expiration-notification)
      - [Expiration email](#Expiration-email)
      - [Sending email](#Sending-email)
* [VIDEO 4: Tasks - Genservers - Supervisors](#Video-4-Tasks-Genservers-Supervisors)
  - [Task](#Task)
  - [Genservers](#Genservers)
  - [Supervisor](#Supervisor)

<div align="center">

  # VIDEO 1: Reinforcing concepts

</div>

### Creating the project
```bash
$ mix phx.new inmana --no-html --no-webpack
```
### Creating the database
```bash
$ cd inmana
```
```bash
$ mix ecto.create
```
### Install Credo
https://github.com/rrrene/credo

```elixir
# mix.exs

defp deps do
  [
    {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
  ]
end
```
```bash
$ mix deps.get
```
```bash
$ mix credo.gen.config
```
```bash
$ mix credo
```

### Creating welcomer

* Receive a name and age from the user
* We have to treat the username for wrong entries, like "BaNaNa", "banana \n"
* If the user calls "Banana" and is 42 years old, he receives a special message
* If the user is of age, he receives a normal message
* If the user is a minor, we return an error

```elixir
# lib/inmana/welcome.ex

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
```

### Creating a welcome route
```elixir
#lib/inmana_web/router.ex

scope "/api", InmanaWeb do
  pipe_through :api

  get "/", WelcomeController, :index
end
```
### Creating the controller
```elixir
# lib/inmana_web/controllers/welcome_controller.ex

defmodule InmanaWeb.WelcomeController do
  use InmanaWeb, :controller
  alias Inmana.Welcomer

  def index(conn, params) do
    params
    |> Welcomer.welcome()
    |> handle_response(conn)
  end

  defp handle_response({:ok, message}, conn) do
    render_response(conn, message, :ok)
  end

  defp handle_response({:error, message}, conn) do
    render_response(conn, message, :bad_request)
  end

  defp render_response(conn, message, status) do
    conn
    # Plug.Conn.put_status/2
    |> put_status(status)
    # Phoenix.Controller.json
    |> json(%{message: message})
  end
end
```
### Welcomer final result

<img src=".github/final_result_welcomer.gif">



<div align="center">

  # VIDEO 2: Creating the restaurant

</div>

### Restaurant migration

Command to create the restaurant migration
```elixir
$ mix ecto.gen.migration create_restaurants_table
```

Changing the restaurant migration file
```elixir
# priv/repo/migrations/20210420113131_create_restaurants_table.exs

defmodule Inmana.Repo.Migrations.CreateRestaurantsTable do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :email, :string
      add :name,  :string

      timestamps()
    end

    create unique_index(:restaurants, [:email])
  end
end
```

Setting up UUID
```elixir
# config/config.exs

config :inmana,
  ecto_repos: [Inmana.Repo]

# after the above existing code, add this code:

config :inmana, Inmana.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]
```

Command to run the restaurant migration
```bash
$ mix ecto.migrate
```

### Restaurant schema
```elixir
# lib/inmana/restaurant.ex

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
    # To create a changeset using the schema, we are going to use Ecto.Changeset.cast/3
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 2)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
  end
end
```

### Restaurant create
```elixir
# lib/inmana/restaurants/create.ex

defmodule Inmana.Restaurants.Create do
  alias Inmana.{Repo, Restaurant}

  def call(params) do
    params
    |> Restaurant.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Restaurant{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, %{result: result, status: :bad_request}}
  end
end
```

### Restaurant facade
```elixir
# lib/inmana.ex

defmodule Inmana do
  alias Inmana.Restaurants.Create

  defdelegate create_restaurant(params), to: Create, as: :call
end
```


### Restaurant controller
```elixir
# lib/inmana_web/controllers/restaurants_controller.ex

defmodule InmanaWeb.RestaurantsController do
  use InmanaWeb, :controller

  alias Inmana.Restaurant
  alias InmanaWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Restaurant{} = restaurant} <- Inmana.create_restaurant(params) do
      conn
      |> put_status(:created)
      |> render("create.json", restaurant: restaurant)
    end
  end
end
```

### Fallback controller
```elixir
# lib/inmana_web/controllers/fallback_controller.ex

defmodule InmanaWeb.FallbackController do
  use InmanaWeb, :controller

  def call(conn, {:error, %{result: result, status: status}}) do
    conn
    |> put_status(status)
    |> put_view(InmanaWeb.ErrorView)
    |> render("error.json", result: result)
  end
end
```

### Error view
```elixir
# lib/inmana_web/views/error_view.ex

defmodule InmanaWeb.ErrorView do
  use InmanaWeb, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{result: %Ecto.Changeset{} = changeset}) do
    %{message: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
```

### Restaurant view
```elixir
# lib/inmana_web/views/restaurants_view.ex

defmodule InmanaWeb.RestaurantsView do
  use InmanaWeb, :view

  def render("create.json", %{restaurant: restaurant}) do
    %{
      message: "Restaurant created!",
      restaurant: restaurant
    }
  end
end
```

### Restaurant route
```elixir
# lib/inmana_web/router.ex

scope "/api", InmanaWeb do
    pipe_through :api

    get "/", WelcomeController, :index

    # add this code:
    post "/restaurants", RestaurantsController, :create
  end
```



<div align="center">

  # VIDEO 3: Creating the supplies

</div>



### Supplies migration

Command to create the supplies migration
```elixir
$ mix ecto.gen.migration create_supplies_table
```

Changing the supplies migration file
```elixir
# priv/repo/migrations/20210421163733_create_supplies_table.exs

defmodule Inmana.Repo.Migrations.CreateSuppliesTable do
  use Ecto.Migration

  def change do
    create table(:supplies) do
      add :description,     :string
      add :expiration_date, :date
      add :responsible,     :string
      add :restaurant_id,   references(:restaurants, type: :binary_id)

      timestamps()
    end
  end
end
```

Command to run the supplies migration
```bash
$ mix ecto.migrate
```

### Supplies schema
```elixir
# lib/inmana/supply.ex

defmodule Inmana.Supply do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [
    :description,
    :expiration_date,
    :responsible,
    :restaurant_id
  ]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "supplies" do
    field :description, :string
    field :expiration_date, :date
    field :responsible, :string

    belongs_to :restaurant, Inmana.Restaurant

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    # cast - change the data
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: 2)
    |> validate_length(:responsible, min: 2)
  end
end
```

```elixir
# lib/inmana/restaurant.ex

# in this code:
schema "restaurants" do
    field :email, :string
    field :name, :string

    # add this line:
    has_many :supplies, Inmana.Supply

    timestamps()
  end
```

### Supplies create
```elixir
# lib/inmana/supplies/create.ex

defmodule Inmana.Supplies.Create do
  alias Inmana.{Repo, Supply}

  def call(params) do
    params
    |> Supply.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Supply{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, %{result: result, status: :bad_request}}
  end
end
```

### Supplies get
Looking at all the supplies
```bash
iex> Inmana.Repo.all(Inmana.Supply)
[debug] QUERY OK source="supplies" db=10.8ms decode=0.9ms queue=1.1ms idle=1647.0ms
SELECT s0."id", s0."description", s0."expiration_date", s0."responsible", s0."restaurant_id", s0."inserted_at", s0."updated_at" FROM "supplies" AS s0 []
[
  %Inmana.Supply{
    __meta__: #Ecto.Schema.Metadata<:loaded, "supplies">,
    description: "Molho de tomate",
    expiration_date: ~D[2021-04-16],
    id: "ef70baa7-1ab7-49df-a10c-6de00b21568d",
    inserted_at: ~N[2021-04-21 18:01:31],
    responsible: "Banana man",
    restaurant: #Ecto.Association.NotLoaded<association :restaurant is not loaded>,
    restaurant_id: "bd1ec1b9-f8a1-4692-8811-f9035d4e8112",
    updated_at: ~N[2021-04-21 18:01:31]
  },
...
```
Looking at supply with id: "ef70baa7-1ab7-49df-a10c-6de00b21568d"
```bash
iex> Inmana.Repo.get(Inmana.Supply, "ef70baa7-1ab7-49df-a10c-6de00b21568d")
[debug] QUERY OK source="supplies" db=1.4ms queue=1.4ms idle=1750.3ms
SELECT s0."id", s0."description", s0."expiration_date", s0."responsible", s0."restaurant_id", s0."inserted_at", s0."updated_at" FROM "supplies" AS s0 WHERE (s0."id" = $1) [<<239, 112, 186, 167, 26, 183, 73, 223, 161, 12, 109, 224, 11, 33, 86, 141>>]
%Inmana.Supply{
  __meta__: #Ecto.Schema.Metadata<:loaded, "supplies">,
  description: "Molho de tomate",
  expiration_date: ~D[2021-04-16],
  id: "ef70baa7-1ab7-49df-a10c-6de00b21568d",
  inserted_at: ~N[2021-04-21 18:01:31],
  responsible: "Banana man",
  restaurant: #Ecto.Association.NotLoaded<association :restaurant is not loaded>,
  restaurant_id: "bd1ec1b9-f8a1-4692-8811-f9035d4e8112",
  updated_at: ~N[2021-04-21 18:01:31]
}
```
Searching for the supply with the id that does not exist
is returned _nil_
```bash
iex> Inmana.Repo.get(Inmana.Supply, "ef70baa7-1ab7-49df-a10c-6de00b77777d")
[debug] QUERY OK source="supplies" db=2.1ms queue=0.1ms idle=964.3ms
SELECT s0."id", s0."description", s0."expiration_date", s0."responsible", s0."restaurant_id", s0."inserted_at", s0."updated_at" FROM "supplies" AS s0 WHERE (s0."id" = $1) [<<239, 112, 186, 167, 26, 183, 73, 223, 161, 12, 109, 224, 11, 119, 119, 125>>]
nil
```
```elixir
# lib/inmana/supplies/get.ex

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
```

### Supplies get by expiration
```elixir
defmodule Inmana.Supplies.GetByExpiration do
  import Ecto.Query

  alias Inmana.{Repo, Restaurant, Supply}

  def call do
    today = Date.utc_today()
    beginning_of_week = Date.beginning_of_week(today)
    end_of_week = Date.end_of_week(today)

    query =
      from supply in Supply,
        where:
          supply.expiration_date >= ^beginning_of_week and
            supply.expiration_date <= ^end_of_week,
        preload: [:restaurant]

    query
    |> Repo.all()
    |> Enum.group_by(fn %Supply{restaurant: %Restaurant{email: email}} -> email end)
  end
end
```

### Supplies facade
```elixir
# lib/inmana.ex

defmodule Inmana do
  alias Inmana.Restaurants.Create, as: RestaurantCreate
  alias Inmana.Supplies.Create, as: SupplyCreate
  alias Inmana.Supplies.Get, as: SupplyGet

  defdelegate create_restaurant(params),
    to: RestaurantCreate,
    as: :call

  defdelegate create_supply(params),
    to: SupplyCreate,
    as: :call

  defdelegate get_supply(params),
    to: SupplyGet,
    as: :call
end
```

### Supplies controller
```elixir
# lib/inmana_web/controllers/supplies_controller.ex

defmodule InmanaWeb.SuppliesController do
  use InmanaWeb, :controller

  alias Inmana.Supply
  alias InmanaWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Supply{} = supply} <- Inmana.create_supply(params) do
      conn
      |> put_status(:created)
      |> render("create.json", supply: supply)
    end
  end

  def show(conn, %{"id" => uuid}) do
    with {:ok, %Supply{} = supply} <- Inmana.get_supply(uuid) do
      conn
      |> put_status(:ok)
      |> render("show.json", supply: supply)
    end
  end
end
```

### Supplies route
```elixir
# lib/inmana_web/router.ex

scope "/api", InmanaWeb do
  pipe_through :api

  get "/", WelcomeController, :index

  post "/restaurants", RestaurantsController, :create

  # add this line:
  resources "/supplies", SuppliesController, only: [:create, :show]
end
```
Looking at all the routes
```bash
$ mix phx.routes
       welcome_path  GET   /api                    InmanaWeb.WelcomeController :index
   restaurants_path  POST  /api/restaurants        InmanaWeb.RestaurantsController :create
      supplies_path  GET   /api/supplies/:id       InmanaWeb.SuppliesController :show
      supplies_path  POST  /api/supplies           InmanaWeb.SuppliesController :create
live_dashboard_path  GET   /dashboard              Phoenix.LiveView.Plug :home
live_dashboard_path  GET   /dashboard/:page        Phoenix.LiveView.Plug :page
live_dashboard_path  GET   /dashboard/:node/:page  Phoenix.LiveView.Plug :page
          websocket  WS    /live/websocket         Phoenix.LiveView.Socket
           longpoll  GET   /live/longpoll          Phoenix.LiveView.Socket
           longpoll  POST  /live/longpoll          Phoenix.LiveView.Socket
          websocket  WS    /socket/websocket       InmanaWeb.UserSocket
```

### Supplies view
```elixir
# lib/inmana_web/views/supplies_view.ex

defmodule InmanaWeb.SuppliesView do
  use InmanaWeb, :view

  def render("create.json", %{supply: supply}) do
    %{
      message: "Supply created!",
      supply: supply
    }
  end
end
```

### Supplies error view
```elixir
# lib/inmana_web/views/error_view.ex

def render("error.json", %{result: %Ecto.Changeset{} = changeset}) do
  %{message: translate_errors(changeset)}
end

# add this line
def render("error.json", %{result: result}) do
  %{message: result}
end
```

### Install bamboo
https://github.com/thoughtbot/bamboo
```elixir
# mix.exs

def deps do
  [{:bamboo, "~> 2.1.0"}]
end
```
```elixir
# config/config.exs

config :inmana, Inmana.Mailer, adapter: Bamboo.LocalAdapter
```
```elixir
# config/test.exs

config :inmana, Inmana.Mailer, adapter: Bamboo.TestAdapter
```

### Mailer
```elixir
# lib/inmana/mailer.ex

defmodule Inmana.Mailer do
  use Bamboo.Mailer, otp_app: :inmana
end
```

### Expiration notification
```elixir
# lib/inmana/supplies/expiration_notification.ex

defmodule Inmana.Supplies.ExpirationNotification do
  alias Inmana.Mailer
  alias Inmana.Supplies.{ExpirationEmail, GetByExpiration}

  def send do
    data = GetByExpiration.call()

    Enum.each(data, fn {to_email, supplies} ->
      to_email
      |> ExpirationEmail.create(supplies)
      |> Mailer.deliver_later!()
    end)
  end
end
```

### Expiration email
```elixir
# lib/inmana/supplies/expiration_email.ex

defmodule Inmana.Supplies.ExpirationEmail do
  import Bamboo.Email

  alias Inmana.Supply]

  def create(to_email, supplies) do
    new_email(
      to: to_email,
      from: "app@inmana.com.br",
      subject: "Supplies that are about to expire",
      text_body: email_text(supplies)
    )
  end

  defp email_text(supplies) do
    initial_text = "-------- Supplies that are about to expire: --------\n"

    Enum.reduce(supplies, initial_text, fn supply, text -> text <> supply_string(supply) end)
  end

  defp supply_string(%Supply{
         description: description,
         expiration_date: expiration_date,
         responsible: responsible
       }) do
    "Description: #{description},
    Expiration Date: #{expiration_date}
    Responsible: #{responsible} \n"
  end
end
```

### Sending email
```elixir
# lib/inmana_web/router.ex

# put at the end of the file
if Mix.env() == :dev do
  forward "/sent_emails", Bamboo.SentEmailViewerPlug
end
```
```bash
$ iex -S mix phx.server
```
```bash
iex> Inmana.Supplies.ExpirationNotification.send()
```
visit: http://localhost:4000/sent_emails





<div align="center">

  # VIDEO 4: Tasks Genservers Supervisors

</div>


### Tasks
```elixir
# lib/inmana/supplies/expiration_notification

defmodule Inmana.Supplies.ExpirationNotification do
  alias Inmana.Mailer
  alias Inmana.Supplies.{ExpirationEmail, GetByExpiration}

  def send do
    data = GetByExpiration.call()

    # Enum.each(data, fn {to_email, supplies} ->
    #   to_email
    #   |> ExpirationEmail.create(supplies)
    #   |> Mailer.deliver_later!()
    # end)

    data
    |> Task.async_stream(fn {to_email, supplies} -> send_email(to_email, supplies) end)
    |> Stream.run()
  end

  defp send_email(to_email, supplies) do
    to_email
    |> ExpirationEmail.create(supplies)
    |> Mailer.deliver_later!()
  end
end
```

### Genservers
```elixir
# lib/inmana/supplies/scheduler.ex

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
```

### Supervisor
```elixir
# lib/inmana/application.ex

def start(_type, _args) do
  children = [
    Inmana.Repo,
    InmanaWeb.Telemetry,
    {Phoenix.PubSub, name: Inmana.PubSub},
    InmanaWeb.Endpoint,

    # add this line:
    Inmana.Supplies.Scheduler
  ]

  opts = [strategy: :one_for_one, name: Inmana.Supervisor]
  Supervisor.start_link(children, opts)
end
```


<br />

<div align="center">
Made with ♥ by Maiqui Tomé 😀
<br />

*Reach out to me* 👇

[![Codepen](https://img.shields.io/badge/Codepen-000000?style=flat-square&logo=codepen&logoColor=white "Codepen")](https://codepen.io/maiquitome)
[![Youtube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white "Youtube")](https://www.youtube.com/channel/UCoXn0XyxLsKpIE5px0UNuEw)
[![Medium](https://img.shields.io/badge/Medium-black?&style=flat-square&logo=medium&logoColor=white "Medium")](https://medium.com/@maiquitome)
[![Linkedin](https://img.shields.io/badge/LinkedIn-0A66C2.svg?&style=flat-square&logo=linkedin&logoColor=white "Linkedin")](https://www.linkedin.com/in/maiquitome)
[![Instagram](https://img.shields.io/badge/Instagram-D8226B.svg?&style=flat-square&logo=instagram&logoColor=white "Instagram")](https://www.instagram.com/maiquitome)
[![Facebook](https://img.shields.io/badge/Facebook-0674E7.svg?&style=flat-square&logo=facebook&logoColor=white "Facebook")](https://www.facebook.com/maiquitome)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?&style=flat-square&logo=twitter&logoColor=white "Twitter")](https://twitter.com/MaiquiTome)
</div>
