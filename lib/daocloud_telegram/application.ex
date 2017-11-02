defmodule DaocloudTelegram.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, DaocloudTelegram.Router, [], port: 4001)
    ]

    Logger.info "started application"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end