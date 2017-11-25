defmodule DaocloudTelegram.Router do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  post "/" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    parsed_body = Poison.Parser.parse!(body)
    IO.inspect(body)
    IO.inspect(parsed_body)
    {body, result } = parsed_body
                      |> print_repo
                      |> print_name
                      |> print_duration
                      |> print_tag
                      |> print_stages
                      |> notify_telegram
    send_resp(conn, 200, result)
  end

  def print_repo(body) do
    {body,  "仓库: #{body["repo"]}\n"}
  end

  def print_name({body, result}) do
    {body, result <> "项目: " <> body["name"] <> "\n"}
  end

  def print_stages({body, result}) do
    result = "#{result}阶段:\n"
    pending = Enum.all?(body["build"]["stages"], fn (item) -> item["status"] == "pending" end)
    enqueue = Enum.any?(body["build"]["stages"], fn (item) -> item["status"] == "Enqueue" end)
    if pending || enqueue do
      return {body, ""}
    end
    stages = Enum.reduce(body["build"]["stages"], "", fn (item, result) -> result <> "\t" <> item["name"] <> " -> " <> item["status"] <> "\n" end)
    result = "#{result}#{stages}"
    {body, result}
  end

  def print_duration({body, result}) do
    {body, result <> "时长: #{body["build"]["duration_seconds"]}秒\n"}
  end

  def print_tag({body, result}) do
    {body, result <> "标签: #{body["build"]["tag"]}"}
  end

  def notify_telegram({body, result}) do
    if result != "" do
      HTTPoison.start
      HTTPoison.post("http://telegram-api.watsy0007.com/bot#{System.get_env("BOT_KEY")}/sendMessage",
        {:form, [chat_id: System.get_env("CHAT_ID"), text: result]},
        %{"Content-type" => "application/x-www-form-urlencoded"})
    end
    {body, result}
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end