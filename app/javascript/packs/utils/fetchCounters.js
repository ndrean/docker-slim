export default async (path) => {
  return fetch(path).then((res) => res.json());
};
