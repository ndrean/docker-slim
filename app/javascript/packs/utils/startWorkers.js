export default async () =>
  fetch("/startWorkers", { cache: "no-cache" }).then((res) => res.json());
