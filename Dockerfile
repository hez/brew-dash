ARG MIX_ENV="prod"

#FROM hexpm/elixir:1.12.2-erlang-24.0.5-alpine-3.12.1 as build
FROM elixir:1.12.2-alpine as build

# install build dependencies
RUN apk add --no-cache build-base git python3 curl

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Dependencies sometimes use compile-time configuration. Copying
# these compile-time config files before we compile dependencies
# ensures that any relevant config changes will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

# build assets
COPY priv priv
COPY assets assets
RUN mix assets.deploy


# build project
# Move to before asset.deploy if we start using a pruner
COPY lib lib
RUN mix compile

# changes to config/runtime.exs don't require recompiling the code
# Uncomment if we want any runtime config
# COPY config/runtime.exs config/
COPY config/releases.exs config/

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release

# Start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.14 AS app

RUN apk add --no-cache bash openssl ncurses-libs
RUN apk add --no-cache libstdc++

ARG MIX_ENV
ENV USER="elixir"

WORKDIR "/home/${USER}/app"
# Creates an unprivileged user to be used exclusively to run the Phoenix app
RUN \
  addgroup \
   -g 1000 \
   -S "${USER}" \
  && adduser \
   -s /bin/sh \
   -u 1000 \
   -G "${USER}" \
   -h /home/elixir \
   -D "${USER}" \
  && su "${USER}"

RUN chown -R "${USER}:${USER}" "/home/${USER}/app"

# Everything from this line onwards will run in the context of the unprivileged user.
USER "${USER}"

COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/brew_dash ./

ENTRYPOINT ["bin/brew_dash"]

# Usage:
#  * build: sudo docker image build -t elixir/my_app .
#  * shell: sudo docker container run --rm -it --entrypoint "" -p 127.0.0.1:4000:4000 elixir/my_app sh
#  * run:   sudo docker container run --rm -it -p 127.0.0.1:4000:4000 --name my_app elixir/my_app
#  * exec:  sudo docker container exec -it my_app sh
#  * logs:  sudo docker container logs --follow --tail 100 my_app
CMD ["start"]
