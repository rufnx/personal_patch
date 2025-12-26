#!/usr/bin/env bash
set -e

BASE_URL=https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive

declare -A CLANG_MAP=(
  [19]="f45722cea929f932b08731a8d2d0a0737f1552cc:r536225"
  [20]="5299c17a7c78cfb703e3830ed02b74fb8fed77f9:r547379"
)

CLANG_VER=${1:-}
CLANG_DIR=${2:-}

[ -z $CLANG_VER ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }
[ -z $CLANG_DIR ] && { echo "Usage: $0 <clang_version> <dir>"; exit 1; }

ENTRY=${CLANG_MAP[$CLANG_VER]}
[ -z $ENTRY ] && { echo "Unsupported clang version: $CLANG_VER"; exit 1; }

HASH=${ENTRY%%:*}
REV=${ENTRY##*:}

TAR="clang-$REV.tar.gz"

if [ ! -d "$CLANG_DIR" ]; then
  echo "[INFO] Fetching clang-$CLANG_VER ($REV)"
  mkdir -p "$CLANG_DIR"
  cd "$CLANG_DIR"

  curl -fL "$BASE_URL/$HASH/$TAR" -o clang.tar.gz
  tar -xf clang.tar.gz
  rm clang.tar.gz

  echo "[OK] clang-$CLANG_VER installed"
else
  echo "[SKIP] clang already exists: $CLANG_DIR"
fi

"$CLANG_DIR/bin/clang" --version || true
