#!/usr/bin/env bash

# ===== CONFIG (ARGUMENT) =====
BOT_TOKEN="$1"
CHAT_ID="$2"
FILE="$3"

# ===== VALIDATION =====
if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ] || [ -z "$FILE" ]; then
  echo "Usage: ./send.sh <BOT_TOKEN> <CHAT_ID> <file.zip>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 1
fi

# ===== UPLOAD (GoFile with fallback servers) =====
link=""

for server in store1 store2 store3 store4; do
  echo "Uploading to $server.gofile.io ..."
  response=$(curl -s -F "file=@$FILE" "https://$server.gofile.io/contents/uploadfile")

  link=$(echo "$response" | grep -oP '"downloadPage"\s*:\s*"\K[^"]+')

  if [ -n "$link" ]; then
    echo "Upload success on $server"
    break
  fi
done

if [ -z "$link" ]; then
  link="Upload failed"
fi

# ===== KERNEL VERSION =====
if [ -f Image.gz ]; then
  kernelver=$(zcat Image.gz | strings | grep "Linux version")
elif [ -f Image ]; then
  kernelver=$(strings Image | grep "Linux version")
else
  kernelver="Kernel image not found"
fi

# ===== DATE =====
date_now=$(date -u "+%Y-%m-%d %H:%M:%S UTC")

# ===== CAPTION (Markdown) =====
caption="*Build Success* 
\`\`\`
$kernelver
\`\`\`
*Date:* $date_now
*Download:* $link"

# ===== SEND TO TELEGRAM =====
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F document=@"$FILE" \
  -F parse_mode=Markdown \
  -F caption="$caption"

echo "Done. Sent to Telegram."
