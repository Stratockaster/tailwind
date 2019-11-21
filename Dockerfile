FROM elixir:1.9.4-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY .env ./

RUN export $(cat .env | xargs) && mix deps.get
RUN export $(cat .env | xargs) && mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN export $(cat .env | xargs) && mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN export $(cat .env | xargs) && mix compile

# build release
# COPY rel rel
RUN export $(cat .env | xargs) && mix release

# prepare release image
FROM alpine:3.10 AS app
RUN apk add --update bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/tailwind ./
COPY .env ./
# COPY ./entrypoint.sh ./
# RUN chmod +x entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app