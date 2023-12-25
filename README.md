# BrewDash

Brew and tap list dashboard with Grainfather integration.

<img width="1413" alt="Screen Shot 2022-04-04 at 11 33 32" src="https://user-images.githubusercontent.com/244021/161609092-f93ebee0-e5fa-4e68-ba6c-6f9e52c48cc3.png">

- [Missing/TODO](#missing-todo)
- [Development Setup](#development-setup)
- [Running in Production](#running-in-production)
- [Production Setup](#production-setup)

## Missing/TODO

- Brew timers and recipes
- Complete GrainFather recipe info
- GrainFather BT integration
- BrewFather integration

## Development setup

Requirements
- [ASDF](https://asdf-vm.com/#/) with Elixir and Erlang
- [Direnv](https://direnv.net)

Install development tools

  - `asdf install`

Setup the project

  * Copy the envrc private example file `cp .envrc.private.example .envrc.private`
  * Install dependencies `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`

### Accessing Notebooks

Get [Liveview installed](https://fly.io/blog/livebook-for-app-documentation/)

```
mix escript.install hex livebook
# if you are running asdf run `asdf reshim elixir`
livebook server
```

Then connect to your mix project via the `Runtime settings`.

Navigate to the `./notebooks` directory for a list.

### Accessing Raw DB

`sqlite3 data/brew_dash.sqlite`

## Running in production

### The easy way

Use fly.io, the existing config should be pretty close to all you need.

#### Getting access with IEx

Get the cookie

```
$ fly ssh console
Connecting to icy-leaf-7381.internal... complete

/ #  cat app/releases/COOKIE
YOUR-COOKIE-VALUE
```

use the remote-iex shell script `COOKIE="<cookie from above>" bin/remote-iex-session.sh`

#### Getting access with Livebook

Get the cookie

```
$ fly ssh console
Connecting to icy-leaf-7381.internal... complete

/ #  cat app/releases/COOKIE
YOUR-COOKIE-VALUE
```

start livebook with: `ERL_AFLAGS="-proto_dist inet6_tcp" livebook server --name livebook@127.0.0.1`

## API

BrewDash supports a minimal public API.

Currently supports
  - /api/taps - A list of on tap and on deck beers

Example fetch:

```bash
curl -H 'Content-Type: application/json' localhost:4000/api/taps
```
