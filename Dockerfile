FROM python:3.13-slim

# ffmpegをインストール
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# streamlinkをインストール
RUN pip install --no-cache-dir streamlink


WORKDIR /usr/src/app

COPY main.sh upload_video.py requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

ENV DIST_DIR=dist

ENTRYPOINT [ "./main.sh" ]
