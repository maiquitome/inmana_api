defmodule InmanaWeb.ErrorView do
  use InmanaWeb, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{result: %Ecto.Changeset{} = changeset}) do
    %{message: translate_errors(changeset)}
  end

  def render("error.json", %{result: result}) do
    %{message: result}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
