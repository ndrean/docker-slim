import consumer from "./consumer";

const hitsChannel = consumer.subscriptions.create(
  { channel: "HitsChannel" },
  {
    connected() {
      console.log("hits connected");
      // calling the method "hits" in "hits_channel.rb" and pass an object
      this.perform("trigger_hits");
      this.send({ msg: "new client" });
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default hitsChannel;
