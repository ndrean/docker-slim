import consumer from "./consumer";

const CounterChannel = consumer.subscriptions.create(
  { channel: "CounterChannel" },
  {
    connected() {},
    disconnected() {},
    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },
  }
);
export default CounterChannel;
