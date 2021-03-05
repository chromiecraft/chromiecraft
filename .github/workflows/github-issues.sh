#!/usr/bin/env /bin/bash
#set -euo pipefail

# debug mode
#set -x

###
## GLOBAL VARIABLES
###
GITHUB_TOKEN=${GITHUB_TOKEN:-''}
ORG=${ORG:-'chromiecraft'}
REPO=${REPO:-'chromiecraft'}
API_URL_PREFIX=${API_URL_PREFIX:-'https://api.github.com'}

get_issue_pagination () {
    issue_pages=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -I "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Linked%20[AC]&per_page=100" | grep -Eo '&page=[0-9]+' | grep -Eo '[0-9]+' | tail -1;)
    echo "${issue_pages:-1}"
}

limit_issue_pagination () {
  seq "$(get_issue_pagination)"
}

repo_issues () {
  for PAGE in $(limit_issue_pagination); do
  
    for i in $(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues?state=all&labels=Linked%20[AC]&per_page=100" | jq -r 'map(select(.created_at | . >= "2021-02-01T00:00" and . <= "2021-02-28T23:59")) | sort_by(.number) | .[] | .number'); do
      ISSUE_PAYLOAD=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}" -H "Accept: application/vnd.github.mercy-preview+json")
      ISSUE_TIMELINE_PAYLOAD=$(curl -H "Authorization: token ${GITHUB_TOKEN}" -s "${API_URL_PREFIX}/repos/${ORG}/${REPO}/issues/${i}/timeline" -H "Accept: application/vnd.github.mockingbird-preview+json" | jq -r '.[] | select(.label.name=="Linked [AC]" or .label.name=="linked")')
       
      ISSUE_AUTHOR=$(echo "$ISSUE_PAYLOAD" | jq -r .user.login)
      ISSUE_HTML_URL=$(echo "$ISSUE_PAYLOAD" | jq -r .html_url)

      ISSUE_TIMELINE_LABELED_BY=$(echo "$ISSUE_TIMELINE_PAYLOAD" | jq -r .actor.login)

      echo -e "Issue Url: ${ISSUE_HTML_URL}\nIssue Author: ${ISSUE_AUTHOR}\nContributor: ${ISSUE_TIMELINE_LABELED_BY}"
    done
  done
}

repo_issues
