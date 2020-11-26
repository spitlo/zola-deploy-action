#!/usr/bin/env bash
set -eu
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

main() {
  echo "Starting deploy..."

  git config --global url."https://".insteadOf git://
  git config --global url."https://github.com/".insteadOf git@github.com:

  version=$(zola --version)

  remote_repo="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
  remote_branch=master

  echo "Using $version"

  zola check
  zola build --output-dir ./docs

  sed -i '' 's_https://spitlo.com__g' docs/search_index.en.js

  echo "Pushing artifacts to ${GITHUB_REPOSITORY}:$remote_branch"

  git add ./docs
  git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M')"
  git push

  git push --force "${remote_repo}" master:${remote_branch}

  echo "Deploy complete"
}

main "$@"
