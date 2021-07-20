export default async () =>
  fetch("/startWorkers", { cache: "no-store" }).then((res) => res.json());
