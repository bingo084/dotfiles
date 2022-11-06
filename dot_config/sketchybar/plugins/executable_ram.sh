#/usr/bin/env bash

sketchybar --set ram_percentage label=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5"%"}')
