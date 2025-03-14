defmodule Accomplish.JobApplications.Importer do
  @moduledoc """
  Service for importing job posting data into job application.
  """

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Events.JobApplicationImported
  alias Accomplish.URLValidators

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  @workplace_types ~w(remote hybrid on_site)a
  @employment_types ~w(full_time part_time contractor employer_of_record internship)a

  def import_job_details(user, job_details) do
    source = get_in(job_details, ["source_url"])
    company_name = get_in(job_details, ["company", "name"]) || "Unknown Company"
    company_website_url = get_in(job_details, ["company", "website_url"])

    application_params =
      %{
        role: job_details["role"] || "Unknown Role",
        company: %{name: company_name, website_url: company_website_url},
        status: :draft,
        source: source,
        apply_url: job_details["apply_url"],
        job_description: job_details["job_description"],
        employment_type: job_details["employment_type"],
        workplace_type: job_details["workplace_type"],
        compensation_details: job_details["compensation_details"]
      }
      |> normalize_fields()

    case JobApplications.create_application(user, application_params) do
      {:ok, application} ->
        broadcast_application_imported(application)
        {:ok, application}

      {:error, changeset} ->
        {:error, {:import_failed, changeset}}
    end
  end

  defp normalize_fields(params) when is_map(params) do
    Map.new(params, &normalize_field/1)
  end

  defp normalize_field({:apply_url, value}), do: {:apply_url, normalize_url(value)}

  defp normalize_field({:workplace_type, value}),
    do: {:workplace_type, normalize_enum(value, @workplace_types)}

  defp normalize_field({:employment_type, value}),
    do: {:employment_type, normalize_enum(value, @employment_types)}

  defp normalize_field({:company, value}), do: {:company, normalize_fields(value)}
  defp normalize_field(other), do: other

  defp normalize_url(value) when not is_nil(value) do
    case URLValidators.validate_url_string(value) do
      :ok -> value
      {:error, _} -> nil
    end
  end

  defp normalize_url(nil), do: nil

  defp normalize_enum(value, allowed_values) when is_atom(value) do
    if value in allowed_values, do: value, else: nil
  end

  defp normalize_enum(value, allowed_values) when is_binary(value) do
    normalized =
      value
      |> String.downcase()
      |> String.replace(~r/\s+/, "_")

    if normalized in Enum.map(allowed_values, &Atom.to_string/1) do
      String.to_existing_atom(normalized)
    else
      nil
    end
  end

  defp normalize_enum(_, _), do: nil

  defp broadcast_application_imported(application) do
    Phoenix.PubSub.broadcast!(
      @pubsub,
      @notifications_topic <> ":#{application.applicant_id}",
      {JobApplications, %JobApplicationImported{application: application}}
    )
  end
end
