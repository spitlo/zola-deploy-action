#!/usr/bin/env bash

set -e
set -o pipefail

if [[ -n "$TOKEN" ]]; then
  GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

if [[ -z "$MAIN_BRANCH" ]]; then
  MAIN_BRANCH="master"
fi

main() {
  echo "Starting deploy..."

  git config --global url."https://".insteadOf git://
  git config --global url."https://github.com/".insteadOf git@github.com:

  version=$(zola --version)

  repo="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

  echo "Using $version"

  zola check
  zola build --output-dir ./docs

  if [[ -n "$SITE_URL" ]] && [[ -f "docs/search_index.en.js" ]]; then
    sed -i 's_'"$SITE_URL"'__g' docs/search_index.en.js
  fi

  echo "Pushing artifacts to ${GITHUB_REPOSITORY}:${MAIN_BRANCH}"
  
  git config user.name "Arnim"
  git config user.email "github-actions-bot@users.noreply.github.com"
  git add ./docs
  git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M')"
  git push

  git push --force "${repo}" "master:${MAIN_BRANCH}"

  echo "Deploy complete"
}

main "$@"
