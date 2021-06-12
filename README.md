# makemkvcon docker
# usage:
 `docker run -v '/path-to-dvd-dir':'/data' maqdev/makemkvcon` looks for VIDEO_TS inside path-to-dvd and prints info
 `docker run -v '/path-to-dvd-dir':'/data' maqdev/makemkvcon mkv file:/data/VIDEO_TS '0' /data` creates mkv from title 0
