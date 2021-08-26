// import { csrfToken } from "@rails/ujs";

export default async (path, object) => {
  csrfToken = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");
  return fetch(path, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken, // csrfToken()
    },
    body: JSON.stringify(object),
  }).then((res) => res.json());
};
