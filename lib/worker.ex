defmodule Worker do
  use GenServer

  def start_link(Message) do
    GenServer.start(__MODULE__, Message, name: __MODULE__)
  end

  @impl true
  def init(Message) do
    {:ok, Message}
  end

  @impl true
  def handle_cast({:worker, Message}, _states) do
    message_operations(Message)
    {:noreply, %{}}
  end

  def message_operations(Message) do
    if Message.data =~ "panic" do
      IO.inspect(%{"Panic message:" => Message})
      Process.exit(self(), :kill)
    else
      data = json_parse(Message)
    end
  end

  def json_parse(Message) do
      message_data = Jason.decode!(Message.data)
      calculate_sentiments(message_data["message"]["tweet"])
  end

  def calculate_sentiments(data) do
    user_words_array = data["text"]
                       |> String.split(" ", trim: true)

    scores_array = Enum.map(user_words_array, fn word -> EmotionValues.get_value(word) end)
    final_score = Enum.sum(scores_array)

    IO.puts(final_score)
  end

   def get_child(pid) do
     GenServer.cast(pid, :get)
   end

end