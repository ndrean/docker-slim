import consumer from "./consumer";

const HitsChannel = consumer.subscriptions.create(
  { channel: "HitsChannel" },
  {
    connected() {
      this.perform("trigger_hits");
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default HitsChannel;
