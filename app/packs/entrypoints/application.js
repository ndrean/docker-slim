import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
// import "~/entrypoints/application.css";
import React from "react";
import { render } from "react-dom";
import "~/channels";

Rails.start();
Turbolinks.start();

const images = require.context("~/images", true);
const imagePath = (name) => images(name, true);

import Button from "~/components/Button.js";

document.addEventListener("turbolinks:load", () => {
  render(<Button />, document.getElementById("root"));
});
