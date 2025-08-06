#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$(readlink -f "$0")" "$@"
fi

echo "Copying files"
if [[ ! -d /etc/rc.cron.d ]]; then
    mkdir -p /etc/rc.cron.d
fi
cp -a systemd/* /etc/systemd/system/
cp rc.cron.d/* /etc/rc.cron.d/
cp rc.cron /etc/
chmod +x /etc/rc.cron.d/*
chmod +x /etc/rc.cron

echo "Reloading systemd..."
systemctl daemon-reexec
systemctl daemon-reload

echo "Enabling @startup timer"
systemctl enable -q cron-startup.service

echo "Enabling @shutdown timer"
systemctl enable -q cron-shutdown.service

echo "Enabling @network timer"
systemctl enable -q cron-network.service

echo "Enabling @5min timer"
systemctl enable -q --now cron@5min.timer

echo "Enabling @15min timer"
systemctl enable -q --now cron@15min.timer

echo "Enabling @hourly timer"
systemctl enable -q --now cron@hourly.timer

echo "Enabling @daily timer"
systemctl enable -q --now cron@daily.timer

echo "Enabling @weekly timer"
systemctl enable -q --now cron@weekly.timer

echo "Enabling @montly timer"
systemctl enable -q --now cron@monthly.timer

echo "Enabling @quarterly timer"
systemctl enable -q --now cron@quarterly.timer

echo "Enabling @annually timer"
systemctl enable -q --now cron@annually.timer

