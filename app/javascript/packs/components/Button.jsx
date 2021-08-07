import React, { useState, useEffect } from "react";

import fetchCounters from "../utils/fetchCounters.js";
import postCounters from "../utils/postCounters.js";
import startWorkers from "../utils/startWorkers.js";
import CountersChannel from "../../channels/counters_channel.js";
import HitsChannel from "../../channels/hits_channel.js";

const Button = () => {
  const [counters, setCounters] = useState({});
  const [hitCounts, setHitCounts] = useState();

  useEffect(() => {
    async function initCounter() {
      try {
        // page hit count
        HitsChannel.received = (data) => {
          setHitCounts(data.hits_count);
        };
        // click counter
        let i = 0;
        CountersChannel.received = ({ countPG }) => {
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
      let { countPG } = counters;
      countPG += 1;
      await Promise.all([
        postCounters("/incrCounters", {
          countPG,
        })
          .then((res) => {
            if (res.status === "created") {
              setCounters({ countPG });
            }
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
