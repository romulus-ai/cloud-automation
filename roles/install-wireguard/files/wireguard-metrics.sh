#!/bin/bash

wg_result=$(wg show all dump)
current_time=$(date +%s)

wg_peers=$(wg show all | grep peer | awk '{print $2}')

IFS=$'\n'

for wg_result_line in $wg_result ; do
  for wg_peer in $wg_peers ; do
    if [[ "$wg_result_line" == *"$wg_peer"* ]] ; then
      device=$(echo $wg_result_line | awk '{print $1}')
      endpoint=$(echo $wg_result_line | awk '{print $4}')
      allowed_ips=$(echo $wg_result_line | awk '{print $5}')
      last_handshake=$(echo $wg_result_line | awk '{print $6}')
      received_bytes=$(echo $wg_result_line | awk '{print $7}')
      sent_bytes=$(echo $wg_result_line | awk '{print $8}')
      ((last_handshake_ago=$current_time - $last_handshake))
      echo "wireguard_peer_receive_bytes_total{device=\"$device\",endpoint=\"$endpoint\",allowed_ips=\"$allowed_ips\"} $received_bytes"
      echo "wireguard_peer_sent_bytes_total{device=\"$device\",endpoint=\"$endpoint\",allowed_ips=\"$allowed_ips\"} $sent_bytes"
      echo "wireguard_peer_last_handshake_seconds{device=\"$device\",endpoint=\"$endpoint\",allowed_ips=\"$allowed_ips\"} $last_handshake"
      echo "wireguard_peer_last_handshake_ago_seconds{device=\"$device\",endpoint=\"$endpoint\",allowed_ips=\"$allowed_ips\"} $last_handshake_ago"
    fi
  done
done