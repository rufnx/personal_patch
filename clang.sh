#!/usr/bin/env bash

set -e

clone(){
BASE_URL=https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive
CLANG_VER=$1
CLANG_DIR=$(pwd)/$2

declare -A CLANG_MAP=(
  [11]="e532342f30eadb954c96d19ca6a0edf89a5c65bc:r383902b1"
  [12]="60429dd0d725956af713ecfd5e16160693eb189f:r416183c2"
  [13]="a7b90d1ea59f1c958ea523c9d69ec94b600f7b43:r433403b"
  [14]="0c1b38b9d76c2e184189468bb77d64529cda9fab:r450784d1"
  [15]="7d21a2e4192728bc50841994d88637ccc45b5692:r468909b"
  [16]="fda0bcea8604fa6f5405927b624993eefec79e57:r475365b"
  [17]="15a3633cd36bb220e5b1b64ca3cebc8c45f45045:r498229b"
  [18]="6a853dd45fe8f0d1821deb899c77a7b954b6306b:r522817"
  [19]="192fe0d378bb9cd4d4271de3e87145a1956fef40:r536225"
  [20]="62cdcefa89e31af2d72c366e8b5ef8db84caea62:r547379"
  [21]="ebcc6c3bef363bc539ea39f45b6abae1dce6ff1a:r574158"
  [22]="167e11df8c330bced88cdf5808f61f41d9eab330:r584948"
)

ENTRY=${CLANG_MAP[$CLANG_VER]}
HASH=${ENTRY%%:*}
REV=${ENTRY##*:}

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

clone "$@"
