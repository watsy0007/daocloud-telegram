FROM elixir:1.5.2-alpine

WORKDIR /app
ADD . /app
RUN mix local.hex --force && mix local.rebar --force && mix deps.get && mix deps.compile

EXPOSE 4001

CMD ["mix", "run", "--no-halt"]