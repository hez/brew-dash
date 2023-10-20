#!/bin/bash
while ! curl http://localhost
  do sleep 1
done
/usr/bin/firefox --kiosk http://localhost/
