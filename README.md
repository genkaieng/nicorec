# nicorec

ニコ生を録画するツール。YouTubeへのアップロードも行える。

## Dependencies

- streamlink
- ffmpeg

## Dockerで実行する場合

```sh
docker pull ghcr.io/genkaieng/nicorec:latest
```

### 録画実行

```sh
docker run -v $(pwd)/dist:/usr/src/app/dist ghcr.io/genkaieng/nicorec --session <NICOLIVE_SESSION> <LVID>
```
