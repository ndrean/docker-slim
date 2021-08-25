import consumer from "./consumer";

const listChannel = consumer.subscriptions.create(
  { channel: "ListChannel" },
  {
    connected() {
      console.log("list connected");
      this.perform("get_pods");
    },

    disconnected() {},

    received(data) {
      // overwritten in Button.js
    },
  }
);

export default listChannel;
