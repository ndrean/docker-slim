import consumer from "./consumer";

const clickChannel = consumer.subscriptions.create(
  { channel: "ClickChannel" },
  {
    connected() {
      console.log("click connected");
    },
    disconnected() {},
    received: function (data) {
      // overwritten in Button.js
    },
    sending(data) {
      this.perform("receiving", data);
    },
  }
);
export default clickChannel;
