#!/bin/bash
#
# Automatically encrypt SWAP partitions without requiring to setup crypttab.
# There is no setup for this, simply make a GPT partition label "swap", "swap[0-9]" or "swap-" on 
# any swap partition. 
#

if ! which cryptsetup >/dev/null 2>&1; then
    echo "Missing cryptsetup binary" >&2; exit 1
fi

i=0
while read -r line; do
    # parse out variables from the line
    devlabel=$(echo "$line" | grep -o 'PARTLABEL="[^"]*"' | cut -d'"' -f2 | tr '[:upper:]' '[:lower:]')
    devpath=$(echo "$line" | grep -o 'PATH="[^"]*"' | cut -d'"' -f2)
    
    if [[ $devlabel =~ ^swap([0-9]+.*|-.*)?$ ]]; then
        echo "Activating swap$i ($devpath)"
        
        if cryptsetup open --type=plain --cipher=aes-xts-plain64 --key-size=512 --key-file=/dev/urandom "$devpath" "swap$i"; then
            mkswap "/dev/mapper/swap$i" >/dev/null 
            swapon "/dev/mapper/swap$i" 2>&1
        fi
        
        ((i++))
    fi

done < <(lsblk -P -o PARTLABEL,PATH)

