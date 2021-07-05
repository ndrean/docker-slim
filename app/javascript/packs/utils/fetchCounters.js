export default async (path) => {
  return fetch(path)
    .then((res) => res.json())
    .catch((err) => console.log(err));
};
