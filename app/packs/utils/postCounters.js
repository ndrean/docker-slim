import { csrfToken } from "@rails/ujs";

export default async (path, object) => {
  return fetch(path, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken(),
    },
    body: JSON.stringify(object),
  }).then((res) => res.json());
};
