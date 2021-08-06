import consumer from "./consumer";

const HitsChannel = consumer.subscriptions.create(
  { channel: "HitsChannel" },
  {
    connected() {
      this.perform("hits", {});
      // Called when the subscription is ready for use on the server
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default HitsChannel;
