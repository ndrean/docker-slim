export default async (path) => {
  return fetch(path, {cache: "no-store"})
    .then((res) => res.json())
    .catch((err) => console.log(err));
};
