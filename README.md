# BrewDash

Brew and tap list dashboard.

## Missing/TODO

- DB schemas
- Taplist
  - Currently on tap
  - On deck
- Brew timers and recipes
- GrainFather integration

## Development setup

Install development tools

  - `asdf install`

Setup the project

  * Install dependencies `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`

## Running in production

The easiest way is to pull down the docker image from Docker Hub
`docker pull hezr/brew_dash` and then run it, there is an included
[docker-compose.yml](./docker-compose.yml) file in the project which
will run the image.

### Building the production image

The production image can be built out of the included [Dockerfile](./Dockerfile)
with the `MIX_ENV=prod docker build .` command.
