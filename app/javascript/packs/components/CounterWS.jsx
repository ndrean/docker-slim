import "channels";
import React, { useState, useEffect } from "react";
import CounterChannel from "channels/counter_channel";

const CounterWS = () => {
  const [counter, setCounter] = useState();
  useEffect(() => {
    CounterChannel.received = (data) => setCounter(data.counter);
  }, []);
};

export default CounterWS;
