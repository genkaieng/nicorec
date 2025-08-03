#!/bin/bash

SESSION=
FILENAME=
ON_SAVE=
VIDEO_TITLE="Test Title"
VIDEO_DESCRIPTION="Test Description"

while [[ $# -gt 0 ]]; do
  case $1 in
    --session)
      SESSION="$2"
      shift 2
      ;;
    --output-mode)
      if [ "$2" = "youtube" ]; then
        ON_SAVE="upload_youtube"
      else
        echo "--output-mode: youtube" >&2
        exit 1
      fi
      shift 2
      ;;
    --video-title)
      VIDEO_TITLE="$2"
      shift 2
      ;;
    --video-description)
      VIDEO_DESCRIPTION="$2"
      shift 2
      ;;
    -o)
      FILENAME="$2"
      shift 2
      ;;
    *)
      LVID="$1"
      shift
      ;;
  esac
done

if [ -z "$LVID" ]; then
  echo "エラー: LVIDを指定してください" >&2
  echo "使い方: $0 [--session SESSION] [-o FILENAME] LVID" >&2
  exit 1
fi

if [ -z "$SESSION" ]; then
  SESSION="$NICOLIVE_SESSION"
fi

if [ -z "$FILENAME" ]; then
  FILENAME="$LVID.mp4"
fi

if [ "$OUTPUT_MODE" = "youtube" ]; then
  ON_SAVE="upload_youtube"
fi

echo "SESSION: $SESSION"
echo "LVID: $LVID"
echo "OUTPUT: $FILENAME"

if [ -z "$SESSION" ]; then
  streamlink "https://live.nicovideo.jp/watch/$LVID" best -O | ffmpeg -i - -c copy "$FILENAME"
else
  streamlink --niconico-user-session="$SESSION" "https://live.nicovideo.jp/watch/$LVID" best -O | ffmpeg -i - -c copy "$FILENAME"
fi

if [ "$ON_SAVE" = "upload_youtube" ]; then
  python upload_video.py --file="$FILENAME" --title="$VIDEO_TITLE" --description="$VIDEO_DESCRIPTION"
fi