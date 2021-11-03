# BrewDash

Brew and tap list dashboard.

<img width="1439" alt="image" src="https://user-images.githubusercontent.com/244021/140109299-a1e3a295-dd5b-4b40-aebd-56edde035464.png">

## Missing/TODO

- Brew timers and recipes
- Complete GrainFather recipe info
- GrainFather BT integration

## Development setup

Requirements
- [ASDF](https://asdf-vm.com/#/) with Elixir and Erlang
- [Direnv](https://direnv.net)

Install development tools

  - `asdf install`

Setup the project

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

The easiest way is to pull down the docker image from Docker Hub
`docker pull hezr/brew_dash` and then run it, there is an included
[docker-compose.yml](./docker-compose.yml) file in the project which
will run the image.

Note: The docker compose config reads in environment variables for
settings such as the secrets key, set these and run `docker-compose up app`
and you should be good to go.

### Migrating with docker and releases

Migrations can be run with the `BrewDash.Release` module, call it via docker
compose `docker-compose run --rm app bin/brew_dash eval "BrewDash.Release.migrate"`.

### Building the production image

The production image can be built out of the included [Dockerfile](./Dockerfile)
with the `docker build .` command.
