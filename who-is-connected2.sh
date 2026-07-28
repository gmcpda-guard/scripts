#!/usr/bin/env bash

echo
echo "Currently connected users"
echo "========================="
echo

if command -v who >/dev/null; then
    who | while read -r user tty date time rest; do
        printf "%-15s %-10s %s %s\n" "$user" "$tty" "$date" "$time"
    done
else
    echo "'who' command not found."
fi

echo
echo "Summary"
echo "-------"

users=$(who | awk '{print $1}' | sort -u)

count=$(echo "$users" | grep -c .)

echo "Unique users: $count"

echo

echo "$users"

