defmodule EngWorker do
  use GenServer

  def start_link(Message) do
    GenServer.start(__MODULE__, Message, name: __MODULE__)
  end

  @impl true
  def init(Message) do
    {:ok, Message}
  end

  @impl true
  def handle_cast({:e_worker, Message}, _states) do
    message_operations(Message)
    {:noreply, %{}}
  end

   def process_data(message) do
    decoded_message = Poison.decode!(message.data)
    ret_status = decoded_message["message"]["tweet"]["retweeted_status"]

    if (ret_status) do
      retweets = (decoded_message["message"]["tweet"]["retweeted_status"]["retweet_count"])
      favorites = (decoded_message["message"]["tweet"]["retweeted_status"]["favorite_count"])
      followers = (decoded_message["message"]["tweet"]["user"]["followers_count"])
      eng_ratio = (retweets + favorites)/followers

      decoded_message = Poison.decode!(message.data)
      user = (decoded_message["message"]["tweet"]["user"]["screen_name"])
      tweet_ratio = %{message: decoded_message, tweet_ratio: eng_ratio}

      GenServer.cast(Sink, {:tweet_ratio, tweet_ratio})
      GenServer.cast(Sink, {:user, user})
    end
  end


end