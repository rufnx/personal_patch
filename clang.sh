#!/usr/bin/env bash

BASE_URL=https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive

declare -A CLANG_MAP=(
  [12]=c935d99d7cf2016289302412d708641d52d2f7ee
  [13]=f55a2d2d48c7d2a8b9b53d09c0d52b30c7c1b5b5
  [14]=a4a3d1e6b1b7a9b54b34db4fa89d94cbbf73b0e6
  [15]=7f4a1b7f7ccfb4c5e5df8ad3d3b5b07db61d1b5c
  [16]=a9b8c7d6e5f4b3a2c1d0e9f8a7b6c5d4e3f2a1b
  [17]=b1a2c3d4e5f697887766554433221100ffeeddcc
  [18]=ccddeeff00112233445566778899aabbccddeeff
  [19]=11223344556677889900aabbccddeeff00112233
  [20]=5299c17a7c78cfb703e3830ed02b74fb8fed77f9
  [21]=abcdefabcdefabcdefabcdefabcdefabcdefabcd
  [22]=167e11df8c330bced88cdf5808f61f41d9eab330
)

CLANG_VER=$1
CLANG_DIR=$2

[ -z $CLANG_VER ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }
[ -z $CLANG_DIR ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }

HASH=${CLANG_MAP[$CLANG_VER]}
[ -z "$HASH" ] && { echo "Unsupported clang version: $CLANG_VER"; exit 1; }

# ===== FETCH =====
if [ ! -d "$CLANG_DIR" ]; then
  echo "[•] Fetching clang-$CLANG_VER"
  mkdir -p "$CLANG_DIR"
  cd "$CLANG_DIR"

  curl -L "$BASE_URL/$HASH/clang-r$HASH.tar.gz" -o clang.tar.gz
  tar -xf clang.tar.gz
  rm clang.tar.gz

  echo "[√] clang-$CLANG_VER installed"
else
  echo "[!] clang already exists: $CLANG_DIR"
fi

$CLANG_DIR/bin/clang --version || true
