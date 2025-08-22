#!/bin/sh
sqfscat $1 /usr/lib/os-release > /tmp/os-release
source /tmp/os-release
echo $VERSION
