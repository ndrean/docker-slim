import React, { useState, useEffect } from "react";

import fetchCounters from "../utils/fetchCounters.js";
// import postCounters from "../utils/postCounters.js";
import startWorkers from "../utils/startWorkers.js";

import clickChannel from "../../channels/click_channel.js";
import hitChannel from "../../channels/hit_channel.js";
import listChannel from "../../channels/list_channel.js";

const Button = () => {
  const [clickCount, setClickCount] = useState({});
  const [hitCount, setHitCount] = useState({});
  const [pods, setPods] = useState({});

  useEffect(() => {
    async function initCounter() {
      try {
        listChannel.received = (data) => {
          console.log("data", data);
          setPods(data);
        };
        hitChannel.received = (data) => {
          console.log(data);
          if (data) return setHitCount({ hitCount: data.hitCount });
        };

        let i = 0;
        clickChannel.received = (data) => {
          if (data) {
            console.log(data);
            i = 1;
            const { clickCount } = data;
            return setClickCount({ clickCount });
          }
        };
        if (i === 0) {
          const { clickCount, hitCount } = await fetchCounters("/getCounters");
          setClickCount({ clickCount: Number(clickCount) });
          setHitCount({ hitCount: Number(hitCount) });
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
      setClickCount((prev) => {
        const update = prev.clickCount + 1;
        clickChannel.sending({ clickCount: update });
        return { clickCount: update };
      });

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
          Click me!!
        </button>

        {/* {(hitCount || clickCout) && ( */}
        <div>
          <h1>Click counter: {clickCount?.clickCount}</h1>
          <br />
          <h1>Page hits: {hitCount?.hitCount}</h1>
        </div>
        {/* )} */}
      </div>
      <br />

      <div className="aligned flexed">
        <table style={{ border: "1", rules: "rows" }}>
          <tr>
            <th>Pod_ID</th>
            <th>Counts</th>
            <th>Create at</th>
          </tr>
          {pods &&
            Object.keys(pods).map((pod) => {
              return (
                <tr>
                  <td>{pod}</td>
                  <td>{pods[pod]?.nb}</td>
                  <td>{pods[pod]?.created_at}</td>
                </tr>
              );
            })}
        </table>
      </div>
    </>
  );
};

export default Button;
