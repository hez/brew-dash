defmodule GrainFather do
  use Tesla

  require Logger

  @type grainfather_api_token :: String.t()
  @type grainfather_api_response :: {:ok, list(map()), boolean()} | {:error, String.t()}

  @recipes_path "/my-recipes/data"
  @brew_sessions_path "/my-brews/data"
  @parent_app :brew_dash

  def login, do: login(get_config(:username), get_config(:password))

  @doc """
  iex> {:ok, token} = GrainFather.login("your@email.here", "xxx")
  {:ok, "grainfather_community_tools_session=eyJpd...."}
  """
  @spec login(String.t(), String.t()) :: {:ok | :error, grainfather_api_token()}
  def login(email, pass) do
    session_start = Tesla.get(unauthed_client(), "/login")
    csrf_token = get_csrf_token(session_start)

    cookies = [
      get_xsrf_token(session_start),
      get_grainfather_session(session_start),
      "checked_for_terms_and_conditions=true",
      "user_region_60402=true"
    ]

    Logger.debug("login cookies: #{inspect(cookies)}")

    login_resp =
      cookies
      |> unauthed_client([{"X-CSRF-TOKEN", csrf_token}])
      |> Tesla.post("/login", %{email: email, password: pass, remember: true})

    case login_resp do
      {:ok, _} = resp ->
        {:ok, get_grainfather_session(resp)}

      err ->
        Logger.warning(inspect(err))
        {:error, "failed to fetch login token"}
    end
  end

  @spec fetch_all(grainfather_api_token(), integer(), function() | atom()) :: list()
  def fetch_all(token, pages \\ 100, func_or_atom)
  def fetch_all(token, pages, :recipes), do: fetch_all(token, pages, &GrainFather.recipes/2)

  def fetch_all(token, pages, :brew_sessions),
    do: fetch_all(token, pages, &GrainFather.brew_sessions/2)

  def fetch_all(token, pages, func) do
    Enum.reduce_while(1..pages, [], fn page, acc ->
      {:ok, resp, final_page} = func.(token, page: page)

      if final_page do
        {:cont, acc ++ resp}
      else
        {:halt, acc ++ resp}
      end
    end)
  end

  @doc """
  iex> GrainFather.recipes(token)
  {:ok,
  [
    %{
      "import_xml_source" => nil,
      "batch_size" => 18,
      "status" => "current",
      "og" => 1.1094063818252,
      ...
    },
    ...
  ]
  """
  @spec recipes(grainfather_api_token(), list()) :: grainfather_api_response()
  def recipes(session, params \\ []), do: authed_get(@recipes_path, session, params)

  @doc """
  iex> GrainFather.brew_sessions(token)
  {:ok,
  [
    %{
      "session_name" => "Batch #48",
      "priming_sugar_amount" => nil,
      "original_gravity" => 1.043,
      "volume_per_bottle" => nil,
      ...
    },
    ...
  ]
  """
  @spec brew_sessions(grainfather_api_token(), list()) :: grainfather_api_response()
  def brew_sessions(session, params \\ []), do: authed_get(@brew_sessions_path, session, params)

  @spec authed_get(String.t(), grainfather_api_token(), list()) :: grainfather_api_response()
  def authed_get(path, session, params \\ []) do
    resp = session |> client() |> Tesla.get(path, query: params)

    case resp do
      {:ok, %_{status: 200, body: %{"data" => data, "next_page_url" => next_page}}} ->
        Logger.debug("Successfully fetched #{path}")
        is_next_page = next_page != nil
        {:ok, data, is_next_page}

      {:ok, %_{status: 200, body: body}} ->
        Logger.debug("Successfully fetched #{path}")
        {:ok, body}

      err ->
        Logger.debug(inspect(err))
        Logger.info("Failed to fetch #{path}")
        {:error, "error"}
    end
  end

  @spec unauthed_client() :: Tesla.Client.t()
  def unauthed_client do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://community.grainfather.com"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  @spec unauthed_client(list(String.t()), list()) :: Tesla.Client.t()
  def unauthed_client(cookies, headers \\ []) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://community.grainfather.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"cookie", Enum.join(cookies, "; ")}] ++ headers}
    ]

    Tesla.client(middleware)
  end

  @spec client(grainfather_api_token()) :: Tesla.Client.t()
  def client(session) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://community.grainfather.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"cookie", session <> ";"}]}
    ]

    Tesla.client(middleware)
  end

  def get_csrf_token({:ok, %_{body: body}}) do
    ~r/"csrfToken":"([^"]*)"/
    |> Regex.run(body)
    |> List.last()
  end

  def get_xsrf_token({:ok, resp}), do: get_cookie_value(resp, "XSRF-TOKEN")

  def get_grainfather_session({:ok, resp}),
    do: get_cookie_value(resp, "grainfather_community_tools_session")

  defp get_cookie_value(resp, name) do
    resp
    |> Tesla.get_headers("set-cookie")
    |> Enum.map(&find_cookie(&1, name))
    |> List.flatten()
    |> Enum.join("=")
  end

  defp find_cookie(cookie, name) do
    cookie
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&String.match?(&1, ~r/=/))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.filter(fn [key, _] -> String.starts_with?(key, name) end)
  end

  def get_config(key), do: @parent_app |> Application.get_env(GrainFather) |> Keyword.get(key)
end
