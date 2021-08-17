import consumer from "./consumer";

const hitChannel = consumer.subscriptions.create(
  { channel: "HitChannel" },
  {
    connected() {
      // calling "hits_channel::trigger_hits" in .rb
      this.perform("trigger_hits");
      // calling hits_channel::receive in .rb
      this.send({ msg: "new client connected" });
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default hitChannel;
