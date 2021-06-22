FROM elixir

WORKDIR /lib

COPY . .

RUN mix local.hex --force
RUN mix deps.get