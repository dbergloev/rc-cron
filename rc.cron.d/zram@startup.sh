#!/bin/bash

# ===========================================================================================
# -------------------------------------------------------------------------------------------
# Enable ZRAM with 18% memory usage and lower priority for disk SWAP
# 
if modprobe zram; then
    echo 3 > /proc/sys/vm/drop_caches

    lMemory=$(cat /proc/meminfo | awk '{ if ($1 eq "MemTotal:") print $2; exit }')
    lCompression=18

    echo "$(($lMemory * $lCompression / 100 * 1024))" > /sys/block/zram0/disksize
    
    # Find current active swap partitions
    readarray -t swap_list < <(tail -n +2 /proc/swaps | awk '{print $1}')
    
    # Disable all swap partitions
    swapoff -a
    
    # Enable ZRAM
    mkswap /dev/zram0 >/dev/null
    swapon /dev/zram0 2>&1
    
    # Now re-enable swap partitions, making sure that ZRAM has the highest priority
    for swap in "${swap_list[@]}"; do
        swapon "$swap"
    done
fi

echo 60 > /proc/sys/vm/swappiness

