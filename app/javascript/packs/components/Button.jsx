// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from "react";

import fetchCounters from "./fetchCounters.js";
import startWorkers from "./startWorkers.js";

const Button = () => {
  const [counters, setCounters] = React.useState({});

  React.useEffect(async () => {
    console.log("init");
    return fetchCounters("getCounters").then(({ countPG, countRedis }) => {
      setCounters({
        countPG,
        countRedis,
      });
    });
  }, []);

  const handleClick = async (e) => {
    e.preventDefault;
    await fetchCounters("incrCounters").then(({ countRedis, countPG }) => {
      setCounters({
        countPG,
        countRedis,
      });
      console.log("click");
    });
    await startWorkers();
  };

  return (
    <>
      <div className="flexed">
        <button className="button" onClick={handleClick}>
          Click me!
        </button>

        {counters && (
          <div>
            <h2>PG counter: {counters.countPG}</h2>
            <h2>Redis counter: {counters.countRedis}</h2>
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
