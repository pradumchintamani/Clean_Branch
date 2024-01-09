#!/bin/bash

# Clone the code repo
git clone https://github.com/pradumchintamani/Clean_Branch.git
cd Clean_Branch

# Get the list of branches older than x days
OLD_BRANCHES=$(git for-each-ref --format '%(committerdate:iso8601)%09%(refname:short)' | sort | awk -v cutoff="$(date -d '10 days ago' --iso-8601=seconds)" '$1 < cutoff {print $2}')

# Approval step - you may need to implement your own logic here
# This is a basic example using GitHub API to get branch protection details
approvalRequired=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/repos/your/repo/branches/main/protection | jq '.required_pull_request_reviews.enabled')

if [ "$approvalRequired" == "true" ]; then
  echo "Branch deletion requires manual approval."
  # You might want to send a notification or await manual approval here
else
  # Proceed with branch deletion
  echo "Deleting old branches: $OLD_BRANCHES"
  git branch -D $OLD_BRANCHES
fi
