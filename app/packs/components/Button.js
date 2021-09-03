import React, { useState, useEffect } from "react";
import fetchCounters from "~/utils/fetchCounters.js";
import startWorkers from "~/utils/startWorkers.js";

import clickChannel from "~/channels/click_channel.js";
import hitChannel from "~/channels/hit_channel.js";
import listChannel from "~/channels/list_channel.js";

import "~/stylesheets/application.css";

const Table = (props) => {
  return (
    <tbody>
      {Object.keys(props.pods).map((pod) => (
        <Row pod={pod} pods={props.pods} key={pod.toString()} />
      ))}
    </tbody>
  );
};

const Row = ({ pod, pods, key }) => (
  <tr key={key}>
    <td>{pod}</td>
    <td>
      <span className="badge">{pods[pod]?.nb}</span>
    </td>
    <td>{pods[pod]?.created_at}</td>
  </tr>
);

const Counter = ({ text, count }) => {
  return (
    <h1>
      {text} <span>{count}</span>
    </h1>
  );
};

export default function Button() {
  const [clickCount, setClickCount] = useState({});
  const [hitCount, setHitCount] = useState({});
  const [pods, setPods] = useState({});

  useEffect(() => {
    let init = true;
    async function initCounter() {
      try {
        listChannel.received = (data) => {
          if (data) setPods(data);
        };
        hitChannel.received = (data) => {
          if (data) return setHitCount({ hitCount: data.hitCount });
        };
        let i = 0;
        clickChannel.received = (data) => {
          if (data) {
            i = 1;
            console.log("via ws");
            const { clickCount } = data;
            return setClickCount({ clickCount });
          }
        };
        console.log(i);
        if (i === 0) {
          console.log("via fetch");
          const { clickCount, hitCount } = await fetchCounters("/getCounters");
          setClickCount({ clickCount: Number(clickCount) });
          setHitCount({ hitCount: Number(hitCount) });
        }
      } catch (err) {
        console.warn(err);
        throw new Error(err);
      }
    }
    if (init) initCounter();
    return () => (init = false);
  }, []);

  const handleClick = async (e) => {
    e.preventDefault();
    try {
      let update;
      clickCount.clickCount === 0
        ? (update = 1)
        : (update = clickCount.clickCount + 1);
      clickChannel.sending({ clickCount: update });
      await startWorkers().catch((err) => console.log(err));
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
        <div className="counters">
          <Counter text={"Click count: "} count={clickCount.clickCount} />
          <br />
          <Counter text={"Page hits: "} count={hitCount.hitCount} />
        </div>
        <div className="flexed">
          <table className="styled-table">
            <thead>
              <tr>
                <th>Pod_ID</th>
                <th>Counts</th>
                <th>Created at</th>
              </tr>
            </thead>
            <Table pods={pods} />
          </table>
        </div>
      </div>
      <br />
    </>
  );
}
