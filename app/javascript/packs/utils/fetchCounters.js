export default async (path) => {
  return fetch(path)
    .then((res) => res.json())
    .then(({ countRedis, countPG }) => {
      return {
        countPG,
        countRedis,
      };
    });
};