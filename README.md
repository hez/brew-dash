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

#### Getting access with Livebook

Get the cookie

```
$ fly ssh console
Connecting to icy-leaf-7381.internal... complete

/ #  cat app/releases/COOKIE
YOUR-COOKIE-VALUE
```

start livebook with: `ERL_AFLAGS="-proto_dist inet6_tcp" livebook server --name livebook@127.0.0.1`

### Self hosting

The easiest way is to pull down the docker image from Docker Hub
`docker pull hezr/brew_dash` and then run it, there is an included
[docker-compose.yml](./docker-compose.yml) file in the project which
will run the image.

Note: The docker compose config reads in environment variables for
settings such as the secrets key, set these and run `docker-compose up app`
and you should be good to go.

Updating to the latest is as easy as

  - `docker-compose pull`
  - `docker-compose up -d`

#### Migrating with docker and releases

Migrations can be run with the `BrewDash.Release` module, call it via docker
compose `docker-compose run --rm app eval "BrewDash.Release.migrate"`.

#### Building the production image

Build assets for production, currently the Dockerfile does not
execute `mix assets.deploy` as `tailwindcss` binaries are not available
for all target platforms.

  - `mix assets.deploy`

Build the docker image.

  - `docker build .`

## Production Setup

This all assumes you are running BrewDash in docker on a Raspberry Pi or
something similar and have it permanently connected to a TV.

- Install Docker
- Use the example docker-compose.yml file and get BrewDash running
  - There are a few enviroment variables or fields in there that will need setting.
- Copy `bin/kiosk.sh` to `~/bin/` and change your config to match the hostname and port.
- Copy the `chromium_autostart.desktop` to your `.config/autostart` directory and change the path to kiosk.sh to match.
