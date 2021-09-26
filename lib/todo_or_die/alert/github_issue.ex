defmodule TodoOrDie.Alert.GitHubIssue do
  @behaviour TodoOrDie.Alert

  def message(string, context, options) do
    [owner_repo, issue_number] = String.split(string, "#")

    url = "https://api.github.com/repos/#{owner_repo}/issues/#{issue_number}"
    case context.httpoison_module.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        %{"state" => state} = Jason.decode!(body)

        if state == "closed" do
          {:ok, "issue ##{issue_number} in repo #{owner_repo} has been closed"}
        else
          {:ok, nil}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:ok, "WAS UNABLE TO CHECK THE ISSUE - HTTP STATUS #{status_code}"}

      {:error, %HTTPoison.Error{} = error} ->
        message = HTTPoison.Error.message(error)

        {:ok, "WAS UNABLE TO CHECK THE ISSUE - GOT ERROR: `#{message}`"}
    end
  end
end





