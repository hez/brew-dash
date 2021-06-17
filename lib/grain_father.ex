defmodule GrainFather do
  use Tesla

  require Logger

  @recipes_path "/dashboard/my-recipes"
  @brew_sessions_path "/my-brews/data"
  @parent_app :brew_dash

  def login, do: login(get_config(:username), get_config(:password))

  @doc """
  iex> {:ok, token} = GrainFather.login("your@email.here", "xxx")
  {:ok, "grainfather_community_tools_session=eyJpd...."}
  """
  @spec login(String.t(), String.t()) :: {:ok | :error, String.t()}
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
        Logger.warn(inspect(err))
        {:error, "failed to fetch login token"}
    end
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
  def recipes(session), do: authed_get(@recipes_path, session)

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
  @spec brew_sessions(String.t(), list()) :: {:ok, list(map())} | {:error, String.t()}
  def brew_sessions(session, params \\ []), do: authed_get(@brew_sessions_path, session, params)

  @spec authed_get(String.t(), String.t(), list()) :: {:ok, list(map())} | {:error, String.t()}
  def authed_get(path, session, params \\ []) do
    resp = session |> client() |> Tesla.get(path, query: params)

    case resp do
      {:ok, %_{status: 200, body: %{"data" => data}}} ->
        Logger.debug("Successfully fetched #{path}")
        {:ok, data}

      {:ok, %_{status: 200, body: body}} ->
        Logger.debug("Successfully fetched #{path}")
        {:ok, body}

      err ->
        Logger.debug(inspect(err))
        Logger.info("Failed to fetch #{path}")
        {:error, "error"}
    end
  end

  def unauthed_client do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://community.grainfather.com"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  # build dynamic client based on runtime arguments
  def unauthed_client(cookies, headers \\ []) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://community.grainfather.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"cookie", Enum.join(cookies, "; ")}] ++ headers}
    ]

    Tesla.client(middleware)
  end

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
