#!/bin/bash

# List branches older than x days
OLD_BRANCHES=$(git for-each-ref --format '%(committerdate:iso8601)%09%(refname:short)' | sort | awk -v cutoff="$(date -d '2 days ago' --iso-8601=seconds)" '$1 < cutoff {print $2}')

# Send the list to email addresses (replace with your email sending logic)
# echo "Old branches: $OLD_BRANCHES" | mail -s "Old Branches Report" user@example.com
