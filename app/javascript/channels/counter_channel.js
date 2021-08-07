import consumer from "./consumer";

const CounterChannel = consumer.subscriptions.create(
  { channel: "ClickCounter" },
  {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received: function (data) {
      // to be overwritten, called when there's incoming data on the websocket for this channel
    },
  }
);

export default CounterChannel;
