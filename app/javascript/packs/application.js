import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import "stylesheets/application";
import React from "react";
import ReactDOM from "react-dom";
import "../channels";

Rails.start();
Turbolinks.start();

const images = require.context("../images", true);
const imagePath = (name) => images(name, true);

import Button from "./components/Button.js";

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(<Button />, document.getElementById("root"));
});
