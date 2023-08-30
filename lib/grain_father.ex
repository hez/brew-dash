defmodule GrainFather do
  require Logger

  alias GrainFather.Session

  @login_path "/login"
  @recipes_path "/my-recipes/data"
  @brew_sessions_path "/my-brews/data"
  @parent_app :brew_dash

  def new_req, do: Req.new(base_url: "https://community.grainfather.com")

  def new_api_req(%{cookies: cookies}) do
    new_req()
    |> Req.Request.put_header("Cookie", cookies <> ";")
    |> Req.Request.put_header("Content-Type", "application/json")
  end

  @spec new_session() :: {:ok, Session.t()} | {:error, String.t()}
  def new_session, do: new_session(get_config(:username), get_config(:password))
  @spec new_session(String.t(), String.t()) :: {:ok, Session.t()} | {:error, String.t()}
  def new_session(email, pass), do: Session.new(email, pass)

  @spec fetch_brew_sessions(Session.t(), list()) ::
          {:ok, list(), boolean()} | {:error, :failed_fetch_brew_sessions}
  def fetch_brew_sessions(session, params \\ []) do
    session
    |> new_api_req()
    |> Req.get(url: brew_sessions_path(), follow_redirects: false, params: params)
    |> case do
      {:ok, %_{status: 200, body: %{"data" => data, "next_page_url" => next_page}}} ->
        is_next_page = next_page != nil
        Logger.debug("Successfully fetched brew sessions is_next_page #{inspect(is_next_page)}")
        {:ok, data, is_next_page}

      {:ok, %_{status: 200, body: body}} ->
        Logger.debug(
          "Successfully fetched brew sessions, but unable to match next_page_url attribute"
        )

        {:ok, body}

      err ->
        Logger.debug(inspect(err))
        {:error, :failed_fetch_brew_sessions}
    end
  end

  @spec fetch_recipes(Session.t(), list()) ::
          {:ok, list(), boolean()} | {:error, :failed_fetch_recipes}
  def fetch_recipes(session, params \\ []) do
    session
    |> new_api_req()
    |> Req.get(url: recipes_path(), follow_redirects: false, params: params)
    |> case do
      {:ok,
       %_{status: 200, body: %{"recipes" => %{"data" => data, "next_page_url" => next_page}}}} ->
        is_next_page = next_page != nil
        Logger.debug("Successfully fetched recipes is_next_page #{inspect(is_next_page)}")
        {:ok, data, is_next_page}

      {:ok, %_{status: 200, body: %{"data" => data, "next_page_url" => next_page}}} ->
        is_next_page = next_page != nil
        Logger.debug("Successfully fetched recipes is_next_page #{inspect(is_next_page)}")
        {:ok, data, is_next_page}

      {:ok, %_{status: 200, body: body}} ->
        Logger.debug("Successfully fetched recipes, but unable to match next_page_url attribute")

        {:ok, body}

      err ->
        Logger.debug(inspect(err))
        {:error, :failed_fetch_recipes}
    end
  end

  def fetch_all_recipes(session, pages \\ 100),
    do: Enum.reduce_while(1..pages, [], &fetch_recipe_page(session, &1, &2))

  defp fetch_recipe_page(session, page, acc) do
    case fetch_recipes(session, page: page) do
      {:ok, resp, true} ->
        {:cont, acc ++ resp}

      {:ok, resp, false} ->
        {:halt, acc ++ resp}

      err ->
        Logger.warning("Encoutered an error or unhandled clause: #{inspect(err)}")
        {:halt, acc}
    end
  end

  def fetch_all_brew_sessions(session, pages \\ 100),
    do: Enum.reduce_while(1..pages, [], &fetch_brew_session_page(session, &1, &2))

  defp fetch_brew_session_page(session, page, acc) do
    case fetch_brew_sessions(session, page: page) do
      {:ok, resp, true} ->
        {:cont, acc ++ resp}

      {:ok, resp, false} ->
        {:halt, acc ++ resp}

      err ->
        Logger.warning("Encoutered an error or unhandled clause: #{inspect(err)}")
        {:halt, acc}
    end
  end

  def login_path, do: @login_path
  def brew_sessions_path, do: @brew_sessions_path
  def recipes_path, do: @recipes_path
  def get_config(key), do: @parent_app |> Application.get_env(GrainFather) |> Keyword.get(key)
end
