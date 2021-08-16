import consumer from "./consumer";

const listChannel = consumer.subscriptions.create(
  { channel: "ListChannel" },
  {
    connected() {
      this.perform("get_pods");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // console.log(data);
    },
  }
);

export default listChannel;
