defmodule GrainFather.Session do
  require Logger

  @type t() :: %__MODULE__{email: String.t(), cookies: String.t()}
  @enforce_keys [:email, :cookies]

  defstruct @enforce_keys

  @spec new(String.t(), String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(email, pass) do
    req = GrainFather.new_req()
    login_page_resp = Req.get(req, url: GrainFather.login_path())
    csrf_token = get_csrf_token(login_page_resp)

    cookies = [
      get_xsrf_token(login_page_resp),
      get_grainfather_session(login_page_resp),
      "checked_for_terms_and_conditions=true",
      "user_region_60402=true"
    ]

    Logger.debug("login cookies: #{inspect(cookies)}")

    login_resp =
      req
      |> Req.Request.put_header("Cookie", Enum.join(cookies, "; "))
      |> Req.Request.put_header("X-CSRF-TOKEN", csrf_token)
      |> Req.post(
        url: "/login",
        redirect: false,
        form: [email: email, password: pass, remember: true]
      )

    case login_resp do
      {:ok, _} = resp ->
        session_cookie = get_grainfather_session(resp)
        Logger.debug("Got logged in session cookie #{inspect(session_cookie)}")
        {:ok, %__MODULE__{email: email, cookies: session_cookie}}

      err ->
        Logger.warning(inspect(err))
        {:error, "failed to fetch login token"}
    end
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
    |> Req.Response.get_header("set-cookie")
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
end
