#!/bin/bash

i3status --config ~/.i3/i3status.conf | (read line && echo $line && read line && echo $line && while :
do
  read line
  play=$(mpc current)
  play="[{ \"full_text\": \"${play}\" },"
  echo "${line/[/$play}" || exit 1
done)
