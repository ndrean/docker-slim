import { csrfToken } from "@rails/ujs";

export default async (path, object) => {
  try {
    const query = await fetch(path, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken(),
      },
      body: JSON.stringify(object),
    });
    if (query) {
      return query.json();
    }
  } catch {
    (err) => console.log(err);
  }
};
