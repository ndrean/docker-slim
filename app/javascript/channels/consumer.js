// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable";

// createConsumer("ws://localhost:28080");
ActionCable.logger.enabled = true;

export default createConsumer();
