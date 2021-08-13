#!/bin/bash

start=$SECONDS
for ((i=1;i<=50;i++)) do
  curl http://localhost:31000
done
res=$(( SECONDS - start ))
echo $res
