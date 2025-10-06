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
  public_pages=$(curl -g -H "Authorization: token ${GITHUB_TOKEN}" -I "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Confirmed&per_page=100" | grep -Eo '&page=[0-9]+' | grep -Eo '[0-9]+' | tail -1;)
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
      for i in $(curl -g -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Confirmed&page=${PAGE}&per_page=100" | jq -r 'map(select(.created_at | . >= "'"${EVENT_START}"'T00:00" and . <= "'"${EVENT_END}"'T23:59")) | sort_by(.number) | .[] | .number'); do

        # Capture the event date from the timeline api
        EVENT_DATE=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}/timeline" -H "Accept: application/vnd.github.mockingbird-preview+json" | jq -r 'map(select(.created_at | . >= "'"${MONTH_START}"'T00:00" and . <= "'"${MONTH_END}"'T23:59")) | .[] | select(.label.name=="Linked [AC]")')
        # check if the response from the event date is empty
        if [ "${EVENT_DATE}" != "null" ] && [ "${EVENT_DATE}" != "[]" ] && [ "${EVENT_DATE}" != "" ]; then
            # Capture the data from each filtered issue into a variable
            ISSUE_PAYLOAD=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}" -H "Accept: application/vnd.github.mercy-preview+json")
            # Capture the data from each filtered issue from the timeline api
            ISSUE_TIMELINE_PAYLOAD=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}/timeline" -H "Accept: application/vnd.github.mockingbird-preview+json" | jq -r '.[] | select(.label.name=="Linked [AC]")')
            
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
  AUTHORS=$(cat issues.json| jq -r '.author' | sort | uniq -c | awk -F " " '{print "{\"author\":""\""$2"\""",\"count\":" $1"}"}' | jq -r .author)
  echo -e "Issue Reporters" >> output.txt
    # Iterate through all issue creators found in the temp json like file
    for AUTHOR in ${AUTHORS}; do
    # Capture the issue creator data into a variable
    TEST_PAYLOAD=$(cat issues.json| jq -r '.author' | sort | uniq -c | awk -F " " '{print "{\"author\":""\""$2"\""",\"count\":" $1"}"}' | jq -r .)
    # Capture the issue creator username into a variable
    TEST_PAYLOAD_AUTHOR=$(echo "$TEST_PAYLOAD" | jq -r --arg AUTHOR "${AUTHOR}" 'select(.author==$AUTHOR) | .author')
    # Capture the number of issues created by the same issue creator
    TEST_PAYLOAD_AUTHOR_COUNT=$(echo "$TEST_PAYLOAD" | jq -r --arg AUTHOR "${AUTHOR}" 'select(.author==$AUTHOR) | .count')
    #echo -e "#######################################################\nIssue Author: ${TEST_PAYLOAD_AUTHOR}\nCount: ${TEST_PAYLOAD_AUTHOR_COUNT}\nIssues:\n${TEST_PAYLOAD_AUTHOR_ISSUE_URL}\n#######################################################\n"
    # Output the results
    echo -e "<a href="https://github.com/${TEST_PAYLOAD_AUTHOR}">${TEST_PAYLOAD_AUTHOR}</a> - ${TEST_PAYLOAD_AUTHOR_COUNT}"
    # Sort the data and pipe into a text file
    done | sort -n -k 4,4 -r >> output.txt
}

contributor_json () {
  # Process data about who appled the linked label (contributor)
  CONTRIBUTORS=$(cat issues.json| jq -r '.contributor' | sort | uniq -c | awk -F " " '{print "{\"contributor\":""\""$2"\""",\"count\":" $1"}"}' | jq -r .contributor)
  echo -e "Contributors that linked issues" >> output.txt
    # Iterate through all issue contributors found in the temp json like file
    for CONTRIBUTOR in ${CONTRIBUTORS}; do
    # Capture the issue contributor data into a variable
    TEST_PAYLOAD=$(cat issues.json| jq -r '.contributor' | sort | uniq -c | awk -F " " '{print "{\"contributor\":""\""$2"\""",\"count\":" $1"}"}' | jq -r .)
    # Capture the issue contributor username into a variable
    TEST_PAYLOAD_CONTRIBUTOR=$(echo "$TEST_PAYLOAD" | jq -r --arg CONTRIBUTOR "${CONTRIBUTOR}" 'select(.contributor==$CONTRIBUTOR) | .contributor')
    # Capture the number of issues linked by the same issue contributor
    TEST_PAYLOAD_CONTRIBUTOR_COUNT=$(echo "$TEST_PAYLOAD" | jq -r --arg CONTRIBUTOR "${CONTRIBUTOR}" 'select(.contributor==$CONTRIBUTOR) | .count')
    #TEST_PAYLOAD_CONTRIBUTOR_ISSUE_URL=$(cat issues.json | jq -r --arg CONTRIBUTOR "${CONTRIBUTOR}" 'select(.contributor==$CONTRIBUTOR) | .issue_url')
    #TEST_PAYLOAD_CONTRIBUTOR_ISSUE_URL="https://github.com/chromiecraft/chromiecraft/issues?q=is%3Aissue+label%3A%22Linked+%5BAC%5D%22+involves%3A${CONTRIBUTOR}+created%3A2021-02-01T00%3A00..2021-02-28T23%3A59+is%3Aclosed"
    #echo -e "#######################################################\nIssue Contributor: ${TEST_PAYLOAD_CONTRIBUTOR}\nCount: ${TEST_PAYLOAD_CONTRIBUTOR_COUNT}\nIssues:\n${TEST_PAYLOAD_CONTRIBUTOR_ISSUE_URL}\n#######################################################\n"
    # Output the results
    echo -e "<a href="https://github.com/${TEST_PAYLOAD_CONTRIBUTOR}">${TEST_PAYLOAD_CONTRIBUTOR}</a> - ${TEST_PAYLOAD_CONTRIBUTOR_COUNT}"
    # Sort the data and pipe into a text file
    done | sort -n -k 4,4 -r >> output.txt
}

# process the above functions in order
repo_issues
author_json
contributor_json
