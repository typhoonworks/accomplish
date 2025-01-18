defmodule AccomplishWeb.ErrorMapper do
  @moduledoc """
  Maps validation errors from OpenAPI and Ecto to a unified structure with consistent messages.
  """

  def translate_ecto_message_to_openapi("can't be blank", field), do: "Missing field: #{field}"
  def translate_ecto_message_to_openapi("is invalid", _field), do: "Invalid value"

  def translate_ecto_message_to_openapi("is too short", _field),
    do: "String length is smaller than minLength"

  def translate_ecto_message_to_openapi("is too long", _field),
    do: "String length is larger than maxLength"

  def translate_ecto_message_to_openapi("is not included in the list", _field),
    do: "Invalid enum value"

  def translate_ecto_message_to_openapi("has already been taken", _field), do: "Duplicate value"

  def translate_ecto_message_to_openapi("must be greater than " <> value, _field),
    do: "Value must be greater than #{value}"

  def translate_ecto_message_to_openapi("must be less than " <> value, _field),
    do: "Value must be less than #{value}"

  def translate_ecto_message_to_openapi(msg, _field), do: msg
end
