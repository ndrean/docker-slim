// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, { useState, useEffect } from "react";

import fetchCounters from "../utils/fetchCounters.js";
import postCounters from "../utils/postCounters.js";
import startWorkers from "../utils/startWorkers.js";

import CounterChannel from "../../channels/counter_channel.js";
import HitsChannel from "../../channels/hits_channel.js";

const Button = () => {
  const [counters, setCounters] = useState({});
  const [hitCounts, setHitCounts] = useState();

  useEffect(() => {
    async function initCounter() {
      try {
        HitsChannel.received = (data) => {
          setHitCounts(data.hits_count);
        };

        let i = 0;
        CounterChannel.received = ({ countPG }) => {
          if (countPG) {
            i = 1;
            return setCounters({ countPG });
          }
        };
        if (i === 0) {
          const { countPG } = await fetchCounters("/getCounters");
          const cPG = Number(countPG);
          setCounters({ countPG: cPG });
        }
      } catch (err) {
        console.warn(err);
        throw new Error(err);
      }
    }
    initCounter();
  }, []);

  const handleClick = async (e) => {
    e.preventDefault();
    try {
      let { countPG } = counters; // , countRedis
      countPG += 1;
      // countRedis = Number(countRedis) + 1;
      await Promise.any([
        postCounters("/incrCounters", { countPG }) // , countRedis
          .then((res) => {
            if (res.status === "created") {
              return setCounters({ countPG }); // , countRedis
            }
            throw new Error(res.status);
          })
          .catch((err) => console.log(err)),
        startWorkers().catch((err) => console.log(err)),
      ]);
    } catch (err) {
      console.log(err);
      throw new Error(err);
    }
  };

  return (
    <>
      <div className="flexed">
        <button className="button" onClick={handleClick}>
          Click me!
        </button>

        {counters && (
          <div>
            <h1>Click counter: {counters.countPG}</h1>
            <br />
            <h1>Total page hits: {hitCounts}</h1>
          </div>
        )}
      </div>
    </>
  );
};

export default Button;
