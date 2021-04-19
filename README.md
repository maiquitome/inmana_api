<div align="center">
  <img alt="refrigerator" height="150" src=".github/frigorifico.svg">
  <h1><strong>INMANA API</strong><br>Inventory Management</h1>

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

- [Creating the project](#Creating-the-project)
  - [Project creation](#Project-creation)
  - [Database creation](#Database-creation)
  - [Install Credo](#Install-credo)
- [Creating welcomer](#Creating-welcomer)
  - [About welcomer](#About-welcomer)
  - [Creating the welcomer file](#Creating-the-welcomer-file)
- [Creating a welcome route](#Creating-a-welcome-route)
  - [Creating a GET](#Creating-a-GET)
  - [Creating the controller](#Creating-the-controller)
  - [Welcomer final result](#Welcomer-final-result)


<div align="center">

  ## Creating the project

</div>

### Project creation
```bash
$ mix phx.new inmana --no-html --no-webpack
```
### Database creation
```bash
$ cd inmana
```
```bash
$ mix ecto.create
```
### Install Credo
- https://github.com/rrrene/credo
- in _mix.exs_ add:
  ```elixir
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
  ```
- and run:
  ```
  $ mix deps.get

  $ mix credo.gen.config

  $ mix credob
  ```
<div align="center">

  ## Creating welcomer

</div>

### About welcomer
* Receive a name and age from the user
* We have to treat the username for wrong entries, like "BaNaNa", "banana \n"
* If the user calls "Banana" and is 42 years old, he receives a special message
* If the user is of age, he receives a normal message
* If the user is a minor, we return an error

### Creating the welcomer file
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

<div align="center">

  ## Creating a welcome route

</div>

### Creating a GET
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
