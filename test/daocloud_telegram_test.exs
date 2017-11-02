defmodule DaocloudTelegramTest do
  use ExUnit.Case
  doctest DaocloudTelegram

  test "greets the world" do
    assert DaocloudTelegram.hello() == :world
  end
end
