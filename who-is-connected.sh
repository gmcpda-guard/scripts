netstat -tn 2>/dev/null | egrep ':80|:22' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head
