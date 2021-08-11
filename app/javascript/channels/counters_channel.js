import consumer from "./consumer";

const counterChannel = consumer.subscriptions.create(
  { channel: "CountersChannel" },
  {
    connected() {
      console.log("Client connected");
      // Called when the subscription is ready for use on the server
    },
    disconnected() {},
    received(data) {
      // overwritten in Button.jsx
    },
    sending(data) {
      this.perform("receiving", { countPG: data });
    },
  }
);
export default counterChannel;
