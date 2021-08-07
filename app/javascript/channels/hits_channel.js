import consumer from "./consumer";

const HitsChannel = consumer.subscriptions.create(
  { channel: "HitsChannel" },
  {
    connected() {
      // const currentHits = document.getElementById("hits").innerHTML;
      // // calling the method "hits" in "hits_channel.rb" and pass an object
      this.perform("trigger_hits", {});
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received: function (data) {
      // overwritten in Button.jsx
    },
  }
);

export default HitsChannel;
