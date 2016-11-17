#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  # This is a Mac
  ./osx/run_ulogme_osx.sh
else
  # Assume Linux
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  pushd "${DIR}"
  echo "" > ./ulogme.log
  until [ "$(pgrep -fca 'keyfreq')" -gt 0 ]
  do
      gksudo -D /home/gserebry/.config/autostart/ulogme.desktop ./keyfreq.sh &
      sleep 10
      echo "trying to start keyfreq" >> ./ulogme.log
      started_count=$(pgrep -fca "keyfreq")
      echo "started_count = ${started_count}"
  done
  until [ "$(pgrep -fca 'logactivewin')" -gt 0 ]
  do
      ./logactivewin.sh &
      echo "trying to start logactivewin" >> ./ulogme.log
      started_count=$(pgrep -fca "logactivewin")
      echo "started_count = ${started_count}"
  done
  until [ "$(pgrep -fca 'ulogme_serve')" -gt 0 ]
  do
      python ./ulogme_serve.py &> /dev/null &
      echo "trying to start ulogme_serve" >> ./ulogme.log
      started_count=$(pgrep -fca "ulogme_serve")
      echo "started_count = ${started_count}"
  done
  echo "all routines started"
  popd
fi
