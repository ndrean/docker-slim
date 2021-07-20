import { csrfToken } from "@rails/ujs";
import { cache } from "webpack";

export default async (path, object) => {
  return fetch(path, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken(),
      "Cache-Control": "no-cache",
    },
    body: JSON.stringify(object),
  }).then((res) => res.json());
};
