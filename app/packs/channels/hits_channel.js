import consumer from "./consumer";

const hitsChannel = consumer.subscriptions.create(
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

export default hitsChannel;
