# xteve
xteve, in docker with cron

docker runs in host mode \
access xteve webui ip:34400/web/

after docker start check your config folder and do your setups, setup is persistent, start from scratch by delete them

cron and xteve start options are updated on docker restart.

mounts to use as sample \
Container Path: /root/.xteve <> /mnt/user/appdata/xteve/ \
Container Path: /config <> /mnt/user/appdata/xteve/_config/ \
Container Path: /tmp/xteve <> /tmp/xteve/ \
Container Path: /TVH <> /mnt/user/appdata/tvheadend/data/ << not needed if no TVHeadend is used \
while /mnt/user/appdata/ should fit to your system path ...

```
docker run -d \
  --name=xteve \
  --net=host \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  -e TZ="Europe/Berlin" \
  -v /mnt/user/appdata/xteve/:/root/.xteve:rw \
  -v /mnt/user/appdata/xteve/_config:/config:rw \
  -v /tmp/xteve/:/tmp/xteve:rw \
  -v /mnt/user/appdata/tvheadend/data/:/TVH \
  alturismo/xteve
```

to test the cronjob functions \
docker exec -it "dockername" ./config/cronjob.sh

included functions are (all can be individual turned on / off)

xteve - iptv and epg proxy server for plex, emby, etc ... thanks to @marmei \
website: http://xteve.de \
Discord: https://discordapp.com/channels/465222357754314767/465222357754314773

some small script lines cause i personally use tvheadend and get playlist for xteve and cp xml data to tvheadend
added now grab xmltv from tvheadend as source for xteve
added rewrite function for reverse proxy usage for xml to get icon links working, see cronjob.sh

so, credits to the programmers, i just putted this together in a docker to fit my needs
