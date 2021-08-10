import React, { useState, useEffect } from "react";

import fetchCounters from "../utils/fetchCounters.js";
import postCounters from "../utils/postCounters.js";
import startWorkers from "../utils/startWorkers.js";
import counterChannel from "../../channels/counter_channel.js";
import hitsChannel from "../../channels/hits_channel.js";

const Button = () => {
  const [counters, setCounters] = useState({});
  const [hitCounts, setHitCounts] = useState(0);

  useEffect(() => {
    async function initCounter() {
      try {
        hitsChannel.received = (data) => {
          if (data) return setHitCounts(data.hits_count);
        };
        let i = 0;
        counterChannel.received = (data) => {
          if (data.countPG) {
            i = 1;
            return setCounters({ countPG: data.countPG });
          }
        };
        if (i === 0) {
          const { countPG } = await fetchCounters("/getCounters");
          setCounters({ countPG: Number(countPG) });
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
      if (!countPG) countPG = 0;
      countPG += 1;
      counterChannel.sending(countPG);
      await startWorkers().catch((err) => console.log(err));
      // await Promise.any([
      //   // postCounters("/incrCounters", { countPG })
      //   //   .then((res) => {
      //   //     if (res.status === "created") {
      //   //       return setCounters({ countPG });
      //   //     }
      //   //     throw new Error(res.status);
      //   //   })
      //   //   .catch((err) => console.log(err)),
      //   startWorkers().catch((err) => console.log(err)),
      // ]);
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
