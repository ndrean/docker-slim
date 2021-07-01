// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from "react";

import fetchCounters from "../utils/fetchCounters.js";
import postCounters from "../utils/postCounters.js";
import startWorkers from "../utils/startWorkers.js";

const Button = () => {
  const [counters, setCounters] = React.useState({});

  React.useEffect(() => {
    async function counter() {
      try {
        const { countPG, countRedis } = await fetchCounters("/getCounters");
        console.log("init", countPG, countRedis);
        setCounters({
          countPG: Number(countPG),
          countRedis: Number(countRedis),
        });
      } catch {
        (err) => console.warn(err);
      }
    }
    counter();
  }, []);

  const handleClick = async (e) => {
    e.preventDefault;
    setCounters((prev) => {
      for (const key in prev) {
        prev[key] = Number.parseInt(prev[key]) + 1;
      }
      return prev;
    });

    try {
      let { countPG, countRedis } = counters;
      countPG += 1;
      countRedis = Number(countRedis) + 1;
      postCounters("/incrCounters", { countPG, countRedis }).then(() => {
        setCounters({ countPG, countRedis });
      });
      await fetch("/startWorkers");
    } catch {
      (err) => console.log(err);
    }

    // await fetchCounters("incrCounters").then(({ countRedis, countPG }) => {
    //   setCounters({
    //     countPG,
    //     countRedis,
    //   }).catch((err) => console.warn(err));
    //   console.log("insert: ", counters);
    // });
  };

  return (
    <>
      <div className="flexed">
        <button className="button" onClick={handleClick}>
          Click me!
        </button>

        {counters && (
          <div>
            <h1>PG counter: {counters.countPG}</h1>
            <br />
            <h1>Redis counter: {counters.countRedis}</h1>
          </div>
        )}
      </div>
    </>
  );
};

export default Button;

// document.addEventListener("DOMContentLoaded", () => {
//   ReactDOM.render(
//     <Hello name="React" />,
//     document.body.appendChild(document.createElement("div"))
//   );
// });
