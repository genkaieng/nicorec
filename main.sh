#!/bin/bash

FILENAME=
ON_SAVE=
VIDEO_TITLE="Test Title"
VIDEO_DESCRIPTION="Test Description"

while [[ $# -gt 0 ]]; do
  case $1 in
    --session)
      NICOLIVE_SESSION="$2"
      shift 2
      ;;
    --output-mode)
      if [ "$2" = "youtube" ]; then
        ON_SAVE="upload_youtube"
      else
        echo "--output-mode: is only supported youtube" >&2
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

if [ -z "$FILENAME" ]; then
  FILENAME="$LVID.mp4"
fi

if [ "$OUTPUT_MODE" = "youtube" ]; then
  ON_SAVE="upload_youtube"
fi

OUTPUT="$FILENAME"
if [ -n "$DIST_DIR" ]; then
  OUTPUT="$DIST_DIR/$OUTPUT"
fi

echo "SESSION: $NICOLIVE_SESSION"
echo "LVID: $LVID"
echo "OUTPUT: $OUTPUT"

if [ -z "$NICOLIVE_SESSION" ]; then
  streamlink "https://live.nicovideo.jp/watch/$LVID" best -O | ffmpeg -i - -c copy "$OUTPUT"
else
  streamlink --niconico-user-session="$NICOLIVE_SESSION" "https://live.nicovideo.jp/watch/$LVID" best -O | ffmpeg -i - -c copy "$OUTPUT"
fi

if [ "$ON_SAVE" = "upload_youtube" ]; then
  python upload_video.py --file="$FILENAME" --title="$VIDEO_TITLE" --description="$VIDEO_DESCRIPTION"
fi