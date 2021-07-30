import consumer from "./consumer";

const CountersChannel = consumer.subscriptions.create(
  { channel: "CountersChannel" },
  {
    connected() {
      console.log("Client connected");
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      // overwritten in Button.jsx
    },
  }
);
export default CountersChannel;
