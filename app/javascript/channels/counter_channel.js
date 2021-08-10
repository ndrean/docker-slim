import consumer from "./consumer";

const counterChannel = consumer.subscriptions.create(
  { channel: "CounterChannel" },
  {
    connected() {
      // Called when the subscription is ready for use on the server
    },
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
    received: function (data) {
      // overwritten, in Button called when there's incoming data on the websocket for this channel
    },
    sending(data) {
      this.perform("receiving", { countPG: data });
    },
  }
);

export default counterChannel;
