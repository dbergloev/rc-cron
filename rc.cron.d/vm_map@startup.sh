#!/bin/bash

##
# Increase virtual memory map per process to 4 times the default value.
# Remove 5 for the kernel recommended safety in case of old tooling. 
#
map=$(( 65635 * 4 - 5 ))
val=$(sysctl -n vm.max_map_count)

if (( $map > $val )); then
    sysctl -w vm.max_map_count=$map
fi

