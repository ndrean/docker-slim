function test(opt = {}) {
  for (const key in opt) {
    console.log(key, opt[key]);
  }
}

test({ a: 1, b: 2 });
