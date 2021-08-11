import consumer from "./consumer";

const counterChannel = consumer.subscriptions.create(
  { channel: "CounterChannel" },
  {
    connected() {
      console.log("click connected");
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.js
    },
    sending(data) {
      this.perform("receiving", { countPG: data });
    },
  }
);
export default counterChannel;
