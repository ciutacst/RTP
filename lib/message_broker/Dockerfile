FROM elixir

WORKDIR /message_broker

COPY . .

RUN mix local.hex --force
RUN mix deps.get
