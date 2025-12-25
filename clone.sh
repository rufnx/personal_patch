#!/usr/bin/env bash

clone() {
  local branch=$1
  local dir=$2

  echo "INFO: Fetching branch ($branch) into [$dir]"
  git clone --depth=1 --single-branch \
    https://github.com/rufnx/toolchains.git \
    -b "$branch" "$dir" >/dev/null 2>&1

  if [[ -d $dir ]]; then
    echo "INFO: Successfully fetched $dir"
  else
    echo "FAILED: Fetch failed"
    exit 1
  fi
}

[[ -n $1 && -n $2 ]] || {
  echo "FAILED: branch or dir missing"
  exit 1
}

clone "$1" "$2"
