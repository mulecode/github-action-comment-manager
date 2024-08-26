#!/bin/bash

set -e

# Assign environment variables to local variables
AUTH_TOKEN=$AUTH_TOKEN
ISSUE_NUMBER=$ISSUE_NUMBER
COMMENT_TITLE=${COMMENT_TITLE:-}
COMMENT_BODY=$COMMENT_BODY
COMMENT_BODY_FILE=$COMMENT_BODY_FILE

# Use the content of COMMENT_BODY_FILE if it is provided
if [ -n "$COMMENT_BODY_FILE" ]; then
  if [ -f "$COMMENT_BODY_FILE" ]; then
    echo "Reading comment body from file: $COMMENT_BODY_FILE"
    COMMENT_BODY=$(cat "$COMMENT_BODY_FILE")
  else
    echo "Error: COMMENT_BODY_FILE specified, but file does not exist."
    exit 1
  fi
fi

# Set up GitHub CLI with the token
echo "Authenticating..."
echo "$AUTH_TOKEN" | gh auth login --with-token

echo "Fetching existing comments..."
# Fetch existing comments
COMMENTS=$(gh api repos/:owner/:repo/issues/"$ISSUE_NUMBER"/comments)

# Find comment by COMMENT_TITLE
COMMENT_ID=$(echo "$COMMENTS" | jq -r ".[] | select(.body | contains(\"$COMMENT_TITLE\")) | .id")

# Combine COMMENT_TITLE and COMMENT_BODY
FULL_BODY=$(printf "### %s\n\n%s" "$COMMENT_TITLE" "$COMMENT_BODY")

if [ -z "$COMMENT_ID" ]; then
  echo "Will create new comment."
  gh api repos/:owner/:repo/issues/"$ISSUE_NUMBER"/comments \
    -f body="$FULL_BODY"
  echo "Comment created."
else
  echo "Will update comment $COMMENT_ID."
  gh api repos/:owner/:repo/issues/comments/"$COMMENT_ID" \
    -X PATCH \
    -f body="$FULL_BODY"
  echo "Comment updated."
fi
