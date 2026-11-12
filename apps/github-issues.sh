#!/bin/bash
set -euo pipefail

# debug mode
# set -x

###
## GLOBAL VARIABLES
###
GITHUB_TOKEN=${GITHUB_TOKEN:-''}
ORG=${ORG:-'chromiecraft'}
REPO=${REPO:-'chromiecraft'}
API_URL_PREFIX=${API_URL_PREFIX:-'https://api.github.com'}
MONTH_START=${MONTH_START:-'2022-03-01'}
MONTH_END=${MONTH_END:-'2022-03-31'}
EVENT_START=$(date --date="180 days ago" +%Y-%m-%d)
EVENT_END=$(date --date="30 days" +%Y-%m-%d)

get_public_pagination () {
  # Github limits to 100 results per query, so we need to break up the results into 100 result chunks. We do this by breaking it up into pages
  public_pages=$(curl -g -H "Authorization: token ${GITHUB_TOKEN}" -I "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Linked%20[AC]&per_page=100" | grep -Eo '&page=[0-9]+' | grep -Eo '[0-9]+' | tail -1;)
  echo "${public_pages:-1}"
}

limit_public_pagination () {
  # Create sequence of pages
  seq "$(get_public_pagination)"
}

repo_issues () {
  # Iterate through all pages in the sequence
  for PAGE in $(limit_public_pagination); do
      # Filter through results and return on issues within the date range, sort by the issue number 
      for i in $(curl -g -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Linked%20[AC]&page=${PAGE}&per_page=100" | jq -r 'map(select(.created_at | . >= "'"${EVENT_START}"'T00:00" and . <= "'"${EVENT_END}"'T23:59")) | sort_by(.number) | .[] | .number'); do

        # Performance Boost ⚡: Fetch timeline payload once and reuse it instead of calling GitHub API twice per issue.
        ISSUE_TIMELINE_RAW=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}/timeline" -H "Accept: application/vnd.github.mockingbird-preview+json")
        EVENT_DATE=$(echo "$ISSUE_TIMELINE_RAW" | jq -r 'map(select(.created_at | . >= "'"${MONTH_START}"'T00:00" and . <= "'"${MONTH_END}"'T23:59")) | .[] | select(.label.name=="Linked [AC]")')

        # check if the response from the event date is empty
        if [ "${EVENT_DATE}" != "null" ] && [ "${EVENT_DATE}" != "[]" ] && [ "${EVENT_DATE}" != "" ]; then
            # Capture the data from each filtered issue into a variable
            ISSUE_PAYLOAD=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}" -H "Accept: application/vnd.github.mercy-preview+json")
            # Extract linked label event directly from cached timeline payload
            ISSUE_TIMELINE_PAYLOAD=$(echo "$ISSUE_TIMELINE_RAW" | jq -r '.[] | select(.label.name=="Linked [AC]")')
            
            # Capture who reported the issue into a variable
            ISSUE_AUTHOR=$(echo "$ISSUE_PAYLOAD" | jq -r .user.login)
            # Capture the url for the issue into a variable
            ISSUE_HTML_URL=$(echo "$ISSUE_PAYLOAD" | jq -r .html_url)

            # Capture who applied the linked label
            ISSUE_TIMELINE_LABELED_BY=$(echo "$ISSUE_TIMELINE_PAYLOAD" | jq -s 'first(.[]| .actor.login)' | jq -r)

            # output data from variables into a json like file for later processing
            cat >> issues.json << EOF
{
  "author": "${ISSUE_AUTHOR}",
  "issue_url": "${ISSUE_HTML_URL}",
  "contributor": "${ISSUE_TIMELINE_LABELED_BY}"         
}
EOF
          echo -e "issue has been processed ""${i}"""
          fi

      done
  done
}

author_json () {
  # Process data about the issue creator
  echo -e "Issue Reporters" >> output.txt
  # Performance Boost ⚡: Streamlined single-pass jq aggregation instead of spawning O(N^2) jq subshells inside a bash loop
  if [ -s issues.json ]; then
    jq -s 'group_by(.author) | map({author: .[0].author, count: length}) | sort_by(-.count) | .[] | "<a href=\"https://github.com/\(.author)\">\(.author)</a> - \(.count)"' -r issues.json >> output.txt
  fi
}

contributor_json () {
  # Process data about who applied the linked label (contributor)
  echo -e "Contributors that linked issues" >> output.txt
  # Performance Boost ⚡: Streamlined single-pass jq aggregation instead of spawning O(N^2) jq subshells inside a bash loop
  if [ -s issues.json ]; then
    jq -s 'group_by(.contributor) | map({contributor: .[0].contributor, count: length}) | sort_by(-.count) | .[] | "<a href=\"https://github.com/\(.contributor)\">\(.contributor)</a> - \(.count)"' -r issues.json >> output.txt
  fi
}

# process the above functions in order
repo_issues
author_json
contributor_json
