// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import "stylesheets/application";
import React from "react";
// import { render } from "react-dom";
import { render } from "react-dom";
// import { render } from "preact";
import "channels"; // <-------

Rails.start();
Turbolinks.start();

const images = require.context("../images", true);
const imagePath = (name) => images(name, true);

import Button from "./components/Button";

document.addEventListener("turbolinks:load", () => {
  render(
    <Button />,
    document.getElementById("root")
    // document.body.appendChild(document.createElement("div"))
  );
});
