#!/usr/bin/env bash

set -e

clone(){
BASE_URL=https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive
CLANG_VER=$1
CLANG_DIR=$(pwd)/$2
ENTRY=${CLANG_MAP[$CLANG_VER]}
HASH=${ENTRY%%:*}
REV=${ENTRY##*:}

declare -A CLANG_MAP=(
  [15]="13a934187ab34eec02565aff0d8a89518250e44f:r498229"
  [16]="8d1c95e1855c241a61b34333b22c33ab56e1c006:r510928"
  [17]="c4a1f59233eea881f36c17c987d0d90ebe362e76:r522817"
  [18]="8b08eceb32a77550f38ecf05271d288e53527062:r530567"
  [19]="f45722cea929f932b08731a8d2d0a0737f1552cc:r536225"
  [20]="5299c17a7c78cfb703e3830ed02b74fb8fed77f9:r547379"
)

[ -z $CLANG_VER ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }
[ -z $CLANG_DIR ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }
[ -z $ENTRY ] && { echo "Unsupported clang version: $CLANG_VER"; exit 1; }

if [ ! -d $CLANG_DIR ]; then
  echo "[INFO] Fetching clang-$CLANG_VER ($REV)"
  mkdir -p $CLANG_DIR
  cd $CLANG_DIR

  curl -fL $BASE_URL/$HASH/clang-$REV.tar.gz -o clang.tar.gz
  tar -xf clang.tar.gz
  rm clang.tar.gz

  echo "[OK] clang-$CLANG_VER installed"
else
  echo "[SKIP] clang already exists: $CLANG_DIR"
fi

$CLANG_DIR/bin/clang --version || true
}

clome "$@"
