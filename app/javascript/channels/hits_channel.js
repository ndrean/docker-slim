import consumer from "./consumer";

const HitsChannel = consumer.subscriptions.create(
  { channel: "HitsChannel" },
  {
    connected() {
      // calling the method "trigger_hits" in "hits_channel.rb" and pass an object
      this.perform("trigger_hits");
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default HitsChannel;
