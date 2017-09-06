#!/bin/bash
isExistApp=`pgrep kong`
if [[ -n  $isExistApp ]]; then
   kong stop
fi

isExistApp=`pgrep supervisor`
if [[ -n  $isExistApp ]]; then
	service supervisor stop
fi

curl -i -X DELETE --retry 100 --retry-delay 10 --url "http://localhost:8001/apis/dslib-api"