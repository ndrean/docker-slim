export default async (path) => {
  return fetch(path, {
    cache: "no-cache",
  }).then((res) => res.json());
};
