FROM elixir:1.9.1

RUN mix local.hex --force && mix archive.install hex phx_new 1.4.10 --force

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs && rm -rf /var/cache/apk/*

WORKDIR /tailwind

RUN mix local.hex --force && mix local.rebar --force
