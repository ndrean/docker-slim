import consumer from "./consumer";

const hitChannel = consumer.subscriptions.create(
  { channel: "HitChannel" },
  {
    connected() {
      // calling the method "trigger_hits" in "hits_channel.rb" and pass an object
      this.perform("trigger_hits");
      this.send({ msg: "new client" });
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default hitChannel;
