#!/bin/bash

# ===========================================================================================
# -------------------------------------------------------------------------------------------
# Clear all user account caches
# 
for user in root $(getent passwd | awk -F: '($3 >= 1000 || $6 ~ /^\/home\//) && $7 !~ /nologin/ {print $1}'); do
    entry=$(getent passwd "$user")
    IFS=: read -r _ _ _ _ _ home _ <<< "$entry"

    if [[ -d "$home" && -d "$home/.cache" ]]; then
        rm -rf "$home/.cache"/*
    fi
done

