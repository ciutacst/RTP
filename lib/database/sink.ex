defmodule Sink do
  use GenServer

  def start_link(message) do
    GenServer.start(__MODULE__, message, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    in_q = []
    {:ok, in_q}
  end

  @impl true
  def handle_cast({:message, message}, _smth) do
    MyIO.my_inspect("ADDING ACTUAL TWEET")
  #  Backpressure.insert(message)

   {:noreply, %{}}
  end

  @impl true
  def handle_cast({:user, user}, _smth) do
    MyIO.my_inspect("ADDING USERS")
    Backpressure.insert_users(user)
    {:noreply, %{}}
  end

  @impl true
  def handle_cast({:tweet_ratio, tweet_ratio}, _smth) do
    MyIO.my_inspect("ADDING ENGAGEMENT RATIO + ACTUAL TWEET")
    Backpressure.insert(tweet_ratio)
    {:noreply, %{}}
  end

  @impl true
  def handle_cast({:sentiment_score, sentiment_score}, _smth) do
    MyIO.my_inspect("ADDING SENTIMENT SCORE")
    Backpressure.insert(sentiment_score)
    {:noreply, %{}}
  end

end
