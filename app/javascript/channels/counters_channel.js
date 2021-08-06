import consumer from "./consumer";

const CountersChannel = consumer.subscriptions.create(
  { channel: "CountersChannel" },
  {
    connected() {
      console.log("Client connected");
      // Called when the subscription is ready for use on the server
    },
    disconnected() {},
    received(data) {
      // overwritten in Button.jsx
    },
  }
);
export default CountersChannel;
