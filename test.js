function f1(opt = {}) {
  for (const key in opt) {
    // console.log(key, opt[key], typeof opt[key]);
    typeof opt[key] === "function"
      ? console.log(opt[key]())
      : console.log(opt[key]);
  }
}

const obj = {
  a: 10,
  b: 20,
  add: function () {
    return obj.a + obj.b;
  },
};

f1({ a: 1, b: 2 });
console.log("-----------");
f1(obj);
console.log("-----------");
obj.a = 50;
obj.c = 100;
console.log(obj);
f1(obj);
